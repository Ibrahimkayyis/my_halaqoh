import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_halaqoh/src/core/theme/app_colors.dart';

/// A single item in the "Setoran Terakhir" section.
/// Displays santri name, surah info, and a clean numeric score badge.
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
    if (score >= 85) return colors.success;
    if (score >= 75) return colors.info;
    return colors.warning;
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final textTheme = Theme.of(context).textTheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final scoreCol = _scoreColor(colors);

    return Container(
      margin: EdgeInsets.only(bottom: 8.h),
      padding: EdgeInsets.symmetric(vertical: 14.h, horizontal: 16.w),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: isDark
              ? colors.border
              : colors.border.withValues(alpha: 0.7),
          width: 0.8,
        ),
        boxShadow: isDark
            ? []
            : [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.02),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Name and surah info column (without avatar)
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  name,
                  style: textTheme.titleMedium?.copyWith(
                        fontSize: 14.5.sp,
                        fontWeight: FontWeight.w700,
                        color: colors.textPrimary,
                      ) ??
                      TextStyle(
                        fontSize: 14.5.sp,
                        fontWeight: FontWeight.w700,
                        color: colors.textPrimary,
                        fontFamily: 'Poppins',
                      ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 3.h),
                Text(
                  surahInfo,
                  style: textTheme.bodySmall?.copyWith(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w400,
                        color: colors.textSecondary,
                      ) ??
                      TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w400,
                        color: colors.textSecondary,
                        fontFamily: 'Poppins',
                      ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          SizedBox(width: 12.w),

          // Numeric Score Badge (Only number, without "Nilai" text)
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: 10.w,
              vertical: 5.h,
            ),
            decoration: BoxDecoration(
              color: scoreCol.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(
                color: scoreCol.withValues(alpha: 0.3),
                width: 1,
              ),
            ),
            child: Text(
              '$score',
              style: textTheme.titleSmall?.copyWith(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w700,
                    color: scoreCol,
                  ) ??
                  TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w700,
                    color: scoreCol,
                    fontFamily: 'Poppins',
                  ),
            ),
          ),
        ],
      ),
    );
  }
}
