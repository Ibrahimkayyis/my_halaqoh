import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_halaqoh/gen/i18n/translations.g.dart';
import 'package:my_halaqoh/src/core/theme/app_colors.dart';
import 'package:my_halaqoh/src/modules/guru_dashboard/domain/models/latest_setoran_item.dart';

/// A card in the "Setoran Terakhir" section on Guru Dashboard.
/// Minimalist and modern design following design-system/myhalaqoh/MASTER.md.
/// Supports displaying single or multiple surahs in one submission session with expandable details.
class SetoranItem extends StatefulWidget {
  final LatestSetoranItem item;

  const SetoranItem({
    super.key,
    required this.item,
  });

  @override
  State<SetoranItem> createState() => _SetoranItemState();
}

class _SetoranItemState extends State<SetoranItem> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final textTheme = Theme.of(context).textTheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final item = widget.item;
    final hasMultiple = item.hasMultiple;
    final isZiyadah = item.isZiyadah;

    return GestureDetector(
      onTap: hasMultiple
          ? () {
              setState(() {
                _isExpanded = !_isExpanded;
              });
            }
          : null,
      child: AnimatedSize(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        child: Container(
          margin: EdgeInsets.only(bottom: 8.h),
          padding: EdgeInsets.symmetric(
            horizontal: 16.w,
            vertical: 14.h,
          ),
          decoration: BoxDecoration(
            color: colors.surface,
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(
              color: isDark
                  ? colors.border
                  : colors.border.withValues(alpha: 0.6),
              width: 0.8,
            ),
            boxShadow: isDark
                ? []
                : [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.04),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Santri and surah info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Row 1: Type label (Hafalan Baru / Muraja'ah) + Multiple surah chip
                        Row(
                          children: [
                            Text(
                              isZiyadah
                                  ? t.riwayatHafalanSantri.hafalanBaru
                                  : t.riwayatHafalanSantri.murajaah,
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
                            if (hasMultiple) ...[
                              SizedBox(width: 6.w),
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 6.w,
                                  vertical: 1.5.h,
                                ),
                                decoration: BoxDecoration(
                                  color: colors.primary.withValues(alpha: 0.08),
                                  borderRadius: BorderRadius.circular(4.r),
                                ),
                                child: Text(
                                  '${item.records.length} surat',
                                  style: textTheme.labelSmall?.copyWith(
                                        fontSize: 9.5.sp,
                                        fontWeight: FontWeight.w600,
                                        color: colors.primary,
                                      ) ??
                                      TextStyle(
                                        fontSize: 9.5.sp,
                                        fontWeight: FontWeight.w600,
                                        color: colors.primary,
                                        fontFamily: 'Poppins',
                                      ),
                                ),
                              ),
                            ],
                          ],
                        ),
                        SizedBox(height: 3.h),

                        // Row 2: Santri Name (Always full, soft-wrapped, never truncated)
                        Text(
                          item.santriName,
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
                          softWrap: true,
                        ),
                        SizedBox(height: 3.h),

                        // Row 3: Surah & Ayat info
                        Text(
                          hasMultiple
                              ? item.surahDisplay
                              : '${item.surahDisplay} • ${item.ayatDisplay}',
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
                          softWrap: true,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 12.w),

                  // Numeric Score Pill
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 10.w,
                      vertical: 4.h,
                    ),
                    decoration: BoxDecoration(
                      color: colors.surface,
                      borderRadius: BorderRadius.circular(8.r),
                      border: Border.all(
                        color: colors.border,
                        width: 1,
                      ),
                    ),
                    child: Text(
                      '${item.avgScore}',
                      style: textTheme.titleSmall?.copyWith(
                            fontSize: 13.5.sp,
                            fontWeight: FontWeight.w700,
                            color: colors.textPrimary,
                          ) ??
                          TextStyle(
                            fontSize: 13.5.sp,
                            fontWeight: FontWeight.w700,
                            color: colors.textPrimary,
                            fontFamily: 'Poppins',
                          ),
                    ),
                  ),

                  // Expand icon if has multiple surahs
                  if (hasMultiple) ...[
                    SizedBox(width: 4.w),
                    AnimatedRotation(
                      turns: _isExpanded ? 0.5 : 0,
                      duration: const Duration(milliseconds: 200),
                      child: Icon(
                        Icons.keyboard_arrow_down_rounded,
                        size: 20.sp,
                        color: colors.textSecondary,
                      ),
                    ),
                  ],
                ],
              ),

              // ── Expanded detail: show each surah in the group ──
              if (_isExpanded && hasMultiple) ...[
                SizedBox(height: 10.h),
                Divider(
                  color: colors.border.withValues(alpha: 0.6),
                  height: 1,
                ),
                SizedBox(height: 8.h),
                ...item.detailLines.map(
                  (line) => Padding(
                    padding: EdgeInsets.symmetric(vertical: 2.5.h, horizontal: 2.w),
                    child: Row(
                      children: [
                        Container(
                          width: 4.5.w,
                          height: 4.5.w,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: colors.primary.withValues(alpha: 0.7),
                          ),
                        ),
                        SizedBox(width: 8.w),
                        Expanded(
                          child: Text(
                            line,
                            style: textTheme.bodySmall?.copyWith(
                                  fontSize: 11.5.sp,
                                  color: colors.textSecondary,
                                ) ??
                                TextStyle(
                                  fontSize: 11.5.sp,
                                  color: colors.textSecondary,
                                  fontFamily: 'Poppins',
                                ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
