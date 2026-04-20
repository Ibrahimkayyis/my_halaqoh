import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_halaqoh/src/core/router/app_router.dart';
import 'package:my_halaqoh/src/core/theme/app_colors.dart';

/// Screen shown when a user tries to access a route they don't have
/// permission for.
@RoutePage()
class AccessDeniedScreen extends StatelessWidget {
  final String attemptedRole;
  final List<String> requiredRoles;

  const AccessDeniedScreen({
    super.key,
    required this.attemptedRole,
    required this.requiredRoles,
  });

  String _roleLabel(String role) {
    switch (role) {
      case 'admin':
        return 'Admin';
      case 'guru':
        return 'Guru';
      case 'santri':
        return 'Wali Santri';
      default:
        return role;
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);

    return Scaffold(
      backgroundColor: colors.background,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 32.w),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // ── Icon ──
                Container(
                  width: 100.w,
                  height: 100.w,
                  decoration: BoxDecoration(
                    color: colors.red.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.lock_outline_rounded,
                    size: 48.sp,
                    color: colors.red,
                  ),
                ),
                SizedBox(height: 24.h),

                // ── Title ──
                Text(
                  'Akses Ditolak',
                  style: TextStyle(
                    fontSize: 22.sp,
                    fontWeight: FontWeight.w700,
                    color: colors.textPrimary,
                    fontFamily: 'Poppins',
                  ),
                ),
                SizedBox(height: 12.h),

                // ── Description ──
                Text(
                  'Anda tidak memiliki izin untuk mengakses halaman ini.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: colors.textSecondary,
                    fontFamily: 'Poppins',
                    height: 1.5,
                  ),
                ),
                SizedBox(height: 8.h),

                // ── Role info ──
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 12.h,
                  ),
                  decoration: BoxDecoration(
                    color: colors.surface,
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(
                      color: colors.border.withValues(alpha: 0.5),
                    ),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.person_outline,
                            size: 16.sp,
                            color: colors.textSecondary,
                          ),
                          SizedBox(width: 6.w),
                          Text(
                            'Role Anda: ',
                            style: TextStyle(
                              fontSize: 13.sp,
                              color: colors.textSecondary,
                              fontFamily: 'Poppins',
                            ),
                          ),
                          Text(
                            _roleLabel(attemptedRole),
                            style: TextStyle(
                              fontSize: 13.sp,
                              fontWeight: FontWeight.w600,
                              color: colors.primary,
                              fontFamily: 'Poppins',
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 6.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.shield_outlined,
                            size: 16.sp,
                            color: colors.textSecondary,
                          ),
                          SizedBox(width: 6.w),
                          Text(
                            'Diperlukan: ',
                            style: TextStyle(
                              fontSize: 13.sp,
                              color: colors.textSecondary,
                              fontFamily: 'Poppins',
                            ),
                          ),
                          Text(
                            requiredRoles.map(_roleLabel).join(', '),
                            style: TextStyle(
                              fontSize: 13.sp,
                              fontWeight: FontWeight.w600,
                              color: colors.red,
                              fontFamily: 'Poppins',
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 32.h),

                // ── Back button ──
                SizedBox(
                  width: double.infinity,
                  height: 50.h,
                  child: ElevatedButton(
                    onPressed: () {
                      if (Navigator.of(context).canPop()) {
                        Navigator.of(context).pop();
                      } else {
                        context.router.replaceAll([const LoginRoute()]);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colors.primary,
                      foregroundColor: colors.textOnButton,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25.r),
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      'Kembali',
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Poppins',
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
