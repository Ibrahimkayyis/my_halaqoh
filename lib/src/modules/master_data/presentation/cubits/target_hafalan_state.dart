import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:my_halaqoh/src/modules/master_data/domain/models/target_hafalan_model.dart';

part 'target_hafalan_state.freezed.dart';

@freezed
abstract class TargetHafalanState with _$TargetHafalanState {
  const factory TargetHafalanState.initial() = _Initial;
  const factory TargetHafalanState.loading() = _Loading;
  const factory TargetHafalanState.loaded(
      List<TargetHafalanModel> targetList) = _Loaded;
  const factory TargetHafalanState.error(String message) = _Error;
}
