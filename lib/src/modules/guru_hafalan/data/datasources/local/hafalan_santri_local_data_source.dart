import 'package:hive_flutter/hive_flutter.dart';
import '../../../../master_data/data/datasources/local/master_data_local_datasource.dart';
import '../../../domain/models/hafalan_santri_model.dart';

class HafalanSantriLocalDataSource {
  Box<HafalanSantriModel> get _box => Hive.box<HafalanSantriModel>(MasterDataBoxNames.hafalanSantri);

  /// Put a single record
  Future<void> put(HafalanSantriModel model) async {
    await _box.put(model.id, model);
  }

  /// Watch all records for a specific santri, month, and year.
  /// Emits current data immediately, then on every Hive change.
  Stream<List<HafalanSantriModel>> watchHafalanBySantriId(String santriId, int month, int year) async* {
    // Emit current snapshot first
    yield _getFilteredHafalan(santriId, month, year);
    // Then emit on every change
    await for (final _ in _box.watch()) {
      yield _getFilteredHafalan(santriId, month, year);
    }
  }

  /// Helper to get filtered list
  List<HafalanSantriModel> _getFilteredHafalan(String santriId, int month, int year) {
    return _box.values.where((item) {
      return item.santriId == santriId &&
             item.tanggalSetoran.month == month &&
             item.tanggalSetoran.year == year;
    }).toList()
      ..sort((a, b) => b.tanggalSetoran.compareTo(a.tanggalSetoran)); // Descending order
  }

  /// Gets the initial list (before any stream events)
  List<HafalanSantriModel> getHafalanBySantriId(String santriId, int month, int year) {
    return _getFilteredHafalan(santriId, month, year);
  }

  /// Watch all Ziyadah records for progress calculation.
  /// Emits current data immediately, then on every Hive change.
  Stream<List<HafalanSantriModel>> watchAllZiyadahBySantriId(String santriId) async* {
    yield _getAllZiyadah(santriId);
    await for (final _ in _box.watch()) {
      yield _getAllZiyadah(santriId);
    }
  }

  List<HafalanSantriModel> _getAllZiyadah(String santriId) {
    return _box.values.where((item) {
      return item.santriId == santriId && item.jenis == 'Ziyadah';
    }).toList();
  }

  List<HafalanSantriModel> getAllZiyadahBySantriId(String santriId) {
    return _getAllZiyadah(santriId);
  }

  /// Get all pending records that need to be synced to Firestore
  List<HafalanSantriModel> getPendingSync() {
    return _box.values.where((item) => !item.isSynced).toList();
  }

  /// Mark a record as synced
  Future<void> markAsSynced(String id) async {
    final item = _box.get(id);
    if (item != null) {
      await _box.put(id, item.copyWith(isSynced: true));
    }
  }

  /// Mark multiple records as synced
  Future<void> markAllAsSynced(List<String> ids) async {
    final mapToUpdate = <String, HafalanSantriModel>{};
    for (final id in ids) {
      final item = _box.get(id);
      if (item != null) {
        mapToUpdate[id] = item.copyWith(isSynced: true);
      }
    }
    if (mapToUpdate.isNotEmpty) {
      await _box.putAll(mapToUpdate);
    }
  }
}
