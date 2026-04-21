part of 'input_hafalan_cubit.dart';

@freezed
class InputHafalanState with _$InputHafalanState {
  const factory InputHafalanState.initial() = _Initial;
  const factory InputHafalanState.loading() = _Loading;
  const factory InputHafalanState.success() = _Success;
  const factory InputHafalanState.error(String message) = _Error;
}
