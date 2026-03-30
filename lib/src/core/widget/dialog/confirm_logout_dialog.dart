import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_halaqoh/gen/i18n/translations.g.dart';
import 'package:my_halaqoh/src/core/theme/app_colors.dart';

class ConfirmLogoutDialog extends StatelessWidget {
  const ConfirmLogoutDialog({super.key});

  /// Displays the logout confirmation dialog with a fade and scale animation.
  /// Returns [true] if user taps "Keluar", otherwise [false].
  static Future<bool> show(BuildContext context) async {
    final result = await showGeneralDialog<bool>(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Dismiss',
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (ctx, anim1, anim2) => const ConfirmLogoutDialog(),
      transitionBuilder: (ctx, anim1, anim2, child) {
        return FadeTransition(
          opacity: anim1,
          child: ScaleTransition(
            scale: Tween<double>(begin: 0.95, end: 1.0).animate(
              CurvedAnimation(parent: anim1, curve: Curves.easeOutBack),
            ),
            child: child,
          ),
        );
      },
    );
    return result ?? false;
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Center(
        child: Container(
          width: 0.85.sw,
          margin: EdgeInsets.symmetric(horizontal: 24.w),
          padding: EdgeInsets.fromLTRB(20.w, 24.h, 20.w, 20.h),
          decoration: BoxDecoration(
            color: colors.surface,
            borderRadius: BorderRadius.circular(24.r),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Icon Circle
              Container(
                width: 64.w,
                height: 64.w,
                decoration: BoxDecoration(
                  color: colors.error.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Icon(Icons.logout, color: colors.error, size: 32.sp),
                ),
              ),
              SizedBox(height: 20.h),

              // Title
              Text(
                t.dialogs.logoutTitle,
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w700,
                  color: colors.textPrimary,
                  fontFamily: 'Poppins',
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 12.h),

              // Message
              Text(
                t.dialogs.logoutMessage,
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w400,
                  color: colors.textSecondary,
                  fontFamily: 'Poppins',
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 28.h),

              // Buttons horizontal layout
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.of(context).pop(false),
                      style: OutlinedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 12.h),
                        side: BorderSide(color: colors.border),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                      ),
                      child: Text(
                        t.dialogs.batal,
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                          color: colors.textPrimary,
                          fontFamily: 'Poppins',
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => Navigator.of(context).pop(true),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: colors.error,
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(vertical: 12.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        elevation: 0,
                      ),
                      child: Text(
                        t.dialogs.keluar,
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                          fontFamily: 'Poppins',
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
