import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_halaqoh/gen/i18n/translations.g.dart';
import 'package:my_halaqoh/src/core/theme/app_colors.dart';

/// Reusable action button row for Hafalan History screens.
///
/// Supports:
/// - Both "Lihat Progress" and "Download Laporan" side-by-side (for Guru Riwayat screen)
/// - Single full-width "Lihat Progress" button (for Wali Santri Riwayat screen)
class HafalanActionRow extends StatelessWidget {
  /// Callback when the "Lihat Progress" button is tapped.
  /// If null, the progress button is omitted.
  final VoidCallback? onViewProgress;

  /// Callback when the "Download Laporan" button is tapped.
  /// If null, the download button is omitted.
  final VoidCallback? onDownloadReport;

  /// Custom label for the progress button. Defaults to 'Lihat Progress'
  /// or full translation text if single button.
  final String? progressLabel;

  /// Custom label for the download button. Defaults to 'Unduh Laporan'.
  final String? downloadLabel;

  /// Outer margin. Defaults to EdgeInsets.zero.
  final EdgeInsetsGeometry? margin;

  const HafalanActionRow({
    super.key,
    this.onViewProgress,
    this.onDownloadReport,
    this.progressLabel,
    this.downloadLabel,
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final hasBoth = onViewProgress != null && onDownloadReport != null;

    if (onViewProgress == null && onDownloadReport == null) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: margin ?? EdgeInsets.zero,
      child: hasBoth
          ? Row(
              children: [
                Expanded(
                  child: _buildProgressButton(context, colors, isCompact: true),
                ),
                SizedBox(width: 10.w),
                Expanded(
                  child: _buildDownloadButton(context, colors, isCompact: true),
                ),
              ],
            )
          : (onViewProgress != null
              ? _buildProgressButton(context, colors, isCompact: false)
              : _buildDownloadButton(context, colors, isCompact: false)),
    );
  }

  Widget _buildProgressButton(
    BuildContext context,
    AppColorSet colors, {
    required bool isCompact,
  }) {
    final label = progressLabel ??
        (isCompact
            ? t.riwayatHafalanSantri.lihatProgress
            : t.riwayatHafalanSantri.lihatProgress);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onViewProgress,
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
                Icons.menu_book_rounded,
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
            ? t.riwayatHafalanSantri.downloadLaporan
            : t.riwayatHafalanSantri.downloadLaporan);

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
