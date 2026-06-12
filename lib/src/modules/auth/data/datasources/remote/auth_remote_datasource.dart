import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:my_halaqoh/src/modules/auth/domain/models/user_model.dart';

abstract class AuthRemoteDataSource {
  /// Sign in using the user's NIP/NIS and password.
  Future<UserModel> signIn(String identifier, String password);

  /// Signs the user out of the application.
  Future<void> signOut();

  /// Retrieves the current authenticated user's metadata from Firestore.
  /// Throws if no user is logged in.
  Future<UserModel> getCurrentUserMeta();

  /// Gets a stream of the authentication state natively.
  Stream<User?> get authStateChanges;
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firestore;

  AuthRemoteDataSourceImpl(this._firebaseAuth, this._firestore);

  @override
  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  @override
  Future<UserModel> signIn(String identifier, String password) async {
    final normalizedIdentifier = identifier.trim();
    final email = '$normalizedIdentifier@myhalaqoh.app';

    // Pre-check: verifikasi identifier di Firestore SEBELUM memanggil
    // Firebase Auth untuk memberikan pesan error yang lebih spesifik.
    //
    // PENTING: Hanya throw user-not-found jika query BERHASIL dan
    // memang tidak ada dokumen. Jika query gagal karena alasan apapun
    // (network, permission-denied, dll) → fallthrough ke Firebase Auth.
    try {
      final userQuery = await _firestore
          .collection('users')
          .where('identifier', isEqualTo: normalizedIdentifier)
          .limit(1)
          .get();

      if (userQuery.docs.isEmpty) {
        // Identifier tidak terdaftar di Firestore
        throw FirebaseAuthException(
          code: 'user-not-found',
          message: 'No user found for identifier: $normalizedIdentifier',
        );
      }
    } on FirebaseAuthException {
      // Re-throw user-not-found yang kita buat sendiri
      rethrow;
    } catch (_) {
      // Query Firestore gagal (network error, permission-denied, dll)
      // → abaikan dan lanjutkan ke Firebase Auth
    }

    // Lanjut ke Firebase Auth
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
    return UserModel.fromJson(data);
  }

  @override
  Future<void> signOut() async {
    await _firebaseAuth.signOut();
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
}
