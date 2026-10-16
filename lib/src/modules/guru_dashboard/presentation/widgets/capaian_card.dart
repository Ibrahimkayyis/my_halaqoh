import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:my_halaqoh/src/core/theme/app_colors.dart';

/// Clean circular progress metric card for "Capaian Hari Ini" section.
/// Uses cohesive primary color branding with soft tinting for visual elegance.
class CapaianCard extends StatelessWidget {
  final String? overline;
  final String title;
  final IconData icon;
  final double percent;
  final String bottomLabel;
  final VoidCallback? onTap;

  const CapaianCard({
    super.key,
    this.overline,
    required this.title,
    required this.icon,
    required this.percent,
    required this.bottomLabel,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final textTheme = Theme.of(context).textTheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
            color: isDark
                ? colors.border
                : colors.primary.withValues(alpha: 0.15),
            width: 0.8,
          ),
          boxShadow: isDark
              ? []
              : [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.03),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
        ),
        child: Material(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(16.r),
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(16.r),
            splashColor: colors.primary.withValues(alpha: 0.08),
            highlightColor: colors.primary.withValues(alpha: 0.04),
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 10.w),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Title & Icon Header (fixed height for guaranteed vertical symmetry)
                  SizedBox(
                    height: 32.h,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          padding: EdgeInsets.all(5.w),
                          decoration: BoxDecoration(
                            color: colors.primary.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                          child: Icon(
                            icon,
                            size: 14.sp,
                            color: colors.primary,
                          ),
                        ),
                        SizedBox(width: 8.w),
                        Flexible(
                          child: overline != null
                              ? Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      overline!,
                                      style: textTheme.labelSmall?.copyWith(
                                            fontSize: 9.sp,
                                            fontWeight: FontWeight.w600,
                                            color: colors.textSecondary,
                                            letterSpacing: 0.5,
                                          ) ??
                                          TextStyle(
                                            fontSize: 9.sp,
                                            fontWeight: FontWeight.w600,
                                            color: colors.textSecondary,
                                            fontFamily: 'Poppins',
                                            letterSpacing: 0.5,
                                          ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    SizedBox(height: 1.h),
                                    Text(
                                      title,
                                      style: textTheme.titleSmall?.copyWith(
                                            fontSize: 12.sp,
                                            fontWeight: FontWeight.w700,
                                            color: colors.textPrimary,
                                            height: 1.15,
                                          ) ??
                                          TextStyle(
                                            fontSize: 12.sp,
                                            fontWeight: FontWeight.w700,
                                            color: colors.textPrimary,
                                            fontFamily: 'Poppins',
                                            height: 1.15,
                                          ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                )
                              : Text(
                                  title,
                                  style: textTheme.titleSmall?.copyWith(
                                        fontSize: 12.sp,
                                        fontWeight: FontWeight.w600,
                                        color: colors.textPrimary,
                                        height: 1.2,
                                      ) ??
                                      TextStyle(
                                        fontSize: 12.sp,
                                        fontWeight: FontWeight.w600,
                                        color: colors.textPrimary,
                                        fontFamily: 'Poppins',
                                        height: 1.2,
                                      ),
                                  maxLines: 2,
                                  softWrap: true,
                                  textAlign: TextAlign.start,
                                  overflow: TextOverflow.ellipsis,
                                ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 14.h),

                  // Circular Progress Indicator (Primary theme)
                  CircularPercentIndicator(
                    radius: 38.w,
                    lineWidth: 6.w,
                    percent: percent.clamp(0.0, 1.0),
                    animation: true,
                    animationDuration: 1000,
                    center: RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: '${(percent * 100).round()}',
                            style: textTheme.titleMedium?.copyWith(
                                  fontSize: 18.sp,
                                  fontWeight: FontWeight.w800,
                                  color: colors.textPrimary,
                                ) ??
                                TextStyle(
                                  fontSize: 18.sp,
                                  fontWeight: FontWeight.w800,
                                  color: colors.textPrimary,
                                  fontFamily: 'Poppins',
                                ),
                          ),
                          TextSpan(
                            text: '%',
                            style: textTheme.bodySmall?.copyWith(
                                  fontSize: 11.sp,
                                  fontWeight: FontWeight.w600,
                                  color: colors.textSecondary,
                                ) ??
                                TextStyle(
                                  fontSize: 11.sp,
                                  fontWeight: FontWeight.w600,
                                  color: colors.textSecondary,
                                  fontFamily: 'Poppins',
                                ),
                          ),
                        ],
                      ),
                    ),
                    circularStrokeCap: CircularStrokeCap.round,
                    progressColor: colors.primary,
                    backgroundColor: colors.primary.withValues(alpha: 0.12),
                  ),
                  SizedBox(height: 14.h),

                  // Bottom Ratio Status Pill
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 8.w,
                      vertical: 4.h,
                    ),
                    decoration: BoxDecoration(
                      color: colors.primary.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(14.r),
                    ),
                    child: Text(
                      bottomLabel,
                      textAlign: TextAlign.center,
                      style: textTheme.labelSmall?.copyWith(
                            fontSize: 10.5.sp,
                            fontWeight: FontWeight.w600,
                            color: colors.primary,
                          ) ??
                          TextStyle(
                            fontSize: 10.5.sp,
                            fontWeight: FontWeight.w600,
                            color: colors.primary,
                            fontFamily: 'Poppins',
                          ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
