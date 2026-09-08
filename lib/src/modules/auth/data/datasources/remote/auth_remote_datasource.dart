import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:my_halaqoh/src/core/services/activity_log_service.dart';
import 'package:my_halaqoh/src/modules/auth/data/datasources/remote/mapper/device_session_mapper.dart';
import 'package:my_halaqoh/src/modules/auth/domain/models/device_session_model.dart';
import 'package:my_halaqoh/src/modules/auth/domain/models/user_model.dart';

abstract class AuthRemoteDataSource {
  /// Sign in using the user's NIP/NIS and password.
  Future<UserModel> signIn(String identifier, String password);

  /// Signs the user out of the application.
  Future<void> signOut();

  /// Deletes the currently authenticated user's account permanently.
  Future<void> deleteOwnAccount();

  /// Retrieves the current authenticated user's metadata from Firestore.
  /// Throws if no user is logged in.
  Future<UserModel> getCurrentUserMeta();

  /// Gets a stream of the authentication state natively.
  Stream<User?> get authStateChanges;

  /// Registers or updates a device session, enforcing role-based device limits.
  Future<void> registerSession({
    required String uid,
    required String role,
    required DeviceSessionModel session,
  });

  /// Unregisters this device session upon logout.
  Future<void> unregisterSession({
    required String uid,
    required String deviceId,
  });

  /// Watches this specific device's session document in Firestore.
  Stream<DeviceSessionModel?> watchDeviceSession({
    required String uid,
    required String deviceId,
  });

  /// Updates heartbeat timestamp for this device.
  Future<void> updateDeviceHeartbeat({
    required String uid,
    required String deviceId,
  });
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firestore;
  final ActivityLogService _activityLog;
  final FirebaseFunctions _functions;

  AuthRemoteDataSourceImpl(
    this._firebaseAuth,
    this._firestore,
    this._activityLog, [
    FirebaseFunctions? functions,
  ]) : _functions = functions ?? FirebaseFunctions.instance;

  @override
  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  @override
  Future<UserModel> signIn(String identifier, String password) async {
    final normalizedIdentifier = identifier.trim();
    final email = '$normalizedIdentifier@myhalaqoh.app';

    // Autentikasi langsung ke Firebase Auth tanpa pre-check query unauthenticated
    final userCredential = await _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    final uid = userCredential.user!.uid;

    // Ambil metadata dari collection users
    final docSnap = await _firestore.collection('users').doc(uid).get();
    if (!docSnap.exists) {
      // Firebase Auth berhasil tapi metadata tidak ada di Firestore
      // → signOut dulu agar tidak terjebak di state invalid
      await _firebaseAuth.signOut();
      throw Exception(
        'Akun ditemukan tetapi data pengguna tidak lengkap. '
        'Hubungi administrator.',
      );
    }

    final data = docSnap.data()!;
    data['uid'] = uid;
    final userModel = UserModel.fromJson(data);

    unawaited(_activityLog.log(
      action: 'login',
      module: 'auth',
      description: 'Pengguna $normalizedIdentifier berhasil login sebagai ${userModel.role}',
    ));

    return userModel;
  }

  @override
  Future<void> signOut() async {
    // EXCEPTION to the "always unawaited()" rule: the logout log entry MUST be
    // awaited BEFORE Firebase Auth sign-out. Once _firebaseAuth.signOut()
    // completes, the auth token is revoked and any in-flight write to
    // /activity_log is rejected by security rules with permission-denied
    // (allow create: if isAuthenticated()). Awaiting here guarantees the
    // audit trail records the logout event while the session is still valid.
    await _activityLog.log(
      action: 'logout',
      module: 'auth',
      description: 'Pengguna logout dari aplikasi',
    );
    await _firebaseAuth.signOut();
  }

  @override
  Future<void> deleteOwnAccount() async {
    final currentUser = _firebaseAuth.currentUser;
    if (currentUser == null) {
      throw Exception('Tidak ada user yang sedang login');
    }

    final uid = currentUser.uid;

    await _activityLog.log(
      action: 'delete_account',
      module: 'auth',
      description: 'Pengguna meminta penghapusan akun mandiri ($uid)',
    );

    try {
      final callable = _functions.httpsCallable('deleteOwnAccount');
      await callable.call();
    } on FirebaseFunctionsException catch (e) {
      throw Exception(e.message ?? 'Gagal menghapus akun: ${e.code}');
    } catch (e) {
      throw Exception('Gagal menghapus akun: ${e.toString()}');
    }

    // Ensure client-side Firebase Auth session is cleanly cleared
    try {
      await _firebaseAuth.signOut();
    } catch (_) {}
  }


  @override
  Future<UserModel> getCurrentUserMeta() async {
    final currentUser = _firebaseAuth.currentUser;
    if (currentUser == null) {
      throw Exception('Tidak ada user yang sedang login');
    }

    final docSnap = await _firestore
        .collection('users')
        .doc(currentUser.uid)
        .get();
    if (!docSnap.exists) {
      // Metadata tidak ditemukan di Firestore → lempar exception
      // agar AuthCubit._fetchUserMeta() dapat menanganinya dengan benar,
      // yaitu signOut + bersihkan Hive cache
      throw Exception('Data metadata pengguna tidak ditemukan di database.');
    }

    final data = docSnap.data()!;
    data['uid'] = currentUser.uid;
    return UserModel.fromJson(data);
  }

  static int _maxDevicesForRole(String role) {
    switch (role) {
      case 'guru':
        return 1;
      case 'admin':
        return 2;
      case 'santri':
        return 3;
      default:
        return 2;
    }
  }

  @override
  Future<void> registerSession({
    required String uid,
    required String role,
    required DeviceSessionModel session,
  }) async {
    final userRef = _firestore.collection('users').doc(uid);
    final devicesRef = userRef.collection('devices');

    final maxAllowed = _maxDevicesForRole(role);

    // 1. Fetch current devices for this user
    final querySnapshot = await devicesRef.get();
    final docs = querySnapshot.docs;

    // 2. Identify other registered devices
    final otherDevices = docs.where((doc) => doc.id != session.deviceId).toList();

    // Sort other devices by lastActiveAt ascending (oldest first)
    otherDevices.sort((a, b) {
      final aTime = (a.data()['lastActiveAt'] as Timestamp?)?.millisecondsSinceEpoch ?? 0;
      final bTime = (b.data()['lastActiveAt'] as Timestamp?)?.millisecondsSinceEpoch ?? 0;
      return aTime.compareTo(bTime);
    });

    // 3. If otherDevices.length + 1 > maxAllowed, terminate excess oldest
    final allowedOthers = maxAllowed - 1;
    if (otherDevices.length > allowedOthers) {
      final excessCount = otherDevices.length - allowedOthers;
      final toEvict = otherDevices.take(excessCount);
      for (final doc in toEvict) {
        await doc.reference.update({
          'isTerminated': true,
          'terminatedBy': session.deviceName,
          'lastActiveAt': FieldValue.serverTimestamp(),
        });
      }
    }

    // 4. Save/update current device document
    await devicesRef.doc(session.deviceId).set(
      DeviceSessionMapper.toFirestore(session),
      SetOptions(merge: true),
    );

    // 5. Update user root document for backward compatibility
    final Map<String, dynamic> userUpdates = {
      'lastLoginAt': FieldValue.serverTimestamp(),
      'activeSessionId': session.sessionId,
      'activeDeviceId': session.deviceId,
      'activeDeviceName': session.deviceName,
    };
    if (session.fcmToken != null && session.fcmToken!.isNotEmpty) {
      userUpdates['fcmToken'] = session.fcmToken;
      userUpdates['fcmTokenUpdatedAt'] = FieldValue.serverTimestamp();
    }
    await userRef.update(userUpdates);
  }

  @override
  Future<void> unregisterSession({
    required String uid,
    required String deviceId,
  }) async {
    final userRef = _firestore.collection('users').doc(uid);
    final devicesRef = userRef.collection('devices');

    // Delete this device document
    try {
      await devicesRef.doc(deviceId).delete();
    } catch (_) {}

    // Check remaining devices
    try {
      final remaining = await devicesRef.get();
      if (remaining.docs.isEmpty) {
        await userRef.update({
          'fcmToken': null,
          'fcmTokenUpdatedAt': FieldValue.serverTimestamp(),
          'activeSessionId': null,
          'activeDeviceId': null,
        });
      } else {
        remaining.docs.sort((a, b) {
          final aTime = (a.data()['lastActiveAt'] as Timestamp?)?.millisecondsSinceEpoch ?? 0;
          final bTime = (b.data()['lastActiveAt'] as Timestamp?)?.millisecondsSinceEpoch ?? 0;
          return bTime.compareTo(aTime);
        });
        final latestWithToken = remaining.docs.where(
          (d) => (d.data()['fcmToken'] as String?)?.isNotEmpty == true,
        );
        if (latestWithToken.isNotEmpty) {
          final token = latestWithToken.first.data()['fcmToken'] as String;
          await userRef.update({
            'fcmToken': token,
            'fcmTokenUpdatedAt': FieldValue.serverTimestamp(),
          });
        }
      }
    } catch (_) {}
  }

  @override
  Stream<DeviceSessionModel?> watchDeviceSession({
    required String uid,
    required String deviceId,
  }) {
    return _firestore
        .collection('users')
        .doc(uid)
        .collection('devices')
        .doc(deviceId)
        .snapshots()
        .map((docSnap) {
      if (!docSnap.exists) return null;
      return DeviceSessionMapper.fromFirestore(docSnap);
    });
  }

  @override
  Future<void> updateDeviceHeartbeat({
    required String uid,
    required String deviceId,
  }) async {
    try {
      await _firestore
          .collection('users')
          .doc(uid)
          .collection('devices')
          .doc(deviceId)
          .update({'lastActiveAt': FieldValue.serverTimestamp()});
    } catch (_) {}
  }
}
