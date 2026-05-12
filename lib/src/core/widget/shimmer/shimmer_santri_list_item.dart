import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_halaqoh/src/core/theme/app_colors.dart';
import 'package:my_halaqoh/src/core/widget/shimmer/shimmer_box.dart';

/// Shimmer skeleton for [SantriListItem]
class ShimmerSantriListItem extends StatelessWidget {
  const ShimmerSantriListItem({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      margin: EdgeInsets.only(bottom: 8.h),
      decoration: BoxDecoration(
        color: isDark ? colors.surface.withValues(alpha: 0.5) : colors.surface,
        borderRadius: BorderRadius.circular(14.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Avatar placeholder
          ShimmerBox(width: 44.w, height: 44.w, radius: 22.r),
          SizedBox(width: 14.w),

          // Main content column
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Name row placeholder
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ShimmerBox(width: 120.w, height: 16.h, radius: 4.r),
                    ShimmerBox(width: 32.w, height: 16.h, radius: 4.r),
                  ],
                ),
                SizedBox(height: 6.h),

                // Progress text placeholder
                ShimmerBox(width: double.infinity, height: 12.h, radius: 4.r),
                SizedBox(height: 8.h),

                // Progress bar placeholder
                ShimmerBox(width: double.infinity, height: 5.h, radius: 2.r),
              ],
            ),
          ),
          SizedBox(width: 8.w),

          // Chevron placeholder
          ShimmerBox(width: 20.w, height: 20.h, radius: 4.r),
        ],
      ),
    );
  }
}
