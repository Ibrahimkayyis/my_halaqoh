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
    await putAll(list);
  }

  /// Upsert a single record.
  Future<void> put(AbsensiModel model) async {
    final box = await _openBox();
    await box.put(model.id, model);
  }

  /// Upsert multiple records in a single batch.
  Future<void> putAll(List<AbsensiModel> list) async {
    if (list.isEmpty) return;
    final box = await _openBox();
    final map = {for (final item in list) item.id: item};
    await box.putAll(map);
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

  /// Stream yang mengembalikan daftar absensi untuk halaqoh tertentu.
  /// Emit data saat ini, lalu emit setiap kali ada perubahan di Hive box.
  Stream<List<AbsensiModel>> watchByHalaqoh(String halaqohId) async* {
    final box = await _openBox();
    yield _filterByHalaqoh(box, halaqohId);
    await for (final _ in box.watch()) {
      yield _filterByHalaqoh(box, halaqohId);
    }
  }

  List<AbsensiModel> _filterByHalaqoh(Box<AbsensiModel> box, String halaqohId) {
    final list = box.values.where((m) => m.halaqohId == halaqohId).toList();
    list.sort((a, b) => b.tanggal.compareTo(a.tanggal));
    return list;
  }

  /// Cari sesi absensi secara sinkron dari Hive cache tanpa network.
  /// Mengembalikan null jika tidak ditemukan.
  AbsensiModel? findInCache(String halaqohId, DateTime tanggal, String sesi) {
    if (!Hive.isBoxOpen(_boxName)) return null;
    final box = Hive.box<AbsensiModel>(_boxName);
    final dateOnly = DateTime(tanggal.year, tanggal.month, tanggal.day);
    try {
      return box.values.firstWhere(
        (m) =>
            m.halaqohId == halaqohId &&
            m.sesi == sesi &&
            m.tanggal.year == dateOnly.year &&
            m.tanggal.month == dateOnly.month &&
            m.tanggal.day == dateOnly.day,
      );
    } catch (_) {
      return null;
    }
  }

  /// Get all unsynced records (isSynced == false).
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
