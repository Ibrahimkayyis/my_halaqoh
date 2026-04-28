import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:my_halaqoh/src/modules/master_data/domain/models/santri_model.dart';
import 'package:my_halaqoh/src/modules/wali_santri_profile/data/datasources/remote/source/abstract/wali_santri_profile_remote_datasource.dart';
import 'package:my_halaqoh/src/modules/wali_santri_profile/domain/repositories/wali_santri_profile_repository.dart';

/// Implementation of [WaliSantriProfileRepository].
/// Wraps remote datasource calls with Either error handling.
class WaliSantriProfileRepositoryImpl implements WaliSantriProfileRepository {
  final WaliSantriProfileRemoteDataSource _remote;

  WaliSantriProfileRepositoryImpl(this._remote);

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
      return const Right(null);
    } catch (e) {
      return Left(e.toString().replaceFirst('Exception: ', ''));
    }
  }
}
