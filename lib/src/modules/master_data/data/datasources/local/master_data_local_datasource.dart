import 'package:hive/hive.dart';
import 'package:my_halaqoh/src/modules/master_data/domain/models/guru_model.dart';
import 'package:my_halaqoh/src/modules/master_data/domain/models/santri_model.dart';
import 'package:my_halaqoh/src/modules/master_data/domain/models/halaqoh_model.dart';
import 'package:my_halaqoh/src/modules/master_data/domain/models/target_hafalan_model.dart';

import 'package:my_halaqoh/src/modules/guru_hafalan/domain/models/hafalan_santri_model.dart';

/// Box name constants for master data Hive storage.
class MasterDataBoxNames {
  static const guru = 'guru_box';
  static const santri = 'santri_box';
  static const halaqoh = 'halaqoh_box';
  static const targetHafalan = 'target_hafalan_box';
  static const hafalanSantri = 'hafalan_santri_box';
}

/// Local data source for master data using Hive as cache.
class MasterDataLocalDataSource {
  late Box<GuruModel> guruBox;
  late Box<SantriModel> santriBox;
  late Box<HalaqohModel> halaqohBox;
  late Box<TargetHafalanModel> targetHafalanBox;
  late Box<HafalanSantriModel> hafalanSantriBox;

  Future<Box<T>> _openBoxSafely<T>(String name) async {
    try {
      return await Hive.openBox<T>(name);
    } catch (e) {
      try {
        await Hive.deleteBoxFromDisk(name);
      } catch (_) {}
      return await Hive.openBox<T>(name);
    }
  }

  /// Open all Hive boxes. Call after adapter registration.
  Future<void> init() async {
    guruBox = await _openBoxSafely<GuruModel>(MasterDataBoxNames.guru);
    santriBox = await _openBoxSafely<SantriModel>(MasterDataBoxNames.santri);
    halaqohBox = await _openBoxSafely<HalaqohModel>(MasterDataBoxNames.halaqoh);
    targetHafalanBox = await _openBoxSafely<TargetHafalanModel>(
      MasterDataBoxNames.targetHafalan,
    );
    hafalanSantriBox = await _openBoxSafely<HafalanSantriModel>(
      MasterDataBoxNames.hafalanSantri,
    );
  }

  // ─── Guru ────────────────────────────────────────────────────────────────

  List<GuruModel> getAllGuru() => guruBox.values.toList();

  Future<void> cacheGuru(List<GuruModel> list) async {
    await guruBox.clear();
    final map = {for (final item in list) item.id: item};
    await guruBox.putAll(map);
  }

  Future<void> putGuru(GuruModel model) => guruBox.put(model.id, model);
  Future<void> deleteGuru(String id) => guruBox.delete(id);

  // ─── Santri ──────────────────────────────────────────────────────────────

  List<SantriModel> getAllSantri() => santriBox.values.toList();

  Future<void> cacheSantri(List<SantriModel> list) async {
    await santriBox.clear();
    final map = {for (final item in list) item.id: item};
    await santriBox.putAll(map);
  }

  Future<void> putSantri(SantriModel model) => santriBox.put(model.id, model);
  Future<void> deleteSantri(String id) => santriBox.delete(id);

  // ─── Halaqoh ─────────────────────────────────────────────────────────────

  List<HalaqohModel> getAllHalaqoh() => halaqohBox.values.toList();

  Future<void> cacheHalaqoh(List<HalaqohModel> list) async {
    await halaqohBox.clear();
    final map = {for (final item in list) item.id: item};
    await halaqohBox.putAll(map);
  }

  Future<void> putHalaqoh(HalaqohModel model) =>
      halaqohBox.put(model.id, model);
  Future<void> deleteHalaqoh(String id) => halaqohBox.delete(id);

  // ─── Target Hafalan ──────────────────────────────────────────────────────

  List<TargetHafalanModel> getAllTargetHafalan() =>
      targetHafalanBox.values.toList();

  Future<void> cacheTargetHafalan(List<TargetHafalanModel> list) async {
    await targetHafalanBox.clear();
    final map = {for (final item in list) item.id: item};
    await targetHafalanBox.putAll(map);
  }

  Future<void> putTargetHafalan(TargetHafalanModel model) =>
      targetHafalanBox.put(model.id, model);
  Future<void> deleteTargetHafalan(String id) =>
      targetHafalanBox.delete(id);
}
