import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_halaqoh/src/core/theme/app_colors.dart';

/// Guru dashboard header with greeting, name, subtitle, and avatar
class GuruDashboardHeader extends StatelessWidget {
  final String greeting;
  final String name;
  final String subtitle;

  const GuruDashboardHeader({
    super.key,
    required this.greeting,
    required this.name,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);

    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 20.h,
        left: 24.w,
        right: 24.w,
        bottom: 28.h,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            colors.primary,
            colors.primary.withValues(alpha: 0.82),
          ],
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(28.r),
          bottomRight: Radius.circular(28.r),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Text section
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Greeting label
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 10.w,
                    vertical: 4.h,
                  ),
                  decoration: BoxDecoration(
                    color: colors.textOnButton.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: Text(
                    greeting,
                    style: TextStyle(
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w600,
                      color: colors.textOnButton,
                      letterSpacing: 1.0,
                      fontFamily: 'Poppins',
                    ),
                  ),
                ),
                SizedBox(height: 8.h),
                // Name
                Text(
                  name,
                  style: TextStyle(
                    fontSize: 24.sp,
                    fontWeight: FontWeight.w700,
                    color: colors.textOnButton,
                    fontFamily: 'Poppins',
                  ),
                ),
                SizedBox(height: 4.h),
                // Subtitle
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w400,
                    color: colors.textOnButton.withValues(alpha: 0.85),
                    fontFamily: 'Poppins',
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 12.w),
          // Avatar
          Container(
            width: 56.w,
            height: 56.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: colors.textOnButton.withValues(alpha: 0.2),
              border: Border.all(
                color: colors.textOnButton.withValues(alpha: 0.4),
                width: 2.5,
              ),
            ),
            child: Icon(
              Icons.person,
              color: colors.textOnButton,
              size: 30.sp,
            ),
          ),
        ],
      ),
    );
  }
}
