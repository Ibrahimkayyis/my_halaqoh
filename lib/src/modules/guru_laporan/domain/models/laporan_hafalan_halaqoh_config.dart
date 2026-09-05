import 'package:freezed_annotation/freezed_annotation.dart';

import 'laporan_absensi_config.dart'; // re-exports ReportRange

part 'laporan_hafalan_halaqoh_config.freezed.dart';

/// Configuration model passed from [LaporanKonfigurasiHafalanHalaqohSheet]
/// to [LaporanHafalanHalaqohCubit] to drive whole-halaqoh Hafalan PDF generation.
@freezed
abstract class LaporanHafalanHalaqohConfig with _$LaporanHafalanHalaqohConfig {
  const factory LaporanHafalanHalaqohConfig({
    /// Name of the halaqoh (from HalaqohModel.nama)
    required String halaqohName,

    /// Teacher's full name (from HalaqohModel.guruNama)
    required String guruNama,

    /// Class name / level (from HalaqohModel.kelas)
    required String kelas,

    /// The selected time range type
    required ReportRange range,

    /// Inclusive report start date (midnight)
    required DateTime startDate,

    /// Inclusive report end date (end of day)
    required DateTime endDate,
  }) = _LaporanHafalanHalaqohConfig;
}
