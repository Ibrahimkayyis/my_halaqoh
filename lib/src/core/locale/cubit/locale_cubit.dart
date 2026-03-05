import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:my_halaqoh/gen/i18n/translations.g.dart';
import 'package:my_halaqoh/src/core/locale/data/locale_repository.dart';

part 'locale_state.dart';
part 'locale_cubit.freezed.dart';

/// Cubit for managing app locale
class LocaleCubit extends Cubit<LocaleState> {
  LocaleCubit(this._repository) : super(const LocaleState.initial());

  final LocaleRepository _repository;

  /// Initialize locale from saved preference
  Future<void> initialize() async {
    final savedLocale = await _repository.getLocale();
    LocaleSettings.setLocale(savedLocale);
    emit(LocaleState.loaded(savedLocale));
  }

  /// Set locale
  Future<void> setLocale(AppLocale locale) async {
    LocaleSettings.setLocale(locale);
    emit(LocaleState.loaded(locale));
    await _repository.saveLocale(locale);
  }
}
