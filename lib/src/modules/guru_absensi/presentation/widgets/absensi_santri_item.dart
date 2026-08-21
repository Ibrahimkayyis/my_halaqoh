import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_halaqoh/src/core/theme/app_colors.dart';

/// Santri list item for absensi screen — clean interactive card with full name, NIS, and chevron.
class AbsensiSantriItem extends StatelessWidget {
  final String name;
  final String nis;
  final VoidCallback? onRiwayatTap;

  const AbsensiSantriItem({
    super.key,
    required this.name,
    required this.nis,
    this.onRiwayatTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final textTheme = Theme.of(context).textTheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: EdgeInsets.only(bottom: 8.h),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: isDark ? colors.border : colors.border.withValues(alpha: 0.7),
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
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16.r),
        child: InkWell(
          onTap: onRiwayatTap,
          borderRadius: BorderRadius.circular(16.r),
          splashColor: colors.primary.withValues(alpha: 0.08),
          highlightColor: colors.primary.withValues(alpha: 0.04),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Name & NIS Column (Full width, soft-wrapping)
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        name,
                        softWrap: true,
                        style: textTheme.titleMedium?.copyWith(
                              fontSize: 14.5.sp,
                              fontWeight: FontWeight.w700,
                              color: colors.textPrimary,
                              height: 1.25,
                            ) ??
                            TextStyle(
                              fontSize: 14.5.sp,
                              fontWeight: FontWeight.w700,
                              color: colors.textPrimary,
                              fontFamily: 'Poppins',
                              height: 1.25,
                            ),
                      ),
                      SizedBox(height: 3.h),
                      Text(
                        'NIS: $nis',
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
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 8.w),

                // Chevron tap affordance
                Icon(
                  Icons.chevron_right_rounded,
                  size: 22.sp,
                  color: colors.textSecondary.withValues(alpha: 0.5),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
