import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_halaqoh/src/core/theme/app_colors.dart';

/// A modern, clean profile context header for sub-screens.
/// Replaces heavy gradient cards with a crisp, low-profile information strip.
class SantriContextHeader extends StatelessWidget {
  final String name;
  final String? nis;
  final String? subtitle;
  final String? profilePictureUrl;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;

  const SantriContextHeader({
    super.key,
    required this.name,
    this.nis,
    this.subtitle,
    this.profilePictureUrl,
    this.margin,
    this.padding,
  });

  String _getInitials(String input) {
    final clean = input.trim();
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
    final hasPhoto = profilePictureUrl != null && profilePictureUrl!.trim().isNotEmpty;

    String? formattedNis;
    if (nis != null && nis!.trim().isNotEmpty) {
      final raw = nis!.trim();
      formattedNis = raw.toUpperCase().startsWith('NIS') ? raw : 'NIS: $raw';
    }

    final hasSubtitle = subtitle != null && subtitle!.trim().isNotEmpty;

    return Container(
      width: double.infinity,
      margin: margin,
      padding: padding ?? EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: isDark ? colors.border : colors.border.withValues(alpha: 0.8),
          width: 1.0,
        ),
        boxShadow: isDark
            ? []
            : [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 3),
                ),
              ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // ── Avatar ────────────────────────────────────────────────
          Container(
            width: 44.w,
            height: 44.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: colors.primary.withValues(alpha: 0.1),
              border: Border.all(
                color: hasPhoto
                    ? (isDark ? colors.border : colors.border.withValues(alpha: 0.8))
                    : colors.primary.withValues(alpha: 0.3),
                width: 1.4,
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
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w700,
                          color: colors.primary,
                        ) ??
                        TextStyle(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w700,
                          color: colors.primary,
                          fontFamily: 'Poppins',
                        ),
                  ),
          ),
          SizedBox(width: 12.w),

          // ── Santri Info Column ────────────────────────────────────
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Santri Name (bold & readable)
                Text(
                  name,
                  style: textTheme.titleMedium?.copyWith(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w700,
                        color: colors.textPrimary,
                        height: 1.25,
                      ) ??
                      TextStyle(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w700,
                        color: colors.textPrimary,
                        fontFamily: 'Poppins',
                        height: 1.25,
                      ),
                  maxLines: 2,
                  softWrap: true,
                ),
                SizedBox(height: 5.h),

                // Semantic Metadata Chips Wrap
                Wrap(
                  spacing: 6.w,
                  runSpacing: 4.h,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    if (formattedNis != null)
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 7.w,
                          vertical: 2.h,
                        ),
                        decoration: BoxDecoration(
                          color: colors.background,
                          borderRadius: BorderRadius.circular(6.r),
                          border: Border.all(
                            color: isDark
                                ? colors.border
                                : colors.border.withValues(alpha: 0.6),
                            width: 0.6,
                          ),
                        ),
                        child: Text(
                          formattedNis,
                          style: textTheme.labelSmall?.copyWith(
                                fontSize: 10.5.sp,
                                fontWeight: FontWeight.w500,
                                color: colors.textSecondary,
                              ) ??
                              TextStyle(
                                fontSize: 10.5.sp,
                                fontWeight: FontWeight.w500,
                                color: colors.textSecondary,
                                fontFamily: 'Poppins',
                              ),
                        ),
                      ),
                    if (hasSubtitle)
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 7.w,
                          vertical: 2.h,
                        ),
                        decoration: BoxDecoration(
                          color: colors.primary.withValues(alpha: 0.08),
                          borderRadius: BorderRadius.circular(6.r),
                          border: Border.all(
                            color: colors.primary.withValues(alpha: 0.22),
                            width: 0.6,
                          ),
                        ),
                        child: Text(
                          subtitle!,
                          style: textTheme.labelSmall?.copyWith(
                                fontSize: 10.5.sp,
                                fontWeight: FontWeight.w600,
                                color: colors.primary,
                              ) ??
                              TextStyle(
                                fontSize: 10.5.sp,
                                fontWeight: FontWeight.w600,
                                color: colors.primary,
                                fontFamily: 'Poppins',
                              ),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
