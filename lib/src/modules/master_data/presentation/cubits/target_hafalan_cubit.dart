import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_halaqoh/src/modules/master_data/domain/models/target_hafalan_model.dart';
import 'package:my_halaqoh/src/modules/master_data/domain/repositories/target_hafalan_repository.dart';
import 'target_hafalan_state.dart';

class TargetHafalanCubit extends Cubit<TargetHafalanState> {
  final TargetHafalanRepository _repository;
  StreamSubscription<List<TargetHafalanModel>>? _subscription;

  TargetHafalanCubit(this._repository)
      : super(const TargetHafalanState.initial());

  /// Start watching all target hafalan via Firestore realtime stream.
  void watchAll() {
    emit(const TargetHafalanState.loading());
    _subscription?.cancel();
    _subscription = _repository.watchAll().listen(
      (list) => emit(TargetHafalanState.loaded(list)),
      onError: (e) => emit(TargetHafalanState.error(e.toString())),
    );
  }

  /// One-time fetch of all target hafalan.
  Future<void> loadAll() async {
    emit(const TargetHafalanState.loading());
    final result = await _repository.getAll();
    result.fold(
      (error) => emit(TargetHafalanState.error(error)),
      (list) => emit(TargetHafalanState.loaded(list)),
    );
  }

  /// Save (create or update) a target hafalan.
  Future<bool> saveTarget(TargetHafalanModel model) async {
    final result = await _repository.save(model);
    return result.isRight();
  }

  /// Delete a target hafalan.
  Future<bool> deleteTarget(String id) async {
    final result = await _repository.delete(id);
    return result.isRight();
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
