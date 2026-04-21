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

  /// Push all pending (isSynced == false) records from Hive to Firestore.
  Future<void> syncPendingRecords();
}
