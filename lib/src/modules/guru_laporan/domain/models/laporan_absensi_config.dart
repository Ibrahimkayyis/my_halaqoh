import 'package:freezed_annotation/freezed_annotation.dart';

part 'laporan_absensi_config.freezed.dart';

/// The teacher-selected time range type for the attendance report.
enum ReportRange { weekly, monthly, semester }

/// Configuration model passed from the UI sheet to [LaporanAbsensiCubit]
/// to drive PDF generation.
///
/// All fields are pre-populated from the existing screen context —
/// no additional Firestore queries are needed.
@freezed
abstract class LaporanAbsensiConfig with _$LaporanAbsensiConfig {
  const factory LaporanAbsensiConfig({
    /// Student full name (from route param)
    required String santriName,

    /// Student NIS (from route param)
    required String santriNis,

    /// 'reguler' or 'takhassus' — drives session columns in the PDF
    required String programType,

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
  }) = _LaporanAbsensiConfig;
}
