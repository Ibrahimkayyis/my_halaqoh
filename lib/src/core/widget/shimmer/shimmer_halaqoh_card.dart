import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_halaqoh/src/core/theme/app_colors.dart';
import 'package:my_halaqoh/src/core/widget/shimmer/shimmer_box.dart';

/// Shimmer skeleton yang merepresentasikan [HalaqohCard].
///
/// Layout:
/// ```
/// ┌────────────────────────────────────────────┐
/// │ [■■■■■■■■■■■■■]                  [■■■] │
/// │ 👤 [■■■■■■■■■■■■■]                     │
/// │ 👥 [■■■]                         [ ] [ ]│
/// └────────────────────────────────────────────┘
/// ```
///
/// Gunakan di dalam [ListView.builder] saat state loading.
class ShimmerHalaqohCard extends StatelessWidget {
  const ShimmerHalaqohCard({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 6.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: isDark ? colors.surface.withValues(alpha: 0.5) : colors.surface,
        borderRadius: BorderRadius.circular(14.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Row 1: Halaqoh name + Kelas badge placeholder
          Row(
            children: [
              Expanded(
                child: ShimmerBox(width: double.infinity, height: 18.h, radius: 4.r),
              ),
              SizedBox(width: 24.w),
              ShimmerBox(width: 48.w, height: 22.h, radius: 12.r),
            ],
          ),
          SizedBox(height: 14.h),

          // Row 2: Teacher placeholder
          Row(
            children: [
              Icon(
                Icons.person,
                color: colors.textSecondary.withValues(alpha: 0.5),
                size: 20.sp,
              ),
              SizedBox(width: 8.w),
              ShimmerBox(width: 140.w, height: 16.h, radius: 4.r),
            ],
          ),
          SizedBox(height: 14.h),

          // Row 3: Santri count + actions placeholder
          Row(
            children: [
              Icon(
                Icons.groups,
                color: colors.textSecondary.withValues(alpha: 0.5),
                size: 20.sp,
              ),
              SizedBox(width: 8.w),
              ShimmerBox(width: 40.w, height: 22.h, radius: 12.r),
              const Spacer(),
              // Detail button placeholder
              ShimmerBox(width: 24.w, height: 24.h, radius: 4.r),
              SizedBox(width: 12.w),
              // Delete button placeholder
              ShimmerBox(width: 24.w, height: 24.h, radius: 4.r),
            ],
          ),
        ],
      ),
    );
  }
}
