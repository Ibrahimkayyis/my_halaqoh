import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:my_halaqoh/src/core/services/storage_service.dart';
import 'package:my_halaqoh/src/modules/guru_profile/data/datasources/remote/source/abstract/guru_profile_remote_datasource.dart';
import 'package:my_halaqoh/src/modules/master_data/data/datasources/remote/mapper/guru_mapper.dart';
import 'package:my_halaqoh/src/modules/master_data/domain/models/guru_model.dart';

/// Implementation of [GuruProfileRemoteDataSource] using
/// Firestore, Firebase Auth, and Firebase Storage.
class GuruProfileRemoteDataSourceImpl implements GuruProfileRemoteDataSource {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;
  final StorageService _storageService;

  CollectionReference<Map<String, dynamic>> get _col =>
      _firestore.collection('guru');

  GuruProfileRemoteDataSourceImpl(
    this._firestore,
    this._auth,
    this._storageService,
  );

  @override
  Future<GuruModel> getById(String docId) async {
    final doc = await _col.doc(docId).get();
    if (!doc.exists) {
      throw Exception('Data guru tidak ditemukan');
    }
    return GuruMapper.fromFirestore(doc);
  }

  @override
  Future<void> update(GuruModel model) async {
    await _col.doc(model.id).update(GuruMapper.toFirestore(model));
  }

  @override
  Future<String> uploadPhoto({
    required String guruDocId,
    required File file,
  }) async {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final ext = file.path.split('.').last;
    final fileName = 'guru_${guruDocId}_$timestamp.$ext';
    final path = 'profile_pictures/$fileName';

    final url = await _storageService.uploadFile(
      file: file,
      path: path,
    );

    if (url == null) {
      throw Exception('Gagal mengunggah foto profil');
    }

    // Update profilePicture field in Firestore
    await _col.doc(guruDocId).update({'profilePicture': url});

    return url;
  }

  @override
  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    final user = _auth.currentUser;
    if (user == null) {
      throw Exception('Tidak ada user yang sedang login');
    }

    // Re-authenticate with the old password
    final credential = EmailAuthProvider.credential(
      email: user.email!,
      password: currentPassword,
    );

    try {
      await user.reauthenticateWithCredential(credential);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'wrong-password' || e.code == 'invalid-credential') {
        throw Exception('Password lama salah');
      }
      throw Exception('Gagal verifikasi password: ${e.message}');
    }

    // Update to new password
    try {
      await user.updatePassword(newPassword);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        throw Exception('Password baru terlalu lemah');
      }
      throw Exception('Gagal mengubah password: ${e.message}');
    }
  }
}
