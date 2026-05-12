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
      margin: EdgeInsets.symmetric(horizontal: 24.w),
      padding: EdgeInsets.symmetric(vertical: 28.h),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [colors.primary, colors.primary.withValues(alpha: 0.82)],
        ),
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Column(
        children: [
          // Avatar placeholder
          ShimmerBox(width: 80.w, height: 80.w, radius: 40.r),
          SizedBox(height: 14.h),
          // Name placeholder
          ShimmerBox(width: 150.w, height: 24.h, radius: 4.r),
          SizedBox(height: 8.h),
          // NIS placeholder
          ShimmerBox(width: 100.w, height: 16.h, radius: 4.r),
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
      margin: EdgeInsets.symmetric(horizontal: 24.w),
      padding: EdgeInsets.symmetric(vertical: 16.h),
      decoration: BoxDecoration(
        color: isDark ? colors.surface.withValues(alpha: 0.5) : colors.surface,
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
        children: List.generate(4, (index) {
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            child: Row(
              children: [
                // Icon box placeholder
                ShimmerBox(width: 40.w, height: 40.w, radius: 10.r),
                SizedBox(width: 16.w),
                // Text placeholder
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ShimmerBox(width: 60.w, height: 12.h, radius: 4.r),
                    SizedBox(height: 6.h),
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
      margin: EdgeInsets.symmetric(horizontal: 24.w),
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: isDark ? colors.surface.withValues(alpha: 0.5) : colors.surface,
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
          // Header row placeholder
          Row(
            children: [
              Icon(Icons.menu_book, size: 20.sp, color: colors.textSecondary.withValues(alpha: 0.5)),
              SizedBox(width: 8.w),
              ShimmerBox(width: 140.w, height: 20.h, radius: 4.r),
            ],
          ),
          SizedBox(height: 16.h),

          // Juz completed + percentage placeholder
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ShimmerBox(width: 100.w, height: 28.h, radius: 4.r),
              ShimmerBox(width: 60.w, height: 28.h, radius: 4.r),
            ],
          ),
          SizedBox(height: 12.h),

          // Progress bar placeholder
          ShimmerBox(width: double.infinity, height: 10.h, radius: 6.r),
          SizedBox(height: 8.h),

          // Target text placeholder
          Align(
            alignment: Alignment.centerRight,
            child: ShimmerBox(width: 80.w, height: 14.h, radius: 4.r),
          ),
        ],
      ),
    );
  }
}
