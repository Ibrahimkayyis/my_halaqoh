import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_halaqoh/src/modules/master_data/domain/models/santri_model.dart';
import 'package:my_halaqoh/src/modules/master_data/domain/repositories/santri_repository.dart';
import 'santri_state.dart';

class SantriCubit extends Cubit<SantriState> {
  final SantriRepository _repository;
  StreamSubscription<List<SantriModel>>? _subscription;

  SantriCubit(this._repository) : super(const SantriState.initial());

  /// Start watching all santri via Firestore realtime stream.
  void watchAll() {
    emit(const SantriState.loading());
    _subscription?.cancel();
    _subscription = _repository.watchAll().listen(
      (list) => emit(SantriState.loaded(list)),
      onError: (e) => emit(SantriState.error(e.toString())),
    );
  }

  /// One-time fetch of all santri.
  Future<void> loadAll() async {
    emit(const SantriState.loading());
    final result = await _repository.getAll();
    result.fold(
      (error) => emit(SantriState.error(error)),
      (list) => emit(SantriState.loaded(list)),
    );
  }

  /// Add a new santri.
  Future<bool> addSantri(SantriModel model) async {
    final result = await _repository.add(model);
    return result.isRight();
  }

  /// Update an existing santri.
  Future<bool> updateSantri(SantriModel model) async {
    final result = await _repository.update(model);
    return result.isRight();
  }

  /// Delete a santri by ID.
  Future<bool> deleteSantri(String id) async {
    final result = await _repository.delete(id);
    return result.isRight();
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
