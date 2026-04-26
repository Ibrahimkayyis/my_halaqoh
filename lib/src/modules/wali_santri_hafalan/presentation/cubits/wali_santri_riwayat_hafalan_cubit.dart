import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/models/wali_santri_hafalan_model.dart';
import '../../domain/repositories/wali_santri_hafalan_repository.dart';

part 'wali_santri_riwayat_hafalan_state.dart';
part 'wali_santri_riwayat_hafalan_cubit.freezed.dart';

class WaliSantriRiwayatHafalanCubit extends Cubit<WaliSantriRiwayatHafalanState> {
  final WaliSantriHafalanRepository _repository;
  StreamSubscription<List<WaliSantriHafalanModel>>? _subscription;

  WaliSantriRiwayatHafalanCubit(this._repository) : super(const WaliSantriRiwayatHafalanState.initial());

  void watchRiwayat(String santriId, int month, int year) {
    emit(const WaliSantriRiwayatHafalanState.loading());
    _subscription?.cancel();
    _subscription = _repository.watchRiwayatHafalan(santriId, month, year).listen(
      (list) => emit(WaliSantriRiwayatHafalanState.loaded(list)),
      onError: (e) => emit(WaliSantriRiwayatHafalanState.error(e.toString())),
    );
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
