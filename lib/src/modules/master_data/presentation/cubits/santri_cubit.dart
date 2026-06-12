import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_halaqoh/src/modules/master_data/domain/models/santri_model.dart';
import 'package:my_halaqoh/src/modules/master_data/domain/models/target_hafalan_model.dart';
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

  /// Add a new santri. Throws an exception on failure.
  Future<void> addSantri(SantriModel model) async {
    final result = await _repository.add(model);
    result.fold(
      (error) => throw Exception(error),
      (_) {}, // success: stream will push the new data automatically
    );
  }

  /// Add multiple santri in bulk. Returns the number of successfully added santri.
  /// Throws an exception if the entire operation fails.
  Future<int> addBulkSantri(List<SantriModel> models) async {
    final result = await _repository.addBulk(models);
    return result.fold(
      (error) => throw Exception(error),
      (count) => count,
    );
  }


  /// Update an existing santri. Throws an exception on failure.
  Future<void> updateSantri(SantriModel model) async {
    final result = await _repository.update(model);
    result.fold(
      (error) => throw Exception(error),
      (_) {},
    );
  }

  /// Delete a santri by ID.
  Future<bool> deleteSantri(String id) async {
    final result = await _repository.delete(id);
    return result.isRight();
  }

  /// Reset a santri's password.
  Future<String?> resetPassword(String authUid) async {
    final result = await _repository.resetPassword(authUid);
    return result.fold(
      (error) => error,
      (_) => null,
    );
  }

  /// Proses kenaikan kelas — menaikkan kelas semua santri aktif sekaligus
  /// memperbarui seluruh TargetHafalanModel dengan tahun ajaran + semester baru.
  /// Mengembalikan pesan error jika gagal, atau null jika berhasil.
  Future<String?> promoteAll({
    required String tahunAjaran,
    required int semesterAktif,
    required List<SantriModel> aktivSantri,
    required List<TargetHafalanModel> currentTargets,
  }) async {
    final result = await _repository.promoteAll(
      tahunAjaran: tahunAjaran,
      semesterAktif: semesterAktif,
      aktivSantri: aktivSantri,
      currentTargets: currentTargets,
    );
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
