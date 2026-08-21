import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_halaqoh/src/core/theme/app_colors.dart';

/// Hero Focus Card for active halaqoh summary on the dashboard.
/// Analogous to the primary account card in Wondr by BNI.
class DashboardHalaqohCard extends StatelessWidget {
  final String halaqohName;
  final String kelasBadge;
  final String programName;
  final String targetSummary;
  final int santriCount;
  final VoidCallback? onTap;

  const DashboardHalaqohCard({
    super.key,
    required this.halaqohName,
    required this.kelasBadge,
    required this.programName,
    required this.targetSummary,
    required this.santriCount,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final textTheme = Theme.of(context).textTheme;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: colors.primaryGradient,
        borderRadius: BorderRadius.circular(18.r),
        boxShadow: [
          BoxShadow(
            color: colors.primary.withValues(alpha: 0.25),
            blurRadius: 14,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(18.r),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(18.r),
          child: Padding(
            padding: EdgeInsets.all(18.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top row: Class & Program Badge
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 10.w,
                        vertical: 4.h,
                      ),
                      decoration: BoxDecoration(
                        color: colors.textOnButton.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(20.r),
                      ),
                      child: Text(
                        '$kelasBadge • $programName',
                        style: textTheme.labelSmall?.copyWith(
                              fontSize: 11.sp,
                              fontWeight: FontWeight.w600,
                              color: colors.textOnButton,
                            ) ??
                            TextStyle(
                              fontSize: 11.sp,
                              fontWeight: FontWeight.w600,
                              color: colors.textOnButton,
                              fontFamily: 'Poppins',
                            ),
                      ),
                    ),
                    Text(
                      '$santriCount Santri',
                      style: textTheme.bodySmall?.copyWith(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w600,
                            color: colors.textOnButton.withValues(alpha: 0.9),
                          ) ??
                          TextStyle(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w600,
                            color: colors.textOnButton.withValues(alpha: 0.9),
                            fontFamily: 'Poppins',
                          ),
                    ),
                  ],
                ),
                SizedBox(height: 12.h),

                // Halaqoh Name
                Text(
                  halaqohName,
                  style: textTheme.titleLarge?.copyWith(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.w700,
                        color: colors.textOnButton,
                      ) ??
                      TextStyle(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.w700,
                        color: colors.textOnButton,
                        fontFamily: 'Poppins',
                      ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 8.h),

                // Target Summary Line
                Text(
                  'Target: $targetSummary',
                  style: textTheme.bodySmall?.copyWith(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w400,
                        color: colors.textOnButton.withValues(alpha: 0.85),
                      ) ??
                      TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w400,
                        color: colors.textOnButton.withValues(alpha: 0.85),
                        fontFamily: 'Poppins',
                      ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
