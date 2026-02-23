import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:my_halaqoh/src/core/theme/theme_mode.dart';
import 'package:my_halaqoh/src/core/theme/data/theme_repository.dart';

part 'theme_state.dart';
part 'theme_cubit.freezed.dart';

/// Cubit for managing app theme
class ThemeCubit extends Cubit<ThemeState> {
  ThemeCubit(this._repository) : super(const ThemeState.initial());

  final ThemeRepository _repository;

  /// Initialize theme from saved preference
  Future<void> initialize() async {
    final savedMode = await _repository.getThemeMode();
    emit(ThemeState.loaded(savedMode));
  }

  /// Set theme mode
  Future<void> setThemeMode(AppThemeMode mode) async {
    emit(ThemeState.loaded(mode));
    await _repository.saveThemeMode(mode);
  }

  /// Toggle between light and dark mode
  Future<void> toggleTheme() async {
    final currentMode = state.maybeWhen(
      loaded: (mode) => mode,
      orElse: () => AppThemeMode.system,
    );

    final newMode = currentMode == AppThemeMode.light
        ? AppThemeMode.dark
        : AppThemeMode.light;

    await setThemeMode(newMode);
  }
}
