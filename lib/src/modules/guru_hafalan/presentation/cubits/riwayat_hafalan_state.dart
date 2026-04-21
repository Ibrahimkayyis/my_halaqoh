part of 'riwayat_hafalan_cubit.dart';

@freezed
class RiwayatHafalanState with _$RiwayatHafalanState {
  const factory RiwayatHafalanState.initial() = _Initial;
  const factory RiwayatHafalanState.loading() = _Loading;
  const factory RiwayatHafalanState.loaded(List<HafalanSantriModel> data) = _Loaded;
  const factory RiwayatHafalanState.error(String message) = _Error;
}
