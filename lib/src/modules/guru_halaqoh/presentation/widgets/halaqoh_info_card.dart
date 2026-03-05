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

    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 24.w),
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            colors.primary,
            colors.primary.withValues(alpha: 0.82),
          ],
        ),
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Badges row
          Row(
            children: [
              _buildBadge(kelas, colors),
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
                style: TextStyle(
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
            style: TextStyle(
              fontSize: 22.sp,
              fontWeight: FontWeight.w700,
              color: colors.textOnButton,
              fontFamily: 'Poppins',
            ),
          ),
          SizedBox(height: 10.h),

          // Info rows
          _buildInfoRow(Icons.person_outline, pengampu, colors),
          SizedBox(height: 6.h),
          _buildInfoRow(Icons.flag_outlined, target, colors),
          SizedBox(height: 6.h),
          _buildInfoRow(Icons.groups_outlined, totalSantri, colors),
        ],
      ),
    );
  }

  Widget _buildBadge(String text, AppColorSet colors) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: colors.textOnButton.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 11.sp,
          fontWeight: FontWeight.w600,
          color: colors.textOnButton,
          fontFamily: 'Poppins',
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text, AppColorSet colors) {
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
            style: TextStyle(
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
