import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_halaqoh/gen/i18n/translations.g.dart';
import 'package:my_halaqoh/src/core/router/app_router.dart';
import 'package:my_halaqoh/src/core/theme/app_colors.dart';
import 'package:my_halaqoh/src/core/widget/dialog/confirm_logout_dialog.dart';
import 'package:my_halaqoh/src/modules/auth/presentation/cubits/auth_cubit.dart';

@RoutePage()
class PengaturanMasterDataScreen extends StatelessWidget {
  const PengaturanMasterDataScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        backgroundColor: colors.background,
        elevation: 0,
        scrolledUnderElevation: 0,
        iconTheme: IconThemeData(color: colors.textPrimary),
        title: Text(
          t.masterDataSettings.title,
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.w700,
            color: colors.textPrimary,
            fontFamily: 'Poppins',
          ),
        ),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        child: Column(
          children: [
            SizedBox(height: 16.h),

            // Card 1 — Pengaturan & Tentang Aplikasi
            _buildMenuCard(
              colors,
              items: [
                _MenuItem(
                  icon: Icons.settings,
                  label: t.masterDataSettings.title, // "Pengaturan"
                  onTap: () {
                    context.router.push(const PengaturanRoute());
                  },
                ),
                _MenuItem(
                  icon: Icons.info_outline,
                  label: t.masterDataSettings.tentangAplikasi,
                  onTap: () {
                    // TODO: Navigate to Tentang Aplikasi
                  },
                ),
              ],
            ),
            SizedBox(height: 14.h),

            // Logout card
            _buildLogoutCard(colors, context),
            SizedBox(height: 16.h),

            // Version text
            Text(
              t.masterDataSettings.appVersion,
              style: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.w400,
                color: colors.textSecondary.withValues(alpha: 0.6),
                fontFamily: 'Poppins',
              ),
            ),
            SizedBox(height: 100.h), // space for bottom nav
          ],
        ),
      ),
    );
  }

  /// Rounded card containing menu items with dividers between them
  Widget _buildMenuCard(AppColorSet colors, {required List<_MenuItem> items}) {
    return Container(
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          for (int i = 0; i < items.length; i++) ...[
            _buildMenuItem(items[i], colors),
            if (i < items.length - 1)
              Divider(
                height: 1,
                indent: 60.w,
                endIndent: 20.w,
                color: colors.border.withValues(alpha: 0.5),
              ),
          ],
        ],
      ),
    );
  }

  Widget _buildMenuItem(_MenuItem item, AppColorSet colors) {
    return InkWell(
      onTap: item.onTap,
      borderRadius: BorderRadius.circular(16.r),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 16.h),
        child: Row(
          children: [
            // Icon circle
            Container(
              width: 40.w,
              height: 40.w,
              decoration: BoxDecoration(
                color: colors.primary.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(item.icon, size: 20.sp, color: colors.primary),
            ),
            SizedBox(width: 14.w),

            // Label
            Expanded(
              child: Text(
                item.label,
                style: TextStyle(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w500,
                  color: colors.textPrimary,
                  fontFamily: 'Poppins',
                ),
              ),
            ),

            // Chevron
            Icon(Icons.chevron_right, size: 22.sp, color: colors.primary),
          ],
        ),
      ),
    );
  }

  /// Logout card
  Widget _buildLogoutCard(AppColorSet colors, BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: InkWell(
        onTap: () async {
          final confirmed = await ConfirmLogoutDialog.show(context);
          if (confirmed && context.mounted) {
            await context.read<AuthCubit>().logout();
            if (context.mounted) {
              context.router.replaceAll([const LoginRoute()]);
            }
          }
        },
        borderRadius: BorderRadius.circular(16.r),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 16.h),
          child: Row(
            children: [
              // Red icon circle
              Container(
                width: 40.w,
                height: 40.w,
                decoration: BoxDecoration(
                  color: colors.error.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.logout, size: 20.sp, color: colors.error),
              ),
              SizedBox(width: 14.w),

              // Label
              Expanded(
                child: Text(
                  t.masterDataSettings.keluar,
                  style: TextStyle(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w600,
                    color: colors.error,
                    fontFamily: 'Poppins',
                  ),
                ),
              ),

              // Chevron
              Icon(Icons.chevron_right, size: 22.sp, color: colors.error),
            ],
          ),
        ),
      ),
    );
  }
}

class _MenuItem {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  _MenuItem({required this.icon, required this.label, required this.onTap});
}
