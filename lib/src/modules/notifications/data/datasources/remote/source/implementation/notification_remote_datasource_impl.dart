import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:logger/logger.dart';

import '../abstract/notification_remote_datasource.dart';

/// Concrete implementation that uses [FirebaseMessaging] for FCM token
/// management and [FirebaseFirestore] to persist the token in Firestore.
///
/// Constructor dependencies are injected via GetIt — never instantiate
/// directly from UI or Cubits.
class NotificationRemoteDataSourceImpl implements NotificationRemoteDataSource {
  final FirebaseMessaging _messaging;
  final FirebaseFirestore _firestore;
  final _log = Logger();

  NotificationRemoteDataSourceImpl(this._messaging, this._firestore);

  // ── Permission & Token Retrieval ──────────────────────────────────────────

  @override
  Future<String?> requestPermissionAndGetToken() async {
    // Step 1: Request OS-level notification permission.
    // On Android 12 and below this is granted automatically.
    // On Android 13+ and iOS this shows a system dialog.
    final settings = await _messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    final status = settings.authorizationStatus;
    if (status == AuthorizationStatus.denied ||
        status == AuthorizationStatus.notDetermined) {
      _log.w(
        'NotificationRemoteDataSource: permission not granted — status: $status',
      );
      return null;
    }

    return _getTokenInternal();
  }

  @override
  Future<AuthorizationStatus> checkPermissionStatus() async {
    // getNotificationSettings() hanya membaca status — TIDAK memunculkan
    // dialog baru kepada user.
    final settings = await _messaging.getNotificationSettings();
    _log.d(
      'NotificationRemoteDataSource: permission status = ${settings.authorizationStatus}',
    );
    return settings.authorizationStatus;
  }

  @override
  Future<String?> getTokenOnly() => _getTokenInternal();

  // ── Internal helper ───────────────────────────────────────────────────────

  Future<String?> _getTokenInternal() async {
    final token = await _messaging.getToken();
    if (token == null) {
      _log.w(
        'NotificationRemoteDataSource: FCM token is null — device may not support FCM.',
      );
    } else {
      _log.i(
        'NotificationRemoteDataSource: FCM token retrieved — ${token.substring(0, 20)}...',
      );
    }
    return token;
  }

  // ── Firestore Token Persistence ───────────────────────────────────────────

  @override
  Future<void> saveToken(String uid, String token, [String? deviceId]) async {
    final userRef = _firestore.collection('users').doc(uid);

    final updates = <String, dynamic>{
      'fcmToken': token,
      'fcmTokenUpdatedAt': FieldValue.serverTimestamp(),
    };
    await userRef.update(updates);

    if (deviceId != null && deviceId.isNotEmpty) {
      try {
        await userRef.collection('devices').doc(deviceId).set({
          'fcmToken': token,
          'lastActiveAt': FieldValue.serverTimestamp(),
        }, SetOptions(merge: true));
      } catch (_) {}
    }

    _log.i('NotificationRemoteDataSource: FCM token saved for uid=$uid, deviceId=$deviceId');
  }

  @override
  Future<void> clearToken(String uid, [String? deviceId]) async {
    final userRef = _firestore.collection('users').doc(uid);

    if (deviceId != null && deviceId.isNotEmpty) {
      try {
        await userRef.collection('devices').doc(deviceId).delete();
      } catch (_) {}
    }

    try {
      final remaining = await userRef.collection('devices').get();
      if (remaining.docs.isEmpty) {
        await userRef.update({
          'fcmToken': null,
          'fcmTokenUpdatedAt': FieldValue.serverTimestamp(),
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
          final activeToken = latestWithToken.first.data()['fcmToken'] as String;
          await userRef.update({
            'fcmToken': activeToken,
            'fcmTokenUpdatedAt': FieldValue.serverTimestamp(),
          });
        }
      }
    } catch (_) {
      // Fallback
      await userRef.update({
        'fcmToken': null,
        'fcmTokenUpdatedAt': FieldValue.serverTimestamp(),
      });
    }

    _log.i('NotificationRemoteDataSource: FCM token cleared for uid=$uid, deviceId=$deviceId');
  }

  // ── Token Refresh Stream ──────────────────────────────────────────────────

  @override
  Stream<String> get onTokenRefresh => _messaging.onTokenRefresh;
}
