import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_halaqoh/gen/i18n/translations.g.dart';
import 'package:my_halaqoh/src/core/router/app_router.dart';
import 'package:my_halaqoh/src/core/theme/app_colors.dart';
import 'package:my_halaqoh/src/core/widget/dialog/confirm_logout_dialog.dart';

/// Profile screen for Guru role — avatar, name, role badge, menu items, logout
class GuruProfileScreen extends StatelessWidget {
  const GuruProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);

    return Scaffold(
      backgroundColor: colors.background,
      body: Column(
        children: [
          // ── Green header with avatar + name + role badge ──
          _buildHeader(colors),

          // ── Menu sections ──
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: Column(
                children: [
                  SizedBox(height: 24.h),

                  // Card 1 — Edit Profile & Ubah Password
                  _buildMenuCard(
                    colors,
                    items: [
                      _MenuItem(
                        icon: Icons.person,
                        label: t.guruProfile.editProfile,
                        onTap: () {
                          context.router.push(const EditProfileRoute());
                        },
                      ),
                      _MenuItem(
                        icon: Icons.lock,
                        label: t.guruProfile.ubahPassword,
                        onTap: () {
                          context.router.push(const UbahPasswordRoute());
                        },
                      ),
                    ],
                  ),
                  SizedBox(height: 14.h),

                  // Card 2 — Pengaturan & Tentang Aplikasi
                  _buildMenuCard(
                    colors,
                    items: [
                      _MenuItem(
                        icon: Icons.settings,
                        label: t.guruProfile.pengaturan,
                        onTap: () {
                          context.router.push(const PengaturanRoute());
                        },
                      ),
                      _MenuItem(
                        icon: Icons.info_outline,
                        label: t.guruProfile.tentangAplikasi,
                        onTap: () {
                          // TODO: Navigate to Tentang Aplikasi
                        },
                      ),
                    ],
                  ),
                  SizedBox(height: 14.h),

                  // Logout button
                  _buildLogoutCard(colors, context),
                  SizedBox(height: 16.h),

                  // Version text
                  Text(
                    t.guruProfile.appVersion(version: '1.2.0'),
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
          ),
        ],
      ),
    );
  }

  /// Green gradient header with avatar, name, and "Guru Halaqoh" badge
  Widget _buildHeader(AppColorSet colors) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [colors.primary, colors.primary.withValues(alpha: 0.85)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(32.r),
          bottomRight: Radius.circular(32.r),
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: EdgeInsets.only(top: 24.h, bottom: 32.h),
          child: Column(
            children: [
              // Avatar circle
              Container(
                width: 100.w,
                height: 100.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withValues(alpha: 0.2),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.5),
                    width: 3,
                  ),
                ),
                child: Icon(Icons.person, size: 52.sp, color: Colors.white),
              ),
              SizedBox(height: 14.h),

              // Name
              Text(
                'Ustadz Kayyis', // Dummy name
                style: TextStyle(
                  fontSize: 22.sp,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                  fontFamily: 'Poppins',
                ),
              ),
              SizedBox(height: 6.h),

              // Role badge
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 5.h),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: Text(
                  t.guruProfile.guruHalaqoh,
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                    fontFamily: 'Poppins',
                  ),
                ),
              ),
            ],
          ),
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
            context.router.replaceAll([const LoginRoute()]);
          }
        },
        borderRadius: BorderRadius.circular(16.r),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 16.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.logout, size: 20.sp, color: Colors.redAccent),
              SizedBox(width: 8.w),
              Text(
                t.guruProfile.keluar,
                style: TextStyle(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.redAccent,
                  fontFamily: 'Poppins',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Helper model for menu items
class _MenuItem {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _MenuItem({
    required this.icon,
    required this.label,
    required this.onTap,
  });
}
