import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'src/core/router/app_router.dart';
import 'src/core/service_locator/service_locator.dart';
import 'src/core/theme/cubit/theme_cubit.dart';
import 'src/core/theme/app_theme.dart';
import 'src/core/theme/theme_mode.dart';
import 'package:my_halaqoh/gen/i18n/translations.g.dart';
import 'package:flutter_localizations/flutter_localizations.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await initDependencies();

  // Set Slang locale to Indonesian
  LocaleSettings.setLocale(AppLocale.id);

  // Initialize theme
  await sl<ThemeCubit>().initialize();

  runApp(TranslationProvider(child: MyApp()));
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final _appRouter = AppRouter();

   @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: sl<ThemeCubit>(),
      child: ScreenUtilInit(
        designSize: const Size(360, 690),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) {
          return BlocBuilder<ThemeCubit, ThemeState>(
            builder: (context, state) {
              return MaterialApp.router(
                debugShowCheckedModeBanner: false,
                routerConfig: _appRouter.config(),
                locale: AppLocale.id.flutterLocale,
                supportedLocales: AppLocaleUtils.supportedLocales,
                localizationsDelegates: GlobalMaterialLocalizations.delegates,
                
                // Theme configuration
                theme: AppTheme.light(),
                darkTheme: AppTheme.dark(),
                themeMode: state.maybeWhen(
                  loaded: (mode) {
                    switch (mode) {
                      case AppThemeMode.light:
                        return ThemeMode.light;
                      case AppThemeMode.dark:
                        return ThemeMode.dark;
                      case AppThemeMode.system:
                        return ThemeMode.system;
                    }
                  },
                  orElse: () => ThemeMode.system,
                ),
              );
            },
          );
        },
      ),
    );
  }
}