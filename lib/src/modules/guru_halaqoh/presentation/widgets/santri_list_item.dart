import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_halaqoh/src/core/theme/app_colors.dart';

/// A single santri list item without avatar.
///
/// Displays the full santri name (soft wrapping without ellipsis truncation),
/// target progress description, percentage, linear progress bar, and chevron.
class SantriListItem extends StatelessWidget {
  final String name;
  final String? profilePictureUrl;
  final String progressText;
  final String percentage;
  final double progress; // 0.0 – 1.0
  final VoidCallback? onTap;

  const SantriListItem({
    super.key,
    required this.name,
    this.profilePictureUrl,
    required this.progressText,
    required this.percentage,
    required this.progress,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final textTheme = Theme.of(context).textTheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16.r),
        splashColor: colors.primary.withValues(alpha: 0.08),
        highlightColor: colors.primary.withValues(alpha: 0.04),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
          margin: EdgeInsets.only(bottom: 8.h),
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
              // Main content column (Without Avatar)
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Name row — name soft-wraps fully without ellipsis, percentage on right
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
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
                        ),
                        SizedBox(width: 10.w),
                        Text(
                          percentage,
                          style: textTheme.titleSmall?.copyWith(
                                fontSize: 13.sp,
                                fontWeight: FontWeight.w700,
                                color: colors.primary,
                              ) ??
                              TextStyle(
                                fontSize: 13.sp,
                                fontWeight: FontWeight.w700,
                                color: colors.primary,
                                fontFamily: 'Poppins',
                              ),
                        ),
                      ],
                    ),
                    SizedBox(height: 4.h),

                    // Progress text description
                    Text(
                      progressText,
                      softWrap: true,
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
                    SizedBox(height: 8.h),

                    // Progress bar
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4.r),
                      child: LinearProgressIndicator(
                        value: progress.clamp(0.0, 1.0),
                        minHeight: 6.h,
                        backgroundColor: colors.primary.withValues(alpha: 0.1),
                        valueColor:
                            AlwaysStoppedAnimation<Color>(colors.primary),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 8.w),

              // Chevron indicator
              Icon(
                Icons.chevron_right_rounded,
                size: 22.sp,
                color: colors.textSecondary.withValues(alpha: 0.5),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
