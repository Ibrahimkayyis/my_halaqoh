import 'package:hive/hive.dart';
import '../../../domain/models/absensi_model.dart';

/// Local Hive cache for attendance records.
class AbsensiLocalDataSource {
  static const String _boxName = 'absensi_box';

  Future<Box<AbsensiModel>> _openBox() async {
    if (Hive.isBoxOpen(_boxName)) {
      return Hive.box<AbsensiModel>(_boxName);
    }
    try {
      return await Hive.openBox<AbsensiModel>(_boxName);
    } catch (e) {
      // If there's a type mismatch or corrupted box, delete it and try again
      try {
        await Hive.deleteBoxFromDisk(_boxName);
      } catch (_) {}
      return await Hive.openBox<AbsensiModel>(_boxName);
    }
  }

  /// Cache a list of records (clear-then-write).
  Future<void> cacheAll(List<AbsensiModel> list) async {
    final box = await _openBox();
    await box.clear();
    for (final item in list) {
      await box.put(item.id, item);
    }
  }

  /// Upsert a single record.
  Future<void> put(AbsensiModel model) async {
    final box = await _openBox();
    await box.put(model.id, model);
  }

  /// Get all cached records.
  Future<List<AbsensiModel>> getAll() async {
    final box = await _openBox();
    return box.values.toList();
  }

  /// Get records for a specific halaqoh.
  Future<List<AbsensiModel>> getByHalaqoh(String halaqohId) async {
    final all = await getAll();
    return all.where((m) => m.halaqohId == halaqohId).toList();
  }

  /// Get all unsynced records.
  Future<List<AbsensiModel>> getUnsynced() async {
    final all = await getAll();
    return all.where((m) => !m.isSynced).toList();
  }

  /// Delete by ID.
  Future<void> delete(String id) async {
    final box = await _openBox();
    await box.delete(id);
  }
}
