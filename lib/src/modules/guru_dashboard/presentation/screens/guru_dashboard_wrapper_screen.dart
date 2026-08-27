import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_halaqoh/gen/i18n/translations.g.dart';
import 'package:my_halaqoh/src/core/router/app_router.dart';
import 'package:my_halaqoh/src/core/helpers/active_session_helper.dart';
import 'package:my_halaqoh/src/core/theme/app_colors.dart';
import 'package:my_halaqoh/src/core/widget/widgets.dart';
import 'package:my_halaqoh/src/modules/auth/presentation/cubits/auth_cubit.dart';
import 'package:my_halaqoh/src/modules/auth/presentation/cubits/auth_state.dart';
import 'package:my_halaqoh/src/modules/guru_absensi/presentation/screens/attendance_screen.dart';
import 'package:my_halaqoh/src/modules/guru_dashboard/presentation/screens/guru_dashboard_screen.dart';
import 'package:my_halaqoh/src/modules/guru_hafalan/presentation/screens/hafalan_screen.dart';
import 'package:my_halaqoh/src/modules/guru_halaqoh/presentation/screens/my_halaqoh_screen.dart';
import 'package:my_halaqoh/src/core/service_locator/service_locator.dart';
import 'package:my_halaqoh/src/modules/guru_profile/presentation/screens/guru_profile_screen.dart';
import 'package:my_halaqoh/src/modules/notifications/presentation/cubits/notification_badge_cubit.dart';
import 'package:my_halaqoh/src/modules/notifications/presentation/cubits/notification_cubit.dart';

/// Dashboard wrapper for Guru role with 5-tab floating bottom navigation
@RoutePage()
class GuruDashboardWrapperScreen extends StatefulWidget {
  final String programType;

  const GuruDashboardWrapperScreen({
    super.key,
    @PathParam('programType') this.programType = 'reguler',
  });

  @override
  State<GuruDashboardWrapperScreen> createState() =>
      _GuruDashboardWrapperScreenState();
}

class _GuruDashboardWrapperScreenState
    extends State<GuruDashboardWrapperScreen> {
  final _pageController = PageController(initialPage: 0);
  int _currentIndex = 0;
  bool _fcmTokenInitialized = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authState = context.read<AuthCubit>().state;
      authState.maybeWhen(
        authenticated: (userMeta) {
          if (!_fcmTokenInitialized) {
            _fcmTokenInitialized = true;
            sl<NotificationCubit>().initialize(userMeta.uid);
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
  /// impersonated guru's linkedDocId correctly, while [uid] stays the real
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
    if (linkedDocId.isEmpty || role != 'guru') return;

    unawaited(sl<NotificationBadgeCubit>().start(
      isWaliSantri: false,
      linkedDocId: linkedDocId,
      uid: uid,
    ));
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _navigateToTab(int index) {
    if (_currentIndex != index) {
      setState(() => _currentIndex = index);
    }
    _pageController.jumpToPage(index);
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);

    final pages = <Widget>[
      GuruDashboardScreen(
        onNavigateToTab: _navigateToTab,
        programType: widget.programType,
      ),
      const MyHalaqohScreen(),
      const AttendanceScreen(),
      const HafalanScreen(),
      const GuruProfileScreen(),
    ];

    final navItems = <AppLiquidNavItem>[
      AppLiquidNavItem(
        icon: Icons.home_outlined,
        selectedIcon: Icons.home,
        label: t.guruNav.home,
      ),
      AppLiquidNavItem(
        icon: Icons.auto_stories_outlined,
        selectedIcon: Icons.auto_stories,
        label: t.guruNav.myHalaqoh,
      ),
      AppLiquidNavItem(
        icon: Icons.qr_code_scanner_outlined,
        selectedIcon: Icons.qr_code_scanner,
        label: t.guruNav.absensi,
      ),
      AppLiquidNavItem(
        icon: Icons.menu_book_outlined,
        selectedIcon: Icons.menu_book,
        label: t.guruNav.hafalan,
      ),
      AppLiquidNavItem(
        icon: Icons.person_outline,
        selectedIcon: Icons.person,
        label: t.guruNav.profile,
      ),
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
