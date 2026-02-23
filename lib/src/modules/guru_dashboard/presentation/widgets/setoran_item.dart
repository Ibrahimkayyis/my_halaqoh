import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_halaqoh/src/core/theme/app_colors.dart';

/// A single item in the "Setoran Terakhir" section
class SetoranItem extends StatelessWidget {
  final String name;
  final String surahInfo;
  final int score;

  const SetoranItem({
    super.key,
    required this.name,
    required this.surahInfo,
    required this.score,
  });

  Color _scoreColor(AppColorSet colors) {
    if (score >= 90) return colors.primary;
    if (score >= 80) return colors.blue;
    return colors.yellow;
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10.h),
      child: Row(
        children: [
          // Green dot indicator
          Container(
            width: 4.w,
            height: 40.h,
            decoration: BoxDecoration(
              color: colors.primary,
              borderRadius: BorderRadius.circular(4.r),
            ),
          ),
          SizedBox(width: 12.w),
          // Name and surah info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: colors.primary,
                    fontFamily: 'Poppins',
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  surahInfo,
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w400,
                    color: colors.textSecondary,
                    fontFamily: 'Poppins',
                  ),
                ),
              ],
            ),
          ),
          // Score badge
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: 14.w,
              vertical: 6.h,
            ),
            decoration: BoxDecoration(
              color: _scoreColor(colors).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Text(
              '$score',
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w700,
                color: _scoreColor(colors),
                fontFamily: 'Poppins',
              ),
            ),
          ),
        ],
      ),
    );
  }
}
