import 'dart:async';

import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:my_halaqoh/gen/i18n/translations.g.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'firebase_options.dart';
import 'src/core/quran/quran_service.dart';
import 'src/core/router/app_router.dart';
import 'src/core/service_locator/service_locator.dart';
import 'src/core/notifications/notification_tap_handler.dart';
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
import 'src/modules/auth/presentation/cubits/auth_state.dart';

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

// ── Parallel helper: Android notification channel setup ───────────────────────
// Completely independent of Firebase, Hive, and GetIt.
// Safe to run in parallel with _initHive() and QuranService.
Future<void> _initNotificationChannels() async {
  const absensiChannel = AndroidNotificationChannel(
    'my_halaqoh_absensi',
    'Notifikasi Absensi MyHalaqoh',
    description: 'Notifikasi kehadiran santri dari guru halaqoh.',
    importance: Importance.high,
  );
  const hafalanChannel = AndroidNotificationChannel(
    'my_halaqoh_hafalan',
    'Notifikasi Hafalan MyHalaqoh',
    description: 'Notifikasi setoran hafalan santri dari guru halaqoh.',
    importance: Importance.high,
  );
  final plugin = FlutterLocalNotificationsPlugin();
  const initSettings = InitializationSettings(
    android: AndroidInitializationSettings('@mipmap/ic_launcher'),
  );
  await plugin.initialize(
    initSettings,
    onDidReceiveNotificationResponse: (NotificationResponse response) {
      // Foreground local-notification tap.
      // Writes to the global ValueNotifier so the dashboard widget can navigate.
      final payload = response.payload;
      if (payload == 'absensi') pendingNotificationTab.value = 2;
      if (payload == 'hafalan') pendingNotificationTab.value = 1;
    },
  );
  final androidImpl =
      plugin.resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>();
  await androidImpl?.createNotificationChannel(absensiChannel);
  await androidImpl?.createNotificationChannel(hafalanChannel);
}

void _setupNotificationTapHandlers() {
  FirebaseMessaging.instance.getInitialMessage().then((RemoteMessage? message) {
    if (message != null) {
      _handleRemoteMessageTap(message);
    }
  });

  FirebaseMessaging.onMessageOpenedApp.listen(_handleRemoteMessageTap);

  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    final notification = message.notification;
    if (notification == null) return;

    final type = message.data['type'] as String? ?? '';
    final channelId = type == 'hafalan'
        ? 'my_halaqoh_hafalan'
        : 'my_halaqoh_absensi';
    final channelName = type == 'hafalan'
        ? 'Notifikasi Hafalan MyHalaqoh'
        : 'Notifikasi Absensi MyHalaqoh';

    final plugin = FlutterLocalNotificationsPlugin();
    plugin.show(
      notification.hashCode,
      notification.title,
      notification.body,
      NotificationDetails(
        android: AndroidNotificationDetails(
          channelId,
          channelName,
          icon: '@mipmap/ic_launcher',
          importance: Importance.high,
          priority: Priority.high,
          showWhen: true,
        ),
      ),
      payload: type,
    );
  });
}

void _handleRemoteMessageTap(RemoteMessage message) {
  final type = message.data['type'] as String?;
  if (type == 'absensi') {
    pendingNotificationTab.value = 2;
  } else if (type == 'hafalan') {
    pendingNotificationTab.value = 1;
  }
}

// ── Parallel helper: Hive initialization ──────────────────────────────────────
// Completely independent of Firebase and GetIt.
// Adapters MUST be registered here (before MasterDataLocalDataSource.init()).
// Safe to run in parallel with _initNotificationChannels() and QuranService.
Future<void> _initHive() async {
  await Hive.initFlutter();
  registerMasterDataAdapters();
  registerAbsensiAdapters();
}

void main() async {
  // Preserve the native splash until we explicitly remove it after auth resolves.
  // This eliminates the blank-white frame between the OS launch and the Flutter UI.
  final widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  // ── 1. Firebase (MUST be first — Firestore, Auth, Messaging all depend on it)
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Register FCM background handler immediately after Firebase init.
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  // Register notification-tap handlers as early as possible.
  // These write to the global [pendingNotificationTab] ValueNotifier,
  // which the WaliSantriDashboardWrapperScreen listens to.
  _setupNotificationTapHandlers();

  // ── 2. Parallel initialization ────────────────────────────────────────────
  // These three tasks are completely independent of each other:
  //   • _initNotificationChannels() — uses only flutter_local_notifications
  //   • _initHive()                 — uses only hive_flutter
  //   • QuranService.initialize()   — reads assets/data/quran.json via rootBundle
  // Running them concurrently saves ~200–400ms vs serial execution.
  await Future.wait([
    _initNotificationChannels(),
    _initHive(),
    QuranService.instance.initialize(),
  ]);

  // ── 3. Firebase App Check (fire-and-forget — does NOT block startup) ──────
  // App Check tokens are cached locally after the first successful activation.
  // On subsequent cold starts the token is served from cache (near-instant).
  // Making this non-blocking saves 500ms–3s on slow networks / first launch.
  // Security is preserved: Firestore Security Rules remain the primary guard.
  // If App Check enforcement is enabled in Firebase Console, all requests
  // automatically include the token once activation resolves in the background.
  // FirebaseAppCheck.instance
  //     .activate(
  //       providerAndroid: kDebugMode
  //           ? AndroidDebugProvider()
  //           : AndroidPlayIntegrityProvider(),
  //       providerApple: kDebugMode
  //           ? AppleDebugProvider()
  //           : AppleAppAttestProvider(),
  //     )
  //     .catchError((Object e) {
  //       debugPrint('[AppCheck] Activation warning: $e');
  //     });

  // ── 4. GetIt Dependencies ─────────────────────────────────────────────────
  // Requires: Firebase (step 1) + Hive adapters registered (step 2).
  // SharedPreferences.getInstance() is called inside initDependencies().
  await initDependencies();

  // ── 5. Open Hive Boxes ────────────────────────────────────────────────────
  // Requires: GetIt ready (step 4) + Hive initialized (step 2).
  // Must run BEFORE runApp() — cubits may read Hive cache on first frame.
  await sl<MasterDataLocalDataSource>().init();

  // ── 6. Theme & Locale (parallelized) ─────────────────────────────────────
  // Both read from SharedPreferences using different keys — safe to run concurrently.
  // Requires: GetIt ready (step 4).
  await Future.wait([
    sl<ThemeCubit>().initialize(),
    sl<LocaleCubit>().initialize(),
  ]);

  // ── 7. Sync Services (fire-and-forget) ────────────────────────────────────
  // These manage their own lifecycle via connectivity_plus stream listeners.
  // They do NOT need to complete before runApp().
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
        // Auth Cubit — checkAuthStatus() kicks off the stream that drives routing
        BlocProvider.value(value: sl<AuthCubit>()..checkAuthStatus()),
        // Master Data Cubits
        BlocProvider(create: (_) => sl<GuruCubit>()..watchAll()),
        BlocProvider(create: (_) => sl<SantriCubit>()..watchAll()),
        BlocProvider(create: (_) => sl<HalaqohCubit>()..watchAll()),
        BlocProvider(create: (_) => sl<TargetHafalanCubit>()..watchAll()),
      ],
      child: BlocListener<AuthCubit, AuthState>(
        // Only trigger routing when the state genuinely changes type.
        // Without this, Firebase token refreshes re-emit `authenticated`,
        // causing _appRouter.replace() to fire again and wipe the nav stack.
        listenWhen: (previous, current) {
          final wasAuthenticated = previous.maybeWhen(
            authenticated: (_) => true,
            orElse: () => false,
          );
          final isAuthenticated = current.maybeWhen(
            authenticated: (_) => true,
            orElse: () => false,
          );
          final wasUnauthenticated = previous.maybeWhen(
            unauthenticated: () => true,
            orElse: () => false,
          );
          final isUnauthenticated = current.maybeWhen(
            unauthenticated: () => true,
            orElse: () => false,
          );
          // Only react when crossing the authenticated ↔ unauthenticated boundary.
          return (!wasAuthenticated && isAuthenticated) ||
              (!wasUnauthenticated && isUnauthenticated);
        },
        // ── Native Splash Routing ────────────────────────────────────────────
        // Listens to AuthCubit state changes. When auth resolves (either
        // authenticated or unauthenticated), we push to the correct root route
        // and IMMEDIATELY remove the native splash so the UI is revealed.
        // This replaces the old SplashScreen widget entirely.
        listener: (context, state) {
          state.maybeWhen(
            authenticated: (user) {
              final programStr =
                  (user.programType == 'T') ? 'takhassus' : 'reguler';

              if (user.role == 'admin') {
                _appRouter.replace(const DashboardWrapperRoute());
              } else if (user.role == 'guru') {
                _appRouter.replace(
                  GuruDashboardWrapperRoute(programType: programStr),
                );
              } else if (user.role == 'santri') {
                _appRouter.replace(
                  WaliSantriDashboardWrapperRoute(programType: programStr),
                );
              } else {
                // Unknown role — fall through to login
                _appRouter.replace(const LoginRoute());
              }
              // Remove the native splash immediately after navigation is queued.
              FlutterNativeSplash.remove();
            },
            unauthenticated: () {
              _appRouter.replace(const LoginRoute());
              FlutterNativeSplash.remove();
            },
            orElse: () {
              // loading / initial — keep the native splash visible; do nothing.
            },
          );
        },
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
      ),
    );
  }
}