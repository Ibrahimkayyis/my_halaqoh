import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_halaqoh/gen/i18n/translations.g.dart';
import 'package:my_halaqoh/src/core/theme/app_colors.dart';

/// Modern Clean List View Collapsible Attendance Legend Card.
///
/// Features:
/// 1. Interactive Collapsible Header with status preview dots & animated chevron.
/// 2. Modern 1-Column Vertical List View for Status Kehadiran (H, HT, T, S, I, A, and optional Belum Absen).
///    Eliminates awkward line wrapping and provides maximum readability.
/// 3. Accent Pill Chips for Session Waktu (P, M for reguler; P, D, S, A, M for takhassus).
class AttendanceLegendCard extends StatefulWidget {
  /// Program type: 'reguler' or 'takhassus'
  final String programType;

  /// Whether to show the '-' Belum Absen entry (typically in calendar screens)
  final bool showBelumAbsen;

  /// Whether the card is initially expanded. Defaults to `false` for compact UX.
  final bool initiallyExpanded;

  /// Outer card margin. Defaults to `EdgeInsets.symmetric(horizontal: 20.w)`
  final EdgeInsetsGeometry? margin;

  /// Inner card padding. Defaults to `EdgeInsets.all(14.w)`
  final EdgeInsetsGeometry? padding;

  const AttendanceLegendCard({
    super.key,
    this.programType = 'reguler',
    this.showBelumAbsen = false,
    this.initiallyExpanded = false,
    this.margin,
    this.padding,
  });

  @override
  State<AttendanceLegendCard> createState() => _AttendanceLegendCardState();
}

class _AttendanceLegendCardState extends State<AttendanceLegendCard> {
  late bool _isExpanded;

  @override
  void initState() {
    super.initState();
    _isExpanded = widget.initiallyExpanded;
  }

  bool get _isTakhassus => widget.programType.toLowerCase() == 'takhassus';

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
                      // Info Icon in Soft Accent Container
                      Container(
                        width: 30.w,
                        height: 30.w,
                        decoration: BoxDecoration(
                          color: colors.primary.withValues(alpha: 0.08),
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        child: Icon(
                          Icons.info_outline_rounded,
                          size: 16.sp,
                          color: colors.primary,
                        ),
                      ),
                      SizedBox(width: 10.w),

                      // Title & Subtitle
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              t.riwayatAbsensi.keterangan,
                              style: TextStyle(
                                fontSize: 13.5.sp,
                                fontWeight: FontWeight.w700,
                                color: colors.textPrimary,
                                fontFamily: 'Poppins',
                              ),
                            ),
                            if (!_isExpanded) ...[
                              SizedBox(height: 2.h),
                              Text(
                                'Ketuk untuk melihat detail status & sesi',
                                style: TextStyle(
                                  fontSize: 10.5.sp,
                                  fontWeight: FontWeight.w400,
                                  color: colors.textSecondary,
                                  fontFamily: 'Poppins',
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),

                      // Collapsed Preview Dots (when closed)
                      if (!_isExpanded) ...[
                        _buildMiniPreviewDots(colors),
                        SizedBox(width: 8.w),
                      ],

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

            // ── Expandable Body (Modern Clean 1-Column List View) ──
            AnimatedSize(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeInOutCubic,
              alignment: Alignment.topCenter,
              child: _isExpanded
                  ? Padding(
                      padding: EdgeInsets.only(
                        left: 14.w,
                        right: 14.w,
                        bottom: 14.h,
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
                          SizedBox(height: 12.h),

                          // Status Kehadiran Section Header
                          Text(
                            'Status Kehadiran',
                            style: TextStyle(
                              fontSize: 11.5.sp,
                              fontWeight: FontWeight.w600,
                              color: colors.textSecondary,
                              fontFamily: 'Poppins',
                              letterSpacing: 0.2,
                            ),
                          ),
                          SizedBox(height: 8.h),

                          // 1-Column Clean Vertical List
                          _buildListRow(
                            color: colors.primary,
                            code: 'H',
                            label: t.detailAbsensiHariIni.hadirBarcode,
                            colors: colors,
                          ),
                          SizedBox(height: 6.h),
                          _buildListRow(
                            color: colors.green,
                            code: 'HT',
                            label: t.detailAbsensiHariIni.hadirManual,
                            colors: colors,
                          ),
                          SizedBox(height: 6.h),
                          _buildListRow(
                            color: const Color(0xFFF3722C),
                            code: 'T',
                            label: t.detailAbsensiHariIni.terlambat,
                            colors: colors,
                          ),
                          SizedBox(height: 6.h),
                          _buildListRow(
                            color: colors.yellow,
                            code: 'S',
                            label: t.detailAbsensiHariIni.sakit,
                            colors: colors,
                          ),
                          SizedBox(height: 6.h),
                          _buildListRow(
                            color: colors.blue,
                            code: 'I',
                            label: t.detailAbsensiHariIni.izin,
                            colors: colors,
                          ),
                          SizedBox(height: 6.h),
                          _buildListRow(
                            color: colors.red,
                            code: 'A',
                            label: t.detailAbsensiHariIni.alfa,
                            colors: colors,
                          ),
                          if (widget.showBelumAbsen) ...[
                            SizedBox(height: 6.h),
                            _buildListRow(
                              color: colors.border,
                              code: '-',
                              label: t.detailAbsensiHariIni.belumAbsen,
                              colors: colors,
                              isDashedBorder: true,
                            ),
                          ],

                          // Divider before Sessions
                          SizedBox(height: 14.h),
                          Divider(
                            color: colors.border.withValues(alpha: 0.35),
                            height: 1,
                            thickness: 1,
                          ),
                          SizedBox(height: 12.h),

                          // Sesi Waktu Header
                          Text(
                            t.riwayatAbsensi.sessionKeterangan,
                            style: TextStyle(
                              fontSize: 11.5.sp,
                              fontWeight: FontWeight.w600,
                              color: colors.textSecondary,
                              fontFamily: 'Poppins',
                              letterSpacing: 0.2,
                            ),
                          ),
                          SizedBox(height: 10.h),

                          // Session Chips in a Wrap
                          Wrap(
                            spacing: 8.w,
                            runSpacing: 8.h,
                            children: _isTakhassus
                                ? [
                                    _buildSessionPill(
                                      'P',
                                      t.riwayatAbsensi.sessionPagiShubuh,
                                      colors,
                                    ),
                                    _buildSessionPill(
                                      'D',
                                      t.riwayatAbsensi.sessionDhuha,
                                      colors,
                                    ),
                                    _buildSessionPill(
                                      'S',
                                      t.riwayatAbsensi.sessionSiang,
                                      colors,
                                    ),
                                    _buildSessionPill(
                                      'A',
                                      t.riwayatAbsensi.sessionSoreAshar,
                                      colors,
                                    ),
                                    _buildSessionPill(
                                      'M',
                                      t.riwayatAbsensi.sessionMalamMaghrib,
                                      colors,
                                    ),
                                  ]
                                : [
                                    _buildSessionPill(
                                      'P',
                                      t.riwayatAbsensi.sessionPagiShubuh,
                                      colors,
                                    ),
                                    _buildSessionPill(
                                      'M',
                                      t.riwayatAbsensi.sessionMalamMaghrib,
                                      colors,
                                    ),
                                  ],
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

  /// Compact 6-dot preview shown when the card is collapsed.
  Widget _buildMiniPreviewDots(AppColorSet colors) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildDot(colors.primary),
        SizedBox(width: 4.w),
        _buildDot(colors.green),
        SizedBox(width: 4.w),
        _buildDot(const Color(0xFFF3722C)),
        SizedBox(width: 4.w),
        _buildDot(colors.yellow),
        SizedBox(width: 4.w),
        _buildDot(colors.blue),
        SizedBox(width: 4.w),
        _buildDot(colors.red),
      ],
    );
  }

  Widget _buildDot(Color color) {
    return Container(
      width: 7.w,
      height: 7.w,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
    );
  }

  /// Modern Clean 1-Column List Row for an attendance status item.
  Widget _buildListRow({
    required Color color,
    required String code,
    required String label,
    required AppColorSet colors,
    bool isDashedBorder = false,
  }) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 7.h),
      decoration: BoxDecoration(
        color: colors.background,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(
          color: colors.border.withValues(alpha: 0.4),
          width: 0.8,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 22.w,
            height: 22.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isDashedBorder ? Colors.transparent : color,
              border: isDashedBorder
                  ? Border.all(color: color, width: 1.2)
                  : null,
            ),
            child: Center(
              child: Text(
                code,
                style: TextStyle(
                  fontSize: code.length > 1 ? 8.5.sp : 10.5.sp,
                  fontWeight: FontWeight.w700,
                  color: isDashedBorder ? colors.textSecondary : Colors.white,
                  fontFamily: 'Poppins',
                ),
              ),
            ),
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.w500,
                color: colors.textPrimary,
                fontFamily: 'Poppins',
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Pill badge for session labels.
  Widget _buildSessionPill(String code, String name, AppColorSet colors) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 5.h),
      decoration: BoxDecoration(
        color: colors.primary.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(
          color: colors.primary.withValues(alpha: 0.15),
          width: 0.8,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 1.5.h),
            decoration: BoxDecoration(
              color: colors.primary,
              borderRadius: BorderRadius.circular(4.r),
            ),
            child: Text(
              code,
              style: TextStyle(
                fontSize: 9.5.sp,
                fontWeight: FontWeight.w700,
                color: Colors.white,
                fontFamily: 'Poppins',
              ),
            ),
          ),
          SizedBox(width: 6.w),
          Text(
            name,
            style: TextStyle(
              fontSize: 11.sp,
              fontWeight: FontWeight.w500,
              color: colors.textPrimary,
              fontFamily: 'Poppins',
            ),
          ),
        ],
      ),
    );
  }
}
