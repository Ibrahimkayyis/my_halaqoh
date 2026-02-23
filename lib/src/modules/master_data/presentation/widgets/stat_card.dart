import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_halaqoh/src/core/theme/app_colors.dart';

/// Reusable stat card for displaying summary counts
class StatCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String count;
  final Color? iconColor;
  final Color? iconBgColor;

  const StatCard({
    super.key,
    required this.icon,
    required this.title,
    required this.count,
    this.iconColor,
    this.iconBgColor,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final effectiveIconColor = iconColor ?? colors.primary;
    final effectiveIconBg = iconBgColor ?? colors.primary.withValues(alpha: 0.1);

    return Container(
      width: 150.w,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Icon in colored circle
          Container(
            width: 40.w,
            height: 40.w,
            decoration: BoxDecoration(
              color: effectiveIconBg,
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Center(
              child: Icon(
                icon,
                color: effectiveIconColor,
                size: 22.sp,
              ),
            ),
          ),
          SizedBox(height: 12.h),
          // Title
          Text(
            title,
            style: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.w400,
              color: colors.textSecondary,
              fontFamily: 'Poppins',
            ),
          ),
          SizedBox(height: 4.h),
          // Count
          Text(
            count,
            style: TextStyle(
              fontSize: 24.sp,
              fontWeight: FontWeight.w700,
              color: colors.textPrimary,
              fontFamily: 'Poppins',
            ),
          ),
        ],
      ),
    );
  }
}
