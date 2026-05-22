import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_halaqoh/src/modules/master_data/domain/repositories/santri_extra_target_repository.dart';
import 'santri_extra_target_state.dart';

/// Cubit that streams the teacher-added juz targets for a specific santri
/// from Firestore and exposes [addExtraJuz] for the teacher to persist new ones.
class SantriExtraTargetCubit extends Cubit<SantriExtraTargetState> {
  final SantriExtraTargetRepository _repository;
  StreamSubscription<List<int>>? _subscription;

  SantriExtraTargetCubit(this._repository)
      : super(const SantriExtraTargetState.initial());

  /// Begin streaming the extra juz list for [santriId].
  void watchExtraJuz(String santriId) {
    emit(const SantriExtraTargetState.loading());
    _subscription?.cancel();
    _subscription = _repository.watchExtraJuz(santriId).listen(
      (juzList) => emit(SantriExtraTargetState.loaded(juzList)),
      onError: (e) => emit(SantriExtraTargetState.error(e.toString())),
    );
  }

  /// Persist [juzNum] as a teacher-added target for [santriId].
  /// The stream will automatically emit the updated list after this call.
  Future<bool> addExtraJuz(String santriId, int juzNum) async {
    final result = await _repository.addExtraJuz(santriId, juzNum);
    return result.isRight();
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
