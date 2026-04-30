import 'dart:async';

import 'package:animated_notch_bottom_bar/animated_notch_bottom_bar/animated_notch_bottom_bar.dart';
import 'package:auto_route/auto_route.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_halaqoh/gen/i18n/translations.g.dart';
import 'package:my_halaqoh/src/core/service_locator/service_locator.dart';
import 'package:my_halaqoh/src/core/theme/app_colors.dart';
import 'package:my_halaqoh/src/modules/auth/presentation/cubits/auth_cubit.dart';
import 'package:my_halaqoh/src/modules/auth/presentation/cubits/auth_state.dart';
import 'package:my_halaqoh/src/modules/master_data/domain/models/santri_model.dart';
import 'package:my_halaqoh/src/modules/master_data/presentation/cubits/santri_cubit.dart';
import 'package:my_halaqoh/src/modules/master_data/presentation/cubits/santri_state.dart';
import 'package:my_halaqoh/src/modules/notifications/presentation/cubits/notification_cubit.dart';
import 'package:my_halaqoh/src/modules/wali_santri_absensi/presentation/screens/wali_santri_riwayat_absensi_screen.dart';
import 'package:my_halaqoh/src/modules/wali_santri_dashboard/presentation/screens/wali_santri_dashboard_screen.dart';
import 'package:my_halaqoh/src/modules/wali_santri_hafalan/presentation/screens/wali_santri_riwayat_hafalan_screen.dart';
import 'package:my_halaqoh/src/modules/wali_santri_profile/presentation/screens/wali_santri_profile_screen.dart';
import 'package:my_halaqoh/src/core/router/app_router.dart';

/// Dashboard wrapper for Wali Santri role with 4-tab bottom navigation.
///
/// Responsibilities beyond navigation:
///   - Initializes the Singleton [NotificationCubit] on first render (once per login session).
///   - Registers a foreground FCM message listener using [FlutterLocalNotificationsPlugin]
///     so that notifications are displayed as heads-up banners even when the app is open.
///   - Handles notification tap from terminated state via [FirebaseMessaging.getInitialMessage].
@RoutePage()
class WaliSantriDashboardWrapperScreen extends StatefulWidget {
  final String programType;

  const WaliSantriDashboardWrapperScreen({
    super.key,
    @PathParam('programType') this.programType = 'reguler',
  });

  @override
  State<WaliSantriDashboardWrapperScreen> createState() =>
      _WaliSantriDashboardWrapperScreenState();
}

class _WaliSantriDashboardWrapperScreenState
    extends State<WaliSantriDashboardWrapperScreen> {
  final _pageController = PageController(initialPage: 0);
  final NotchBottomBarController _controller = NotchBottomBarController(
    index: 0,
  );

  // FCM foreground message subscription — cancelled in dispose()
  StreamSubscription<RemoteMessage>? _foregroundMessageSub;

  // flutter_local_notifications plugin for foreground banner display
  final _localNotificationsPlugin = FlutterLocalNotificationsPlugin();

  // Guard against calling initialize() more than once per session
  bool _notificationInitialized = false;

  @override
  void initState() {
    super.initState();
    // Defer init to the first frame so that AuthCubit state is available
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initNotifications();
      _handleInitialMessage();
    });
  }

  /// Initializes [NotificationCubit] and registers the FCM foreground listener.
  /// Only called once per session — subsequent renders are no-ops.
  Future<void> _initNotifications() async {
    if (_notificationInitialized) return;
    _notificationInitialized = true;

    // Initialize local notifications with default app icon
    const initializationSettingsAndroid = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );
    const initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
    );
    await _localNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        // Handle foreground notification banner tap.
        // Foreground taps bypass FCM's onMessageOpenedApp, so we handle
        // them here via the payload set in _localNotificationsPlugin.show().
        final payload = response.payload;
        if (payload == 'absensi') _navigateToTab(2);
        if (payload == 'hafalan') _navigateToTab(1);
      },
    );

    final authState = context.read<AuthCubit>().state;
    authState.maybeWhen(
      authenticated: (userMeta) {
        // Only initialize FCM for Wali Santri (role == 'santri').
        // Guru and Admin sessions intentionally bypass this.
        if (userMeta.role == 'santri') {
          sl<NotificationCubit>().initialize(userMeta.uid);
        }
      },
      orElse: () {},
    );

    // Set up foreground message listener.
    // FCM does NOT show a banner when the app is in the foreground — we
    // must display it manually using flutter_local_notifications.
    _foregroundMessageSub = FirebaseMessaging.onMessage.listen((
      RemoteMessage message,
    ) {
      final notification = message.notification;
      if (notification == null) return;

      // Branch by notification type to use the correct channel.
      final type = message.data['type'] as String? ?? '';
      final channelId = type == 'hafalan'
          ? 'my_halaqoh_hafalan'
          : 'my_halaqoh_absensi';
      final channelName = type == 'hafalan'
          ? 'Notifikasi Hafalan MyHalaqoh'
          : 'Notifikasi Absensi MyHalaqoh';

      _localNotificationsPlugin.show(
        // Unique ID per message to allow stacking multiple notifications
        notification.hashCode,
        notification.title,
        notification.body,
        NotificationDetails(
          android: AndroidNotificationDetails(
            channelId,
            channelName,
            icon:
                '@mipmap/ic_launcher', // CRITICAL: prevents NullPointerException
            importance: Importance.high,
            priority: Priority.high,
            showWhen: true,
          ),
        ),
        payload:
            type, // 'absensi' or 'hafalan' — used by onDidReceiveNotificationResponse
      );
    });

    // Handle notification tap when the app was in background (not terminated)
    FirebaseMessaging.onMessageOpenedApp.listen(_handleNotificationTap);
  }

  /// Handles notification tap when app was launched from terminated state.
  Future<void> _handleInitialMessage() async {
    final message = await FirebaseMessaging.instance.getInitialMessage();
    if (message != null) _handleNotificationTap(message);
  }

  /// Routes the user to the relevant screen based on the notification payload.
  void _handleNotificationTap(RemoteMessage message) {
    final type = message.data['type'] as String?;
    if (type == 'absensi') {
      _navigateToTab(2);
    } else if (type == 'hafalan') {
      _navigateToTab(1); // Tambahkan baris ini untuk navigasi hafalan
    }
  }

  @override
  void dispose() {
    _foregroundMessageSub?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  void _navigateToTab(int index) {
    _controller.jumpTo(index);
    _pageController.jumpToPage(index);
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);

    final authState = context.watch<AuthCubit>().state;
    String santriName = '';
    String nis = '';
    String linkedDocId = '';

    authState.maybeWhen(
      authenticated: (userMeta) {
        santriName = userMeta.displayName;
        nis = userMeta.identifier;
        linkedDocId = userMeta.linkedDocId;
      },
      orElse: () {},
    );

    // Look up real santri data for more accurate name if available locally
    final santriState = context.watch<SantriCubit>().state;
    SantriModel? mySantri;
    santriState.maybeWhen(
      loaded: (list) {
        try {
          mySantri = list.firstWhere((s) => s.id == linkedDocId);
        } catch (_) {}
      },
      orElse: () {},
    );

    final displayName = mySantri?.nama ?? santriName;
    final displayNis = mySantri?.nis ?? nis;

    final pages = <Widget>[
      WaliSantriDashboardScreen(
        onNavigateToTab: _navigateToTab,
        programType: widget.programType,
      ),
      WaliSantriRiwayatHafalanScreen(name: displayName, nis: displayNis),
      WaliSantriRiwayatAbsensiScreen(
        name: displayName,
        nis: displayNis,
        programType: widget.programType,
      ),
      const WaliSantriProfileScreen(),
    ];

    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        state.maybeWhen(
          unauthenticated: () {
            context.router.replaceAll([const LoginRoute()]);
          },
          orElse: () {},
        );
      },
      child: Scaffold(
        backgroundColor: colors.background,
        body: PageView(
          controller: _pageController,
          physics: const NeverScrollableScrollPhysics(),
          children: pages,
        ),
        extendBody: true,
        bottomNavigationBar: AnimatedNotchBottomBar(
          notchBottomBarController: _controller,
          color: colors.surface,
          showLabel: true,
          textOverflow: TextOverflow.visible,
          maxLine: 1,
          shadowElevation: 5,
          kBottomRadius: 20.0,
          notchColor: colors.primary,
          removeMargins: false,
          showShadow: true,
          durationInMilliSeconds: 300,
          itemLabelStyle: TextStyle(
            fontSize: 9.sp,
            fontFamily: 'Poppins',
            color: colors.textSecondary,
          ),
          elevation: 2,
          bottomBarItems: [
            BottomBarItem(
              inActiveItem: Icon(Icons.home, color: colors.textSecondary),
              activeItem: Icon(Icons.home, color: colors.textOnButton),
              itemLabel: t.waliSantriNav.home,
            ),
            BottomBarItem(
              inActiveItem: Icon(Icons.menu_book, color: colors.textSecondary),
              activeItem: Icon(Icons.menu_book, color: colors.textOnButton),
              itemLabel: t.waliSantriNav.hafalan,
            ),
            BottomBarItem(
              inActiveItem: Icon(Icons.checklist, color: colors.textSecondary),
              activeItem: Icon(Icons.checklist, color: colors.textOnButton),
              itemLabel: t.waliSantriNav.absensi,
            ),
            BottomBarItem(
              inActiveItem: Icon(Icons.person, color: colors.textSecondary),
              activeItem: Icon(Icons.person, color: colors.textOnButton),
              itemLabel: t.waliSantriNav.profile,
            ),
          ],
          onTap: (index) {
            _pageController.jumpToPage(index);
          },
          kIconSize: 24.0,
        ),
      ),
    );
  }
}
