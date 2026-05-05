import 'dart:typed_data';

import 'package:freezed_annotation/freezed_annotation.dart';

part 'laporan_hafalan_state.freezed.dart';

/// States for the Hafalan PDF report generation flow.
@freezed
abstract class LaporanHafalanState with _$LaporanHafalanState {
  /// No PDF has been generated yet.
  const factory LaporanHafalanState.initial() = _Initial;

  /// PDF is being built asynchronously.
  const factory LaporanHafalanState.generating() = _Generating;

  /// PDF bytes are ready.
  const factory LaporanHafalanState.generated(Uint8List pdfBytes) = _Generated;

  /// An error occurred during generation or sharing.
  const factory LaporanHafalanState.error(String message) = _Error;
}
