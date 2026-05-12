import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_halaqoh/src/core/theme/app_colors.dart';
import 'package:my_halaqoh/src/core/widget/shimmer/shimmer_box.dart';

/// Shimmer skeleton for [GuruDashboardHeader]
class ShimmerDashboardHeader extends StatelessWidget {
  const ShimmerDashboardHeader({super.key});

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
                // Greeting label placeholder
                ShimmerBox(width: 80.w, height: 20.h, radius: 20.r),
                SizedBox(height: 8.h),
                // Name placeholder
                ShimmerBox(width: 180.w, height: 32.h, radius: 6.r),
                SizedBox(height: 8.h),
                // Subtitle placeholder
                ShimmerBox(width: 220.w, height: 16.h, radius: 4.r),
              ],
            ),
          ),
          SizedBox(width: 12.w),
          // Avatar placeholder
          ShimmerBox(width: 56.w, height: 56.w, radius: 28.r),
        ],
      ),
    );
  }
}
