import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_halaqoh/gen/i18n/translations.g.dart';
import 'package:my_halaqoh/src/core/theme/app_colors.dart';

/// Clean Santri list item for guru hafalan screen.
///
/// Features:
/// 1. Clean header with Santri Name & NIS (Target info removed for clean minimalism).
/// 2. Borderless Integrated Action Bar (Alternatif 3):
///    - Riwayat Hafalan (Left action with subtle history icon).
///    - Input Hafalan (Right action with primary edit icon).
class HafalanSantriItem extends StatelessWidget {
  final String name;
  final String nis;
  final String riwayatLabel;
  final String inputLabel;
  final VoidCallback? onRiwayatTap;
  final VoidCallback? onInputTap;

  const HafalanSantriItem({
    super.key,
    required this.name,
    required this.nis,
    required this.riwayatLabel,
    required this.inputLabel,
    this.onRiwayatTap,
    this.onInputTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final textTheme = Theme.of(context).textTheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: EdgeInsets.only(bottom: 10.h),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: isDark ? colors.border : colors.border.withValues(alpha: 0.7),
          width: 0.8,
        ),
        boxShadow: isDark
            ? []
            : [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.02),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16.r),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // ── Top Section: Name + NIS ──
            Padding(
              padding: EdgeInsets.fromLTRB(16.w, 14.h, 16.w, 12.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    name,
                    softWrap: true,
                    style: textTheme.titleMedium?.copyWith(
                          fontSize: 14.5.sp,
                          fontWeight: FontWeight.w700,
                          color: colors.textPrimary,
                          height: 1.25,
                        ) ??
                        TextStyle(
                          fontSize: 14.5.sp,
                          fontWeight: FontWeight.w700,
                          color: colors.textPrimary,
                          fontFamily: 'Poppins',
                          height: 1.25,
                        ),
                  ),
                  SizedBox(height: 3.h),
                  Text(
                    t.hafalan.nisLabel(nis: nis),
                    style: textTheme.bodySmall?.copyWith(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w400,
                          color: colors.textSecondary,
                        ) ??
                        TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w400,
                          color: colors.textSecondary,
                          fontFamily: 'Poppins',
                        ),
                  ),
                ],
              ),
            ),

            // ── Hairline Divider ──
            Divider(
              color: isDark
                  ? colors.border.withValues(alpha: 0.6)
                  : colors.border.withValues(alpha: 0.4),
              height: 1,
              thickness: 0.8,
            ),

            // ── Integrated Action Bar (Alternatif 3) ──
            SizedBox(
              height: 42.h,
              child: Row(
                children: [
                  // Left Action: Riwayat Hafalan
                  Expanded(
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: onRiwayatTap,
                        splashColor: colors.primary.withValues(alpha: 0.08),
                        highlightColor: colors.primary.withValues(alpha: 0.04),
                        child: Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.history_rounded,
                                size: 16.sp,
                                color: colors.textSecondary,
                              ),
                              SizedBox(width: 6.w),
                              Text(
                                riwayatLabel,
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w600,
                                  color: colors.textSecondary,
                                  fontFamily: 'Poppins',
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),

                  // Vertical Separator
                  Container(
                    width: 0.8,
                    height: 20.h,
                    color: isDark
                        ? colors.border.withValues(alpha: 0.6)
                        : colors.border.withValues(alpha: 0.4),
                  ),

                  // Right Action: Input Hafalan
                  Expanded(
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: onInputTap,
                        splashColor: colors.primary.withValues(alpha: 0.08),
                        highlightColor: colors.primary.withValues(alpha: 0.04),
                        child: Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.edit_note_rounded,
                                size: 18.sp,
                                color: colors.primary,
                              ),
                              SizedBox(width: 5.w),
                              Text(
                                inputLabel,
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w600,
                                  color: colors.primary,
                                  fontFamily: 'Poppins',
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}