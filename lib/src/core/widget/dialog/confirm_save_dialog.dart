import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_halaqoh/gen/i18n/translations.g.dart';
import 'package:my_halaqoh/src/core/theme/app_colors.dart';

/// Global reusable save confirmation dialog.
///
/// Usage:
/// ```dart
/// final confirmed = await ConfirmSaveDialog.show(context);
/// if (confirmed) { // save the data }
///
/// // Or with custom texts:
/// final confirmed = await ConfirmSaveDialog.show(
///   context,
///   title: 'Simpan Hafalan?',
///   message: 'Data hafalan akan disimpan.',
/// );
/// ```
class ConfirmSaveDialog extends StatelessWidget {
  final String? title;
  final String? message;
  final String? cancelLabel;
  final String? confirmLabel;

  const ConfirmSaveDialog({
    super.key,
    this.title,
    this.message,
    this.cancelLabel,
    this.confirmLabel,
  });

  /// Show the save confirmation dialog.
  /// Returns `true` if user confirms, `false` otherwise.
  static Future<bool> show(
    BuildContext context, {
    String? title,
    String? message,
    String? cancelLabel,
    String? confirmLabel,
  }) async {
    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (_) => ConfirmSaveDialog(
        title: title,
        message: message,
        cancelLabel: cancelLabel,
        confirmLabel: confirmLabel,
      ),
    );
    return result ?? false;
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);

    return Dialog(
      backgroundColor: colors.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24.r)),
      insetPadding: EdgeInsets.symmetric(horizontal: 40.w),
      child: Padding(
        padding: EdgeInsets.fromLTRB(24.w, 28.h, 24.w, 20.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // ── Green circle icon ──
            Container(
              width: 64.w,
              height: 64.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: colors.primary.withValues(alpha: 0.1),
              ),
              child: Icon(Icons.check, size: 32.sp, color: colors.primary),
            ),
            SizedBox(height: 20.h),

            // ── Title ──
            Text(
              title ?? t.dialogs.saveTitle,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.w700,
                color: colors.textPrimary,
                fontFamily: 'Poppins',
              ),
            ),
            SizedBox(height: 10.h),

            // ── Message ──
            Text(
              message ?? t.dialogs.saveMessage,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13.sp,
                fontWeight: FontWeight.w400,
                color: colors.textSecondary,
                fontFamily: 'Poppins',
                height: 1.5,
              ),
            ),
            SizedBox(height: 24.h),

            // ── Buttons ──
            Row(
              children: [
                // Cancel button
                Expanded(
                  child: SizedBox(
                    height: 48.h,
                    child: OutlinedButton(
                      onPressed: () => Navigator.of(context).pop(false),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: colors.textPrimary,
                        side: BorderSide(color: colors.border, width: 1.5),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14.r),
                        ),
                      ),
                      child: Text(
                        cancelLabel ?? t.dialogs.batal,
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Poppins',
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 12.w),

                // Save button
                Expanded(
                  child: SizedBox(
                    height: 48.h,
                    child: ElevatedButton(
                      onPressed: () => Navigator.of(context).pop(true),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: colors.primary,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14.r),
                        ),
                      ),
                      child: Text(
                        confirmLabel ?? t.dialogs.simpan,
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w700,
                          fontFamily: 'Poppins',
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
