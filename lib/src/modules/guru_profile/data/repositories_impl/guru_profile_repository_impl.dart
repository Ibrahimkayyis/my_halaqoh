import 'dart:async';
import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:my_halaqoh/src/core/services/activity_log_service.dart';
import 'package:my_halaqoh/src/modules/guru_profile/data/datasources/remote/source/abstract/guru_profile_remote_datasource.dart';
import 'package:my_halaqoh/src/modules/guru_profile/domain/repositories/guru_profile_repository.dart';
import 'package:my_halaqoh/src/modules/master_data/domain/models/guru_model.dart';

/// Implementation of [GuruProfileRepository].
/// Wraps remote datasource calls with Either error handling.
class GuruProfileRepositoryImpl implements GuruProfileRepository {
  final GuruProfileRemoteDataSource _remote;
  final ActivityLogService _activityLog;

  GuruProfileRepositoryImpl(this._remote, this._activityLog);

  @override
  Future<Either<String, GuruModel>> getProfile(String guruDocId) async {
    try {
      final model = await _remote.getById(guruDocId);
      return Right(model);
    } catch (e) {
      return Left('Gagal memuat profil: $e');
    }
  }

  @override
  Future<Either<String, void>> updateProfile(GuruModel model) async {
    try {
      await _remote.update(model);
      unawaited(_activityLog.log(
        action: 'update',
        module: 'guru',
        entityId: model.id,
        entityName: model.nama,
        description: 'Memperbarui informasi profil guru: ${model.nama}',
      ));
      return const Right(null);
    } catch (e) {
      return Left('Gagal memperbarui profil: $e');
    }
  }

  @override
  Future<Either<String, String>> uploadProfilePhoto({
    required String guruDocId,
    required File imageFile,
  }) async {
    try {
      final url = await _remote.uploadPhoto(
        guruDocId: guruDocId,
        file: imageFile,
      );
      unawaited(_activityLog.log(
        action: 'update',
        module: 'guru',
        entityId: guruDocId,
        description: 'Mengunggah foto profil baru untuk Guru ID: $guruDocId',
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
        description: 'Guru berhasil memperbarui kata sandi akun',
      ));
      return const Right(null);
    } catch (e) {
      return Left(e.toString().replaceFirst('Exception: ', ''));
    }
  }
}
