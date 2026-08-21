import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_halaqoh/src/core/router/app_router.dart';
import 'package:my_halaqoh/src/core/theme/app_colors.dart';
import 'package:my_halaqoh/src/core/widget/dialog/confirm_logout_dialog.dart';
import 'package:my_halaqoh/src/modules/auth/presentation/cubits/auth_cubit.dart';

/// Guru dashboard header featuring a brand logo + title on top left,
/// logout button on top right, and an Islamic hero card with SVG mosque silhouette decoration.
class GuruDashboardHeader extends StatelessWidget {
  final String name;
  final String? profilePictureUrl;
  final String dateText;
  final String halaqohName;
  final int santriCount;

  const GuruDashboardHeader({
    super.key,
    required this.name,
    this.profilePictureUrl,
    required this.dateText,
    required this.halaqohName,
    required this.santriCount,
  });

  /// Extracts 1 or 2 letter initials from full name.
  String _getInitials(String fullName) {
    final clean = fullName.trim();
    if (clean.isEmpty) return 'U';
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

              // Top Right Actions: Notification Bell & Logout Button
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // 1. Notification Button with unread indicator
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () {
                        context.router.push(const NotificationListRoute());
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
                        child: Stack(
                          clipBehavior: Clip.none,
                          children: [
                            Icon(
                              Icons.notifications_outlined,
                              size: 19.sp,
                              color: colors.textPrimary,
                            ),
                            // Red unread badge dot
                            Positioned(
                              top: -1,
                              right: -1,
                              child: Container(
                                width: 7.w,
                                height: 7.w,
                                decoration: BoxDecoration(
                                  color: colors.error,
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  SizedBox(width: 8.w),

                  // 2. Logout Button in rounded square container
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
            ],
          ),
          SizedBox(height: 14.h),

          // ── Islamic Hero Card: Mosque Silhouette SVG + Teacher Info ────
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
                      // Top Row: Avatar + Name + Greeting
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
                                    _getInitials(name),
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
                                  name.toUpperCase(),
                                  style: textTheme.titleLarge?.copyWith(
                                        fontSize: 18.sp,
                                        fontWeight: FontWeight.w800,
                                        color: colors.textOnButton,
                                        letterSpacing: 0.3,
                                      ) ??
                                      TextStyle(
                                        fontSize: 18.sp,
                                        fontWeight: FontWeight.w800,
                                        color: colors.textOnButton,
                                        letterSpacing: 0.3,
                                        fontFamily: 'Poppins',
                                      ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                SizedBox(height: 3.h),
                                Text(
                                  dateText,
                                  style: textTheme.bodySmall?.copyWith(
                                        fontSize: 11.5.sp,
                                        fontWeight: FontWeight.w400,
                                        color: colors.textOnButton
                                            .withValues(alpha: 0.85),
                                      ) ??
                                      TextStyle(
                                        fontSize: 11.5.sp,
                                        fontWeight: FontWeight.w400,
                                        color: colors.textOnButton
                                            .withValues(alpha: 0.85),
                                        fontFamily: 'Poppins',
                                      ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      // Bottom Halaqoh Pill Capsule (if halaqoh assigned)
                      if (halaqohName.isNotEmpty) ...[
                        SizedBox(height: 14.h),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 12.w,
                            vertical: 5.h,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(20.r),
                            border: Border.all(
                              color: Colors.white.withValues(alpha: 0.25),
                              width: 0.8,
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.people_outline_rounded,
                                size: 14.sp,
                                color: Colors.white,
                              ),
                              SizedBox(width: 6.w),
                              Text(
                                '$halaqohName  •  $santriCount Santri',
                                style: textTheme.bodySmall?.copyWith(
                                      fontSize: 11.5.sp,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.white,
                                    ) ??
                                    TextStyle(
                                      fontSize: 11.5.sp,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.white,
                                      fontFamily: 'Poppins',
                                    ),
                              ),
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
