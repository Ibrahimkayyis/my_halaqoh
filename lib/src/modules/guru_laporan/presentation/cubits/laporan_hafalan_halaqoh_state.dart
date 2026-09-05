import 'dart:typed_data';

import 'package:freezed_annotation/freezed_annotation.dart';

part 'laporan_hafalan_halaqoh_state.freezed.dart';

/// States for the whole-halaqoh Hafalan PDF report generation flow.
@freezed
abstract class LaporanHafalanHalaqohState with _$LaporanHafalanHalaqohState {
  /// No PDF has been generated yet.
  const factory LaporanHafalanHalaqohState.initial() = _Initial;

  /// PDF is being built asynchronously.
  const factory LaporanHafalanHalaqohState.generating() = _Generating;

  /// PDF bytes are ready.
  const factory LaporanHafalanHalaqohState.generated(Uint8List pdfBytes) = _Generated;

  /// An error occurred during generation or sharing.
  const factory LaporanHafalanHalaqohState.error(String message) = _Error;
}
