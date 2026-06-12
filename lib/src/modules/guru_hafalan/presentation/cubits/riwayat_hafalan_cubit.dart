import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/models/hafalan_santri_model.dart';
import '../../domain/repositories/hafalan_santri_repository.dart';

part 'riwayat_hafalan_state.dart';
part 'riwayat_hafalan_cubit.freezed.dart';

class RiwayatHafalanCubit extends Cubit<RiwayatHafalanState> {
  final HafalanSantriRepository _repository;
  StreamSubscription<List<HafalanSantriModel>>? _subscription;

  RiwayatHafalanCubit(this._repository) : super(const RiwayatHafalanState.initial());

  /// Load riwayat hafalan for [santriId] in the given month/year.
  ///
  /// Flow:
  /// 1. Subscribe to the Hive stream immediately (fast, offline-first).
  /// 2. Trigger a non-blocking seed from Firestore in case Hive was wiped
  ///    (e.g. fresh install, cache cleared). When the seed writes records to Hive,
  ///    the stream emits automatically — no extra reload needed.
  void watchRiwayat(String santriId, int month, int year) {
    emit(const RiwayatHafalanState.loading());
    _subscription?.cancel();
    _subscription = _repository.watchHafalanBySantriId(santriId, month, year).listen(
      (list) => emit(RiwayatHafalanState.loaded(list)),
      onError: (e) => emit(RiwayatHafalanState.error(e.toString())),
    );

    // Non-blocking seed: if Hive is empty for this santri, fetch from Firestore.
    // The stream listener above will automatically receive the newly seeded data.
    _repository.seedFromRemoteIfEmpty(santriId);
  }

  /// Delete a submission group containing multiple hafalan records.
  Future<bool> deleteSubmissionGroup(List<HafalanSantriModel> records) async {
    bool allSuccess = true;
    for (final r in records) {
      final res = await _repository.deleteHafalan(r.id);
      if (res.isLeft()) {
        allSuccess = false;
      }
    }
    return allSuccess;
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
