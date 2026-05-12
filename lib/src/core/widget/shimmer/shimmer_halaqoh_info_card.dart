import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_halaqoh/src/core/theme/app_colors.dart';
import 'package:my_halaqoh/src/core/widget/shimmer/shimmer_box.dart';

/// Shimmer skeleton for [HalaqohInfoCard]
class ShimmerHalaqohInfoCard extends StatelessWidget {
  const ShimmerHalaqohInfoCard({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);

    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 24.w),
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            colors.primary,
            colors.primary.withValues(alpha: 0.82),
          ],
        ),
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Badges row
          Row(
            children: [
              ShimmerBox(width: 40.w, height: 20.h, radius: 20.r),
              SizedBox(width: 8.w),
              Text(
                '•',
                style: TextStyle(
                  color: colors.textOnButton.withValues(alpha: 0.7),
                  fontSize: 14.sp,
                ),
              ),
              SizedBox(width: 8.w),
              ShimmerBox(width: 50.w, height: 20.h, radius: 4.r),
            ],
          ),
          SizedBox(height: 12.h),

          // Halaqoh name
          ShimmerBox(width: 150.w, height: 28.h, radius: 6.r),
          SizedBox(height: 10.h),

          // Info rows
          Row(
            children: [
              Icon(Icons.person_outline, size: 16.sp, color: colors.textOnButton.withValues(alpha: 0.8)),
              SizedBox(width: 8.w),
              ShimmerBox(width: 180.w, height: 16.h, radius: 4.r),
            ],
          ),
          SizedBox(height: 6.h),
          Row(
            children: [
              Icon(Icons.flag_outlined, size: 16.sp, color: colors.textOnButton.withValues(alpha: 0.8)),
              SizedBox(width: 8.w),
              ShimmerBox(width: 220.w, height: 16.h, radius: 4.r),
            ],
          ),
          SizedBox(height: 6.h),
          Row(
            children: [
              Icon(Icons.groups_outlined, size: 16.sp, color: colors.textOnButton.withValues(alpha: 0.8)),
              SizedBox(width: 8.w),
              ShimmerBox(width: 100.w, height: 16.h, radius: 4.r),
            ],
          ),
        ],
      ),
    );
  }
}
