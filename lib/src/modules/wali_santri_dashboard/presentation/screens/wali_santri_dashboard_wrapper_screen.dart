import 'package:animated_notch_bottom_bar/animated_notch_bottom_bar/animated_notch_bottom_bar.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_halaqoh/src/core/theme/app_colors.dart';

/// Dashboard wrapper for Wali Santri role with bottom navigation
@RoutePage()
class WaliSantriDashboardWrapperScreen extends StatefulWidget {
  const WaliSantriDashboardWrapperScreen({super.key});

  @override
  State<WaliSantriDashboardWrapperScreen> createState() =>
      _WaliSantriDashboardWrapperScreenState();
}

class _WaliSantriDashboardWrapperScreenState
    extends State<WaliSantriDashboardWrapperScreen> {
  final _pageController = PageController(initialPage: 0);
  final NotchBottomBarController _controller =
      NotchBottomBarController(index: 0);

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);

    final pages = <Widget>[
      _buildPlaceholderPage('Dashboard Wali Santri', Icons.dashboard),
      _buildPlaceholderPage('Hafalan Anak', Icons.menu_book),
      _buildPlaceholderPage('Absensi Anak', Icons.checklist),
      _buildPlaceholderPage('Laporan', Icons.bar_chart),
      _buildPlaceholderPage('Profil', Icons.person),
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
            inActiveItem: Icon(Icons.dashboard, color: colors.textSecondary),
            activeItem: Icon(Icons.dashboard, color: colors.textOnButton),
            itemLabel: 'Dashboard',
          ),
          BottomBarItem(
            inActiveItem: Icon(Icons.menu_book, color: colors.textSecondary),
            activeItem: Icon(Icons.menu_book, color: colors.textOnButton),
            itemLabel: 'Hafalan',
          ),
          BottomBarItem(
            inActiveItem: Icon(Icons.checklist, color: colors.textSecondary),
            activeItem: Icon(Icons.checklist, color: colors.textOnButton),
            itemLabel: 'Absensi',
          ),
          BottomBarItem(
            inActiveItem: Icon(Icons.bar_chart, color: colors.textSecondary),
            activeItem: Icon(Icons.bar_chart, color: colors.textOnButton),
            itemLabel: 'Laporan',
          ),
          BottomBarItem(
            inActiveItem: Icon(Icons.person, color: colors.textSecondary),
            activeItem: Icon(Icons.person, color: colors.textOnButton),
            itemLabel: 'Profil',
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
