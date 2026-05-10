import 'dart:typed_data';

import 'package:freezed_annotation/freezed_annotation.dart';

part 'laporan_absensi_halaqoh_state.freezed.dart';

/// State for [LaporanAbsensiHalaqohCubit].
///
/// Mirrors [LaporanAbsensiState] but scoped to halaqoh-wide reports.
@freezed
abstract class LaporanAbsensiHalaqohState with _$LaporanAbsensiHalaqohState {
  /// Nothing has happened yet.
  const factory LaporanAbsensiHalaqohState.initial() = _Initial;

  /// PDF is being generated asynchronously.
  const factory LaporanAbsensiHalaqohState.generating() = _Generating;

  /// PDF bytes are ready for preview / share.
  const factory LaporanAbsensiHalaqohState.generated(Uint8List bytes) =
      _Generated;

  /// An error occurred during generation.
  const factory LaporanAbsensiHalaqohState.error(String message) = _Error;
}
