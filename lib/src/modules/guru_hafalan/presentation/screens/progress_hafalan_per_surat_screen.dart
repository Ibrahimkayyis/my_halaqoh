import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_halaqoh/gen/i18n/translations.g.dart';
import 'package:my_halaqoh/src/core/quran/quran_service.dart';
import 'package:my_halaqoh/src/core/service_locator/service_locator.dart';
import 'package:my_halaqoh/src/core/theme/app_colors.dart';
import 'package:my_halaqoh/src/modules/guru_hafalan/presentation/cubits/progress_hafalan_cubit.dart';

/// Progress Hafalan Per Surat — shows surah-level progress for a specific juz
@RoutePage()
class ProgressHafalanPerSuratScreen extends StatelessWidget implements AutoRouteWrapper {
  final String santriId;
  final String name;
  final String nis;
  final int juzNumber;

  const ProgressHafalanPerSuratScreen({
    super.key,
    required this.santriId,
    required this.name,
    required this.nis,
    required this.juzNumber,
  });

  @override
  Widget wrappedRoute(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<ProgressHafalanCubit>()..watchProgress(santriId),
      child: this,
    );
  }

  /// Build surah data for this juz from QuranService with real progress.
  List<Map<String, dynamic>> _buildSurahData(ProgressHafalanState progressState) {
    final juz = QuranService.instance.getJuzByNumber(juzNumber);
    if (juz == null) return [];

    return juz.surahs.map((seg) {
      final surah = QuranService.instance.getSurahById(seg.surahId);
      final totalAyat = seg.ayatEnd - seg.ayatStart + 1;

      // Look up real memorized count from ProgressHafalanCubit
      int memorized = 0;
      progressState.maybeWhen(
        loaded: (progress) {
          final juzProgress = progress.juzProgressList
              .where((jp) => jp.juzNumber == juzNumber)
              .firstOrNull;
          if (juzProgress != null) {
            final surahProgress = juzProgress.surahProgressList
                .where((sp) => sp.surahId == seg.surahId)
                .firstOrNull;
            if (surahProgress != null) {
              memorized = surahProgress.memorizedAyat;
            }
          }
        },
        orElse: () {},
      );

      return {
        'name': surah?.name ?? 'Unknown',
        'totalAyat': totalAyat,
        'memorized': memorized,
      };
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);

    return BlocBuilder<ProgressHafalanCubit, ProgressHafalanState>(
      builder: (context, progressState) {
        // Build surah data with real progress
        final surahs = _buildSurahData(progressState);

    return Scaffold(
      backgroundColor: colors.background,
      body: SafeArea(
        child: Column(
          children: [
            // AppBar
            Padding(
              padding: EdgeInsets.only(left: 8.w, top: 8.h, right: 24.w),
              child: Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_back, color: colors.textPrimary),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  SizedBox(width: 4.w),
                  Text(
                    'Juz $juzNumber',
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w700,
                      color: colors.textPrimary,
                      fontFamily: 'Poppins',
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 8.h),

            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Green gradient profile card
                    _buildProfileCard(colors),
                    SizedBox(height: 20.h),

                    // Progress Per Surat header
                    Text(
                      t.progressHafalanPerSurat.title,
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w700,
                        color: colors.textPrimary,
                        fontFamily: 'Poppins',
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      t.progressHafalanPerSurat.detailJuz(juz: '$juzNumber'),
                      style: TextStyle(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w400,
                        color: colors.textSecondary,
                        fontFamily: 'Poppins',
                      ),
                    ),
                    SizedBox(height: 14.h),

                    // Surah cards
                    ...surahs.map((surah) => _buildSurahCard(surah, colors)),
                    SizedBox(height: 24.h),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
      },
    );
  }

  Widget _buildProfileCard(AppColorSet colors) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(18.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [colors.primary, colors.primary.withValues(alpha: 0.8)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Row(
        children: [
          Container(
            width: 50.w,
            height: 50.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withValues(alpha: 0.2),
            ),
            child: Icon(Icons.person, size: 26.sp, color: Colors.white),
          ),
          SizedBox(width: 14.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                    fontFamily: 'Poppins',
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  'NIS: $nis',
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w400,
                    color: Colors.white.withValues(alpha: 0.85),
                    fontFamily: 'Poppins',
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSurahCard(Map<String, dynamic> surah, AppColorSet colors) {
    final surahName = surah['name'] as String;
    final totalAyat = surah['totalAyat'] as int;
    final memorized = surah['memorized'] as int;
    final progressVal = totalAyat > 0 ? (memorized / totalAyat * 100) : 0.0;
    String percentStr;
    if (progressVal == 0 || progressVal == 100) {
      percentStr = progressVal.toInt().toString();
    } else {
      percentStr = progressVal.toStringAsFixed(1);
    }
    final progress = totalAyat > 0 ? memorized / totalAyat : 0.0;

    String statusLabel;
    Color statusColor;
    if (progressVal == 100) {
      statusLabel = t.progressHafalanPerSurat.selesai;
      statusColor = colors.primary;
    } else if (progressVal > 0) {
      statusLabel = t.progressHafalanPerSurat.dalamProses;
      statusColor = colors.primary;
    } else {
      statusLabel = t.progressHafalanPerSurat.belumDimulai;
      statusColor = colors.textSecondary;
    }

    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(14.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Surah name + percent
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    surahName,
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w700,
                      color: colors.textPrimary,
                      fontFamily: 'Poppins',
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    '$totalAyat Ayat',
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w400,
                      color: colors.textSecondary,
                      fontFamily: 'Poppins',
                    ),
                  ),
                ],
              ),
              Text(
                '$percentStr%',
                style: TextStyle(
                  fontSize: 20.sp,
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
            borderRadius: BorderRadius.circular(4.r),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 6.h,
              backgroundColor: colors.border,
              valueColor: AlwaysStoppedAnimation<Color>(colors.primary),
            ),
          ),
          SizedBox(height: 8.h),

          // Ayat count + status label
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                t.progressHafalanPerSurat.ayatDari(
                  memorized: '$memorized',
                  total: '$totalAyat',
                ),
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w400,
                  color: colors.textSecondary,
                  fontFamily: 'Poppins',
                ),
              ),
              Text(
                statusLabel,
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w600,
                  color: statusColor,
                  fontFamily: 'Poppins',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
