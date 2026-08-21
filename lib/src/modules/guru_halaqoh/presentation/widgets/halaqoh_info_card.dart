import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_halaqoh/src/core/theme/app_colors.dart';

/// Green gradient card showing halaqoh info:
/// class/program badges, halaqoh name, guru, target, total santri
class HalaqohInfoCard extends StatelessWidget {
  final String kelas;
  final String program;
  final String halaqohName;
  final String pengampu;
  final String target;
  final String totalSantri;

  const HalaqohInfoCard({
    super.key,
    required this.kelas,
    required this.program,
    required this.halaqohName,
    required this.pengampu,
    required this.target,
    required this.totalSantri,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final textTheme = Theme.of(context).textTheme;

    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 20.w),
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        gradient: colors.primaryGradient,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: colors.primary.withValues(alpha: 0.25),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Badges row
          Row(
            children: [
              _buildBadge(kelas, colors, textTheme),
              SizedBox(width: 8.w),
              Text(
                '•',
                style: TextStyle(
                  color: colors.textOnButton.withValues(alpha: 0.7),
                  fontSize: 14.sp,
                ),
              ),
              SizedBox(width: 8.w),
              Text(
                program,
                style: textTheme.bodySmall?.copyWith(
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w500,
                      color: colors.textOnButton.withValues(alpha: 0.9),
                    ) ??
                    TextStyle(
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w500,
                      color: colors.textOnButton.withValues(alpha: 0.9),
                      fontFamily: 'Poppins',
                    ),
              ),
            ],
          ),
          SizedBox(height: 12.h),

          // Halaqoh name
          Text(
            halaqohName,
            style: textTheme.headlineSmall?.copyWith(
                  fontSize: 22.sp,
                  fontWeight: FontWeight.w700,
                  color: colors.textOnButton,
                ) ??
                TextStyle(
                  fontSize: 22.sp,
                  fontWeight: FontWeight.w700,
                  color: colors.textOnButton,
                  fontFamily: 'Poppins',
                ),
          ),
          SizedBox(height: 12.h),

          // Info rows
          _buildInfoRow(Icons.person_outline, pengampu, colors, textTheme),
          SizedBox(height: 6.h),
          _buildInfoRow(Icons.flag_outlined, target, colors, textTheme),
          SizedBox(height: 6.h),
          _buildInfoRow(Icons.groups_outlined, totalSantri, colors, textTheme),
        ],
      ),
    );
  }

  Widget _buildBadge(String text, AppColorSet colors, TextTheme textTheme) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: colors.textOnButton.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Text(
        text,
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
    );
  }

  Widget _buildInfoRow(
    IconData icon,
    String text,
    AppColorSet colors,
    TextTheme textTheme,
  ) {
    return Row(
      children: [
        Icon(
          icon,
          size: 16.sp,
          color: colors.textOnButton.withValues(alpha: 0.8),
        ),
        SizedBox(width: 8.w),
        Expanded(
          child: Text(
            text,
            style: textTheme.bodySmall?.copyWith(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w400,
                  color: colors.textOnButton.withValues(alpha: 0.9),
                ) ??
                TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w400,
                  color: colors.textOnButton.withValues(alpha: 0.9),
                  fontFamily: 'Poppins',
                ),
          ),
        ),
      ],
    );
  }
}
