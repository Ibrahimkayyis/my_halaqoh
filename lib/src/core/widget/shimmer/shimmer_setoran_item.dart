import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_halaqoh/src/core/widget/shimmer/shimmer_box.dart';

/// Shimmer skeleton for [SetoranItem]
class ShimmerSetoranItem extends StatelessWidget {
  const ShimmerSetoranItem({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10.h),
      child: Row(
        children: [
          // Green dot indicator placeholder
          ShimmerBox(width: 4.w, height: 40.h, radius: 4.r),
          SizedBox(width: 12.w),
          // Name and surah info placeholder
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ShimmerBox(width: 120.w, height: 16.h, radius: 4.r),
                SizedBox(height: 6.h),
                ShimmerBox(width: 180.w, height: 14.h, radius: 4.r),
              ],
            ),
          ),
          // Score badge placeholder
          ShimmerBox(width: 48.w, height: 32.h, radius: 10.r),
        ],
      ),
    );
  }
}
