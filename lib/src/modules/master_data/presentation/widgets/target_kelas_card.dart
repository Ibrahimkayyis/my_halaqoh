import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_halaqoh/src/core/theme/app_colors.dart';

/// Card widget for displaying a class target in Target Hafalan screen
class TargetKelasCard extends StatelessWidget {
  final String kelasNumber;
  final String kelasTitle;
  final String targetInfo;
  final String juzRange;
  final VoidCallback? onDetailTap;

  const TargetKelasCard({
    super.key,
    required this.kelasNumber,
    required this.kelasTitle,
    required this.targetInfo,
    required this.juzRange,
    this.onDetailTap,
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
      child: Row(
        children: [
          // Kelas number badge
          Container(
            width: 52.w,
            height: 58.h,
            decoration: BoxDecoration(
              color: colors.background,
              borderRadius: BorderRadius.circular(10.r),
              border: Border.all(
                color: colors.border.withValues(alpha: 0.5),
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Kelas',
                  style: TextStyle(
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w400,
                    color: colors.textSecondary,
                    fontFamily: 'Poppins',
                  ),
                ),
                Text(
                  kelasNumber,
                  style: TextStyle(
                    fontSize: 22.sp,
                    fontWeight: FontWeight.w700,
                    color: colors.textPrimary,
                    fontFamily: 'Poppins',
                    height: 1.1,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 14.w),

          // Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  kelasTitle,
                  style: TextStyle(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w700,
                    color: colors.textPrimary,
                    fontFamily: 'Poppins',
                  ),
                ),
                SizedBox(height: 4.h),
                // Target row
                Row(
                  children: [
                    Icon(
                      Icons.verified,
                      size: 15.sp,
                      color: colors.primary,
                    ),
                    SizedBox(width: 6.w),
                    Text(
                      targetInfo,
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w500,
                        color: colors.textSecondary,
                        fontFamily: 'Poppins',
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 2.h),
                // Juz range row
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.menu_book,
                      size: 15.sp,
                      color: colors.primary,
                    ),
                    SizedBox(width: 6.w),
                    Flexible(
                      child: Text(
                        juzRange,
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w500,
                          color: colors.textSecondary,
                          fontFamily: 'Poppins',
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Detail icon
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
        ],
      ),
    );
  }
}
