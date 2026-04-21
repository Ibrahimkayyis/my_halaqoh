import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/models/hafalan_santri_model.dart';
import '../../domain/repositories/hafalan_santri_repository.dart';

part 'input_hafalan_state.dart';
part 'input_hafalan_cubit.freezed.dart';

class InputHafalanCubit extends Cubit<InputHafalanState> {
  final HafalanSantriRepository _repository;

  InputHafalanCubit(this._repository) : super(const InputHafalanState.initial());

  Future<void> submitHafalan(HafalanSantriModel model) async {
    emit(const InputHafalanState.loading());
    final result = await _repository.addHafalan(model);
    result.fold(
      (error) => emit(InputHafalanState.error(error)),
      (_) => emit(const InputHafalanState.success()),
    );
  }

  Future<void> submitMultipleHafalan(List<HafalanSantriModel> models) async {
    if (models.isEmpty) return;
    emit(const InputHafalanState.loading());
    
    for (final model in models) {
      final result = await _repository.addHafalan(model);
      if (result.isLeft()) {
        final error = result.fold((l) => l, (r) => '');
        emit(InputHafalanState.error(error));
        return; // Stop on first error
      }
    }
    
    emit(const InputHafalanState.success());
  }
}
