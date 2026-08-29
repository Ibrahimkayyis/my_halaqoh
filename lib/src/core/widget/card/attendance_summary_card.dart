import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_halaqoh/gen/i18n/translations.g.dart';
import 'package:my_halaqoh/src/core/theme/app_colors.dart';

/// Clean Minimalist Collapsible Attendance Summary Card.
///
/// Design Highlights:
/// 1. Collapsed State (Default): Pure, elegant typography displaying 4 accumulated counters:
///    - Hadir (Accumulation of Barcode + Manual + Terlambat)
///    - Izin
///    - Sakit
///    - Alfa
///    Without heavy badge containers or colored boxes.
/// 2. Expanded State: Clean metric list with status abbreviation circular badges
///    (H, HT, T, S, I, A), full-width category labels, and pure right-aligned numeric
///    counter values (without badge/box wrappers).
class AttendanceSummaryCard extends StatefulWidget {
  /// Attendance counts map containing keys:
  /// - 'hadir'
  /// - 'sakit'
  /// - 'izin'
  /// - 'alfa'
  final Map<String, int> stats;

  /// Whether the card is initially expanded. Defaults to `false` (collapsed by default).
  final bool initiallyExpanded;

  /// Outer margin. Defaults to `EdgeInsets.symmetric(horizontal: 20.w)`.
  final EdgeInsetsGeometry? margin;

  /// Inner padding. Defaults to `EdgeInsets.all(14.w)`.
  final EdgeInsetsGeometry? padding;

  const AttendanceSummaryCard({
    super.key,
    required this.stats,
    this.initiallyExpanded = false,
    this.margin,
    this.padding,
  });

  @override
  State<AttendanceSummaryCard> createState() => _AttendanceSummaryCardState();
}

class _AttendanceSummaryCardState extends State<AttendanceSummaryCard> {
  late bool _isExpanded;

  @override
  void initState() {
    super.initState();
    _isExpanded = widget.initiallyExpanded;
  }

  int get _hadirTotal => widget.stats['hadir'] ?? 0;

  int get _izinCount => widget.stats['izin'] ?? 0;
  int get _sakitCount => widget.stats['sakit'] ?? 0;
  int get _alfaCount => widget.stats['alfa'] ?? 0;

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);

    return Container(
      width: double.infinity,
      margin: widget.margin ?? EdgeInsets.symmetric(horizontal: 20.w),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
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
            // ── Interactive Collapsible Header ──
            Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {
                  setState(() {
                    _isExpanded = !_isExpanded;
                  });
                },
                child: Padding(
                  padding: widget.padding ?? EdgeInsets.all(14.w),
                  child: Row(
                    children: [
                      // Analytics Icon in Soft Container
                      Container(
                        width: 30.w,
                        height: 30.w,
                        decoration: BoxDecoration(
                          color: colors.primary.withValues(alpha: 0.08),
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        child: Icon(
                          Icons.bar_chart_rounded,
                          size: 17.sp,
                          color: colors.primary,
                        ),
                      ),
                      SizedBox(width: 10.w),

                      // Title & Clean Collapsed Counter Text (No Badge Boxes)
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              t.riwayatAbsensi.ringkasanKehadiran,
                              style: TextStyle(
                                fontSize: 13.5.sp,
                                fontWeight: FontWeight.w700,
                                color: colors.textPrimary,
                                fontFamily: 'Poppins',
                              ),
                            ),
                            if (!_isExpanded) ...[
                              SizedBox(height: 4.h),
                              Wrap(
                                spacing: 8.w,
                                runSpacing: 4.h,
                                crossAxisAlignment: WrapCrossAlignment.center,
                                children: [
                                  _buildCollapsedItem(
                                    '$_hadirTotal Hadir',
                                    colors.primary,
                                    colors,
                                  ),
                                  _buildCollapsedItem(
                                    '$_izinCount Izin',
                                    colors.blue,
                                    colors,
                                  ),
                                  _buildCollapsedItem(
                                    '$_sakitCount Sakit',
                                    colors.yellow,
                                    colors,
                                  ),
                                  _buildCollapsedItem(
                                    '$_alfaCount Alfa',
                                    colors.red,
                                    colors,
                                  ),
                                ],
                              ),
                            ],
                          ],
                        ),
                      ),

                      SizedBox(width: 6.w),

                      // Animated Chevron
                      AnimatedRotation(
                        turns: _isExpanded ? 0.5 : 0.0,
                        duration: const Duration(milliseconds: 200),
                        curve: Curves.easeInOut,
                        child: Icon(
                          Icons.keyboard_arrow_down_rounded,
                          size: 20.sp,
                          color: colors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // ── Expandable Body (Clean Typography Metric List with Status Code Badges) ──
            AnimatedSize(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeInOutCubic,
              alignment: Alignment.topCenter,
              child: _isExpanded
                  ? Padding(
                      padding: EdgeInsets.only(
                        left: 14.w,
                        right: 14.w,
                        bottom: 12.h,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Divider
                          Divider(
                            color: colors.border.withValues(alpha: 0.35),
                            height: 1,
                            thickness: 1,
                          ),
                          SizedBox(height: 8.h),

                          // Clean List of 4 Metric Rows with Abbreviation Code Badges
                          _buildCleanRow(
                            color: colors.primary,
                            code: 'H',
                            label: t.detailAbsensiHariIni.hadir,
                            count: widget.stats['hadir'] ?? 0,
                            colors: colors,
                          ),
                          _buildRowDivider(colors),
                          _buildCleanRow(
                            color: colors.yellow,
                            code: 'S',
                            label: t.detailAbsensiHariIni.sakit,
                            count: widget.stats['sakit'] ?? 0,
                            colors: colors,
                          ),
                          _buildRowDivider(colors),
                          _buildCleanRow(
                            color: colors.blue,
                            code: 'I',
                            label: t.detailAbsensiHariIni.izin,
                            count: widget.stats['izin'] ?? 0,
                            colors: colors,
                          ),
                          _buildRowDivider(colors),
                          _buildCleanRow(
                            color: colors.red,
                            code: 'A',
                            label: t.detailAbsensiHariIni.alfa,
                            count: widget.stats['alfa'] ?? 0,
                            colors: colors,
                          ),
                        ],
                      ),
                    )
                  : const SizedBox.shrink(),
            ),
          ],
        ),
      ),
    );
  }

  /// Clean text item for collapsed state with a subtle colored dot.
  Widget _buildCollapsedItem(String text, Color dotColor, AppColorSet colors) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 6.w,
          height: 6.w,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: dotColor,
          ),
        ),
        SizedBox(width: 4.w),
        Text(
          text,
          style: TextStyle(
            fontSize: 11.sp,
            fontWeight: FontWeight.w500,
            color: colors.textSecondary,
            fontFamily: 'Poppins',
          ),
        ),
      ],
    );
  }

  /// Metric row with circular abbreviation badge (H, HT, T, S, I, A), title label, and pure numeric counter.
  Widget _buildCleanRow({
    required Color color,
    required String code,
    required String label,
    required int count,
    required AppColorSet colors,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 7.h, horizontal: 4.w),
      child: Row(
        children: [
          // Circular status abbreviation badge
          Container(
            width: 22.w,
            height: 22.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: color,
            ),
            child: Center(
              child: Text(
                code,
                style: TextStyle(
                  fontSize: code.length > 1 ? 8.5.sp : 10.5.sp,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                  fontFamily: 'Poppins',
                ),
              ),
            ),
          ),
          SizedBox(width: 10.w),

          // Category Label (Title Case)
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 12.5.sp,
                fontWeight: FontWeight.w500,
                color: colors.textPrimary,
                fontFamily: 'Poppins',
              ),
            ),
          ),

          // Pure numeric counter (NO box/badge wrapper)
          Text(
            '$count',
            style: TextStyle(
              fontSize: 13.5.sp,
              fontWeight: FontWeight.w700,
              color: colors.textPrimary,
              fontFamily: 'Poppins',
            ),
          ),
        ],
      ),
    );
  }

  /// Subtle divider between rows
  Widget _buildRowDivider(AppColorSet colors) {
    return Divider(
      color: colors.border.withValues(alpha: 0.25),
      height: 1,
      thickness: 0.7,
      indent: 32.w,
    );
  }
}
