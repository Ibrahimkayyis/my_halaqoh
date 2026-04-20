import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_halaqoh/src/core/theme/app_colors.dart';

/// A global reusable Primary Button (ElevatedButton)
/// Default background is [AppColors.primary] (green), text is [AppColors.textOnButton] (white).
class PrimaryButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String label;

  /// Optional icon to display before the text
  final IconData? icon;

  /// By default false. If true, shows a CircularProgressIndicator instead of the label
  final bool isLoading;

  /// Optional custom width. If null, it can expand entirely inside a SizedBox
  final double? width;

  /// Defaults to 50.h minimum
  final double? height;

  /// Custom border radius. Defaults to 14.r
  final double? borderRadius;

  const PrimaryButton({
    super.key,
    required this.onPressed,
    required this.label,
    this.icon,
    this.isLoading = false,
    this.width,
    this.height,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final themeBgColor = colors.primary;
    final themeFgColor = colors.textOnButton;

    Widget childContent;
    if (isLoading) {
      childContent = SizedBox(
        width: 24.w,
        height: 24.w,
        child: CircularProgressIndicator(color: themeFgColor, strokeWidth: 2.5),
      );
    } else {
      childContent = Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (icon != null) ...[Icon(icon, size: 22.sp), SizedBox(width: 8.w)],
          Flexible(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w700,
                fontFamily: 'Poppins',
                letterSpacing: 0.5,
                height: 1.2, // Spasi antar baris
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              softWrap: true,
            ),
          ),
        ],
      );
    }

    Widget button = DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius ?? 14.r),
        boxShadow: onPressed == null || isLoading
            ? []
            : [
                BoxShadow(
                  color: themeBgColor.withValues(alpha: 0.3),
                  blurRadius: 15,
                  offset: const Offset(0, 8),
                ),
              ],
      ),
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: themeBgColor,
          foregroundColor: themeFgColor,
          disabledBackgroundColor: themeBgColor.withValues(alpha: 0.5),
          disabledForegroundColor: themeFgColor.withValues(alpha: 0.8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius ?? 14.r),
          ),
          elevation: 0,
          // Tambahkan padding vertikal agar teks punya ruang bernapas di atas/bawah
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        ),
        child: childContent,
      ),
    );

    // FIX APPLIED HERE: Menggunakan ConstrainedBox alih-alih SizedBox
    return ConstrainedBox(
      constraints: BoxConstraints(
        minWidth: width ?? 0,
        maxWidth: width ?? double.infinity,
        minHeight:
            height ??
            50.h, // Tombol minimal 50.h, tapi BISA lebih tinggi jika teks 2 baris
      ),
      child: button,
    );
  }
}
