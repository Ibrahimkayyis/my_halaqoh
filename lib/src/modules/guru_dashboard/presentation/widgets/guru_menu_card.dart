import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_halaqoh/src/core/theme/app_colors.dart';

/// Menu card for guru dashboard — icon + label side by side
class GuruMenuCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color? iconColor;
  final Color? iconBgColor;
  final VoidCallback? onTap;

  const GuruMenuCard({
    super.key,
    required this.icon,
    required this.label,
    this.iconColor,
    this.iconBgColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final iColor = iconColor ?? colors.primary;
    final iBgColor = iconBgColor ?? colors.primary.withValues(alpha: 0.1);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: BorderRadius.circular(14.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            // Icon container
            Container(
              width: 40.w,
              height: 40.w,
              decoration: BoxDecoration(
                color: iBgColor,
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Icon(
                icon,
                size: 22.sp,
                color: iColor,
              ),
            ),
            SizedBox(width: 12.w),
            // Label
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w600,
                  color: colors.textPrimary,
                  fontFamily: 'Poppins',
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
