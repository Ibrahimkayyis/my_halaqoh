import 'package:hive_flutter/hive_flutter.dart';
import '../../../../master_data/data/datasources/local/master_data_local_datasource.dart';
import '../../../domain/models/hafalan_santri_model.dart';

class HafalanSantriLocalDataSource {
  /// Returns the open box, or throws [StateError] if it is not yet open.
  /// Use [_boxOrNull] for read paths that should silently skip when closed.
  Box<HafalanSantriModel> get _box =>
      Hive.box<HafalanSantriModel>(MasterDataBoxNames.hafalanSantri);

  Box<HafalanSantriModel>? get _boxOrNull => Hive.isBoxOpen(MasterDataBoxNames.hafalanSantri)
      ? Hive.box<HafalanSantriModel>(MasterDataBoxNames.hafalanSantri)
      : null;

  /// Put a single record
  Future<void> put(HafalanSantriModel model) async {
    await _box.put(model.id, model);
  }

  /// Put multiple records in batch
  Future<void> putAll(List<HafalanSantriModel> list) async {
    if (list.isEmpty) return;
    final map = {for (final item in list) item.id: item};
    await _box.putAll(map);
  }

  /// Watch all records for a specific santri, month, and year.
  /// Emits current data immediately, then on every Hive change.
  /// Terminates gracefully if the box is closed (e.g. on hot restart).
  Stream<List<HafalanSantriModel>> watchHafalanBySantriId(String santriId, int month, int year) async* {
    final box = _boxOrNull;
    if (box == null) return;
    // Emit current snapshot first
    yield _getFilteredHafalan(santriId, month, year);
    // Then emit on every change, stopping if box closes
    try {
      await for (final _ in box.watch()) {
        if (!box.isOpen) break;
        yield _getFilteredHafalan(santriId, month, year);
      }
    } on HiveError catch (_) {
      // Box was closed (e.g. hot restart) — end stream silently.
    }
  }

  /// Helper to get filtered list
  List<HafalanSantriModel> _getFilteredHafalan(String santriId, int month, int year) {
    final box = _boxOrNull;
    if (box == null) return [];
    return box.values.where((item) {
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

  /// Get ALL records for a specific santri.
  List<HafalanSantriModel> getAllHafalanBySantriId(String santriId) {
    final box = _boxOrNull;
    if (box == null) return [];
    return box.values.where((item) => item.santriId == santriId).toList()
      ..sort((a, b) => b.tanggalSetoran.compareTo(a.tanggalSetoran));
  }

  /// Watch all Ziyadah records for progress calculation.
  /// Emits current data immediately, then on every Hive change.
  /// Terminates gracefully if the box is closed (e.g. on hot restart).
  Stream<List<HafalanSantriModel>> watchAllZiyadahBySantriId(String santriId) async* {
    final box = _boxOrNull;
    if (box == null) return;
    yield _getAllZiyadah(santriId);
    try {
      await for (final _ in box.watch()) {
        if (!box.isOpen) break;
        yield _getAllZiyadah(santriId);
      }
    } on HiveError catch (_) {
      // Box was closed — end stream silently.
    }
  }

  List<HafalanSantriModel> _getAllZiyadah(String santriId) {
    final box = _boxOrNull;
    if (box == null) return [];
    return box.values.where((item) {
      return item.santriId == santriId && item.jenis == 'Ziyadah';
    }).toList();
  }

  List<HafalanSantriModel> getAllZiyadahBySantriId(String santriId) {
    return _getAllZiyadah(santriId);
  }

  /// Get all pending records that need to be synced to Firestore
  List<HafalanSantriModel> getPendingSync() {
    final box = _boxOrNull;
    if (box == null) return [];
    return box.values.where((item) => !item.isSynced).toList();
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

  /// Get all hafalan records for students in a halaqoh on a specific date.
  /// Used by the dashboard to calculate today's setoran percentage.
  List<HafalanSantriModel> getHafalanByHalaqohAndDate(
      List<String> santriIds, DateTime date) {
    final box = _boxOrNull;
    if (box == null) return [];
    final targetDate = date.toLocal();
    return box.values.where((item) {
      final itemDate = item.tanggalSetoran.toLocal();
      return santriIds.contains(item.santriId) &&
             itemDate.year == targetDate.year &&
             itemDate.month == targetDate.month &&
             itemDate.day == targetDate.day;
    }).toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
  }

  /// Get the N most recent hafalan records for a list of santri.
  /// Used by the dashboard for the "Setoran Terakhir" section.
  List<HafalanSantriModel> getRecentHafalanBySantriIds(
      List<String> santriIds, {int limit = 3}) {
    final box = _boxOrNull;
    if (box == null) return [];
    final records = box.values.where((item) {
      return santriIds.contains(item.santriId);
    }).toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return records.take(limit).toList();
  }

  /// Stream that emits whenever any record in the hafalan box changes.
  /// Used by the dashboard cubit to reactively recompute setoran data.
  /// Ensures the box is open and emits an initial event immediately.
  /// Terminates gracefully if the box is closed (e.g. on hot restart).
  Stream<void> watchAnyChanges() async* {
    Box<HafalanSantriModel> box;
    if (Hive.isBoxOpen(MasterDataBoxNames.hafalanSantri)) {
      box = Hive.box<HafalanSantriModel>(MasterDataBoxNames.hafalanSantri);
    } else {
      try {
        box = await Hive.openBox<HafalanSantriModel>(
            MasterDataBoxNames.hafalanSantri);
      } catch (_) {
        return;
      }
    }
    // Emit initial event so listeners can compute initial state immediately
    yield null;
    try {
      await for (final _ in box.watch()) {
        if (!box.isOpen) break;
        yield null;
      }
    } on HiveError catch (_) {
      // Silently swallow HiveError (box closed on hot restart).
    }
  }

  /// Delete a single record from Hive
  Future<void> delete(String id) async {
    await _box.delete(id);
  }
}

