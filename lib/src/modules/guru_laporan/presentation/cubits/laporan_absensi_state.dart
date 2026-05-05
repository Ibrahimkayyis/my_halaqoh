import 'dart:typed_data';

import 'package:freezed_annotation/freezed_annotation.dart';

part 'laporan_absensi_state.freezed.dart';

/// States for the PDF attendance report generation flow.
@freezed
abstract class LaporanAbsensiState with _$LaporanAbsensiState {
  /// No PDF has been generated yet.
  const factory LaporanAbsensiState.initial() = _Initial;

  /// PDF is being built asynchronously.
  const factory LaporanAbsensiState.generating() = _Generating;

  /// PDF bytes are ready — passed to preview or share actions.
  const factory LaporanAbsensiState.generated(Uint8List pdfBytes) = _Generated;

  /// An error occurred during generation or sharing.
  const factory LaporanAbsensiState.error(String message) = _Error;
}
