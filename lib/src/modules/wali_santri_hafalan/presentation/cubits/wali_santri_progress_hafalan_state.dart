part of 'wali_santri_progress_hafalan_cubit.dart';

@freezed
abstract class WaliSantriProgressHafalanState with _$WaliSantriProgressHafalanState {
  const factory WaliSantriProgressHafalanState.initial() = _Initial;
  const factory WaliSantriProgressHafalanState.loading() = _Loading;
  const factory WaliSantriProgressHafalanState.loaded(OverallHafalanProgress progress) = _Loaded;
  const factory WaliSantriProgressHafalanState.error(String message) = _Error;
}
