import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_halaqoh/src/modules/master_data/domain/models/guru_model.dart';
import 'package:my_halaqoh/src/modules/master_data/domain/repositories/guru_repository.dart';
import 'guru_state.dart';

class GuruCubit extends Cubit<GuruState> {
  final GuruRepository _repository;
  StreamSubscription<List<GuruModel>>? _subscription;

  GuruCubit(this._repository) : super(const GuruState.initial());

  /// Start watching all guru via Firestore realtime stream.
  void watchAll() {
    emit(const GuruState.loading());
    _subscription?.cancel();
    _subscription = _repository.watchAll().listen(
      (list) => emit(GuruState.loaded(list)),
      onError: (e) => emit(GuruState.error(e.toString())),
    );
  }

  /// One-time fetch of all guru.
  Future<void> loadAll() async {
    emit(const GuruState.loading());
    final result = await _repository.getAll();
    result.fold(
      (error) => emit(GuruState.error(error)),
      (list) => emit(GuruState.loaded(list)),
    );
  }

  /// Add a new guru.
  Future<bool> addGuru(GuruModel model) async {
    final result = await _repository.add(model);
    return result.isRight();
  }

  /// Update an existing guru.
  Future<bool> updateGuru(GuruModel model) async {
    final result = await _repository.update(model);
    return result.isRight();
  }

  /// Delete a guru by ID.
  Future<bool> deleteGuru(String id) async {
    final result = await _repository.delete(id);
    return result.isRight();
  }

  /// Reset a guru's password.
  Future<String?> resetPassword(String authUid) async {
    final result = await _repository.resetPassword(authUid);
    return result.fold(
      (error) => error,
      (_) => null,
    );
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
