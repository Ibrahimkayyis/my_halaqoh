import 'package:dartz/dartz.dart';
import 'package:logger/logger.dart';
import '../../domain/models/absensi_model.dart';
import '../../domain/repositories/absensi_repository.dart';
import '../datasources/local/absensi_local_datasource.dart';
import '../datasources/remote/source/abstract/absensi_remote_datasource.dart';

/// Unified Offline-First implementation — seragam dengan guru_hafalan.
///
/// Prinsip:
/// 1. BACA  : Stream dari Hive (lokal). Firestore hanya diakses untuk seed awal.
/// 2. TULIS : Hive dulu (instant, selalu sukses) → async push ke Firestore.
/// 3. ID    : Deterministic client-side key: '{halaqohId}_{tanggalMs}_{sesi}'.
///            Key tidak pernah berubah antara offline dan online, tidak perlu
///            penggantian ID seperti pola local_xxx sebelumnya.
/// 4. SYNC  : AbsensiSyncService mendengarkan connectivity_plus, memanggil
///            syncPendingRecords() saat internet tersambung kembali.
class AbsensiRepositoryImpl implements AbsensiRepository {
  final AbsensiRemoteDataSource _remote;
  final AbsensiLocalDataSource _local;
  final _log = Logger();

  AbsensiRepositoryImpl(this._remote, this._local);

  // ── READ ────────────────────────────────────────────────────────────────────

  @override
  Stream<List<AbsensiModel>> watchByHalaqoh(String halaqohId) {
    // Non-blocking seed: jika Hive kosong untuk halaqoh ini, fetch dari Firestore.
    // Saat seed selesai, stream akan otomatis emit data baru.
    seedFromRemoteIfEmpty(halaqohId);

    // Sumber data utama: Hive stream (offline-first, selalu tersedia).
    return _local.watchByHalaqoh(halaqohId);
  }

  @override
  Stream<List<AbsensiModel>> watchByHalaqohFromRemote(String halaqohId) {
    // Sumber data: Firestore realtime stream (untuk wali santri di device berbeda).
    // Side-effect: update Hive setiap emit agar data offline tetap fresh.
    return _remote.watchByHalaqoh(halaqohId).asyncMap((list) async {
      await _local.putAll(list);
      return list;
    });
  }

  @override
  Future<Either<String, List<AbsensiModel>>> getByHalaqoh(
    String halaqohId,
  ) async {
    try {
      final list = await _remote.getByHalaqoh(halaqohId);
      await _local.cacheAll(list);
      return Right(list);
    } catch (_) {
      try {
        final cached = await _local.getByHalaqoh(halaqohId);
        return Right(cached);
      } catch (e) {
        return Left('Gagal memuat data absensi: $e');
      }
    }
  }

  // ── FIND EXISTING (cek duplikat) ────────────────────────────────────────────

  @override
  Future<AbsensiModel?> findExisting(
    String halaqohId,
    DateTime tanggal,
    String sesi,
  ) async {
    // Cek dari Hive secara sinkron — tidak butuh network, tidak bisa timeout.
    return _local.findInCache(halaqohId, tanggal, sesi);
  }

  // ── WRITE ───────────────────────────────────────────────────────────────────

  @override
  Future<Either<String, String>> saveSession(AbsensiModel model) async {
    try {
      // STEP 1: Simpan ke Hive (isSynced: false) — INSTANT, selalu berhasil.
      final localModel = model.copyWith(isSynced: false);
      await _local.put(localModel);

      // STEP 2: Push ke Firestore di background (fire-and-forget).
      // Jika offline/gagal, AbsensiSyncService akan retry saat koneksi kembali.
      _trySyncNow(localModel);

      return Right(model.id);
    } catch (e, st) {
      _log.e('Failed to save absensi locally', error: e, stackTrace: st);
      return Left('Gagal menyimpan absensi secara lokal: $e');
    }
  }

  /// Push satu record ke Firestore secara asinkron (fire-and-forget).
  Future<void> _trySyncNow(AbsensiModel model) async {
    try {
      await _remote.put(model);
      final synced = model.copyWith(isSynced: true);
      await _local.put(synced);
      _log.d('Absensi ${model.id} synced immediately.');
    } catch (e) {
      _log.w('Immediate sync failed for ${model.id}, will retry later. Error: $e');
      // Gagal diam-diam — record tetap di Hive dengan isSynced: false.
    }
  }

  // ── SEED ────────────────────────────────────────────────────────────────────

  @override
  Future<void> seedFromRemoteIfEmpty(String halaqohId) async {
    final cached = await _local.getByHalaqoh(halaqohId);
    if (cached.isNotEmpty) {
      _log.d('seedFromRemoteIfEmpty: Hive sudah ada data untuk halaqoh=$halaqohId — skip.');
      return;
    }

    _log.i('seedFromRemoteIfEmpty: Hive kosong untuk halaqoh=$halaqohId. Fetch dari Firestore...');
    try {
      final remoteList = await _remote.getByHalaqoh(halaqohId);
      if (remoteList.isEmpty) {
        _log.i('seedFromRemoteIfEmpty: tidak ada data di Firestore untuk halaqoh=$halaqohId.');
        return;
      }
      await _local.putAll(remoteList); // isSynced: true karena dari Firestore
      _log.i('seedFromRemoteIfEmpty: seeded ${remoteList.length} records ke Hive.');
    } catch (e, st) {
      // Non-fatal: tampilkan empty state, user bisa retry dengan membuka ulang.
      _log.e('seedFromRemoteIfEmpty: Firestore fetch gagal', error: e, stackTrace: st);
    }
  }

  // ── DELETE ──────────────────────────────────────────────────────────────────

  @override
  Future<Either<String, void>> delete(String id) async {
    try {
      // 1. Hapus dari Hive lokal
      await _local.delete(id);

      // 2. Hapus dari Firestore (best-effort)
      try {
        await _remote.delete(id);
      } catch (e) {
        _log.w('Failed to delete remote record immediately: $e');
      }
      return const Right(null);
    } catch (e, st) {
      _log.e('Failed to delete absensi locally', error: e, stackTrace: st);
      return Left('Gagal menghapus data absensi: $e');
    }
  }

  // ── SYNC ────────────────────────────────────────────────────────────────────

  @override
  Future<void> syncPendingRecords() async {
    final unsynced = await _local.getUnsynced();
    if (unsynced.isEmpty) return;

    _log.i('Syncing ${unsynced.length} pending absensi records...');

    for (final model in unsynced) {
      try {
        // Gunakan put() dengan ID stabil — tidak perlu replace ID seperti dulu.
        await _remote.put(model);
        await _local.put(model.copyWith(isSynced: true));
        _log.d('Synced absensi: ${model.id}');
      } catch (e) {
        _log.w('Failed to sync absensi ${model.id}: $e — will retry.');
        // Lanjut ke record berikutnya, jangan hentikan seluruh loop.
      }
    }
  }
}
