import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_halaqoh/src/core/widget/shimmer/shimmer_box.dart';

/// Shimmer skeleton for [SetoranItem]
class ShimmerSetoranItem extends StatelessWidget {
  const ShimmerSetoranItem({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: EdgeInsets.only(bottom: 8.h),
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
      decoration: BoxDecoration(
        color: isDark
            ? Colors.white.withValues(alpha: 0.05)
            : Colors.white.withValues(alpha: 0.8),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: isDark
              ? Colors.white.withValues(alpha: 0.1)
              : Colors.black.withValues(alpha: 0.05),
          width: 0.8,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Middle info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    ShimmerBox(width: 110.w, height: 14.h, radius: 4.r),
                    SizedBox(width: 8.w),
                    ShimmerBox(width: 60.w, height: 14.h, radius: 4.r),
                  ],
                ),
                SizedBox(height: 6.h),
                ShimmerBox(width: 160.w, height: 12.h, radius: 4.r),
              ],
            ),
          ),
          SizedBox(width: 12.w),
          // Score badge
          ShimmerBox(width: 32.w, height: 26.h, radius: 8.r),
        ],
      ),
    );
  }
}
