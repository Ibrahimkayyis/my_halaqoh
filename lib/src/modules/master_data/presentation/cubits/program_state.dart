import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:my_halaqoh/src/modules/master_data/domain/models/program_model.dart';

part 'program_state.freezed.dart';

@freezed
abstract class ProgramState with _$ProgramState {
  const factory ProgramState.initial() = _Initial;
  const factory ProgramState.loading() = _Loading;
  const factory ProgramState.loaded(List<ProgramModel> programList) = _Loaded;
  const factory ProgramState.error(String message) = _Error;
}
