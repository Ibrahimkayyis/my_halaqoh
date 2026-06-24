import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:my_halaqoh/src/modules/master_data/domain/models/kelas_model.dart';

part 'kelas_state.freezed.dart';

@freezed
abstract class KelasState with _$KelasState {
  const factory KelasState.initial() = _Initial;
  const factory KelasState.loading() = _Loading;
  const factory KelasState.loaded(List<KelasModel> kelasList) = _Loaded;
  const factory KelasState.error(String message) = _Error;
}
