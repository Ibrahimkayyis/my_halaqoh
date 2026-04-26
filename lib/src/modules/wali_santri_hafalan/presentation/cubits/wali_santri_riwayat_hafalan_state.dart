part of 'wali_santri_riwayat_hafalan_cubit.dart';

@freezed
abstract class WaliSantriRiwayatHafalanState with _$WaliSantriRiwayatHafalanState {
  const factory WaliSantriRiwayatHafalanState.initial() = _Initial;
  const factory WaliSantriRiwayatHafalanState.loading() = _Loading;
  const factory WaliSantriRiwayatHafalanState.loaded(List<WaliSantriHafalanModel> records) = _Loaded;
  const factory WaliSantriRiwayatHafalanState.error(String message) = _Error;
}
