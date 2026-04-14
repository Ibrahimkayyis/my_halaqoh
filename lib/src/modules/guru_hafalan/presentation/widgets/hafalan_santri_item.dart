import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_halaqoh/src/core/theme/app_colors.dart';

/// Santri list item for hafalan screen — avatar, name, NIS, Riwayat Hafalan and Input Hafalan buttons
class HafalanSantriItem extends StatelessWidget {
  final String name;
  final String nis;
  final String riwayatLabel;
  final String inputLabel;
  final String? targetInfo;
  final VoidCallback? onRiwayatTap;
  final VoidCallback? onInputTap;

  const HafalanSantriItem({
    super.key,
    required this.name,
    required this.nis,
    required this.riwayatLabel,
    required this.inputLabel,
    this.targetInfo,
    this.onRiwayatTap,
    this.onInputTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
      margin: EdgeInsets.only(bottom: 12.h),
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
      child: Column(
        children: [
          // Top row: avatar + name/NIS
          Row(
            children: [
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
                child: Icon(
                  Icons.person,
                  size: 22.sp,
                  color: colors.primary,
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: TextStyle(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w700,
                        color: colors.textPrimary,
                        fontFamily: 'Poppins',
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      'NIS: $nis',
                      style: TextStyle(
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w400,
                        color: colors.textSecondary,
                        fontFamily: 'Poppins',
                      ),
                    ),
                    if (targetInfo != null && targetInfo!.isNotEmpty) ...[
                      SizedBox(height: 2.h),
                      Text(
                        targetInfo!,
                        style: TextStyle(
                          fontSize: 11.sp,
                          fontWeight: FontWeight.w500,
                          color: colors.primary.withValues(alpha: 0.8),
                          fontFamily: 'Poppins',
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),

          // Bottom row: two buttons — keduanya punya border 1.5 agar tinggi sama
          Row(
            children: [
              // Riwayat Hafalan (outlined)
              Expanded(
                child: GestureDetector(
                  onTap: onRiwayatTap,
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 10.h),
                    decoration: BoxDecoration(
                      color: colors.surface,
                      borderRadius: BorderRadius.circular(10.r),
                      border: Border.all(
                        color: colors.primary,
                        width: 1.5,
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.history,
                          size: 14.sp,
                          color: colors.primary,
                        ),
                        SizedBox(width: 6.w),
                        Text(
                          riwayatLabel,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w600,
                            color: colors.primary,
                            fontFamily: 'Poppins',
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(width: 10.w),

              // Input Hafalan (filled) — transparent border agar tinggi sama
              Expanded(
                child: GestureDetector(
                  onTap: onInputTap,
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 10.h),
                    decoration: BoxDecoration(
                      color: colors.primary,
                      borderRadius: BorderRadius.circular(10.r),
                      border: Border.all(
                        color: Colors.transparent,
                        width: 1.5,
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.edit_note,
                          size: 14.sp,
                          color: colors.textOnButton,
                        ),
                        SizedBox(width: 6.w),
                        Text(
                          inputLabel,
                          style: TextStyle(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w600,
                            color: colors.textOnButton,
                            fontFamily: 'Poppins',
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}