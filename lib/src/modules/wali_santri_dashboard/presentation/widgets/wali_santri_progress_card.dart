import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_halaqoh/gen/i18n/translations.g.dart';
import 'package:my_halaqoh/src/core/theme/app_colors.dart';
import 'package:my_halaqoh/src/modules/master_data/domain/models/santri_model.dart';
import 'package:my_halaqoh/src/modules/master_data/domain/models/target_hafalan_model.dart';
import 'package:my_halaqoh/src/modules/master_data/domain/helpers/target_hafalan_helper.dart';
import 'package:my_halaqoh/src/core/quran/hafalan_progress.dart';

class WaliSantriProgressCard extends StatelessWidget {
  final SantriModel? santri;
  final TargetHafalanModel? target;
  final OverallHafalanProgress? progressData;
  final List<int> extraJuz;

  const WaliSantriProgressCard({
    super.key,
    this.santri,
    this.target,
    this.progressData,
    this.extraJuz = const [],
  });

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final textTheme = Theme.of(context).textTheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // ── Admin-defined target juz ──────────────────────────────────────────────
    final adminJuzList = target != null && santri != null
        ? TargetHafalanHelper.getTargetJuzList(target!, santri!.kelas, santri!.program)
        : <int>[];

    // ── Admin progress calculation ────────────────────────────────────────────
    final double juzTargetAdmin = target != null && santri != null
        ? TargetHafalanHelper.getTargetJuzCountDouble(target!, santri!.kelas, santri!.program)
        : 0.0;
    
    double juzCompletedAdmin = 0.0;
    if (target != null && santri != null && progressData != null) {
      juzCompletedAdmin = TargetHafalanHelper.getCompletedJuzCountDouble(
        targetModel: target!,
        kelas: santri!.kelas,
        programCode: santri!.program,
        progressData: progressData!,
      );
    } else if (progressData != null) {
      for (final juzNum in adminJuzList) {
        final jp = progressData!.juzProgressList
            .where((j) => j.juzNumber == juzNum)
            .firstOrNull;
        if (jp != null && jp.totalAyat > 0) {
          juzCompletedAdmin += jp.memorizedAyat / jp.totalAyat;
        }
      }
    }

    final double progressAdmin = juzTargetAdmin > 0 ? (juzCompletedAdmin / juzTargetAdmin).clamp(0.0, 1.0) : 0.0;
    final double percentValueAdmin = progressAdmin * 100;

    // ── Extra juz calculation (not in admin list) ─────────────────────────────
    final progressJuzNums = progressData?.juzProgressList
            .where((jp) => jp.memorizedAyat > 0)
            .map((jp) => jp.juzNumber)
            .toSet() ??
        <int>{};

    final extraJuzList = <int>{
      ...extraJuz,
      ...progressJuzNums,
    }.difference(adminJuzList.toSet()).toList()..sort();

    final int juzTargetExtra = extraJuzList.length;
    double extraJuzCompleted = 0.0;
    if (progressData != null) {
      for (final juzNum in extraJuzList) {
        final jp = progressData!.juzProgressList
            .where((j) => j.juzNumber == juzNum)
            .firstOrNull;
        if (jp != null && jp.totalAyat > 0) {
          extraJuzCompleted += jp.memorizedAyat / jp.totalAyat;
        }
      }
    }

    final double progressExtra = juzTargetExtra > 0 ? (extraJuzCompleted / juzTargetExtra).clamp(0.0, 1.0) : 0.0;
    final double percentValueExtra = progressExtra * 100;

    // Format percentage accurately: show up to 2 decimal places, trim trailing zeros
    String formatPercent(double v) {
      if (v == 0) return '0';
      if (v >= 1) {
        final rounded = double.parse(v.toStringAsFixed(1));
        return rounded == rounded.roundToDouble()
            ? rounded.toInt().toString()
            : rounded.toStringAsFixed(1);
      }
      final s = v.toStringAsFixed(2);
      return s.replaceAll(RegExp(r'0+$'), '').replaceAll(RegExp(r'\.$'), '');
    }

    // Format juzCompleted to remove .0 if it's a whole number, otherwise show 2 decimals
    String formatJuz(double v) {
      if (v == 0) return '0';
      if (v == v.roundToDouble()) return v.toInt().toString();
      final s = v.toStringAsFixed(2);
      return s.replaceAll(RegExp(r'0+$'), '').replaceAll(RegExp(r'\.$'), '');
    }

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(18.w),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(16.r),
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
          // Header row
          Row(
            children: [
              Expanded(
                child: Text(
                  t.waliSantriDashboard.progressHafalan,
                  style: textTheme.titleMedium?.copyWith(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w700,
                        color: colors.textPrimary,
                      ) ??
                      TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w700,
                        color: colors.textPrimary,
                        fontFamily: 'Poppins',
                      ),
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

          // Juz completed + percentage
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: '${formatJuz(juzCompletedAdmin)} ',
                      style: textTheme.headlineMedium?.copyWith(
                            fontSize: 28.sp,
                            fontWeight: FontWeight.w800,
                            color: colors.textPrimary,
                          ) ??
                          TextStyle(
                            fontSize: 28.sp,
                            fontWeight: FontWeight.w800,
                            color: colors.textPrimary,
                            fontFamily: 'Poppins',
                          ),
                    ),
                    TextSpan(
                      text: t.waliSantriDashboard.juzTerselesaikan,
                      style: textTheme.bodyMedium?.copyWith(
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w400,
                            color: colors.textSecondary,
                          ) ??
                          TextStyle(
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w400,
                            color: colors.textSecondary,
                            fontFamily: 'Poppins',
                          ),
                    ),
                  ],
                ),
              ),
              Text(
                '${formatPercent(percentValueAdmin)}%',
                style: textTheme.headlineSmall?.copyWith(
                      fontSize: 24.sp,
                      fontWeight: FontWeight.w800,
                      color: colors.primary,
                    ) ??
                    TextStyle(
                      fontSize: 24.sp,
                      fontWeight: FontWeight.w800,
                      color: colors.primary,
                      fontFamily: 'Poppins',
                    ),
              ),
            ],
          ),
          SizedBox(height: 10.h),

          // Progress bar
          ClipRRect(
            borderRadius: BorderRadius.circular(6.r),
            child: LinearProgressIndicator(
              value: progressAdmin,
              minHeight: 10.h,
              backgroundColor: colors.border.withValues(alpha: 0.3),
              valueColor: AlwaysStoppedAnimation<Color>(colors.primary),
            ),
          ),
          SizedBox(height: 8.h),

          // Target text
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              t.waliSantriDashboard.target(target: formatJuz(juzTargetAdmin)),
              style: textTheme.bodySmall?.copyWith(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w500,
                    color: colors.textSecondary,
                  ) ??
                  TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w500,
                    color: colors.textSecondary,
                    fontFamily: 'Poppins',
                  ),
            ),
          ),

          // ── BLOCK 2: TARGET EKSTRA (Only shown if has extra targets) ──
          if (extraJuzList.isNotEmpty) ...[
            SizedBox(height: 16.h),
            const Divider(),
            SizedBox(height: 12.h),
            Text(
              t.waliSantriDashboard.extraMemorization,
              style: textTheme.titleSmall?.copyWith(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w700,
                    color: colors.blue,
                    letterSpacing: 0.3,
                  ) ??
                  TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w700,
                    color: colors.blue,
                    fontFamily: 'Poppins',
                    letterSpacing: 0.3,
                  ),
            ),
            SizedBox(height: 10.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: '${formatJuz(extraJuzCompleted)} ',
                        style: textTheme.headlineSmall?.copyWith(
                              fontSize: 24.sp,
                              fontWeight: FontWeight.w800,
                              color: colors.textPrimary,
                            ) ??
                            TextStyle(
                              fontSize: 24.sp,
                              fontWeight: FontWeight.w800,
                              color: colors.textPrimary,
                              fontFamily: 'Poppins',
                            ),
                      ),
                      TextSpan(
                        text: t.waliSantriDashboard.juzTerselesaikan,
                        style: textTheme.bodyMedium?.copyWith(
                              fontSize: 13.sp,
                              fontWeight: FontWeight.w400,
                              color: colors.textSecondary,
                            ) ??
                            TextStyle(
                              fontSize: 13.sp,
                              fontWeight: FontWeight.w400,
                              color: colors.textSecondary,
                              fontFamily: 'Poppins',
                            ),
                      ),
                    ],
                  ),
                ),
                Text(
                  '${formatPercent(percentValueExtra)}%',
                  style: textTheme.titleLarge?.copyWith(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.w800,
                        color: colors.blue,
                      ) ??
                      TextStyle(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.w800,
                        color: colors.blue,
                        fontFamily: 'Poppins',
                      ),
                ),
              ],
            ),
            SizedBox(height: 8.h),
            ClipRRect(
              borderRadius: BorderRadius.circular(6.r),
              child: LinearProgressIndicator(
                value: progressExtra,
                minHeight: 8.h,
                backgroundColor: colors.border.withValues(alpha: 0.3),
                valueColor: AlwaysStoppedAnimation<Color>(colors.blue),
              ),
            ),
            SizedBox(height: 8.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  t.waliSantriDashboard.juzList(juz: extraJuzList.join(', ')),
                  style: textTheme.bodySmall?.copyWith(
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w500,
                        color: colors.textSecondary,
                      ) ??
                      TextStyle(
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w500,
                        color: colors.textSecondary,
                        fontFamily: 'Poppins',
                      ),
                ),
                Text(
                  t.waliSantriDashboard.extraJuzTarget(count: juzTargetExtra),
                  style: textTheme.bodySmall?.copyWith(
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w500,
                        color: colors.textSecondary,
                      ) ??
                      TextStyle(
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w500,
                        color: colors.textSecondary,
                        fontFamily: 'Poppins',
                      ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
