import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_halaqoh/src/core/theme/app_colors.dart';
import 'package:my_halaqoh/src/core/widget/shimmer/shimmer_box.dart';

/// Shimmer skeleton for the header card in Detail Absensi
class ShimmerDetailAbsensiHeader extends StatelessWidget {
  const ShimmerDetailAbsensiHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(18.w),
      decoration: BoxDecoration(
        color: isDark ? colors.surface.withValues(alpha: 0.5) : colors.surface,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: colors.border.withValues(alpha: 0.5),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title
          ShimmerBox(width: 140.w, height: 20.h, radius: 4.r),
          SizedBox(height: 6.h),
          
          // Date
          Row(
            children: [
              Icon(Icons.calendar_today, size: 14.sp, color: colors.textSecondary.withValues(alpha: 0.5)),
              SizedBox(width: 6.w),
              ShimmerBox(width: 120.w, height: 14.h, radius: 4.r),
            ],
          ),
          SizedBox(height: 12.h),

          // Scanned count
          Row(
            children: [
              Icon(Icons.qr_code_scanner, size: 14.sp, color: colors.primary.withValues(alpha: 0.5)),
              SizedBox(width: 6.w),
              ShimmerBox(width: 160.w, height: 14.h, radius: 4.r),
            ],
          ),
          SizedBox(height: 14.h),

          // Chips
          Wrap(
            spacing: 8.w,
            runSpacing: 8.h,
            children: List.generate(5, (index) => ShimmerBox(width: 70.w, height: 28.h, radius: 14.r)),
          ),
        ],
      ),
    );
  }
}

/// Shimmer skeleton for the Tab Selector
class ShimmerTabSelector extends StatelessWidget {
  const ShimmerTabSelector({super.key});

  @override
  Widget build(BuildContext context) {
    return ShimmerBox(width: double.infinity, height: 48.h, radius: 24.r);
  }
}

/// Shimmer skeleton for Santri Card in Detail Absensi
class ShimmerDetailAbsensiSantriItem extends StatelessWidget {
  const ShimmerDetailAbsensiSantriItem({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
      margin: EdgeInsets.only(bottom: 12.h),
      decoration: BoxDecoration(
        color: isDark ? colors.surface.withValues(alpha: 0.5) : colors.surface,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: colors.border.withValues(alpha: 0.5)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top section: Avatar, Name, NIS
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ShimmerBox(width: 40.w, height: 40.w, radius: 20.r),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ShimmerBox(width: 140.w, height: 16.h, radius: 4.r),
                    SizedBox(height: 4.h),
                    ShimmerBox(width: 80.w, height: 12.h, radius: 4.r),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 14.h),

          // Bottom section: Dropdown
          ShimmerBox(width: double.infinity, height: 44.h, radius: 12.r),
        ],
      ),
    );
  }
}
