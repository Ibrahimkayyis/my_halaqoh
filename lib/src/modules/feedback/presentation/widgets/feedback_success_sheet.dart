import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_halaqoh/gen/i18n/translations.g.dart';
import 'package:my_halaqoh/src/core/theme/app_colors.dart';
import 'package:my_halaqoh/src/core/widget/button/primary_button.dart';

/// Modal bottom sheet displayed upon successful submission of feedback.
class FeedbackSuccessSheet extends StatelessWidget {
  const FeedbackSuccessSheet({super.key});

  /// Static helper to display the sheet.
  static Future<void> show(BuildContext context) {
    return showModalBottomSheet<void>(
      context: context,
      isDismissible: false,
      enableDrag: false,
      backgroundColor: Colors.transparent,
      builder: (_) => const FeedbackSuccessSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final fb = t.feedback;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 28.h),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 64.w,
              height: 64.w,
              decoration: BoxDecoration(
                color: colors.green.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.check_circle_rounded,
                color: colors.green,
                size: 40.sp,
              ),
            ),
            SizedBox(height: 16.h),
            Text(
              fb.successTitle,
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.w700,
                color: colors.textPrimary,
                fontFamily: 'Poppins',
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              fb.successMessage,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13.sp,
                color: colors.textSecondary,
                fontFamily: 'Poppins',
                height: 1.6,
              ),
            ),
            SizedBox(height: 24.h),
            PrimaryButton(
              label: fb.kembali,
              onPressed: () {
                Navigator.of(context).pop(); // Pop sheet
                Navigator.of(context).pop(); // Pop feedback screen
              },
            ),
          ],
        ),
      ),
    );
  }
}
