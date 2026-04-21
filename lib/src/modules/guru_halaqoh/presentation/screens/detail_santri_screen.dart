import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_halaqoh/gen/i18n/translations.g.dart';
import 'package:my_halaqoh/src/core/theme/app_colors.dart';
import 'package:my_halaqoh/src/modules/guru_halaqoh/presentation/widgets/academic_info_row.dart';
import 'package:my_halaqoh/src/modules/master_data/domain/helpers/target_hafalan_helper.dart';
import 'package:my_halaqoh/src/modules/master_data/domain/models/halaqoh_model.dart';
import 'package:my_halaqoh/src/modules/master_data/domain/models/santri_model.dart';
import 'package:my_halaqoh/src/modules/master_data/domain/models/target_hafalan_model.dart';
import 'package:my_halaqoh/src/modules/master_data/presentation/cubits/halaqoh_cubit.dart';
import 'package:my_halaqoh/src/modules/master_data/presentation/cubits/halaqoh_state.dart';
import 'package:my_halaqoh/src/modules/master_data/presentation/cubits/santri_cubit.dart';
import 'package:my_halaqoh/src/modules/master_data/presentation/cubits/santri_state.dart';
import 'package:my_halaqoh/src/modules/master_data/presentation/cubits/target_hafalan_cubit.dart';
import 'package:my_halaqoh/src/modules/master_data/presentation/cubits/target_hafalan_state.dart';

import 'package:my_halaqoh/src/core/service_locator/service_locator.dart';
import 'package:my_halaqoh/src/modules/guru_hafalan/presentation/cubits/progress_hafalan_cubit.dart';
import 'package:my_halaqoh/src/core/quran/hafalan_progress.dart';

/// Detail santri screen showing profile header, academic info, and progress hafalan
@RoutePage()
class DetailSantriScreen extends StatelessWidget implements AutoRouteWrapper {
  final String name;
  final String nis;

  const DetailSantriScreen({super.key, required this.name, required this.nis});

  @override
  Widget wrappedRoute(BuildContext context) {
    // Determine santriId from nis using SantriCubit
    final santriState = context.read<SantriCubit>().state;
    String? santriId;
    santriState.maybeWhen(
      loaded: (sList) {
        try {
          santriId = sList.firstWhere((s) => s.nis == nis).id;
        } catch (_) {}
      },
      orElse: () {},
    );

    return BlocProvider(
      create: (context) {
        final cubit = sl<ProgressHafalanCubit>();
        if (santriId != null) {
          cubit.watchProgress(santriId!);
        }
        return cubit;
      },
      child: this,
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);

    // Look up real santri data by NIS
    final santriState = context.watch<SantriCubit>().state;
    final halaqohState = context.watch<HalaqohCubit>().state;
    final targetHafalanState = context.watch<TargetHafalanCubit>().state;

    SantriModel? santri;
    santriState.maybeWhen(
      loaded: (list) {
        try {
          santri = list.firstWhere((s) => s.nis == nis);
        } catch (_) {}
      },
      orElse: () {},
    );

    // Look up halaqoh for this santri
    HalaqohModel? halaqoh;
    if (santri?.halaqohId != null) {
      halaqohState.maybeWhen(
        loaded: (list) {
          try {
            halaqoh = list.firstWhere((h) => h.id == santri!.halaqohId);
          } catch (_) {}
        },
        orElse: () {},
      );
    }

    // Look up memorization target for this santri's kelas + program
    TargetHafalanModel? target;
    if (santri != null) {
      targetHafalanState.maybeWhen(
        loaded: (targets) {
          target = TargetHafalanHelper.findTarget(
            targets,
            santri!.kelas,
            santri!.program,
          );
        },
        orElse: () {},
      );
    }

    // Use real data with fallbacks to route params
    final displayName = santri?.nama ?? name;
    final displayNis = santri?.nis ?? nis;
    final displayKelas = santri != null ? 'Kelas ${santri!.kelas}' : '-';
    final displayProgram = santri != null
        ? TargetHafalanHelper.programCodeToFullName(santri!.program)
        : '-';
    final displayHalaqoh = halaqoh?.nama ?? '-';
    final displayPembimbing = halaqoh?.guruNama ?? '-';
    final profilePictureUrl = santri?.profilePicture;

    return Scaffold(
      backgroundColor: colors.background,
      body: SafeArea(
        child: Column(
          children: [
            // Back arrow + title
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
                    t.detailSantri.title,
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

            // Scrollable content
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 8.h),

                    // Profile header card
                    _buildProfileHeader(
                      colors,
                      displayName,
                      displayNis,
                      profilePictureUrl,
                    ),
                    SizedBox(height: 28.h),

                    // INFORMASI AKADEMIK section
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 24.w),
                      child: Text(
                        t.detailSantri.informasiAkademik,
                        style: TextStyle(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w600,
                          color: colors.textSecondary,
                          letterSpacing: 0.8,
                          fontFamily: 'Poppins',
                        ),
                      ),
                    ),
                    SizedBox(height: 12.h),

                    // Info card
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 24.w),
                      decoration: BoxDecoration(
                        color: colors.surface,
                        borderRadius: BorderRadius.circular(16.r),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.04),
                            blurRadius: 10,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          AcademicInfoRow(
                            icon: Icons.school,
                            iconColor: colors.primary,
                            iconBgColor: colors.primary.withValues(alpha: 0.1),
                            label: t.detailSantri.kelas,
                            value: displayKelas,
                          ),
                          AcademicInfoRow(
                            icon: Icons.menu_book,
                            iconColor: colors.blue,
                            iconBgColor: colors.blue.withValues(alpha: 0.1),
                            label: t.detailSantri.program,
                            value: displayProgram,
                          ),
                          AcademicInfoRow(
                            icon: Icons.auto_stories,
                            iconColor: colors.primary,
                            iconBgColor: colors.primary.withValues(alpha: 0.1),
                            label: t.detailSantri.halaqoh,
                            value: displayHalaqoh,
                          ),
                          AcademicInfoRow(
                            icon: Icons.groups,
                            iconColor: colors.red,
                            iconBgColor: colors.red.withValues(alpha: 0.1),
                            label: t.detailSantri.pembimbing,
                            value: displayPembimbing,
                            showDivider: false,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 28.h),

                    // PROGRESS HAFALAN section
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 24.w),
                      child: Text(
                        t.detailSantri.progressHafalan,
                        style: TextStyle(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w600,
                          color: colors.textSecondary,
                          letterSpacing: 0.8,
                          fontFamily: 'Poppins',
                        ),
                      ),
                    ),
                    SizedBox(height: 12.h),

                    // Progress card (driven by admin target)
                    BlocBuilder<ProgressHafalanCubit, ProgressHafalanState>(
                      builder: (context, progressState) {
                        OverallHafalanProgress? progressData;
                        progressState.maybeWhen(
                          loaded: (data) => progressData = data,
                          orElse: () {},
                        );
                        return _buildProgressCard(colors, target, progressData);
                      },
                    ),
                    SizedBox(height: 40.h),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Green gradient profile header with avatar, name, NIS
  Widget _buildProfileHeader(
    AppColorSet colors,
    String displayName,
    String displayNis,
    String? profilePictureUrl,
  ) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 24.w),
      padding: EdgeInsets.symmetric(vertical: 28.h),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [colors.primary, colors.primary.withValues(alpha: 0.82)],
        ),
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Column(
        children: [
          // Avatar
          Container(
            width: 80.w,
            height: 80.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: colors.textOnButton.withValues(alpha: 0.2),
              border: Border.all(
                color: colors.textOnButton.withValues(alpha: 0.4),
                width: 3,
              ),
              image: profilePictureUrl != null && profilePictureUrl.isNotEmpty
                  ? DecorationImage(
                      image: NetworkImage(profilePictureUrl),
                      fit: BoxFit.cover,
                    )
                  : null,
            ),
            child: profilePictureUrl == null || profilePictureUrl.isEmpty
                ? Icon(Icons.person, size: 40.sp, color: colors.textOnButton)
                : null,
          ),
          SizedBox(height: 14.h),
          // Name
          Text(
            displayName,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.w700,
              color: colors.textOnButton,
              fontFamily: 'Poppins',
            ),
          ),
          SizedBox(height: 4.h),
          // NIS
          Text(
            'NIS: $displayNis',
            style: TextStyle(
              fontSize: 13.sp,
              fontWeight: FontWeight.w400,
              color: colors.textOnButton.withValues(alpha: 0.85),
              fontFamily: 'Poppins',
            ),
          ),
        ],
      ),
    );
  }

  /// Progress Hafalan card driven by admin-set memorization targets.
  /// Shows target juz, completion count (0 for now), progress bar.
  Widget _buildProgressCard(AppColorSet colors, TargetHafalanModel? target, OverallHafalanProgress? progressData) {
    final int juzTarget = target?.targetJuz ?? 0;
    
    double juzCompleted = 0.0;
    if (progressData != null) {
      for (final jp in progressData.juzProgressList) {
        if (jp.totalAyat > 0) {
          juzCompleted += jp.memorizedAyat / jp.totalAyat;
        }
      }
    }

    final double progress = juzTarget > 0 ? juzCompleted / juzTarget : 0.0;
    final int percent = (progress * 100).round();
    
    // Format juzCompleted to remove .0 if it's a whole number, otherwise show 2 decimals
    String formatJuz(double v) {
      if (v == 0) return '0';
      return v == v.roundToDouble() ? v.toInt().toString() : v.toStringAsFixed(2);
    }

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 24.w),
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
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
              Icon(Icons.menu_book, size: 20.sp, color: colors.primary),
              SizedBox(width: 8.w),
              Expanded(
                child: Text(
                  t.waliSantriDashboard.progressHafalan,
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w700,
                    color: colors.textPrimary,
                    fontFamily: 'Poppins',
                  ),
                ),
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
                      text: '${formatJuz(juzCompleted)} ',
                      style: TextStyle(
                        fontSize: 28.sp,
                        fontWeight: FontWeight.w800,
                        color: colors.textPrimary,
                        fontFamily: 'Poppins',
                      ),
                    ),
                    TextSpan(
                      text: t.waliSantriDashboard.juzTerselesaikan,
                      style: TextStyle(
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
                '$percent%',
                style: TextStyle(
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
              value: progress,
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
              t.waliSantriDashboard.target(target: '$juzTarget'),
              style: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.w500,
                color: colors.textSecondary,
                fontFamily: 'Poppins',
              ),
            ),
          ),
        ],
      ),
    );
  }
}
