import 'package:hive/hive.dart';
import 'package:my_halaqoh/src/modules/master_data/domain/models/guru_model.dart';
import 'package:my_halaqoh/src/modules/master_data/domain/models/santri_model.dart';
import 'package:my_halaqoh/src/modules/master_data/domain/models/halaqoh_model.dart';
import 'package:my_halaqoh/src/modules/master_data/domain/models/target_hafalan_model.dart';

/// Box name constants for master data Hive storage.
class MasterDataBoxNames {
  static const guru = 'guru_box';
  static const santri = 'santri_box';
  static const halaqoh = 'halaqoh_box';
  static const targetHafalan = 'target_hafalan_box';
}

/// Local data source for master data using Hive as cache.
class MasterDataLocalDataSource {
  late Box<GuruModel> guruBox;
  late Box<SantriModel> santriBox;
  late Box<HalaqohModel> halaqohBox;
  late Box<TargetHafalanModel> targetHafalanBox;

  /// Open all Hive boxes. Call after adapter registration.
  Future<void> init() async {
    guruBox = await Hive.openBox<GuruModel>(MasterDataBoxNames.guru);
    santriBox = await Hive.openBox<SantriModel>(MasterDataBoxNames.santri);
    halaqohBox = await Hive.openBox<HalaqohModel>(MasterDataBoxNames.halaqoh);
    targetHafalanBox = await Hive.openBox<TargetHafalanModel>(
      MasterDataBoxNames.targetHafalan,
    );
  }

  // ─── Guru ────────────────────────────────────────────────────────────────

  List<GuruModel> getAllGuru() => guruBox.values.toList();

  Future<void> cacheGuru(List<GuruModel> list) async {
    await guruBox.clear();
    for (final item in list) {
      await guruBox.put(item.id, item);
    }
  }

  Future<void> putGuru(GuruModel model) => guruBox.put(model.id, model);
  Future<void> deleteGuru(String id) => guruBox.delete(id);

  // ─── Santri ──────────────────────────────────────────────────────────────

  List<SantriModel> getAllSantri() => santriBox.values.toList();

  Future<void> cacheSantri(List<SantriModel> list) async {
    await santriBox.clear();
    for (final item in list) {
      await santriBox.put(item.id, item);
    }
  }

  Future<void> putSantri(SantriModel model) => santriBox.put(model.id, model);
  Future<void> deleteSantri(String id) => santriBox.delete(id);

  // ─── Halaqoh ─────────────────────────────────────────────────────────────

  List<HalaqohModel> getAllHalaqoh() => halaqohBox.values.toList();

  Future<void> cacheHalaqoh(List<HalaqohModel> list) async {
    await halaqohBox.clear();
    for (final item in list) {
      await halaqohBox.put(item.id, item);
    }
  }

  Future<void> putHalaqoh(HalaqohModel model) =>
      halaqohBox.put(model.id, model);
  Future<void> deleteHalaqoh(String id) => halaqohBox.delete(id);

  // ─── Target Hafalan ──────────────────────────────────────────────────────

  List<TargetHafalanModel> getAllTargetHafalan() =>
      targetHafalanBox.values.toList();

  Future<void> cacheTargetHafalan(List<TargetHafalanModel> list) async {
    await targetHafalanBox.clear();
    for (final item in list) {
      await targetHafalanBox.put(item.id, item);
    }
  }

  Future<void> putTargetHafalan(TargetHafalanModel model) =>
      targetHafalanBox.put(model.id, model);
  Future<void> deleteTargetHafalan(String id) =>
      targetHafalanBox.delete(id);
}
