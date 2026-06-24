import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/models/absensi_model.dart';
import '../../domain/repositories/absensi_repository.dart';
import 'absensi_state.dart';

/// Cubit managing attendance data for a specific halaqoh.
///
/// Unlike master data cubits that use `watchAll()`, this cubit
/// requires a `halaqohId` before it can start streaming.
class AbsensiCubit extends Cubit<AbsensiState> {
  final AbsensiRepository _repository;
  StreamSubscription<List<AbsensiModel>>? _subscription;

  AbsensiCubit(this._repository) : super(const AbsensiState.initial());

  /// Start streaming attendance records for the given halaqoh from Hive.
  /// Used by guru (offline-first, same device as writer).
  void watchByHalaqoh(String halaqohId) {
    emit(const AbsensiState.loading());
    _subscription?.cancel();
    _subscription = _repository.watchByHalaqoh(halaqohId).listen(
      (data) => emit(AbsensiState.loaded(data)),
      onError: (e) => emit(AbsensiState.error(e.toString())),
    );
  }

  /// Start streaming attendance records for the given halaqoh from Firestore.
  /// Used by wali santri (read-only consumer on a different device).
  /// Updates Hive as a side-effect so offline data stays fresh.
  void watchByHalaqohFromRemote(String halaqohId) {
    emit(const AbsensiState.loading());
    _subscription?.cancel();
    _subscription = _repository.watchByHalaqohFromRemote(halaqohId).listen(
      (data) => emit(AbsensiState.loaded(data)),
      onError: (e) => emit(AbsensiState.error(e.toString())),
    );
  }

  /// Find existing session for duplicate checking.
  Future<AbsensiModel?> findExisting(
    String halaqohId,
    DateTime tanggal,
    String sesi,
  ) {
    return _repository.findExisting(halaqohId, tanggal, sesi);
  }

  /// Save an attendance session. Returns `true` on success.
  Future<bool> saveSession(AbsensiModel model) async {
    final result = await _repository.saveSession(model);
    return result.isRight();
  }

  /// Delete an attendance session. Returns `true` on success.
  Future<bool> deleteSession(String id) async {
    final result = await _repository.delete(id);
    return result.isRight();
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
