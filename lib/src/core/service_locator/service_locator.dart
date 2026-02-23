import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:my_halaqoh/src/core/theme/data/theme_repository.dart';
import 'package:my_halaqoh/src/core/theme/cubit/theme_cubit.dart';

final sl = GetIt.instance;

/// Call this in main.dart before runApp()
Future<void> initDependencies() async {
  // Theme System
  // SharedPreferences
  final prefs = await SharedPreferences.getInstance();
  sl.registerSingleton<SharedPreferences>(prefs);

  // Theme Repository
  sl.registerLazySingleton<ThemeRepository>(() => ThemeRepository(sl()));

  // Theme Cubit
  sl.registerSingleton<ThemeCubit>(ThemeCubit(sl()));
}
