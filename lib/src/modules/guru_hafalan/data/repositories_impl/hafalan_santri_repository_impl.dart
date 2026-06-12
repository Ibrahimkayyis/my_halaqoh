import 'package:dartz/dartz.dart';
import 'package:logger/logger.dart';
import '../../domain/models/hafalan_santri_model.dart';
import '../../domain/repositories/hafalan_santri_repository.dart';
import '../datasources/local/hafalan_santri_local_data_source.dart';
import '../datasources/remote/source/abstract/hafalan_santri_remote_datasource.dart';

class HafalanSantriRepositoryImpl implements HafalanSantriRepository {
  final HafalanSantriLocalDataSource _local;
  final HafalanSantriRemoteDataSource _remote;
  final _log = Logger();

  HafalanSantriRepositoryImpl(this._local, this._remote);

  @override
  Future<Either<String, HafalanSantriModel>> addHafalan(HafalanSantriModel hafalan) async {
    try {
      // 1. Save to Local Hive (Offline-First)
      // Ensure isSynced is false initially
      final localModel = hafalan.copyWith(isSynced: false);
      await _local.put(localModel);

      // 2. Try to sync to remote immediately
      _trySyncNow(localModel);

      return Right(localModel);
    } catch (e, st) {
      _log.e('Failed to add hafalan locally', error: e, stackTrace: st);
      return Left('Gagal menyimpan data hafalan secara lokal: $e');
    }
  }

  Future<void> _trySyncNow(HafalanSantriModel model) async {
    try {
      final syncedModel = await _remote.put(model);
      await _local.put(syncedModel);
    } catch (e) {
      _log.w('Immediate sync failed, will retry later. Error: $e');
      // Fails silently, stays in Hive with isSynced = false
    }
  }

  @override
  Stream<List<HafalanSantriModel>> watchHafalanBySantriId(String santriId, int month, int year) {
    return _local.watchHafalanBySantriId(santriId, month, year);
  }

  @override
  Stream<List<HafalanSantriModel>> watchAllZiyadahBySantriId(String santriId) {
    return _local.watchAllZiyadahBySantriId(santriId);
  }

  @override
  List<HafalanSantriModel> getAllHafalanBySantriId(String santriId) {
    return _local.getAllHafalanBySantriId(santriId);
  }

  @override
  Future<void> syncPendingRecords() async {
    final pending = _local.getPendingSync();
    if (pending.isEmpty) return;

    _log.i('Syncing ${pending.length} pending hafalan records...');
    
    final syncedIds = <String>[];
    for (final item in pending) {
      try {
        await _remote.put(item);
        syncedIds.add(item.id);
      } catch (e) {
        _log.e('Failed to sync record ${item.id}', error: e);
        // Stop the loop or continue? We should continue to try others.
      }
    }

    if (syncedIds.isNotEmpty) {
      await _local.markAllAsSynced(syncedIds);
      _log.i('Successfully synced ${syncedIds.length} records.');
    }
  }

  @override
  Future<void> seedFromRemoteIfEmpty(String santriId) async {
    // Guard: only fetch from Firestore if the local box has NO records for this santri
    // across all months. Checks Ziyadah (all-time) as a fast proxy since every
    // santri has at least some Ziyadah records if they have any hafalan at all.
    final hasAnyLocal = _local.getAllZiyadahBySantriId(santriId).isNotEmpty ||
        _local.getHafalanBySantriId(santriId, DateTime.now().month, DateTime.now().year).isNotEmpty;

    if (hasAnyLocal) {
      _log.d('seedFromRemoteIfEmpty: local data exists for santriId=$santriId — skipping fetch.');
      return;
    }

    _log.i('seedFromRemoteIfEmpty: Hive box empty for santriId=$santriId. Fetching from Firestore...');
    try {
      final remoteRecords = await _remote.fetchBySantriId(santriId);
      if (remoteRecords.isEmpty) {
        _log.i('seedFromRemoteIfEmpty: no records in Firestore for santriId=$santriId.');
        return;
      }
      for (final record in remoteRecords) {
        await _local.put(record); // isSynced: true via fromFirestore in mapper
      }
      _log.i('seedFromRemoteIfEmpty: seeded ${remoteRecords.length} records into Hive for santriId=$santriId.');
    } catch (e, st) {
      // Non-fatal: screen shows empty state; user can retry by re-opening the screen.
      _log.e('seedFromRemoteIfEmpty: Firestore fetch failed', error: e, stackTrace: st);
    }
  }

  @override
  List<HafalanSantriModel> getHafalanByHalaqohAndDate(
      List<String> santriIds, DateTime date) {
    return _local.getHafalanByHalaqohAndDate(santriIds, date);
  }

  @override
  List<HafalanSantriModel> getRecentHafalanBySantriIds(
      List<String> santriIds, {int limit = 3}) {
    return _local.getRecentHafalanBySantriIds(santriIds, limit: limit);
  }

  @override
  Stream<void> watchAnyChanges() {
    return _local.watchAnyChanges();
  }

  @override
  Future<Either<String, void>> deleteHafalan(String id) async {
    try {
      // 1. Delete from local Hive
      await _local.delete(id);

      // 2. Try to delete from Firestore
      try {
        await _remote.delete(id);
      } catch (e) {
        _log.w('Failed to delete remote record immediately: $e');
        // Fails silently for now, as is typical for offline-first actions
      }
      return const Right(null);
    } catch (e, st) {
      _log.e('Failed to delete hafalan locally', error: e, stackTrace: st);
      return Left('Gagal menghapus data hafalan secara lokal: $e');
    }
  }
}
