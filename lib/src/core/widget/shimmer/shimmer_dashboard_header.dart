import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_halaqoh/src/core/widget/shimmer/shimmer_box.dart';

/// Shimmer skeleton for [GuruDashboardHeader] with top brand logo, logout placeholder, and hero card
class ShimmerDashboardHeader extends StatelessWidget {
  const ShimmerDashboardHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 12.h,
        left: 20.w,
        right: 20.w,
        bottom: 4.h,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top Brand logo + Logout button placeholder
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                children: [
                  ShimmerBox(width: 26.w, height: 26.w, radius: 6.r),
                  SizedBox(width: 8.w),
                  ShimmerBox(width: 90.w, height: 16.h, radius: 4.r),
                ],
              ),
              ShimmerBox(width: 32.w, height: 32.w, radius: 12.r),
            ],
          ),
          SizedBox(height: 14.h),

          // Hero Card placeholder
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 18.w),
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.04),
              borderRadius: BorderRadius.circular(20.r),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ShimmerBox(width: 52.w, height: 52.w, radius: 26.r),
                    SizedBox(width: 14.w),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ShimmerBox(width: 80.w, height: 12.h, radius: 4.r),
                        SizedBox(height: 4.h),
                        ShimmerBox(width: 140.w, height: 18.h, radius: 4.r),
                        SizedBox(height: 4.h),
                        ShimmerBox(width: 100.w, height: 12.h, radius: 4.r),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 14.h),
                ShimmerBox(width: 160.w, height: 26.h, radius: 20.r),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
