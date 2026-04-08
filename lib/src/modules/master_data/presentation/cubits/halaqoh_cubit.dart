import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_halaqoh/src/modules/master_data/domain/models/halaqoh_model.dart';
import 'package:my_halaqoh/src/modules/master_data/domain/repositories/halaqoh_repository.dart';
import 'halaqoh_state.dart';

class HalaqohCubit extends Cubit<HalaqohState> {
  final HalaqohRepository _repository;
  StreamSubscription<List<HalaqohModel>>? _subscription;

  HalaqohCubit(this._repository) : super(const HalaqohState.initial());

  /// Start watching all halaqoh via Firestore realtime stream.
  void watchAll() {
    emit(const HalaqohState.loading());
    _subscription?.cancel();
    _subscription = _repository.watchAll().listen(
      (list) => emit(HalaqohState.loaded(list)),
      onError: (e) => emit(HalaqohState.error(e.toString())),
    );
  }

  /// One-time fetch of all halaqoh.
  Future<void> loadAll() async {
    emit(const HalaqohState.loading());
    final result = await _repository.getAll();
    result.fold(
      (error) => emit(HalaqohState.error(error)),
      (list) => emit(HalaqohState.loaded(list)),
    );
  }

  /// Add a new halaqoh.
  Future<bool> addHalaqoh(HalaqohModel model) async {
    final result = await _repository.add(model);
    return result.isRight();
  }

  /// Update an existing halaqoh.
  Future<bool> updateHalaqoh(HalaqohModel model) async {
    final result = await _repository.update(model);
    return result.isRight();
  }

  /// Delete a halaqoh by ID.
  Future<bool> deleteHalaqoh(String id) async {
    final result = await _repository.delete(id);
    return result.isRight();
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
