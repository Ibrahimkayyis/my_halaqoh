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

  void watchRiwayat(String santriId, int month, int year) {
    emit(const RiwayatHafalanState.loading());
    _subscription?.cancel();
    _subscription = _repository.watchHafalanBySantriId(santriId, month, year).listen(
      (list) => emit(RiwayatHafalanState.loaded(list)),
      onError: (e) => emit(RiwayatHafalanState.error(e.toString())),
    );
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
