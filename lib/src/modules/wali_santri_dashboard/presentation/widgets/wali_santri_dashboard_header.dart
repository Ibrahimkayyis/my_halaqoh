import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_halaqoh/gen/i18n/translations.g.dart';
import 'package:my_halaqoh/src/core/router/app_router.dart';
import 'package:my_halaqoh/src/core/theme/app_colors.dart';
import 'package:my_halaqoh/src/core/widget/dialog/confirm_logout_dialog.dart';
import 'package:my_halaqoh/src/modules/auth/presentation/cubits/auth_cubit.dart';

/// Wali Santri dashboard header featuring a brand logo + title on top left,
/// logout button on top right, and an Islamic hero card with SVG mosque silhouette decoration.
class WaliSantriDashboardHeader extends StatelessWidget {
  final String santriName;
  final String nis;
  final String halaqohInfo;
  final String? guruName;
  final String? profilePictureUrl;

  const WaliSantriDashboardHeader({
    super.key,
    required this.santriName,
    required this.nis,
    required this.halaqohInfo,
    this.guruName,
    this.profilePictureUrl,
  });

  /// Extracts 1 or 2 letter initials from full name.
  String _getInitials(String fullName) {
    final clean = fullName.trim();
    if (clean.isEmpty) return 'S';
    final parts = clean.split(RegExp(r'\s+'));
    if (parts.length == 1) {
      return parts[0].substring(0, parts[0].length >= 2 ? 2 : 1).toUpperCase();
    }
    return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final textTheme = Theme.of(context).textTheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final hasPhoto = profilePictureUrl != null && profilePictureUrl!.isNotEmpty;

    return Padding(
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 12.h,
        left: 20.w,
        right: 20.w,
        bottom: 4.h,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Top Row: Brand Logo (Left) & Logout Button (Right) ────────
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Logo image + Text brand
              Row(
                children: [
                  Image.asset(
                    'assets/images/my_halaqoh_logo_new.png',
                    width: 26.w,
                    height: 26.w,
                    fit: BoxFit.contain,
                  ),
                  SizedBox(width: 8.w),
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: 'My',
                          style: textTheme.titleMedium?.copyWith(
                                fontSize: 17.sp,
                                fontWeight: FontWeight.w800,
                                color: colors.primary,
                                letterSpacing: -0.3,
                              ) ??
                              TextStyle(
                                fontSize: 17.sp,
                                fontWeight: FontWeight.w800,
                                color: colors.primary,
                                fontFamily: 'Poppins',
                              ),
                        ),
                        TextSpan(
                          text: 'Halaqoh',
                          style: textTheme.titleMedium?.copyWith(
                                fontSize: 17.sp,
                                fontWeight: FontWeight.w800,
                                color: colors.textPrimary,
                                letterSpacing: -0.3,
                              ) ??
                              TextStyle(
                                fontSize: 17.sp,
                                fontWeight: FontWeight.w800,
                                color: colors.textPrimary,
                                fontFamily: 'Poppins',
                              ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              // Logout Button in rounded square container
              Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () async {
                    final confirmed = await ConfirmLogoutDialog.show(context);
                    if (confirmed && context.mounted) {
                      final authCubit = context.read<AuthCubit>();
                      context.router.replaceAll([const LoginRoute()]);
                      await authCubit.logout();
                    }
                  },
                  borderRadius: BorderRadius.circular(12.r),
                  child: Container(
                    padding: EdgeInsets.all(8.w),
                    decoration: BoxDecoration(
                      color: colors.surface,
                      borderRadius: BorderRadius.circular(12.r),
                      border: Border.all(
                        color: isDark
                            ? colors.border
                            : colors.border.withValues(alpha: 0.8),
                        width: 0.8,
                      ),
                      boxShadow: isDark
                          ? []
                          : [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.03),
                                blurRadius: 6,
                                offset: const Offset(0, 2),
                              ),
                            ],
                    ),
                    child: Icon(
                      Icons.logout_rounded,
                      size: 18.sp,
                      color: Colors.redAccent,
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 14.h),

          // ── Islamic Hero Card: Mosque Silhouette SVG + Santri Info ────
          Container(
            width: double.infinity,
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              gradient: colors.primaryGradient,
              borderRadius: BorderRadius.circular(20.r),
              boxShadow: [
                BoxShadow(
                  color: colors.primary.withValues(alpha: 0.28),
                  blurRadius: 16,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Stack(
              children: [
                // Mosque Silhouette PNG Decoration across card background
                Positioned.fill(
                  child: IgnorePointer(
                    child: Opacity(
                      opacity: 0.16,
                      child: Image.asset(
                        'assets/images/Mosque-Silhouette.png',
                        fit: BoxFit.cover,
                        alignment: Alignment.bottomRight,
                      ),
                    ),
                  ),
                ),

                // Foreground Content
                Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: 20.h,
                    horizontal: 18.w,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Top Row: Avatar + Name + NIS
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // Circular Avatar
                          Container(
                            width: 52.w,
                            height: 52.w,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: colors.textOnButton.withValues(alpha: 0.2),
                              border: Border.all(
                                color: colors.textOnButton.withValues(alpha: 0.6),
                                width: 2.2,
                              ),
                              image: hasPhoto
                                  ? DecorationImage(
                                      image: NetworkImage(profilePictureUrl!),
                                      fit: BoxFit.cover,
                                    )
                                  : null,
                            ),
                            alignment: Alignment.center,
                            child: hasPhoto
                                ? null
                                : Text(
                                    _getInitials(santriName),
                                    style: textTheme.titleMedium?.copyWith(
                                          fontSize: 18.sp,
                                          fontWeight: FontWeight.w700,
                                          color: colors.textOnButton,
                                        ) ??
                                        TextStyle(
                                          fontSize: 18.sp,
                                          fontWeight: FontWeight.w700,
                                          color: colors.textOnButton,
                                          fontFamily: 'Poppins',
                                        ),
                                  ),
                          ),
                          SizedBox(width: 14.w),

                          // Text Column
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  'Assalamu\'alaikum,',
                                  style: textTheme.bodySmall?.copyWith(
                                        fontSize: 12.sp,
                                        fontWeight: FontWeight.w400,
                                        color: colors.textOnButton
                                            .withValues(alpha: 0.85),
                                      ) ??
                                      TextStyle(
                                        fontSize: 12.sp,
                                        fontWeight: FontWeight.w400,
                                        color: colors.textOnButton
                                            .withValues(alpha: 0.85),
                                        fontFamily: 'Poppins',
                                      ),
                                ),
                                SizedBox(height: 2.h),
                                Text(
                                  santriName.toUpperCase(),
                                  style: textTheme.titleLarge?.copyWith(
                                        fontSize: 17.sp,
                                        fontWeight: FontWeight.w800,
                                        color: colors.textOnButton,
                                        letterSpacing: 0.2,
                                        height: 1.2,
                                      ) ??
                                      TextStyle(
                                        fontSize: 17.sp,
                                        fontWeight: FontWeight.w800,
                                        color: colors.textOnButton,
                                        letterSpacing: 0.2,
                                        fontFamily: 'Poppins',
                                        height: 1.2,
                                      ),
                                  maxLines: 2,
                                ),
                                if (nis.isNotEmpty) ...[
                                  SizedBox(height: 4.h),
                                  Text(
                                    t.waliSantriDashboard.nis(nis: nis),
                                    style: textTheme.bodySmall?.copyWith(
                                          fontSize: 11.5.sp,
                                          fontWeight: FontWeight.w500,
                                          color: colors.textOnButton
                                              .withValues(alpha: 0.9),
                                        ) ??
                                        TextStyle(
                                          fontSize: 11.5.sp,
                                          fontWeight: FontWeight.w500,
                                          color: colors.textOnButton
                                              .withValues(alpha: 0.9),
                                          fontFamily: 'Poppins',
                                        ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ],
                      ),

                      // Bottom Halaqoh & Guru Info Container
                      if (halaqohInfo.isNotEmpty) ...[
                        SizedBox(height: 14.h),
                        Container(
                          width: double.infinity,
                          padding: EdgeInsets.symmetric(
                            horizontal: 14.w,
                            vertical: 9.h,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.14),
                            borderRadius: BorderRadius.circular(12.r),
                            border: Border.all(
                              color: Colors.white.withValues(alpha: 0.22),
                              width: 0.8,
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Row 1: Halaqoh & Kelas
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.school_rounded,
                                    size: 14.sp,
                                    color: Colors.white,
                                  ),
                                  SizedBox(width: 8.w),
                                  Expanded(
                                    child: Text(
                                      halaqohInfo,
                                      style: textTheme.bodySmall?.copyWith(
                                            fontSize: 12.sp,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.white,
                                            height: 1.25,
                                          ) ??
                                          TextStyle(
                                            fontSize: 12.sp,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.white,
                                            fontFamily: 'Poppins',
                                            height: 1.25,
                                          ),
                                    ),
                                  ),
                                ],
                              ),

                              // Row 2: Guru Pengampu
                              if (guruName != null && guruName!.isNotEmpty) ...[
                                SizedBox(height: 5.h),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.person_rounded,
                                      size: 14.sp,
                                      color: Colors.white.withValues(alpha: 0.85),
                                    ),
                                    SizedBox(width: 8.w),
                                    Expanded(
                                      child: Text(
                                        t.waliSantriDashboard.guru(name: guruName!),
                                        style: textTheme.bodySmall?.copyWith(
                                              fontSize: 11.5.sp,
                                              fontWeight: FontWeight.w400,
                                              color: Colors.white.withValues(alpha: 0.9),
                                              height: 1.25,
                                            ) ??
                                            TextStyle(
                                              fontSize: 11.5.sp,
                                              fontWeight: FontWeight.w400,
                                              color: Colors.white.withValues(alpha: 0.9),
                                              fontFamily: 'Poppins',
                                              height: 1.25,
                                            ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
