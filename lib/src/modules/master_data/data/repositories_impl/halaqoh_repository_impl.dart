import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:my_halaqoh/src/core/services/activity_log_service.dart';
import 'package:my_halaqoh/src/modules/master_data/data/datasources/local/master_data_local_datasource.dart';
import 'package:my_halaqoh/src/modules/master_data/data/datasources/remote/source/abstract/halaqoh_remote_datasource.dart';
import 'package:my_halaqoh/src/modules/master_data/domain/models/halaqoh_model.dart';
import 'package:my_halaqoh/src/modules/master_data/domain/repositories/halaqoh_repository.dart';

class HalaqohRepositoryImpl implements HalaqohRepository {
  final HalaqohRemoteDataSource _remote;
  final MasterDataLocalDataSource _local;
  final ActivityLogService _activityLog;

  HalaqohRepositoryImpl(this._remote, this._local, this._activityLog);

  @override
  Stream<List<HalaqohModel>> watchAll() {
    return _remote.watchAll().map((list) {
      _local.cacheHalaqoh(list);
      return list;
    });
  }

  @override
  Future<Either<String, List<HalaqohModel>>> getAll() async {
    try {
      final list = await _remote.getAll();
      await _local.cacheHalaqoh(list);
      return Right(list);
    } catch (e) {
      final cached = _local.getAllHalaqoh();
      if (cached.isNotEmpty) return Right(cached);
      return Left('Gagal memuat data halaqoh: $e');
    }
  }

  @override
  Future<Either<String, HalaqohModel>> getById(String id) async {
    try {
      final model = await _remote.getById(id);
      if (model == null) return const Left('Halaqoh tidak ditemukan');
      return Right(model);
    } catch (e) {
      return Left('Gagal memuat halaqoh: $e');
    }
  }

  @override
  Future<Either<String, String>> add(HalaqohModel model) async {
    try {
      final id = await _remote.add(model);
      final created = model.copyWith(id: id);
      await _local.putHalaqoh(created);
      unawaited(_activityLog.log(
        action: 'create',
        module: 'halaqoh',
        entityId: id,
        entityName: model.nama,
        description: 'Menambahkan halaqoh baru: ${model.nama}',
      ));
      return Right(id);
    } catch (e) {
      return Left('Gagal menambahkan halaqoh: $e');
    }
  }

  @override
  Future<Either<String, void>> update(HalaqohModel model) async {
    try {
      await _remote.update(model);
      await _local.putHalaqoh(model);
      unawaited(_activityLog.log(
        action: 'update',
        module: 'halaqoh',
        entityId: model.id,
        entityName: model.nama,
        description: 'Memperbarui halaqoh: ${model.nama}',
      ));
      return const Right(null);
    } catch (e) {
      return Left('Gagal mengupdate halaqoh: $e');
    }
  }

  @override
  Future<Either<String, void>> delete(String id) async {
    try {
      await _remote.delete(id);
      await _local.deleteHalaqoh(id);
      unawaited(_activityLog.log(
        action: 'delete',
        module: 'halaqoh',
        entityId: id,
        description: 'Menghapus halaqoh dengan ID: $id',
      ));
      return const Right(null);
    } catch (e) {
      return Left('Gagal menghapus halaqoh: $e');
    }
  }
}
