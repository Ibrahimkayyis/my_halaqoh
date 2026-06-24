import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_halaqoh/src/modules/guru_absensi/domain/models/absensi_model.dart';
import 'package:my_halaqoh/src/modules/guru_absensi/domain/repositories/absensi_repository.dart';
import 'package:my_halaqoh/src/modules/guru_dashboard/domain/models/latest_setoran_item.dart';
import 'package:my_halaqoh/src/modules/guru_hafalan/domain/models/hafalan_santri_model.dart';
import 'package:my_halaqoh/src/modules/guru_hafalan/domain/repositories/hafalan_santri_repository.dart';
import 'dashboard_summary_state.dart';

/// Cubit that computes the Guru Dashboard summary data by composing
/// attendance and hafalan data from existing repositories.
///
/// - **Attendance:** Streamed reactively from [AbsensiRepository]. Shows
///   the percentage for the **latest session** today (resets per session).
/// - **Setoran:** Watched reactively from Hive via [HafalanSantriRepository].
///   Any type (Ziyadah or Murajaah) counts.
/// - **Latest Setoran:** 3 most recent hafalan entries for the halaqoh.
class DashboardSummaryCubit extends Cubit<DashboardSummaryState> {
  final AbsensiRepository _absensiRepo;
  final HafalanSantriRepository _hafalanRepo;
  StreamSubscription<List<AbsensiModel>>? _absensiSub;
  StreamSubscription<void>? _hafalanSub;
  StreamSubscription<List<AbsensiModel>>? _absensiRemoteSub;
  StreamSubscription<List<HafalanSantriModel>>? _hafalanRemoteSub;

  // Store latest data for recomputation when either stream fires
  List<AbsensiModel> _latestAbsensiList = [];
  List<String> _santriIds = [];
  Map<String, String> _santriNameMap = {};

  DashboardSummaryCubit(this._absensiRepo, this._hafalanRepo)
      : super(const DashboardSummaryState.initial());

  /// Start loading dashboard data for the teacher's halaqoh.
  ///
  /// [halaqohId] — Firestore ID of the halaqoh.
  /// [santriIds] — List of santri IDs in this halaqoh.
  /// [santriNameMap] — Map of santriId → display name.
  void loadDashboardData({
    required String halaqohId,
    required List<String> santriIds,
    required Map<String, String> santriNameMap,
  }) {
    emit(const DashboardSummaryState.loading());

    _santriIds = santriIds;
    _santriNameMap = santriNameMap;

    // ── Stream 1: Absensi (Firestore) ──
    // Reactive updates when attendance is recorded
    _absensiSub?.cancel();
    _absensiSub = _absensiRepo.watchByHalaqoh(halaqohId).listen(
      (absensiList) {
        _latestAbsensiList = absensiList;
        _computeAndEmit();
      },
      onError: (e) => emit(DashboardSummaryState.error(e.toString())),
    );

    // Background stream to sync remote attendance updates to local Hive cache
    _absensiRemoteSub?.cancel();
    _absensiRemoteSub = _absensiRepo.watchByHalaqohFromRemote(halaqohId).listen(
      (_) {},
      onError: (e) {}, // Silently fail/ignore in background
    );

    // ── Stream 2: Hafalan (Hive box changes) ──
    // Reactive updates when a new setoran is saved locally
    _hafalanSub?.cancel();
    _hafalanSub = _hafalanRepo.watchAnyChanges().listen(
      (_) {
        // Recompute with the latest absensi data + fresh hafalan reads
        _computeAndEmit();
      },
    );

    // Background stream to sync remote hafalan updates to local Hive cache
    _hafalanRemoteSub?.cancel();
    _hafalanRemoteSub = _hafalanRepo.watchByHalaqohFromRemote(halaqohId).listen(
      (_) {},
      onError: (e) {}, // Silently fail/ignore in background
    );
  }

  /// Core computation — called when either stream fires.
  void _computeAndEmit() {
    final now = DateTime.now();
    final totalSantri = _santriIds.length;

    // ── 1. Attendance — latest session today ──
    final todayAbsensi = _latestAbsensiList.where((a) =>
      a.tanggal.year == now.year &&
      a.tanggal.month == now.month &&
      a.tanggal.day == now.day
    ).toList();

    int attendedCount = 0;
    double attendancePercent = 0.0;

    if (todayAbsensi.isNotEmpty) {
      // Sort by createdAt descending to find the latest session
      todayAbsensi.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      final latestSession = todayAbsensi.first;

      // Count 'hadir' in this session
      attendedCount = latestSession.records
          .where((r) => r.status == 'hadir')
          .length;

      final sessionTotal = latestSession.records.length;
      attendancePercent = sessionTotal > 0
          ? attendedCount / sessionTotal
          : 0.0;
    }

    // ── 2. Setoran — distinct santri with any hafalan today ──
    // Re-read from Hive (synchronous) to get the freshest data
    final todayHafalan = _hafalanRepo.getHafalanByHalaqohAndDate(
      _santriIds,
      now,
    );

    final setoranSantriIds = todayHafalan
        .map((h) => h.santriId)
        .toSet();
    final setoranCount = setoranSantriIds.length;
    final setoranPercent = totalSantri > 0
        ? setoranCount / totalSantri
        : 0.0;

    // ── 3. Latest Setoran — 3 most recent records ──
    // Try today's records first; if fewer than 3, fill from all-time
    List<LatestSetoranItem> latestSetoran;
    if (todayHafalan.length >= 3) {
      latestSetoran = todayHafalan.take(3).map(_toSetoranItem).toList();
    } else {
      final recent = _hafalanRepo.getRecentHafalanBySantriIds(
        _santriIds,
        limit: 3,
      );
      latestSetoran = recent.map(_toSetoranItem).toList();
    }

    emit(DashboardSummaryState.loaded(
      attendedCount: attendedCount,
      totalSantriCount: totalSantri,
      attendancePercent: attendancePercent,
      setoranCount: setoranCount,
      setoranPercent: setoranPercent,
      latestSetoran: latestSetoran,
    ));
  }

  /// Convert a HafalanSantriModel to LatestSetoranItem.
  LatestSetoranItem _toSetoranItem(dynamic h) {
    final name = _santriNameMap[h.santriId] ?? 'Santri';
    return LatestSetoranItem(
      santriName: name,
      surahInfo: '${h.surahName} ${h.ayatMulai} - ${h.ayatSelesai}',
      score: h.nilaiKelancaran,
    );
  }

  @override
  Future<void> close() {
    _absensiSub?.cancel();
    _absensiRemoteSub?.cancel();
    _hafalanSub?.cancel();
    _hafalanRemoteSub?.cancel();
    return super.close();
  }
}
