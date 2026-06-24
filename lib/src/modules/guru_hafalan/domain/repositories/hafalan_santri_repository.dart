import 'package:dartz/dartz.dart';
import '../models/hafalan_santri_model.dart';

abstract class HafalanSantriRepository {
  /// Save hafalan record. Will try to save online, but fallback to Hive offline.
  Future<Either<String, HafalanSantriModel>> addHafalan(HafalanSantriModel hafalan);

  /// Watch all hafalan history for a specific santri within a given month and year.
  /// Sources directly from local Hive box for offline-first behavior.
  Stream<List<HafalanSantriModel>> watchHafalanBySantriId(String santriId, int month, int year);

  /// Watch all Ziyadah records for progress calculation.
  /// Sources directly from local Hive box.
  Stream<List<HafalanSantriModel>> watchAllZiyadahBySantriId(String santriId);

  /// Get ALL hafalan records for a specific santri.
  /// Reads from local Hive cache (synchronous).
  List<HafalanSantriModel> getAllHafalanBySantriId(String santriId);

  /// Push all pending (isSynced == false) records from Hive to Firestore.
  Future<void> syncPendingRecords();

  /// Seed the local Hive cache from Firestore for a specific santri.
  /// Only performs a network fetch if the local box has NO records for this santri.
  /// Call this when opening any screen that reads from the local Hive box to
  /// ensure historical data is present after a fresh install or cache wipe.
  Future<void> seedFromRemoteIfEmpty(String santriId);

  /// Watch hafalan records for a specific halaqoh from Firestore, updating the local Hive cache.
  Stream<List<HafalanSantriModel>> watchByHalaqohFromRemote(String halaqohId);

  /// Get all hafalan records for students in a halaqoh on a specific date.

  /// Reads from local Hive cache (synchronous).
  List<HafalanSantriModel> getHafalanByHalaqohAndDate(
      List<String> santriIds, DateTime date);

  /// Get the N most recent hafalan records for a list of santri IDs.
  /// Reads from local Hive cache (synchronous).
  List<HafalanSantriModel> getRecentHafalanBySantriIds(
      List<String> santriIds, {int limit = 3});

  /// Stream that emits whenever any hafalan record changes in the local cache.
  /// Used by the dashboard to reactively update setoran data.
  Stream<void> watchAnyChanges();

  /// Delete a hafalan record.
  Future<Either<String, void>> deleteHafalan(String id);
}
