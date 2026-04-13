import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_halaqoh/src/core/theme/app_colors.dart';

/// Santri list item for absensi screen — avatar, name, NIS, and RIWAYAT ABSENSI button
class AbsensiSantriItem extends StatelessWidget {
  final String name;
  final String nis;
  final String riwayatLabel;
  final VoidCallback? onRiwayatTap;

  const AbsensiSantriItem({
    super.key,
    required this.name,
    required this.nis,
    required this.riwayatLabel,
    this.onRiwayatTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
      margin: EdgeInsets.only(bottom: 10.h),
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
          SizedBox(width: 12.w),

          // Name, NIS, and button — stacked vertically, takes remaining width
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Name — full width, wraps naturally
                Text(
                  name,
                  softWrap: true,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: colors.primary,
                    fontFamily: 'Poppins',
                    height: 1.3,
                  ),
                ),
                SizedBox(height: 2.h),

                // NIS
                Text(
                  nis,
                  style: TextStyle(
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w400,
                    color: colors.textSecondary,
                    fontFamily: 'Poppins',
                  ),
                ),
                SizedBox(height: 8.h),

                // Riwayat Absensi button — aligned to left
                GestureDetector(
                  onTap: onRiwayatTap,
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 10.w,
                      vertical: 6.h,
                    ),
                    decoration: BoxDecoration(
                      color: colors.primary.withValues(alpha: 0.05),
                      borderRadius: BorderRadius.circular(8.r),
                      border: Border.all(
                        color: colors.primary.withValues(alpha: 0.2),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.calendar_today,
                          size: 12.sp,
                          color: colors.primary,
                        ),
                        SizedBox(width: 4.w),
                        Text(
                          riwayatLabel,
                          style: TextStyle(
                            fontSize: 10.sp,
                            fontWeight: FontWeight.w600,
                            color: colors.primary,
                            fontFamily: 'Poppins',
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
