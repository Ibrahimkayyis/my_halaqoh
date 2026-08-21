import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_halaqoh/src/core/theme/app_colors.dart';

/// A single row in the academic info card — icon box, stacked label (top) and value (bottom).
/// Fully safe for long values such as lengthy teacher/supervisor titles.
class AcademicInfoRow extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final Color iconBgColor;
  final String label;
  final String value;
  final bool showDivider;

  const AcademicInfoRow({
    super.key,
    required this.icon,
    required this.iconColor,
    required this.iconBgColor,
    required this.label,
    required this.value,
    this.showDivider = true,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final textTheme = Theme.of(context).textTheme;

    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Icon box
              Container(
                width: 38.w,
                height: 38.w,
                decoration: BoxDecoration(
                  color: iconBgColor,
                  borderRadius: BorderRadius.circular(10.r),
                ),
                alignment: Alignment.center,
                child: Icon(icon, size: 19.sp, color: iconColor),
              ),
              SizedBox(width: 14.w),

              // Stacked label (top) and value (bottom)
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      label,
                      style: textTheme.bodySmall?.copyWith(
                            fontSize: 11.5.sp,
                            fontWeight: FontWeight.w400,
                            color: colors.textSecondary,
                          ) ??
                          TextStyle(
                            fontSize: 11.5.sp,
                            fontWeight: FontWeight.w400,
                            color: colors.textSecondary,
                            fontFamily: 'Poppins',
                          ),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      value,
                      softWrap: true,
                      style: textTheme.titleMedium?.copyWith(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                            color: colors.textPrimary,
                            height: 1.25,
                          ) ??
                          TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                            color: colors.textPrimary,
                            fontFamily: 'Poppins',
                            height: 1.25,
                          ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        if (showDivider)
          Divider(
            height: 1,
            thickness: 1,
            color: colors.borderLight,
            indent: 68.w,
            endIndent: 16.w,
          ),
      ],
    );
  }
}
