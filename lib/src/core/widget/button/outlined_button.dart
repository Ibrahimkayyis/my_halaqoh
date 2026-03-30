import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_halaqoh/src/core/theme/app_colors.dart';

/// Global reusable outlined button.
///
/// Usage:
/// ```dart
/// CustomOutlinedButton(
///   width: double.infinity,
///   height: 48.h,
///   onPressed: () {},
///   icon: Icons.download,
///   label: 'Download Laporan',
/// )
/// ```
class CustomOutlinedButton extends StatelessWidget {
  final double? width;
  final double? height;
  final VoidCallback? onPressed;
  final String label;
  final IconData? icon;
  final double? borderRadius;
  final Color? borderColor;
  final Color? labelColor;

  const CustomOutlinedButton({
    super.key,
    this.width,
    this.height,
    required this.onPressed,
    required this.label,
    this.icon,
    this.borderRadius,
    this.borderColor,
    this.labelColor,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final effectiveBorderColor = borderColor ?? colors.primary;
    final effectiveLabelColor = labelColor ?? colors.primary;

    return SizedBox(
      width: width,
      height: height,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: effectiveBorderColor, width: 1.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius ?? 12.r),
          ),
          backgroundColor: colors.surface,
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 0),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(icon, size: 20.sp, color: effectiveLabelColor),
              SizedBox(width: 8.w),
            ],
            // Flexible prevents overflow when label text is long
            Flexible(
              child: Text(
                label,
                maxLines: 2,
                overflow: TextOverflow.visible,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w700,
                  color: effectiveLabelColor,
                  fontFamily: 'Poppins',
                  letterSpacing: 0.5,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}