import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/models/latest_setoran_item.dart';

part 'dashboard_summary_state.freezed.dart';

/// State for the [DashboardSummaryCubit].
///
/// Carries computed attendance percentage, setoran percentage,
/// and the 3 most recent setoran items for the teacher's halaqoh.
@freezed
abstract class DashboardSummaryState with _$DashboardSummaryState {
  const factory DashboardSummaryState.initial() = _Initial;
  const factory DashboardSummaryState.loading() = _Loading;
  const factory DashboardSummaryState.loaded({
    // ── Attendance (latest session) ──
    /// Number of santri marked 'hadir' in the latest session
    required int attendedCount,

    /// Total santri in the halaqoh
    required int totalSantriCount,

    /// Attendance percentage (0.0 – 1.0)
    required double attendancePercent,

    // ── Setoran ──
    /// Distinct santri who submitted any hafalan today
    required int setoranCount,

    /// Setoran percentage (0.0 – 1.0)
    required double setoranPercent,

    // ── Latest Setoran list ──
    /// 3 most recent setoran entries
    required List<LatestSetoranItem> latestSetoran,
  }) = _Loaded;
  const factory DashboardSummaryState.error(String message) = _Error;
}
