import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:my_halaqoh/src/core/theme/data/theme_repository.dart';
import 'package:my_halaqoh/src/core/theme/cubit/theme_cubit.dart';
import 'package:my_halaqoh/src/core/locale/data/locale_repository.dart';
import 'package:my_halaqoh/src/core/locale/cubit/locale_cubit.dart';

final sl = GetIt.instance;

/// Call this in main.dart before runApp()
Future<void> initDependencies() async {
  // SharedPreferences
  final prefs = await SharedPreferences.getInstance();
  sl.registerSingleton<SharedPreferences>(prefs);

  // Theme System
  sl.registerLazySingleton<ThemeRepository>(() => ThemeRepository(sl()));
  sl.registerSingleton<ThemeCubit>(ThemeCubit(sl()));

  // Locale System
  sl.registerLazySingleton<LocaleRepository>(() => LocaleRepository(sl()));
  sl.registerSingleton<LocaleCubit>(LocaleCubit(sl()));
}
