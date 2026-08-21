import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:my_halaqoh/gen/i18n/translations.g.dart';
import 'package:my_halaqoh/src/core/theme/app_colors.dart';
import 'package:my_halaqoh/src/modules/guru_absensi/domain/models/absensi_model.dart';

/// Modern & Clean Attendance Card for Wali Santri Dashboard.
/// Features a circular attendance rate overview and sleek soft-tinted status breakdown.
class WaliSantriAttendanceCard extends StatelessWidget {
  final String nis;
  final List<AbsensiModel> allRecords;
  final String programType;

  const WaliSantriAttendanceCard({
    super.key,
    required this.nis,
    required this.allRecords,
    this.programType = 'reguler',
  });

  Map<String, int> _computeMonthlyAttendanceStats(
    List<AbsensiModel> allRecords,
    String nis,
    int month,
    int year,
  ) {
    int hadirBarcode = 0, hadirManual = 0, terlambat = 0, sakit = 0, izin = 0, alfa = 0;

    for (final record in allRecords) {
      if (record.tanggal.month != month || record.tanggal.year != year) {
        continue;
      }

      final entry = record.records.where((r) => r.nis == nis);
      if (entry.isEmpty) continue;

      switch (entry.first.status) {
        case 'hadir':
        case 'hadir_barcode':
          hadirBarcode++;
          break;
        case 'hadir_manual':
          hadirManual++;
          break;
        case 'terlambat':
          terlambat++;
          break;
        case 'sakit':
          sakit++;
          break;
        case 'izin':
          izin++;
          break;
        case 'alfa':
          alfa++;
          break;
      }
    }

    return {
      'hadir_barcode': hadirBarcode,
      'hadir_manual': hadirManual,
      'terlambat': terlambat,
      'sakit': sakit,
      'izin': izin,
      'alfa': alfa,
    };
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final now = DateTime.now();
    final stats = _computeMonthlyAttendanceStats(
      allRecords,
      nis,
      now.month,
      now.year,
    );
    final periodName = DateFormat.yMMMM(t.$meta.locale.languageCode).format(now);

    // ── Statistical Calculations ──────────────────────────────────────────────
    final int hadirBarcode = stats['hadir_barcode'] ?? 0;
    final int hadirManual = stats['hadir_manual'] ?? 0;
    final int terlambat = stats['terlambat'] ?? 0;
    final int sakit = stats['sakit'] ?? 0;
    final int izin = stats['izin'] ?? 0;
    final int alfa = stats['alfa'] ?? 0;

    final int totalHadir = hadirBarcode + hadirManual + terlambat;
    final int totalAbsen = sakit + izin + alfa;
    final int totalRecordedSessions = totalHadir + totalAbsen;

    final double rate = totalRecordedSessions > 0
        ? (totalHadir / totalRecordedSessions).clamp(0.0, 1.0)
        : 0.0;
    final int percentInt = (rate * 100).round();

    Color rateColor;
    String statusLabel;
    IconData statusIcon;

    if (totalRecordedSessions == 0) {
      rateColor = colors.textSecondary;
      statusLabel = 'Belum Ada Sesi';
      statusIcon = Icons.hourglass_empty_rounded;
    } else if (rate >= 0.90) {
      rateColor = colors.primary;
      statusLabel = 'Kehadiran Sangat Baik';
      statusIcon = Icons.check_circle_rounded;
    } else if (rate >= 0.75) {
      rateColor = colors.yellow;
      statusLabel = 'Kehadiran Cukup Baik';
      statusIcon = Icons.info_outline_rounded;
    } else {
      rateColor = colors.red;
      statusLabel = 'Perlu Perhatian';
      statusIcon = Icons.warning_amber_rounded;
    }

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: isDark ? colors.border : colors.border.withValues(alpha: 0.5),
          width: 0.8,
        ),
        boxShadow: isDark
            ? []
            : [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.04),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Header Row ────────────────────────────────────────────────────
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      t.waliSantriDashboard.kehadiran,
                      style: TextStyle(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w700,
                        color: colors.textPrimary,
                        fontFamily: 'Poppins',
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      t.waliSantriDashboard.periode(periode: periodName),
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w400,
                        color: colors.textSecondary,
                        fontFamily: 'Poppins',
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right_rounded,
                size: 22.sp,
                color: colors.textSecondary,
              ),
            ],
          ),
          SizedBox(height: 16.h),

          // ── Hero Summary Section (Circular Rate + Status) ──────────────────
          Container(
            padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
            decoration: BoxDecoration(
              color: colors.background,
              borderRadius: BorderRadius.circular(10.r),
              border: Border.all(
                color: isDark ? colors.border : colors.border.withValues(alpha: 0.35),
                width: 0.8,
              ),
            ),
            child: Row(
              children: [
                // Circular Progress Indicator
                CircularPercentIndicator(
                  radius: 32.w,
                  lineWidth: 5.5.w,
                  percent: rate,
                  animation: true,
                  animationDuration: 1000,
                  circularStrokeCap: CircularStrokeCap.round,
                  progressColor: rateColor,
                  backgroundColor: rateColor.withValues(alpha: 0.15),
                  center: RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: '$percentInt',
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w800,
                            color: colors.textPrimary,
                            fontFamily: 'Poppins',
                          ),
                        ),
                        TextSpan(
                          text: '%',
                          style: TextStyle(
                            fontSize: 10.sp,
                            fontWeight: FontWeight.w600,
                            color: colors.textSecondary,
                            fontFamily: 'Poppins',
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(width: 14.w),

                // Description & Performance Tag
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            statusIcon,
                            size: 15.sp,
                            color: rateColor,
                          ),
                          SizedBox(width: 6.w),
                          Flexible(
                            child: Text(
                              statusLabel,
                              style: TextStyle(
                                fontSize: 13.sp,
                                fontWeight: FontWeight.w700,
                                color: rateColor,
                                fontFamily: 'Poppins',
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        totalRecordedSessions == 0
                            ? 'Belum ada sesi tercatat bulan ini'
                            : 'Total $totalHadir dari $totalRecordedSessions sesi terlaksana',
                        style: TextStyle(
                          fontSize: 11.5.sp,
                          fontWeight: FontWeight.w400,
                          color: colors.textSecondary,
                          fontFamily: 'Poppins',
                          height: 1.2,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 14.h),

          // ── Status Breakdown Grid (2x3 Clean Soft Pills) ───────────────────
          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: _buildStatusChip(
                    label: t.detailAbsensiHariIni.hadirBarcode,
                    count: hadirBarcode,
                    accentColor: colors.primary,
                    colors: colors,
                  ),
                ),
                SizedBox(width: 8.w),
                Expanded(
                  child: _buildStatusChip(
                    label: t.detailAbsensiHariIni.hadirManual,
                    count: hadirManual,
                    accentColor: colors.green,
                    colors: colors,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 8.h),
          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: _buildStatusChip(
                    label: t.detailAbsensiHariIni.terlambat,
                    count: terlambat,
                    accentColor: const Color(0xFFF3722C),
                    colors: colors,
                  ),
                ),
                SizedBox(width: 8.w),
                Expanded(
                  child: _buildStatusChip(
                    label: t.waliSantriDashboard.sakit,
                    count: sakit,
                    accentColor: colors.yellow,
                    colors: colors,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 8.h),
          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: _buildStatusChip(
                    label: t.waliSantriDashboard.izin,
                    count: izin,
                    accentColor: colors.blue,
                    colors: colors,
                  ),
                ),
                SizedBox(width: 8.w),
                Expanded(
                  child: _buildStatusChip(
                    label: t.waliSantriDashboard.alpha,
                    count: alfa,
                    accentColor: colors.red,
                    colors: colors,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusChip({
    required String label,
    required int count,
    required Color accentColor,
    required AppColorSet colors,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: accentColor.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(
          color: accentColor.withValues(alpha: 0.2),
          width: 0.8,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 7.w,
            height: 7.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: accentColor,
            ),
          ),
          SizedBox(width: 6.w),
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 11.sp,
                fontWeight: FontWeight.w500,
                color: colors.textPrimary,
                fontFamily: 'Poppins',
                height: 1.2,
              ),
              maxLines: 2,
              softWrap: true,
            ),
          ),
          SizedBox(width: 6.w),
          Text(
            '$count',
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w800,
              color: accentColor,
              fontFamily: 'Poppins',
            ),
          ),
        ],
      ),
    );
  }
}
