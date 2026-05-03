import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../../core/quran/hafalan_progress.dart';
import '../../../../core/quran/quran_service.dart';
import '../../domain/repositories/hafalan_santri_repository.dart';

part 'progress_hafalan_state.dart';
part 'progress_hafalan_cubit.freezed.dart';

class ProgressHafalanCubit extends Cubit<ProgressHafalanState> {
  final HafalanSantriRepository _repository;
  StreamSubscription? _subscription;

  ProgressHafalanCubit(this._repository) : super(const ProgressHafalanState.initial());

  void watchProgress(String santriId) {
    emit(const ProgressHafalanState.loading());
    _subscription?.cancel();
    
    _subscription = _repository.watchAllZiyadahBySantriId(santriId).listen(
      (ziyadahList) {
        // Convert HafalanSantriModel Ziyadah list to list of segments
        final segments = ziyadahList.map((item) {
          return {
            'surah_id': item.surahId,
            'ayat_start': item.ayatMulai,
            'ayat_end': item.ayatSelesai,
          };
        }).toList();

        // QuranService natively merges overlapping segments and calculates detailed precise percentages
        final progress = QuranService.instance.calculateProgress(segments);
        emit(ProgressHafalanState.loaded(progress));
      },
      onError: (e) => emit(ProgressHafalanState.error(e.toString())),
    );

    // Non-blocking seed: if Hive is empty for this santri, fetch from Firestore.
    // The stream listener above will automatically receive the newly seeded data.
    _repository.seedFromRemoteIfEmpty(santriId);
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
