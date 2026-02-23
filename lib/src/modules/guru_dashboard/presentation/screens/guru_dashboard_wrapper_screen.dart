import 'package:animated_notch_bottom_bar/animated_notch_bottom_bar/animated_notch_bottom_bar.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_halaqoh/gen/i18n/translations.g.dart';
import 'package:my_halaqoh/src/core/theme/app_colors.dart';
import 'package:my_halaqoh/src/modules/guru_dashboard/presentation/screens/guru_dashboard_screen.dart';

/// Dashboard wrapper for Guru role with 4-tab bottom navigation
@RoutePage()
class GuruDashboardWrapperScreen extends StatefulWidget {
  const GuruDashboardWrapperScreen({super.key});

  @override
  State<GuruDashboardWrapperScreen> createState() =>
      _GuruDashboardWrapperScreenState();
}

class _GuruDashboardWrapperScreenState
    extends State<GuruDashboardWrapperScreen> {
  final _pageController = PageController(initialPage: 0);
  final NotchBottomBarController _controller =
      NotchBottomBarController(index: 0);

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
      ),
      _buildPlaceholderPage('My Halaqoh', Icons.auto_stories),
      _buildPlaceholderPage(t.guruNav.laporan, Icons.bar_chart),
      _buildPlaceholderPage(t.guruNav.profile, Icons.person),
    ];

    return Scaffold(
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
            inActiveItem:
                Icon(Icons.auto_stories, color: colors.textSecondary),
            activeItem: Icon(Icons.auto_stories, color: colors.textOnButton),
            itemLabel: t.guruNav.myHalaqoh,
          ),
          BottomBarItem(
            inActiveItem: Icon(Icons.bar_chart, color: colors.textSecondary),
            activeItem: Icon(Icons.bar_chart, color: colors.textOnButton),
            itemLabel: t.guruNav.laporan,
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
    );
  }

  Widget _buildPlaceholderPage(String title, IconData icon) {
    final colors = AppColors.of(context);

    return Scaffold(
      backgroundColor: colors.background,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 64.sp,
              color: colors.textSecondary.withValues(alpha: 0.5),
            ),
            SizedBox(height: 16.h),
            Text(
              title,
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.w600,
                color: colors.textSecondary,
                fontFamily: 'Poppins',
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              'Coming Soon',
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w400,
                color: colors.textSecondary.withValues(alpha: 0.6),
                fontFamily: 'Poppins',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
