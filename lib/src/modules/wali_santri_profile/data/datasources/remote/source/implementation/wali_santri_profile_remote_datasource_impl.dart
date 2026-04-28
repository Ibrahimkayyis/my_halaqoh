import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:my_halaqoh/src/core/services/storage_service.dart';
import 'package:my_halaqoh/src/modules/master_data/data/datasources/remote/mapper/santri_mapper.dart';
import 'package:my_halaqoh/src/modules/master_data/domain/models/santri_model.dart';
import '../abstract/wali_santri_profile_remote_datasource.dart';

/// Implementation of [WaliSantriProfileRemoteDataSource] using
/// Firestore, Firebase Auth, and Firebase Storage.
class WaliSantriProfileRemoteDataSourceImpl
    implements WaliSantriProfileRemoteDataSource {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;
  final StorageService _storageService;

  CollectionReference<Map<String, dynamic>> get _col =>
      _firestore.collection('santri');

  WaliSantriProfileRemoteDataSourceImpl(
    this._firestore,
    this._auth,
    this._storageService,
  );

  @override
  Future<SantriModel> getById(String santriDocId) async {
    final doc = await _col.doc(santriDocId).get();
    if (!doc.exists) {
      throw Exception('Data santri tidak ditemukan');
    }
    return SantriMapper.fromFirestore(doc);
  }

  @override
  Future<void> update(SantriModel model) async {
    // Only update fields the wali santri is allowed to change.
    // NIS, kelas, program, halaqohId, and authUid are admin-managed.
    await _col.doc(model.id).update({
      'nama': model.nama,
      'profilePicture': model.profilePicture,
      'waliSantri': model.waliSantri?.toJson(),
      'updatedAt': Timestamp.fromDate(DateTime.now()),
    });
  }

  @override
  Future<String> uploadPhoto({
    required String santriDocId,
    required File file,
  }) async {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final ext = file.path.split('.').last;
    final fileName = 'santri_${santriDocId}_$timestamp.$ext';
    final path = 'profile_pictures/$fileName';

    final url = await _storageService.uploadFile(
      file: file,
      path: path,
    );

    if (url == null) {
      throw Exception('Gagal mengunggah foto profil');
    }

    // Update profilePicture field in Firestore immediately
    await _col.doc(santriDocId).update({'profilePicture': url});

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

    // Re-authenticate with the old password before changing
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
