import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_halaqoh/src/core/theme/app_colors.dart';

/// Reusable card widget for displaying a Halaqoh group
class HalaqohCard extends StatelessWidget {
  final String name;
  final String kelasLabel;
  final String teacherName;
  final String santriCount;
  final VoidCallback? onDetailTap;
  final VoidCallback? onDeleteTap;

  const HalaqohCard({
    super.key,
    required this.name,
    required this.kelasLabel,
    required this.teacherName,
    required this.santriCount,
    this.onDetailTap,
    this.onDeleteTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 6.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: colors.surface,
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
          // Row 1: Halaqoh name + Kelas badge
          Row(
            children: [
              Text(
                name,
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w700,
                  color: colors.textPrimary,
                  fontFamily: 'Poppins',
                ),
              ),
              SizedBox(width: 10.w),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 10.w,
                  vertical: 3.h,
                ),
                decoration: BoxDecoration(
                  color: colors.border.withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Text(
                  kelasLabel,
                  style: TextStyle(
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w500,
                    color: colors.textSecondary,
                    fontFamily: 'Poppins',
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 10.h),

          // Row 2: Teacher
          Row(
            children: [
              Icon(
                Icons.person,
                color: colors.primary,
                size: 20.sp,
              ),
              SizedBox(width: 8.w),
              Expanded(
                child: Text(
                  teacherName,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                    color: colors.textPrimary,
                    fontFamily: 'Poppins',
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),

          // Row 3: Santri count + actions
          Row(
            children: [
              Icon(
                Icons.groups,
                color: colors.textSecondary,
                size: 20.sp,
              ),
              SizedBox(width: 8.w),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 10.w,
                  vertical: 3.h,
                ),
                decoration: BoxDecoration(
                  color: colors.background,
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(
                    color: colors.border,
                    width: 0.5,
                  ),
                ),
                child: Text(
                  santriCount,
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w500,
                    color: colors.textPrimary,
                    fontFamily: 'Poppins',
                  ),
                ),
              ),
              const Spacer(),
              // Detail button
              GestureDetector(
                onTap: onDetailTap,
                child: Padding(
                  padding: EdgeInsets.all(4.w),
                  child: Icon(
                    Icons.sort,
                    size: 22.sp,
                    color: colors.textSecondary,
                  ),
                ),
              ),
              SizedBox(width: 8.w),
              // Delete button
              GestureDetector(
                onTap: onDeleteTap,
                child: Padding(
                  padding: EdgeInsets.all(4.w),
                  child: Icon(
                    Icons.delete_outlined,
                    size: 22.sp,
                    color: colors.textSecondary,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
