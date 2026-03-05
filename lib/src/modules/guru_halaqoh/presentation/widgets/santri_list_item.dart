import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_halaqoh/src/core/theme/app_colors.dart';

/// A single santri list item with avatar, name, progress text, percentage,
/// progress bar, and chevron
class SantriListItem extends StatelessWidget {
  final String name;
  final String progressText;
  final String percentage;
  final double progress; // 0.0 – 1.0
  final VoidCallback? onTap;

  const SantriListItem({
    super.key,
    required this.name,
    required this.progressText,
    required this.percentage,
    required this.progress,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14.r),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        margin: EdgeInsets.only(bottom: 8.h),
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: BorderRadius.circular(14.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Avatar
            Container(
              width: 44.w,
              height: 44.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: colors.primary.withValues(alpha: 0.1),
                border: Border.all(
                  color: colors.primary.withValues(alpha: 0.2),
                  width: 1.5,
                ),
              ),
              child: Icon(Icons.person, size: 22.sp, color: colors.primary),
            ),
            SizedBox(width: 14.w),

            // Main content column
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Name row — name left, percentage right
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                      Text(
                        percentage,
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w700,
                          color: colors.primary,
                          fontFamily: 'Poppins',
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 2.h),

                  // Progress text — full width, wraps naturally (max 2 lines)
                  Text(
                    progressText,
                    maxLines: 2,
                    style: TextStyle(
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w400,
                      color: colors.textSecondary,
                      fontFamily: 'Poppins',
                    ),
                  ),
                  SizedBox(height: 6.h),

                  // Progress bar — full width
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4.r),
                    child: LinearProgressIndicator(
                      value: progress,
                      minHeight: 5.h,
                      backgroundColor: colors.border.withValues(alpha: 0.3),
                      valueColor: AlwaysStoppedAnimation<Color>(colors.primary),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: 8.w),

            // Chevron
            Icon(Icons.chevron_right, size: 22.sp, color: colors.textSecondary),
          ],
        ),
      ),
    );
  }
}
