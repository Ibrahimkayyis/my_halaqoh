import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_halaqoh/src/core/theme/app_colors.dart';

/// Global reusable tab selector widget.
///
/// Usage:
/// ```dart
/// AppTabSelector(
///   controller: _tabController,
///   tabs: ['Reguler', 'Takhassus'],
/// )
/// ```
///
/// Designed to be used with a [TabController] from a [StatefulWidget]
/// or [SingleTickerProviderStateMixin].
class AppTabSelector extends StatelessWidget {
  /// The [TabController] that manages the selected tab state.
  final TabController controller;

  /// List of tab labels. Must match [TabController.length].
  final List<String> tabs;

  /// Optional height of the tab bar container. Defaults to 42.h
  final double? height;

  /// Optional horizontal padding around the tab bar. Defaults to 16.w
  final double? horizontalPadding;

  const AppTabSelector({
    super.key,
    required this.controller,
    required this.tabs,
    this.height,
    this.horizontalPadding,
  }) : assert(tabs.length >= 2, 'AppTabSelector requires at least 2 tabs');

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding ?? 16.w),
      child: Container(
        height: height ?? 42.h,
        decoration: BoxDecoration(
          color: colors.border.withValues(alpha: 0.3),
          borderRadius: BorderRadius.circular(10.r),
        ),
        child: TabBar(
          controller: controller,
          indicatorSize: TabBarIndicatorSize.tab,
          dividerColor: Colors.transparent,
          indicator: BoxDecoration(
            color: colors.surface,
            borderRadius: BorderRadius.circular(8.r),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.06),
                blurRadius: 4,
                offset: const Offset(0, 1),
              ),
            ],
          ),
          labelColor: colors.primary,
          unselectedLabelColor: colors.textSecondary,
          labelStyle: TextStyle(
            fontSize: 13.sp,
            fontWeight: FontWeight.w700,
            fontFamily: 'Poppins',
          ),
          unselectedLabelStyle: TextStyle(
            fontSize: 13.sp,
            fontWeight: FontWeight.w500,
            fontFamily: 'Poppins',
          ),
          labelPadding: EdgeInsets.zero,
          padding: EdgeInsets.all(3.w),
          tabs: tabs.map((label) => Tab(text: label)).toList(),
        ),
      ),
    );
  }
}