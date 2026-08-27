import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:my_halaqoh/src/modules/sertifikasi_tahfidz/domain/models/sertifikasi_model.dart';

part 'sertifikasi_state.freezed.dart';

@freezed
abstract class SertifikasiState with _$SertifikasiState {
  const factory SertifikasiState.initial() = _Initial;
  const factory SertifikasiState.loading() = _Loading;
  const factory SertifikasiState.loaded(List<SertifikasiModel> data) = _Loaded;
  const factory SertifikasiState.error(String message) = _Error;
}
