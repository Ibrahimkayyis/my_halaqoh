import 'package:freezed_annotation/freezed_annotation.dart';

import 'laporan_absensi_config.dart'; // re-exports ReportRange

part 'laporan_absensi_halaqoh_config.freezed.dart';

/// Configuration model passed from [LaporanKonfigurasiHalaqohSheet] to
/// [LaporanAbsensiHalaqohCubit] to drive PDF generation.
///
/// All fields are pre-populated from the screen context — no additional
/// Firestore queries are made during report generation.
@freezed
abstract class LaporanAbsensiHalaqohConfig with _$LaporanAbsensiHalaqohConfig {
  const factory LaporanAbsensiHalaqohConfig({
    /// Name of the halaqoh (from HalaqohModel.nama)
    required String halaqohName,

    /// Teacher's full name (from HalaqohModel.guruNama)
    required String guruNama,

    /// 'reguler' | 'takhassus' — determines session columns & page orientation
    required String programType,

    /// The teacher-selected range type
    required ReportRange range,

    /// Inclusive report start date (midnight)
    required DateTime startDate,

    /// Inclusive report end date (end of day)
    required DateTime endDate,
  }) = _LaporanAbsensiHalaqohConfig;
}
