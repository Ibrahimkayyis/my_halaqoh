import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:my_halaqoh/src/modules/master_data/domain/models/guru_model.dart';

part 'guru_state.freezed.dart';

@freezed
abstract class GuruState with _$GuruState {
  const factory GuruState.initial() = _Initial;
  const factory GuruState.loading() = _Loading;
  const factory GuruState.loaded(List<GuruModel> guruList) = _Loaded;
  const factory GuruState.error(String message) = _Error;
}
