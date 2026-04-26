import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../../core/quran/hafalan_progress.dart';
import '../../../../core/quran/quran_service.dart';
import '../../domain/repositories/wali_santri_hafalan_repository.dart';

part 'wali_santri_progress_hafalan_state.dart';
part 'wali_santri_progress_hafalan_cubit.freezed.dart';

class WaliSantriProgressHafalanCubit extends Cubit<WaliSantriProgressHafalanState> {
  final WaliSantriHafalanRepository _repository;
  StreamSubscription? _subscription;

  WaliSantriProgressHafalanCubit(this._repository) : super(const WaliSantriProgressHafalanState.initial());

  void watchProgress(String santriId) {
    emit(const WaliSantriProgressHafalanState.loading());
    _subscription?.cancel();
    
    _subscription = _repository.watchAllZiyadahBySantriId(santriId).listen(
      (ziyadahList) {
        // Convert WaliSantriHafalanModel Ziyadah list to list of segments
        final segments = ziyadahList.map((item) {
          return {
            'surah_id': item.surahId,
            'ayat_start': item.ayatMulai,
            'ayat_end': item.ayatSelesai,
          };
        }).toList();

        // QuranService natively merges overlapping segments and calculates detailed precise percentages
        final progress = QuranService.instance.calculateProgress(segments);
        emit(WaliSantriProgressHafalanState.loaded(progress));
      },
      onError: (e) => emit(WaliSantriProgressHafalanState.error(e.toString())),
    );
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
