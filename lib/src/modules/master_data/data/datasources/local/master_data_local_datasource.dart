import 'dart:async';
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
/// Designed to be resilient against hot restart and unexpected box closures.
class MasterDataLocalDataSource {
  Box<GuruModel>? _guruBox;
  Box<SantriModel>? _santriBox;
  Box<HalaqohModel>? _halaqohBox;
  Box<TargetHafalanModel>? _targetHafalanBox;
  Box<HafalanSantriModel>? _hafalanSantriBox;

  Box<GuruModel> get guruBox => _getOpenBoxSync<GuruModel>(MasterDataBoxNames.guru) ?? _guruBox!;
  Box<SantriModel> get santriBox => _getOpenBoxSync<SantriModel>(MasterDataBoxNames.santri) ?? _santriBox!;
  Box<HalaqohModel> get halaqohBox => _getOpenBoxSync<HalaqohModel>(MasterDataBoxNames.halaqoh) ?? _halaqohBox!;
  Box<TargetHafalanModel> get targetHafalanBox => _getOpenBoxSync<TargetHafalanModel>(MasterDataBoxNames.targetHafalan) ?? _targetHafalanBox!;
  Box<HafalanSantriModel> get hafalanSantriBox => _getOpenBoxSync<HafalanSantriModel>(MasterDataBoxNames.hafalanSantri) ?? _hafalanSantriBox!;

  Box<T>? _getOpenBoxSync<T>(String name) {
    if (Hive.isBoxOpen(name)) {
      final box = Hive.box<T>(name);
      if (box.isOpen) return box;
    }
    return null;
  }

  Future<Box<T>> _openBoxSafely<T>(String name) async {
    // If the box is already open (e.g. after a hot restart where Dart VM
    // persists but the widget tree is rebuilt), return it immediately.
    // Calling Hive.openBox() on an already-open box throws HiveError.
    if (Hive.isBoxOpen(name)) {
      final box = Hive.box<T>(name);
      if (box.isOpen) return box;
    }
    try {
      return await Hive.openBox<T>(name);
    } catch (e) {
      // Type mismatch or corrupted box — wipe and retry once.
      try {
        await Hive.deleteBoxFromDisk(name);
      } catch (_) {}
      return await Hive.openBox<T>(name);
    }
  }

  /// Open all Hive boxes. Call after adapter registration.
  /// Safe to call multiple times (idempotent — already-open boxes are reused).
  Future<void> init() async {
    _guruBox = await _openBoxSafely<GuruModel>(MasterDataBoxNames.guru);
    _santriBox = await _openBoxSafely<SantriModel>(MasterDataBoxNames.santri);
    _halaqohBox = await _openBoxSafely<HalaqohModel>(MasterDataBoxNames.halaqoh);
    _targetHafalanBox = await _openBoxSafely<TargetHafalanModel>(
      MasterDataBoxNames.targetHafalan,
    );
    _hafalanSantriBox = await _openBoxSafely<HafalanSantriModel>(
      MasterDataBoxNames.hafalanSantri,
    );
  }

  // ─── Guru ────────────────────────────────────────────────────────────────

  List<GuruModel> getAllGuru() {
    final box = _getOpenBoxSync<GuruModel>(MasterDataBoxNames.guru);
    return box != null && box.isOpen ? box.values.toList() : [];
  }

  Future<void> cacheGuru(List<GuruModel> list) async {
    try {
      final box = await _openBoxSafely<GuruModel>(MasterDataBoxNames.guru);
      if (!box.isOpen) return;
      await box.clear();
      final map = {for (final item in list) item.id: item};
      await box.putAll(map);
    } on HiveError catch (_) {
      // Box was closed during hot restart or teardown — gracefully ignore
    } catch (_) {}
  }

  Future<void> putGuru(GuruModel model) async {
    try {
      final box = await _openBoxSafely<GuruModel>(MasterDataBoxNames.guru);
      if (box.isOpen) await box.put(model.id, model);
    } catch (_) {}
  }

  Future<void> deleteGuru(String id) async {
    try {
      final box = await _openBoxSafely<GuruModel>(MasterDataBoxNames.guru);
      if (box.isOpen) await box.delete(id);
    } catch (_) {}
  }

  // ─── Santri ──────────────────────────────────────────────────────────────

  List<SantriModel> getAllSantri() {
    final box = _getOpenBoxSync<SantriModel>(MasterDataBoxNames.santri);
    return box != null && box.isOpen ? box.values.toList() : [];
  }

  Future<void> cacheSantri(List<SantriModel> list) async {
    try {
      final box = await _openBoxSafely<SantriModel>(MasterDataBoxNames.santri);
      if (!box.isOpen) return;
      await box.clear();
      final map = {for (final item in list) item.id: item};
      await box.putAll(map);
    } on HiveError catch (_) {
      // Box was closed during hot restart or teardown — gracefully ignore
    } catch (_) {}
  }

  Future<void> putSantri(SantriModel model) async {
    try {
      final box = await _openBoxSafely<SantriModel>(MasterDataBoxNames.santri);
      if (box.isOpen) await box.put(model.id, model);
    } catch (_) {}
  }

  Future<void> deleteSantri(String id) async {
    try {
      final box = await _openBoxSafely<SantriModel>(MasterDataBoxNames.santri);
      if (box.isOpen) await box.delete(id);
    } catch (_) {}
  }

  // ─── Halaqoh ─────────────────────────────────────────────────────────────

  List<HalaqohModel> getAllHalaqoh() {
    final box = _getOpenBoxSync<HalaqohModel>(MasterDataBoxNames.halaqoh);
    return box != null && box.isOpen ? box.values.toList() : [];
  }

  Future<void> cacheHalaqoh(List<HalaqohModel> list) async {
    try {
      final box = await _openBoxSafely<HalaqohModel>(MasterDataBoxNames.halaqoh);
      if (!box.isOpen) return;
      await box.clear();
      final map = {for (final item in list) item.id: item};
      await box.putAll(map);
    } on HiveError catch (_) {
      // Box was closed during hot restart or teardown — gracefully ignore
    } catch (_) {}
  }

  Future<void> putHalaqoh(HalaqohModel model) async {
    try {
      final box = await _openBoxSafely<HalaqohModel>(MasterDataBoxNames.halaqoh);
      if (box.isOpen) await box.put(model.id, model);
    } catch (_) {}
  }

  Future<void> deleteHalaqoh(String id) async {
    try {
      final box = await _openBoxSafely<HalaqohModel>(MasterDataBoxNames.halaqoh);
      if (box.isOpen) await box.delete(id);
    } catch (_) {}
  }

  // ─── Target Hafalan ──────────────────────────────────────────────────────

  List<TargetHafalanModel> getAllTargetHafalan() {
    final box = _getOpenBoxSync<TargetHafalanModel>(MasterDataBoxNames.targetHafalan);
    return box != null && box.isOpen ? box.values.toList() : [];
  }

  Future<void> cacheTargetHafalan(List<TargetHafalanModel> list) async {
    try {
      final box = await _openBoxSafely<TargetHafalanModel>(MasterDataBoxNames.targetHafalan);
      if (!box.isOpen) return;
      await box.clear();
      final map = {for (final item in list) item.id: item};
      await box.putAll(map);
    } on HiveError catch (_) {
      // Box was closed during hot restart or teardown — gracefully ignore
    } catch (_) {}
  }

  Future<void> putTargetHafalan(TargetHafalanModel model) async {
    try {
      final box = await _openBoxSafely<TargetHafalanModel>(MasterDataBoxNames.targetHafalan);
      if (box.isOpen) await box.put(model.id, model);
    } catch (_) {}
  }

  Future<void> deleteTargetHafalan(String id) async {
    try {
      final box = await _openBoxSafely<TargetHafalanModel>(MasterDataBoxNames.targetHafalan);
      if (box.isOpen) await box.delete(id);
    } catch (_) {}
  }
}
