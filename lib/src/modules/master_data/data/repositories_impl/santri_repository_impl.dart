import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:logger/logger.dart';
import 'package:my_halaqoh/src/core/services/activity_log_service.dart';
import 'package:my_halaqoh/src/modules/master_data/data/datasources/local/master_data_local_datasource.dart';
import 'package:my_halaqoh/src/modules/master_data/data/datasources/remote/mapper/santri_mapper.dart';
import 'package:my_halaqoh/src/modules/master_data/data/datasources/remote/mapper/target_hafalan_mapper.dart';
import 'package:my_halaqoh/src/modules/master_data/data/datasources/remote/source/abstract/santri_remote_datasource.dart';
import 'package:my_halaqoh/src/modules/master_data/domain/models/santri_model.dart';
import 'package:my_halaqoh/src/modules/master_data/domain/models/target_hafalan_model.dart';
import 'package:my_halaqoh/src/modules/master_data/domain/repositories/santri_repository.dart';

class SantriRepositoryImpl implements SantriRepository {
  final SantriRemoteDataSource _remote;
  final MasterDataLocalDataSource _local;
  final FirebaseFirestore _firestore;
  final ActivityLogService _activityLog;
  final _log = Logger();

  SantriRepositoryImpl(
      this._remote, this._local, this._firestore, this._activityLog);

  // ──────────────────────────────────────────────────────────────────────────
  // Existing methods
  // ──────────────────────────────────────────────────────────────────────────

  @override
  Stream<List<SantriModel>> watchAll() {
    return _remote.watchAll().map((list) {
      _local.cacheSantri(list);
      return list;
    });
  }

  @override
  Future<Either<String, List<SantriModel>>> getAll() async {
    try {
      final list = await _remote.getAll();
      await _local.cacheSantri(list);
      return Right(list);
    } catch (e) {
      final cached = _local.getAllSantri();
      if (cached.isNotEmpty) return Right(cached);
      return Left('Gagal memuat data santri: $e');
    }
  }

  @override
  Future<Either<String, SantriModel>> getById(String id) async {
    try {
      final model = await _remote.getById(id);
      if (model == null) return const Left('Santri tidak ditemukan');
      return Right(model);
    } catch (e) {
      return Left('Gagal memuat santri: $e');
    }
  }

  @override
  Future<Either<String, List<SantriModel>>> getByFilter({
    String? kelas,
    String? program,
  }) async {
    try {
      final list = await _remote.getByFilter(kelas: kelas, program: program);
      return Right(list);
    } catch (e) {
      // Fallback: filter locally
      final cached = _local.getAllSantri().where((s) {
        if (kelas != null && s.kelas != kelas) return false;
        if (program != null && s.program != program) return false;
        return true;
      }).toList();
      if (cached.isNotEmpty) return Right(cached);
      return Left('Gagal memfilter santri: $e');
    }
  }

  @override
  Future<Either<String, String>> add(SantriModel model) async {
    try {
      final id = await _remote.add(model);
      final created = model.copyWith(id: id);
      await _local.putSantri(created);
      unawaited(_activityLog.log(
        action: 'create',
        module: 'santri',
        entityId: id,
        entityName: model.nama,
        description: 'Menambahkan santri baru: ${model.nama} (NIS: ${model.nis})',
      ));
      return Right(id);
    } catch (e) {
      return Left('Gagal menambahkan santri: $e');
    }
  }

  @override
  Future<Either<String, int>> addBulk(List<SantriModel> models) async {
    try {
      final count = await _remote.addBulk(models);
      unawaited(_activityLog.log(
        action: 'create',
        module: 'santri',
        entityId: 'BULK_UPLOAD',
        entityName: 'Bulk Upload Santri',
        description: 'Menambahkan $count santri via bulk upload',
      ));
      return Right(count);
    } catch (e) {
      return Left('Gagal menambahkan santri bulk: $e');
    }
  }

  @override
  Future<Either<String, void>> update(SantriModel model) async {
    try {
      await _remote.update(model);
      await _local.putSantri(model);
      unawaited(_activityLog.log(
        action: 'update',
        module: 'santri',
        entityId: model.id,
        entityName: model.nama,
        description: 'Mengubah data santri: ${model.nama} (NIS: ${model.nis})',
      ));
      return const Right(null);
    } catch (e) {
      return Left('Gagal mengupdate santri: $e');
    }
  }

  @override
  Future<Either<String, void>> delete(String id) async {
    try {
      String? santriName;
      try {
        final localSantri = _local.santriBox.get(id);
        santriName = localSantri?.nama;
      } catch (_) {}

      await _remote.delete(id);
      await _local.deleteSantri(id);

      unawaited(_activityLog.log(
        action: 'delete',
        module: 'santri',
        entityId: id,
        entityName: santriName ?? 'ID: $id',
        description: 'Menghapus santri: ${santriName ?? id}',
      ));
      return const Right(null);
    } catch (e) {
      return Left('Gagal menghapus santri: $e');
    }
  }

  @override
  Future<Either<String, void>> resetPassword(String authUid) async {
    try {
      await _remote.resetPassword(authUid);
      return const Right(null);
    } catch (e) {
      return Left(e.toString().replaceAll('Exception: ', ''));
    }
  }

  // ──────────────────────────────────────────────────────────────────────────
  // Kenaikan Kelas — Batch Write
  // ──────────────────────────────────────────────────────────────────────────

  /// Mapping kelas lama → kelas baru. Kelas 12 tidak ada entrynya → alumni.
  @override
  Future<Either<String, void>> promoteAll({
    required String tahunAjaran,
    required int semesterAktif,
    required List<SantriModel> aktivSantri,
    required List<TargetHafalanModel> currentTargets,
  }) async {
    try {
      final now = DateTime.now();

      // Fetch Kelas and Program dynamically from Firestore
      final kelasSnap = await _firestore.collection('kelas').get();
      final nextKelasMap = <String, String?>{
        for (final doc in kelasSnap.docs)
          doc.id: doc.data()['nextKelasId'] as String?,
      };
      final allKelas = kelasSnap.docs.map((doc) => doc.id).toList();

      final programSnap = await _firestore.collection('program').get();
      final allPrograms = programSnap.docs
          .map((doc) => doc.data()['nama'] as String)
          .toList();

      final batch = _firestore.batch();
      final santriCol = _firestore.collection('santri');
      final targetCol = _firestore.collection('targetHafalan');
      final halaqohCol = _firestore.collection('halaqoh');

      // 1. Update setiap santri aktif + kumpulkan mapping halaqohId → nextKelas
      final Map<String, String> halaqohNextKelas = {};
      for (final santri in aktivSantri) {
        final nextKelas = nextKelasMap[santri.kelas];
        final updated = nextKelas != null
            ? santri.copyWith(kelas: nextKelas, updatedAt: now)
            : santri.copyWith(isAlumni: true, updatedAt: now);

        batch.update(
          santriCol.doc(santri.id),
          SantriMapper.toFirestore(updated),
        );
        // Update local cache too
        _local.putSantri(updated);

        // Catat nextKelas untuk halaqoh ini (hanya jika naik kelas, bukan alumni)
        if (nextKelas != null &&
            santri.halaqohId != null &&
            santri.halaqohId!.isNotEmpty) {
          halaqohNextKelas[santri.halaqohId!] = nextKelas;
        }
      }

      // 2. Update kelas pada setiap HalaqohModel yang terdampak.
      for (final entry in halaqohNextKelas.entries) {
        batch.update(
          halaqohCol.doc(entry.key),
          {'kelas': entry.value, 'updatedAt': Timestamp.fromDate(now)},
        );
      }

      // 3. Upsert SEMUA kombinasi kelas+program dengan tahun ajaran + semester baru.
      final existingMap = {
        for (final t in currentTargets) '${t.kelas}_${t.program}': t,
      };

      for (final kelas in allKelas) {
        for (final program in allPrograms) {
          final docId = '${kelas}_$program';
          final existing = existingMap[docId];

          final updated = existing != null
              ? existing.copyWith(
                  tahunAjaran: tahunAjaran,
                  semesterAktif: semesterAktif,
                  updatedAt: now,
                )
              : TargetHafalanModel(
                  id: docId,
                  kelas: kelas,
                  program: program,
                  tahunAjaran: tahunAjaran,
                  semesterAktif: semesterAktif,
                  createdAt: now,
                  updatedAt: now,
                );

          batch.set(
            targetCol.doc(docId),
            TargetHafalanMapper.toFirestore(updated),
            SetOptions(merge: true),
          );
        }
      }

      await batch.commit();
      final totalAlumniBaru = aktivSantri.where((s) => nextKelasMap[s.kelas] == null).length;
      _log.i('promoteAll: ${aktivSantri.length} santri diproses, $totalAlumniBaru alumni baru.');
      return const Right(null);
    } catch (e) {
      _log.e('promoteAll failed: $e');
      return Left('Gagal memproses kenaikan kelas: $e');
    }
  }
}
