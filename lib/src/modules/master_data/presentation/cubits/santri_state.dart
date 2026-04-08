import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:my_halaqoh/src/modules/master_data/domain/models/santri_model.dart';

part 'santri_state.freezed.dart';

@freezed
abstract class SantriState with _$SantriState {
  const factory SantriState.initial() = _Initial;
  const factory SantriState.loading() = _Loading;
  const factory SantriState.loaded(List<SantriModel> santriList) = _Loaded;
  const factory SantriState.error(String message) = _Error;
}
