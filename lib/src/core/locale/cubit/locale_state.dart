part of 'locale_cubit.dart';

@freezed
class LocaleState with _$LocaleState {
  const factory LocaleState.initial() = _Initial;
  const factory LocaleState.loaded(AppLocale locale) = _Loaded;
}
