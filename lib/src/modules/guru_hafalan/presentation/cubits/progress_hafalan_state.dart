part of 'progress_hafalan_cubit.dart';

@freezed
class ProgressHafalanState with _$ProgressHafalanState {
  const factory ProgressHafalanState.initial() = _Initial;
  const factory ProgressHafalanState.loading() = _Loading;
  const factory ProgressHafalanState.loaded(OverallHafalanProgress progress) = _Loaded;
  const factory ProgressHafalanState.error(String message) = _Error;
}
