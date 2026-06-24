import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_halaqoh/src/modules/master_data/domain/models/program_model.dart';
import 'package:my_halaqoh/src/modules/master_data/domain/repositories/program_repository.dart';
import 'program_state.dart';

class ProgramCubit extends Cubit<ProgramState> {
  final ProgramRepository _repository;
  StreamSubscription<List<ProgramModel>>? _subscription;

  ProgramCubit(this._repository) : super(const ProgramState.initial());

  void watchAll() {
    emit(const ProgramState.loading());
    _subscription?.cancel();
    _subscription = _repository.watchAll().listen(
      (list) => emit(ProgramState.loaded(list)),
      onError: (e) => emit(ProgramState.error(e.toString())),
    );
  }

  Future<void> loadAll() async {
    emit(const ProgramState.loading());
    final result = await _repository.getAll();
    result.fold(
      (error) => emit(ProgramState.error(error)),
      (list) => emit(ProgramState.loaded(list)),
    );
  }

  Future<void> addProgram(ProgramModel model) async {
    final result = await _repository.add(model);
    result.fold(
      (error) => throw Exception(error),
      (_) {},
    );
  }

  Future<void> updateProgram(ProgramModel model) async {
    final result = await _repository.update(model);
    result.fold(
      (error) => throw Exception(error),
      (_) {},
    );
  }

  Future<bool> deleteProgram(String id) async {
    final result = await _repository.delete(id);
    return result.isRight();
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
