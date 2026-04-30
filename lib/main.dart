import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:my_halaqoh/gen/i18n/translations.g.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'firebase_options.dart';
import 'src/core/quran/quran_service.dart';
import 'src/core/router/app_router.dart';
import 'src/core/service_locator/service_locator.dart';
import 'src/core/theme/cubit/theme_cubit.dart';
import 'src/core/theme/app_theme.dart';
import 'src/core/theme/theme_mode.dart';
import 'src/core/locale/cubit/locale_cubit.dart';

// Master Data — Hive & Cubits
import 'src/modules/master_data/data/datasources/local/hive_adapters.dart';
import 'src/modules/master_data/data/datasources/local/master_data_local_datasource.dart';
import 'src/modules/master_data/presentation/cubits/guru_cubit.dart';
import 'src/modules/master_data/presentation/cubits/santri_cubit.dart';
import 'src/modules/master_data/presentation/cubits/halaqoh_cubit.dart';
import 'src/modules/master_data/presentation/cubits/target_hafalan_cubit.dart';

// Guru Absensi — Hive & Sync
import 'src/modules/guru_absensi/data/datasources/local/absensi_hive_adapters.dart';
import 'src/modules/guru_absensi/data/datasources/remote/source/implementation/absensi_sync_service.dart';

// Guru Hafalan — Sync
import 'src/modules/guru_hafalan/domain/services/hafalan_sync_service.dart';

// Auth
import 'src/modules/auth/presentation/cubits/auth_cubit.dart';

// ── FCM Background Message Handler ────────────────────────────────────────────
// MUST be a top-level function (not inside a class).
// CONSTRAINT: This runs in a SEPARATE BACKGROUND ISOLATE.
// Do NOT use GetIt (sl), Cubits, BuildContext, or any UI code here.
// Firebase is already initialized by the FCM SDK before this is called.
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // FCM native SDK handles the OS notification display automatically.
  // No additional action is needed for background/terminated state display.
  // Add any background data-only processing here if required in the future.
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // ── 1. Firebase ────────────────────────────────────────────────────
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // ── 1a. FCM Background Handler ──────────────────────────────────────
  // Must be registered immediately after Firebase.initializeApp().
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  // ── 1b. Android Notification Channels ──────────────────────────────
  // Required on Android 8+ (API 26+). Channel IDs must match values in
  // the Cloud Function payloads (sendAbsensiNotification / sendHafalanNotification).
  const absensiChannel = AndroidNotificationChannel(
    'my_halaqoh_absensi',           // id — matches Cloud Function + foreground handler
    'Notifikasi Absensi MyHalaqoh', // human-readable name
    description: 'Notifikasi kehadiran santri dari guru halaqoh.',
    importance: Importance.high,
  );
  const hafalanChannel = AndroidNotificationChannel(
    'my_halaqoh_hafalan',           // id — matches sendHafalanNotification Cloud Function
    'Notifikasi Hafalan MyHalaqoh', // human-readable name
    description: 'Notifikasi setoran hafalan santri dari guru halaqoh.',
    importance: Importance.high,
  );
  final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  
  const initializationSettingsAndroid = AndroidInitializationSettings('@mipmap/ic_launcher');
  const initializationSettings = InitializationSettings(android: initializationSettingsAndroid);
  await flutterLocalNotificationsPlugin.initialize(initializationSettings);

  final androidImpl = flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
  await androidImpl?.createNotificationChannel(absensiChannel);
  await androidImpl?.createNotificationChannel(hafalanChannel);


  // ── 1c. Firebase App Check ───────────────────────────────────────────────
  await FirebaseAppCheck.instance.activate(
    providerAndroid:
        kDebugMode ? AndroidDebugProvider() : AndroidPlayIntegrityProvider(),
    providerApple:
        kDebugMode ? AppleDebugProvider() : AppleAppAttestProvider(),
  );

  // ── 2. Hive ────────────────────────────────────────────────────────────────
  await Hive.initFlutter();
  registerMasterDataAdapters();
  registerAbsensiAdapters();

  // ── 3. Quran Service ───────────────────────────────────────────────────────
  await QuranService.instance.initialize();

  // ── 4. Dependencies (GetIt) ────────────────────────────────────────────────
  await initDependencies();

  // ── 5. Open Hive Boxes ─────────────────────────────────────────────────────
  await sl<MasterDataLocalDataSource>().init();

  // ── 6. Theme & Locale ─────────────────────────────────────────────────────
  await sl<ThemeCubit>().initialize();
  await sl<LocaleCubit>().initialize();

  // ── 7. Offline Sync Services ──────────────────────────────────────────────
  sl<AbsensiSyncService>().start();
  sl<HafalanSyncService>().start();

  runApp(TranslationProvider(child: MyApp()));
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final _appRouter = AppRouter(sl<AuthCubit>());

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: sl<ThemeCubit>()),
        BlocProvider.value(value: sl<LocaleCubit>()),
        // Auth Cubit
        BlocProvider.value(value: sl<AuthCubit>()..checkAuthStatus()),
        // Master Data Cubits
        BlocProvider(create: (_) => sl<GuruCubit>()..watchAll()),
        BlocProvider(create: (_) => sl<SantriCubit>()..watchAll()),
        BlocProvider(create: (_) => sl<HalaqohCubit>()..watchAll()),
        BlocProvider(create: (_) => sl<TargetHafalanCubit>()..watchAll()),
      ],
      child: ScreenUtilInit(
        designSize: const Size(360, 690),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) {
          return BlocBuilder<LocaleCubit, LocaleState>(
            builder: (context, localeState) {
              return BlocBuilder<ThemeCubit, ThemeState>(
                builder: (context, themeState) {
                  final locale = localeState.maybeWhen(
                    loaded: (appLocale) => appLocale.flutterLocale,
                    orElse: () => AppLocale.id.flutterLocale,
                  );
                  return MaterialApp.router(
                    debugShowCheckedModeBanner: false,
                    routerConfig: _appRouter.config(),
                    locale: locale,
                    supportedLocales: AppLocaleUtils.supportedLocales,
                    localizationsDelegates:
                        GlobalMaterialLocalizations.delegates,
                    theme: AppTheme.light(),
                    darkTheme: AppTheme.dark(),
                    themeMode: themeState.maybeWhen(
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
          );
        },
      ),
    );
  }
}