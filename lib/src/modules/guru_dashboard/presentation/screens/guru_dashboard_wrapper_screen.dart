import 'package:animated_notch_bottom_bar/animated_notch_bottom_bar/animated_notch_bottom_bar.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_halaqoh/gen/i18n/translations.g.dart';
import 'package:my_halaqoh/src/core/theme/app_colors.dart';
import 'package:my_halaqoh/src/modules/guru_dashboard/presentation/screens/guru_dashboard_screen.dart';
import 'package:my_halaqoh/src/modules/guru_halaqoh/presentation/screens/my_halaqoh_screen.dart';
import 'package:my_halaqoh/src/modules/guru_absensi/presentation/screens/attendance_screen.dart';
import 'package:my_halaqoh/src/modules/guru_hafalan/presentation/screens/hafalan_screen.dart';
import 'package:my_halaqoh/src/modules/guru_profile/presentation/screens/guru_profile_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_halaqoh/src/modules/auth/presentation/cubits/auth_cubit.dart';
import 'package:my_halaqoh/src/modules/auth/presentation/cubits/auth_state.dart';
import 'package:my_halaqoh/src/core/router/app_router.dart';

/// Dashboard wrapper for Guru role with 5-tab bottom navigation
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
  final NotchBottomBarController _controller = NotchBottomBarController(
    index: 0,
  );

  @override
  void dispose() {
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

    final pages = <Widget>[
      GuruDashboardScreen(
        onNavigateToTab: _navigateToTab,
        programType: widget.programType,
      ),
      const MyHalaqohScreen(),
      AttendanceScreen(programType: widget.programType),
      const HafalanScreen(),
      const GuruProfileScreen(),
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
            itemLabel: t.guruNav.home,
          ),
          BottomBarItem(
            inActiveItem: Icon(Icons.auto_stories, color: colors.textSecondary),
            activeItem: Icon(Icons.auto_stories, color: colors.textOnButton),
            itemLabel: t.guruNav.myHalaqoh,
          ),
          BottomBarItem(
            inActiveItem: Icon(
              Icons.qr_code_scanner,
              color: colors.textSecondary,
            ),
            activeItem: Icon(Icons.qr_code_scanner, color: colors.textOnButton),
            itemLabel: t.guruNav.absensi,
          ),
          BottomBarItem(
            inActiveItem: Icon(Icons.menu_book, color: colors.textSecondary),
            activeItem: Icon(Icons.menu_book, color: colors.textOnButton),
            itemLabel: t.guruNav.hafalan,
          ),
          BottomBarItem(
            inActiveItem: Icon(Icons.person, color: colors.textSecondary),
            activeItem: Icon(Icons.person, color: colors.textOnButton),
            itemLabel: t.guruNav.profile,
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
