import 'package:freezed_annotation/freezed_annotation.dart';

part 'santri_extra_target_state.freezed.dart';

@freezed
abstract class SantriExtraTargetState with _$SantriExtraTargetState {
  const factory SantriExtraTargetState.initial() = _Initial;
  const factory SantriExtraTargetState.loading() = _Loading;

  /// [extraJuz] is the live list of teacher-added juz numbers for the current santri.
  const factory SantriExtraTargetState.loaded(List<int> extraJuz) = _Loaded;

  const factory SantriExtraTargetState.error(String message) = _Error;
}
