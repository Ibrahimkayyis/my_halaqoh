import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_halaqoh/src/core/widget/widgets.dart';
import 'package:my_halaqoh/gen/i18n/translations.g.dart';
import 'package:my_halaqoh/src/core/service_locator/service_locator.dart';
import 'package:my_halaqoh/src/core/theme/app_colors.dart';
import 'package:my_halaqoh/src/modules/auth/presentation/cubits/auth_cubit.dart';
import 'package:my_halaqoh/src/modules/auth/presentation/cubits/auth_state.dart';
import 'package:my_halaqoh/src/core/helpers/active_session_helper.dart';
import 'package:my_halaqoh/src/modules/master_data/domain/models/santri_model.dart';
import 'package:my_halaqoh/src/modules/master_data/presentation/cubits/santri_cubit.dart';
import 'package:my_halaqoh/src/modules/master_data/presentation/cubits/santri_state.dart';
import 'package:my_halaqoh/src/modules/notifications/presentation/cubits/notification_badge_cubit.dart';
import 'package:my_halaqoh/src/modules/notifications/presentation/cubits/notification_cubit.dart';
import 'package:my_halaqoh/src/modules/wali_santri_absensi/presentation/screens/wali_santri_riwayat_absensi_screen.dart';
import 'package:my_halaqoh/src/modules/wali_santri_dashboard/presentation/screens/wali_santri_dashboard_screen.dart';
import 'package:my_halaqoh/src/modules/wali_santri_hafalan/presentation/screens/wali_santri_riwayat_hafalan_screen.dart';
import 'package:my_halaqoh/src/modules/wali_santri_profile/presentation/screens/wali_santri_profile_screen.dart';
import 'package:my_halaqoh/src/core/notifications/notification_tap_handler.dart';
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
  int _currentIndex = 0;

  bool _fcmTokenInitialized = false;

  // Stores a tab index requested before PageController was attached.
  // Consumed in the next addPostFrameCallback by _navigateToTab().
  int? _pendingTabIndex;

  @override
  void initState() {
    super.initState();
    pendingNotificationTab.addListener(_onPendingNotificationTabChanged);

    // Defer to first frame so PageController and NotchBottomBarController are
    // both attached to the widget tree before any navigation attempt.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Consume any initial pending tab set by early tap handlers in main.dart
      if (pendingNotificationTab.value != null) {
        _navigateToTab(pendingNotificationTab.value!);
        pendingNotificationTab.value = null;
      }

      // Initialize FCM Token for Wali Santri if authenticated
      final authState = context.read<AuthCubit>().state;
      authState.maybeWhen(
        authenticated: (userMeta) {
          if (userMeta.role == 'santri') {
            _initializeFCMToken(userMeta);
          }
        },
        orElse: () {},
      );

      // Start the global notification badge pipeline for this session.
      _startNotificationBadge();
    });
  }

  /// Starts the global [NotificationBadgeCubit] live subscription.
  ///
  /// Uses [ActiveSessionHelper] so super_admin impersonation resolves the
  /// impersonated santri's linkedDocId correctly, while [uid] stays the real
  /// logged-in account (used as the SharedPreferences read-state key).
  void _startNotificationBadge() {
    if (!mounted) return;
    final authState = context.read<AuthCubit>().state;
    String uid = '';
    authState.maybeWhen(
      authenticated: (user) => uid = user.uid,
      orElse: () {},
    );
    if (uid.isEmpty) return;

    final linkedDocId = ActiveSessionHelper.getActiveLinkedDocId(context) ?? '';
    final role = ActiveSessionHelper.getActiveRole(context) ?? '';
    if (linkedDocId.isEmpty) return;

    final isWaliSantri = role == 'santri' || role == 'wali_santri';

    unawaited(sl<NotificationBadgeCubit>().start(
      isWaliSantri: isWaliSantri,
      linkedDocId: linkedDocId,
      uid: uid,
    ));
  }

  /// Helper to initialize FCM token exactly once per session
  void _initializeFCMToken(dynamic userMeta) {
    if (_fcmTokenInitialized) return;
    _fcmTokenInitialized = true;
    sl<NotificationCubit>().initialize(userMeta.uid);
  }

  void _onPendingNotificationTabChanged() {
    if (!mounted) return;
    final tabIndex = pendingNotificationTab.value;
    if (tabIndex != null) {
      _navigateToTab(tabIndex);
      pendingNotificationTab.value = null;
    }
  }

  @override
  void dispose() {
    pendingNotificationTab.removeListener(_onPendingNotificationTabChanged);
    _pageController.dispose();
    super.dispose();
  }

  /// Switches the bottom nav tab and the PageView to [index].
  ///
  /// Safe to call at any time — if [PageController] is not yet attached
  /// to the [PageView] (race condition on cold launch via notification),
  /// the navigation is deferred to the next rendered frame.
  void _navigateToTab(int index) {
    if (!mounted) return;
    if (_currentIndex != index) {
      setState(() => _currentIndex = index);
    }
    if (_pageController.hasClients) {
      _pageController.jumpToPage(index);
    } else {
      // PageController not yet attached (too early on cold launch).
      // Schedule for the next frame when PageView has been laid out.
      _pendingTabIndex = index;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        final pending = _pendingTabIndex;
        if (pending == null) return;
        _pendingTabIndex = null;
        if (_pageController.hasClients) {
          _pageController.jumpToPage(pending);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);

    // Gunakan ActiveSessionHelper agar super_admin yang sedang impersonasi
    // santri bisa mendapatkan linkedDocId dari ImpersonationContext.
    final linkedDocId = ActiveSessionHelper.getActiveLinkedDocId(context) ?? '';

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

    // Fallback name/nis dari AuthCubit (untuk santri asli),
    // atau dari ImpersonationContext (untuk super_admin impersonasi santri).
    final authState = context.watch<AuthCubit>().state;
    String santriName = '';
    String nis = '';
    authState.maybeWhen(
      authenticated: (userMeta) {
        santriName = userMeta.displayName;
        nis = userMeta.identifier;
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

    final navItems = <AppLiquidNavItem>[
      AppLiquidNavItem(
        icon: Icons.home_outlined,
        selectedIcon: Icons.home,
        label: t.waliSantriNav.home,
      ),
      AppLiquidNavItem(
        icon: Icons.menu_book_outlined,
        selectedIcon: Icons.menu_book,
        label: t.waliSantriNav.hafalan,
      ),
      AppLiquidNavItem(
        icon: Icons.checklist_outlined,
        selectedIcon: Icons.checklist,
        label: t.waliSantriNav.absensi,
      ),
      AppLiquidNavItem(
        icon: Icons.person_outline,
        selectedIcon: Icons.person,
        label: t.waliSantriNav.profile,
      ),
    ];

    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        state.maybeWhen(
          authenticated: (userMeta) {
            if (userMeta.role == 'santri') {
              _initializeFCMToken(userMeta);
            }
          },
          unauthenticated: () {
            context.router.replaceAll([const LoginRoute()]);
          },
          orElse: () {},
        );
      },
      child: Scaffold(
        backgroundColor: colors.background,
        extendBody: true,
        body: PageView(
          controller: _pageController,
          physics: const NeverScrollableScrollPhysics(),
          children: pages,
        ),
        bottomNavigationBar: AppLiquidBottomNav(
          currentIndex: _currentIndex,
          items: navItems,
          theme: AppLiquidNavTheme(
            surfaceColor: colors.surface,
            blurSigma: 0,
            accentColor: colors.primary,
            selectedColor: Colors.white,
            unselectedColor: colors.textSecondary,
            borderColor: colors.border.withValues(alpha: 0.6),
            height: 70,
            bottomGap: 12,
            horizontalMargin: 16,
            iconSize: 22,
            labelFontSize: 10,
          ),
          onTap: (index) {
            setState(() => _currentIndex = index);
            _pageController.jumpToPage(index);
          },
        ),
      ),
    );
  }
}
