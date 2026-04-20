import 'dart:async';
import 'package:dartz/dartz.dart';
import '../../domain/models/absensi_model.dart';
import '../../domain/repositories/absensi_repository.dart';
import '../datasources/local/absensi_local_datasource.dart';
import '../datasources/remote/source/abstract/absensi_remote_datasource.dart';

/// Write-through implementation: always writes to Hive first, then Firestore.
class AbsensiRepositoryImpl implements AbsensiRepository {
  final AbsensiRemoteDataSource _remote;
  final AbsensiLocalDataSource _local;

  AbsensiRepositoryImpl(this._remote, this._local);

  @override
  Stream<List<AbsensiModel>> watchByHalaqoh(String halaqohId) {
    return _remote.watchByHalaqoh(halaqohId).map((list) {
      // Side-effect: cache to Hive
      _local.cacheAll(list);
      return list;
    });
  }

  @override
  Future<Either<String, List<AbsensiModel>>> getByHalaqoh(
    String halaqohId,
  ) async {
    try {
      final list = await _remote.getByHalaqoh(halaqohId);
      await _local.cacheAll(list);
      return Right(list);
    } catch (_) {
      // Fallback to local cache
      try {
        final cached = await _local.getByHalaqoh(halaqohId);
        return Right(cached);
      } catch (e) {
        return Left('Gagal memuat data absensi: $e');
      }
    }
  }

  @override
  Future<AbsensiModel?> findExisting(
    String halaqohId,
    DateTime tanggal,
    String sesi,
  ) async {
    try {
      return await _remote.findExisting(halaqohId, tanggal, sesi);
    } catch (_) {
      // Fallback: check local cache
      final cached = await _local.getByHalaqoh(halaqohId);
      final dateOnly = DateTime(tanggal.year, tanggal.month, tanggal.day);
      try {
        return cached.firstWhere(
          (m) =>
              m.sesi == sesi &&
              m.tanggal.year == dateOnly.year &&
              m.tanggal.month == dateOnly.month &&
              m.tanggal.day == dateOnly.day,
        );
      } catch (_) {
        return null;
      }
    }
  }

  @override
  Future<Either<String, String>> saveSession(AbsensiModel model) async {
    try {
      // Try to write to Firestore first
      String docId;
      if (model.id.startsWith('local_')) {
        // New record
        docId = await _remote.add(model);
      } else {
        // Existing record — update
        await _remote.update(model);
        docId = model.id;
      }
      // Cache as synced
      final synced = model.copyWith(id: docId, isSynced: true);
      await _local.put(synced);
      // Remove the local_ key if it was a temp ID
      if (model.id.startsWith('local_')) {
        await _local.delete(model.id);
      }
      return Right(docId);
    } catch (_) {
      // Offline: save to Hive only, marked as unsynced
      final localModel = model.copyWith(isSynced: false);
      await _local.put(localModel);
      return Right(model.id);
    }
  }

  @override
  Future<Either<String, void>> delete(String id) async {
    try {
      await _remote.delete(id);
      await _local.delete(id);
      return const Right(null);
    } catch (e) {
      return Left('Gagal menghapus data absensi: $e');
    }
  }

  @override
  Future<void> syncPendingRecords() async {
    final unsynced = await _local.getUnsynced();
    for (final model in unsynced) {
      try {
        String docId;
        if (model.id.startsWith('local_')) {
          docId = await _remote.add(model);
        } else {
          await _remote.update(model);
          docId = model.id;
        }
        final synced = model.copyWith(id: docId, isSynced: true);
        await _local.put(synced);
        if (model.id.startsWith('local_')) {
          await _local.delete(model.id);
        }
      } catch (_) {
        // Will retry on next sync cycle
      }
    }
  }
}
