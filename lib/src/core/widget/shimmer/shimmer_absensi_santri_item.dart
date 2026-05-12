import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_halaqoh/src/core/theme/app_colors.dart';
import 'package:my_halaqoh/src/core/widget/shimmer/shimmer_box.dart';

/// Shimmer skeleton for [AbsensiSantriItem]
class ShimmerAbsensiSantriItem extends StatelessWidget {
  const ShimmerAbsensiSantriItem({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
      margin: EdgeInsets.only(bottom: 10.h),
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
          SizedBox(width: 12.w),

          // Main content column
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Name placeholder
                ShimmerBox(width: 150.w, height: 16.h, radius: 4.r),
                SizedBox(height: 6.h),

                // NIS placeholder
                ShimmerBox(width: 80.w, height: 12.h, radius: 4.r),
                SizedBox(height: 10.h),

                // Button placeholder
                ShimmerBox(width: 120.w, height: 26.h, radius: 8.r),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
