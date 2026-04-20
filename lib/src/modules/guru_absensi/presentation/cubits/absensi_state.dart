import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/models/absensi_model.dart';

part 'absensi_state.freezed.dart';

/// State for [AbsensiCubit].
@freezed
abstract class AbsensiState with _$AbsensiState {
  const factory AbsensiState.initial() = _Initial;
  const factory AbsensiState.loading() = _Loading;
  const factory AbsensiState.loaded(List<AbsensiModel> data) = _Loaded;
  const factory AbsensiState.error(String message) = _Error;
}
