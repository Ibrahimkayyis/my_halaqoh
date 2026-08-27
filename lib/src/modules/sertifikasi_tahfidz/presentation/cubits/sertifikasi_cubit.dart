import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_halaqoh/src/modules/sertifikasi_tahfidz/domain/models/sertifikasi_model.dart';
import 'package:my_halaqoh/src/modules/sertifikasi_tahfidz/domain/repositories/sertifikasi_repository.dart';
import 'sertifikasi_state.dart';

class SertifikasiCubit extends Cubit<SertifikasiState> {
  final SertifikasiRepository _repository;
  StreamSubscription<List<SertifikasiModel>>? _subscription;

  SertifikasiCubit(this._repository) : super(const SertifikasiState.initial());

  /// Watch certifications for a specific teacher's halaqoh students.
  void watchByGuruId(String guruId) {
    emit(const SertifikasiState.loading());
    _subscription?.cancel();
    _subscription = _repository.watchByGuruId(guruId).listen(
      (list) => emit(SertifikasiState.loaded(list)),
      onError: (e) => emit(SertifikasiState.error(e.toString())),
    );
  }

  /// Watch certifications for a specific student (Wali Santri view).
  void watchBySantriId(String santriId) {
    emit(const SertifikasiState.loading());
    _subscription?.cancel();
    _subscription = _repository.watchBySantriId(santriId).listen(
      (list) => emit(SertifikasiState.loaded(list)),
      onError: (e) => emit(SertifikasiState.error(e.toString())),
    );
  }

  /// Watch all certifications (Super Admin / Waka Tahfidz).
  void watchAll() {
    emit(const SertifikasiState.loading());
    _subscription?.cancel();
    _subscription = _repository.watchAll().listen(
      (list) => emit(SertifikasiState.loaded(list)),
      onError: (e) => emit(SertifikasiState.error(e.toString())),
    );
  }

  /// Register a new certification. Returns true if successful.
  Future<bool> addSertifikasi(SertifikasiModel model) async {
    final result = await _repository.add(model);
    return result.isRight();
  }

  /// Update an existing certification record.
  Future<bool> updateSertifikasi(SertifikasiModel model) async {
    final result = await _repository.update(model);
    return result.isRight();
  }

  /// Delete a certification record.
  Future<bool> deleteSertifikasi(String id) async {
    final result = await _repository.delete(id);
    return result.isRight();
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
