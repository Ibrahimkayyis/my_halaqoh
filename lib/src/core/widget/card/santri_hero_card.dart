import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_halaqoh/src/core/theme/app_colors.dart';

/// Global hero information card for Santri.
/// Used across Guru and Wali Santri screens for a consistent, premium design.
class SantriHeroCard extends StatelessWidget {
  const SantriHeroCard({
    super.key,
    required this.name,
    this.nis,
    this.subtitle,
    this.profilePictureUrl,
    this.margin,
    this.padding,
  });

  /// Name of the santri (will soft wrap to full length if long).
  final String name;

  /// NIS of the santri (e.g. "12345" or "NIS: 12345").
  final String? nis;

  /// Optional subtitle below NIS (e.g. "Kelas 5A  •  Tahfidz" or "Halaqoh Al-Fatihah").
  final String? subtitle;

  /// Optional profile picture URL.
  final String? profilePictureUrl;

  /// Optional outer margin.
  final EdgeInsetsGeometry? margin;

  /// Optional inner padding.
  final EdgeInsetsGeometry? padding;

  String _getInitials(String input) {
    final cleanName = input.trim();
    if (cleanName.isEmpty) return '';
    final parts = cleanName.split(RegExp(r'\s+'));
    if (parts.length == 1) {
      return parts[0].isNotEmpty ? parts[0][0].toUpperCase() : '';
    }
    return '${parts[0][0]}${parts[parts.length - 1][0]}'.toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final hasPhoto = profilePictureUrl != null && profilePictureUrl!.trim().isNotEmpty;
    final initials = _getInitials(name);

    String? formattedNis;
    if (nis != null && nis!.trim().isNotEmpty) {
      final rawNis = nis!.trim();
      formattedNis = rawNis.toUpperCase().startsWith('NIS') ? rawNis : 'NIS: $rawNis';
    }

    final hasSubtitle = subtitle != null && subtitle!.trim().isNotEmpty;

    return Container(
      width: double.infinity,
      margin: margin,
      padding: padding ?? EdgeInsets.symmetric(vertical: 16.h, horizontal: 16.w),
      decoration: BoxDecoration(
        gradient: colors.primaryGradient,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: colors.primary.withValues(alpha: 0.22),
            blurRadius: 14,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // ── Avatar: Photo / Initials / Icon ───────────────────────
          Container(
            width: 52.w,
            height: 52.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: colors.textOnButton.withValues(alpha: 0.2),
              border: Border.all(
                color: colors.textOnButton.withValues(alpha: 0.6),
                width: 2.0,
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
                : (initials.isNotEmpty
                    ? Text(
                        initials,
                        style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w700,
                          color: colors.textOnButton,
                          fontFamily: 'Poppins',
                        ),
                      )
                    : Icon(
                        Icons.person,
                        size: 26.sp,
                        color: colors.textOnButton,
                      )),
          ),
          SizedBox(width: 14.w),

          // ── Santri Info Column ────────────────────────────────────
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Santri Name (Full width soft wrap without ellipsis truncation)
                Text(
                  name,
                  softWrap: true,
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w700,
                    color: colors.textOnButton,
                    fontFamily: 'Poppins',
                    height: 1.25,
                  ),
                ),
                if (formattedNis != null) ...[
                  SizedBox(height: 3.h),
                  Text(
                    formattedNis,
                    softWrap: true,
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w400,
                      color: colors.textOnButton.withValues(alpha: 0.85),
                      fontFamily: 'Poppins',
                    ),
                  ),
                ],
                if (hasSubtitle) ...[
                  SizedBox(height: 2.h),
                  Text(
                    subtitle!.trim(),
                    softWrap: true,
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w400,
                      color: colors.textOnButton.withValues(alpha: 0.80),
                      fontFamily: 'Poppins',
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
