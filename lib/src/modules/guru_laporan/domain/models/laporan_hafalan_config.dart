import 'package:freezed_annotation/freezed_annotation.dart';

import 'laporan_absensi_config.dart'; // re-exports ReportRange

part 'laporan_hafalan_config.freezed.dart';

/// Configuration model passed from [LaporanKonfigurasiHafalanSheet]
/// to [LaporanHafalanCubit] to drive Hafalan PDF generation.
///
/// Re-uses [ReportRange] from [LaporanAbsensiConfig].
/// No [programType] field — the Hafalan report is program-agnostic.
@freezed
abstract class LaporanHafalanConfig with _$LaporanHafalanConfig {
  const factory LaporanHafalanConfig({
    /// Student full name (from route param)
    required String santriName,

    /// Student ID (from route param, for fetching data)
    required String santriId,

    /// Student NIS (from route param)
    required String santriNis,

    /// Halaqoh name (from HalaqohCubit)
    required String halaqohName,

    /// Teacher name (from HalaqohModel.guruNama)
    required String guruNama,

    /// The selected time range type
    required ReportRange range,

    /// Inclusive report start date (midnight)
    required DateTime startDate,

    /// Inclusive report end date (end of day)
    required DateTime endDate,
  }) = _LaporanHafalanConfig;
}
