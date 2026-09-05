import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:my_halaqoh/gen/i18n/translations.g.dart';
import 'package:my_halaqoh/src/core/theme/app_colors.dart';
import 'package:my_halaqoh/src/modules/guru_absensi/domain/models/absensi_model.dart';
import 'package:my_halaqoh/src/modules/guru_laporan/domain/helpers/schedule_helper.dart';

/// Modern & Clean Attendance Card for Wali Santri Dashboard.
/// Displays "{hadir} dari total {totalMonth} sesi hadir" and sleek soft-tinted status breakdown.
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
    int hadir = 0, sakit = 0, izin = 0, alfa = 0;

    for (final record in allRecords) {
      if (record.tanggal.month != month || record.tanggal.year != year) {
        continue;
      }

      final entry = record.records.where((r) => r.nis == nis);
      if (entry.isEmpty) continue;

      switch (entry.first.status) {
        case 'hadir':
          hadir++;
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
      'hadir': hadir,
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
    final startOfMonth = DateTime(now.year, now.month, 1);
    final endOfMonth = DateTime(now.year, now.month + 1, 0);

    final stats = _computeMonthlyAttendanceStats(
      allRecords,
      nis,
      now.month,
      now.year,
    );
    final periodName = DateFormat.yMMMM(t.$meta.locale.languageCode).format(now);

    // ── Statistical Calculations ──────────────────────────────────────────────
    final int totalHadir = stats['hadir'] ?? 0;
    final int sakit = stats['sakit'] ?? 0;
    final int izin = stats['izin'] ?? 0;
    final int alfa = stats['alfa'] ?? 0;
    final int totalAbsen = sakit + izin + alfa;
    final int totalRecordedSessions = totalHadir + totalAbsen;

    final int totalScheduledMonth = ScheduleHelper.totalScheduledSessions(
      startOfMonth,
      endOfMonth,
      programType,
    );

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

          // ── Hero Summary Section (Clear Session Count Banner) ─────────────
          Container(
            width: double.infinity,
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
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Icon Badge
                Container(
                  width: 44.w,
                  height: 44.w,
                  decoration: BoxDecoration(
                    color: (totalHadir == 0 && totalRecordedSessions == 0
                            ? colors.textSecondary
                            : colors.primary)
                        .withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: Icon(
                    totalHadir == 0 && totalRecordedSessions == 0
                        ? Icons.hourglass_empty_rounded
                        : Icons.event_available_rounded,
                    size: 22.sp,
                    color: totalHadir == 0 && totalRecordedSessions == 0
                        ? colors.textSecondary
                        : colors.primary,
                  ),
                ),
                SizedBox(width: 12.w),

                // Text Description
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: '$totalHadir',
                              style: TextStyle(
                                fontSize: 18.sp,
                                fontWeight: FontWeight.w800,
                                color: colors.primary,
                                fontFamily: 'Poppins',
                              ),
                            ),
                            TextSpan(
                              text: ' dari total ',
                              style: TextStyle(
                                fontSize: 13.sp,
                                fontWeight: FontWeight.w500,
                                color: colors.textSecondary,
                                fontFamily: 'Poppins',
                              ),
                            ),
                            TextSpan(
                              text: '$totalScheduledMonth',
                              style: TextStyle(
                                fontSize: 15.sp,
                                fontWeight: FontWeight.w700,
                                color: colors.textPrimary,
                                fontFamily: 'Poppins',
                              ),
                            ),
                            TextSpan(
                              text: ' sesi hadir',
                              style: TextStyle(
                                fontSize: 13.sp,
                                fontWeight: FontWeight.w600,
                                color: colors.textPrimary,
                                fontFamily: 'Poppins',
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        totalRecordedSessions == 0
                            ? 'Belum ada sesi absensi yang terlaksana bulan ini'
                            : '$totalRecordedSessions sesi telah dilaksanakan sejauh ini',
                        style: TextStyle(
                          fontSize: 11.sp,
                          fontWeight: FontWeight.w400,
                          color: colors.textSecondary,
                          fontFamily: 'Poppins',
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 14.h),

          // ── Status Breakdown Grid (2x2 Clean Soft Pills) ───────────────────
          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: _buildStatusChip(
                    label: t.detailAbsensiHariIni.hadir,
                    count: totalHadir,
                    accentColor: colors.primary,
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
