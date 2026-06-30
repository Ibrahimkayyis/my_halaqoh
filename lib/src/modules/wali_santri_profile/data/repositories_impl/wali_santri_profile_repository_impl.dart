import 'dart:async';
import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:my_halaqoh/src/core/services/activity_log_service.dart';
import 'package:my_halaqoh/src/modules/master_data/domain/models/santri_model.dart';
import 'package:my_halaqoh/src/modules/wali_santri_profile/data/datasources/remote/source/abstract/wali_santri_profile_remote_datasource.dart';
import 'package:my_halaqoh/src/modules/wali_santri_profile/domain/repositories/wali_santri_profile_repository.dart';

/// Implementation of [WaliSantriProfileRepository].
/// Wraps remote datasource calls with Either error handling.
class WaliSantriProfileRepositoryImpl implements WaliSantriProfileRepository {
  final WaliSantriProfileRemoteDataSource _remote;
  final ActivityLogService _activityLog;

  WaliSantriProfileRepositoryImpl(this._remote, this._activityLog);

  @override
  Future<Either<String, SantriModel>> getProfile(String santriDocId) async {
    try {
      final model = await _remote.getById(santriDocId);
      return Right(model);
    } catch (e) {
      return Left('Gagal memuat profil: $e');
    }
  }

  @override
  Future<Either<String, void>> updateProfile(SantriModel model) async {
    try {
      await _remote.update(model);
      unawaited(_activityLog.log(
        action: 'update',
        module: 'santri',
        entityId: model.id,
        entityName: model.nama,
        description: 'Memperbarui informasi profil wali santri untuk siswa: ${model.nama}',
      ));
      return const Right(null);
    } catch (e) {
      return Left('Gagal memperbarui profil: $e');
    }
  }

  @override
  Future<Either<String, String>> uploadProfilePhoto({
    required String santriDocId,
    required File imageFile,
  }) async {
    try {
      final url = await _remote.uploadPhoto(
        santriDocId: santriDocId,
        file: imageFile,
      );
      unawaited(_activityLog.log(
        action: 'update',
        module: 'santri',
        entityId: santriDocId,
        description: 'Mengunggah foto profil baru untuk Wali Santri dari siswa ID: $santriDocId',
      ));
      return Right(url);
    } catch (e) {
      return Left('Gagal mengunggah foto: $e');
    }
  }

  @override
  Future<Either<String, void>> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    try {
      await _remote.changePassword(
        currentPassword: currentPassword,
        newPassword: newPassword,
      );
      unawaited(_activityLog.log(
        action: 'update',
        module: 'auth',
        description: 'Wali Santri berhasil memperbarui kata sandi akun',
      ));
      return const Right(null);
    } catch (e) {
      return Left(e.toString().replaceFirst('Exception: ', ''));
    }
  }
}
