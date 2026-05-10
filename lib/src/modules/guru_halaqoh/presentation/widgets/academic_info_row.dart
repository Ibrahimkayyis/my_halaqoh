import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_halaqoh/src/core/theme/app_colors.dart';

/// A single row in the academic info card — icon, label, value
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

    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
          // Tambahkan crossAxisAlignment agar jika value sampai 2 baris,
          // icon dan label tetap berada di posisi atas (rapi)
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Icon box
              Container(
                width: 40.w,
                height: 40.w,
                decoration: BoxDecoration(
                  color: iconBgColor,
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Icon(icon, size: 20.sp, color: iconColor),
              ),
              SizedBox(width: 14.w),

              // Label — Dibiarkan mengambil lebar aslinya agar selalu 1 baris
              // dan tidak akan pernah terpotong
              Padding(
                // Sedikit padding top agar text sejajar dengan tengah-tengah icon
                padding: EdgeInsets.only(top: 8.h),
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w400,
                    color: colors.textSecondary,
                    fontFamily: 'Poppins',
                  ),
                ),
              ),

              // Jarak aman antara label dan value
              SizedBox(width: 16.w),

              // Value — Mengambil sisa ruang.
              // Jika terlalu panjang, otomatis akan turun ke baris ke-2 tanpa terpotong
              Expanded(
                child: Padding(
                  // Sedikit padding top agar sejajar dengan label
                  padding: EdgeInsets.only(top: 8.h),
                  child: Text(
                    value,
                    textAlign: TextAlign.end,
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: colors.textPrimary,
                      fontFamily: 'Poppins',
                    ),
                  ),
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
            indent: 16.w,
            endIndent: 16.w,
          ),
      ],
    );
  }
}
