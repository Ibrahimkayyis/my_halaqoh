import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:my_halaqoh/src/core/theme/app_colors.dart';

/// Circular progress card for "Capaian hari ini" section
class CapaianCard extends StatelessWidget {
  final String title;
  final double percent;
  final String bottomLabel;
  final Color progressColor;

  const CapaianCard({
    super.key,
    required this.title,
    required this.percent,
    required this.bottomLabel,
    required this.progressColor,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);

    return Expanded(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 12.w),
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            // Title
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.w500,
                color: colors.textSecondary,
                fontFamily: 'Poppins',
              ),
            ),
            SizedBox(height: 12.h),
            // Circular indicator
            CircularPercentIndicator(
              radius: 48.w,
              lineWidth: 8.w,
              percent: percent.clamp(0.0, 1.0),
              animation: true,
              animationDuration: 1200,
              center: RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: '${(percent * 100).round()}',
                      style: TextStyle(
                        fontSize: 28.sp,
                        fontWeight: FontWeight.w700,
                        color: colors.textPrimary,
                        fontFamily: 'Poppins',
                      ),
                    ),
                    TextSpan(
                      text: '%',
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                        color: colors.textSecondary,
                        fontFamily: 'Poppins',
                      ),
                    ),
                  ],
                ),
              ),
              circularStrokeCap: CircularStrokeCap.round,
              progressColor: progressColor,
              backgroundColor: colors.border.withValues(alpha: 0.3),
            ),
            SizedBox(height: 10.h),
            // Bottom label
            Text(
              bottomLabel,
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
    );
  }
}
