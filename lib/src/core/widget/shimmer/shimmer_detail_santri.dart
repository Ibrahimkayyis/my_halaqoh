import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_halaqoh/src/core/theme/app_colors.dart';
import 'package:my_halaqoh/src/core/widget/shimmer/shimmer_box.dart';

/// Shimmer skeleton for profile header in detail santri
class ShimmerProfileHeader extends StatelessWidget {
  const ShimmerProfileHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);

    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 20.w),
      padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 18.w),
      decoration: BoxDecoration(
        color: colors.primary.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Avatar placeholder
          ShimmerBox(width: 56.w, height: 56.w, radius: 28.r),
          SizedBox(width: 14.w),
          // Name and NIS placeholders
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                ShimmerBox(width: 160.w, height: 18.h, radius: 4.r),
                SizedBox(height: 6.h),
                ShimmerBox(width: 90.w, height: 12.h, radius: 4.r),
                SizedBox(height: 4.h),
                ShimmerBox(width: 120.w, height: 12.h, radius: 4.r),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Shimmer skeleton for academic info box
class ShimmerAcademicInfo extends StatelessWidget {
  const ShimmerAcademicInfo({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20.w),
      padding: EdgeInsets.symmetric(vertical: 8.h),
      decoration: BoxDecoration(
        color: isDark ? colors.surface.withValues(alpha: 0.5) : colors.surface,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: List.generate(4, (index) {
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Icon box placeholder
                ShimmerBox(width: 38.w, height: 38.w, radius: 10.r),
                SizedBox(width: 14.w),
                // Stacked text placeholder
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ShimmerBox(width: 60.w, height: 12.h, radius: 4.r),
                    SizedBox(height: 4.h),
                    ShimmerBox(width: 140.w, height: 16.h, radius: 4.r),
                  ],
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}

/// Shimmer skeleton for progress hafalan card
class ShimmerProgressCard extends StatelessWidget {
  const ShimmerProgressCard({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20.w),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: isDark ? colors.surface.withValues(alpha: 0.5) : colors.surface,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Juz completed + percentage placeholder
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ShimmerBox(width: 150.w, height: 26.h, radius: 4.r),
              ShimmerBox(width: 50.w, height: 26.h, radius: 12.r),
            ],
          ),
          SizedBox(height: 14.h),

          // Progress bar placeholder
          ShimmerBox(width: double.infinity, height: 8.h, radius: 4.r),
          SizedBox(height: 10.h),

          // Target text placeholder
          Align(
            alignment: Alignment.centerRight,
            child: ShimmerBox(width: 90.w, height: 14.h, radius: 4.r),
          ),
        ],
      ),
    );
  }
}
