import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:my_halaqoh/src/modules/master_data/domain/models/halaqoh_model.dart';

part 'halaqoh_state.freezed.dart';

@freezed
abstract class HalaqohState with _$HalaqohState {
  const factory HalaqohState.initial() = _Initial;
  const factory HalaqohState.loading() = _Loading;
  const factory HalaqohState.loaded(List<HalaqohModel> halaqohList) = _Loaded;
  const factory HalaqohState.error(String message) = _Error;
}
