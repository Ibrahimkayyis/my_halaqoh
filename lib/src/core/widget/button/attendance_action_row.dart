import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_halaqoh/gen/i18n/translations.g.dart';
import 'package:my_halaqoh/src/core/theme/app_colors.dart';

/// Reusable action button row for Attendance screens.
///
/// Supports:
/// - Both Calendar and Download buttons side-by-side (for Guru Riwayat screen)
/// - Single full-width Calendar button (for Wali Santri Riwayat screen)
/// - Single full-width Download button (if needed)
class AttendanceActionRow extends StatelessWidget {
  /// Callback when the "Lihat Kalender" button is tapped.
  /// If null, the calendar button is omitted.
  final VoidCallback? onViewCalendar;

  /// Callback when the "Download Laporan" button is tapped.
  /// If null, the download button is omitted.
  final VoidCallback? onDownloadReport;

  /// Custom label for the calendar button. Defaults to 'Lihat Kalender'
  /// or full translation text if single button.
  final String? calendarLabel;

  /// Custom label for the download button. Defaults to 'Download Laporan'.
  final String? downloadLabel;

  /// Outer margin. Defaults to `EdgeInsets.symmetric(horizontal: 20.w)`.
  final EdgeInsetsGeometry? margin;

  const AttendanceActionRow({
    super.key,
    this.onViewCalendar,
    this.onDownloadReport,
    this.calendarLabel,
    this.downloadLabel,
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final hasBoth = onViewCalendar != null && onDownloadReport != null;

    if (onViewCalendar == null && onDownloadReport == null) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: margin ?? EdgeInsets.symmetric(horizontal: 20.w),
      child: hasBoth
          ? Row(
              children: [
                Expanded(
                  child: _buildCalendarButton(context, colors, isCompact: true),
                ),
                SizedBox(width: 10.w),
                Expanded(
                  child: _buildDownloadButton(context, colors, isCompact: true),
                ),
              ],
            )
          : (onViewCalendar != null
              ? _buildCalendarButton(context, colors, isCompact: false)
              : _buildDownloadButton(context, colors, isCompact: false)),
    );
  }

  Widget _buildCalendarButton(
    BuildContext context,
    AppColorSet colors, {
    required bool isCompact,
  }) {
    final label = calendarLabel ??
        (isCompact
            ? 'Lihat Kalender'
            : t.riwayatAbsensi.lihatKalender);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onViewCalendar,
        borderRadius: BorderRadius.circular(8.r),
        child: Container(
          height: 44.h,
          padding: EdgeInsets.symmetric(horizontal: 10.w),
          decoration: BoxDecoration(
            color: colors.surface,
            borderRadius: BorderRadius.circular(8.r),
            border: Border.all(
              color: colors.primary.withValues(alpha: 0.65),
              width: 1.2,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.03),
                blurRadius: 4,
                offset: const Offset(0, 1),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.calendar_month_outlined,
                size: 17.sp,
                color: colors.primary,
              ),
              SizedBox(width: 6.w),
              Flexible(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: isCompact ? 12.sp : 13.sp,
                    fontWeight: FontWeight.w600,
                    color: colors.primary,
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

  Widget _buildDownloadButton(
    BuildContext context,
    AppColorSet colors, {
    required bool isCompact,
  }) {
    final label = downloadLabel ??
        (isCompact
            ? 'Unduh Laporan'
            : t.riwayatAbsensi.downloadLaporan);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onDownloadReport,
        borderRadius: BorderRadius.circular(8.r),
        child: Container(
          height: 44.h,
          padding: EdgeInsets.symmetric(horizontal: 10.w),
          decoration: BoxDecoration(
            color: colors.primary,
            borderRadius: BorderRadius.circular(8.r),
            boxShadow: [
              BoxShadow(
                color: colors.primary.withValues(alpha: 0.25),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.download_rounded,
                size: 17.sp,
                color: Colors.white,
              ),
              SizedBox(width: 6.w),
              Flexible(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: isCompact ? 12.sp : 13.sp,
                    fontWeight: FontWeight.w600,
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
}
