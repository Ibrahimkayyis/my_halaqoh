import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_halaqoh/src/modules/master_data/domain/models/kelas_model.dart';
import 'package:my_halaqoh/src/modules/master_data/domain/repositories/kelas_repository.dart';
import 'kelas_state.dart';

class KelasCubit extends Cubit<KelasState> {
  final KelasRepository _repository;
  StreamSubscription<List<KelasModel>>? _subscription;

  KelasCubit(this._repository) : super(const KelasState.initial());

  void watchAll() {
    emit(const KelasState.loading());
    _subscription?.cancel();
    _subscription = _repository.watchAll().listen(
      (list) => emit(KelasState.loaded(list)),
      onError: (e) => emit(KelasState.error(e.toString())),
    );
  }

  Future<void> loadAll() async {
    emit(const KelasState.loading());
    final result = await _repository.getAll();
    result.fold(
      (error) => emit(KelasState.error(error)),
      (list) => emit(KelasState.loaded(list)),
    );
  }

  Future<void> addKelas(KelasModel model) async {
    final result = await _repository.add(model);
    result.fold(
      (error) => throw Exception(error),
      (_) {},
    );
  }

  Future<void> updateKelas(KelasModel model) async {
    final result = await _repository.update(model);
    result.fold(
      (error) => throw Exception(error),
      (_) {},
    );
  }

  Future<bool> deleteKelas(String id) async {
    final result = await _repository.delete(id);
    return result.isRight();
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
