import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_halaqoh/gen/i18n/translations.g.dart';
import 'package:my_halaqoh/src/core/quran/hafalan_progress.dart';
import 'package:my_halaqoh/src/core/router/app_router.dart';
import 'package:my_halaqoh/src/core/service_locator/service_locator.dart';
import 'package:my_halaqoh/src/core/theme/app_colors.dart';
import 'package:my_halaqoh/src/core/widget/widgets.dart';
import 'package:my_halaqoh/src/modules/guru_hafalan/presentation/cubits/progress_hafalan_cubit.dart';
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
import 'package:my_halaqoh/src/modules/master_data/presentation/cubits/santri_extra_target_cubit.dart';
import 'package:my_halaqoh/src/modules/master_data/presentation/cubits/santri_extra_target_state.dart';

/// Detail santri screen showing profile header card, academic info, and progress hafalan
@RoutePage()
class DetailSantriScreen extends StatelessWidget implements AutoRouteWrapper {
  final String name;
  final String nis;

  const DetailSantriScreen({super.key, required this.name, required this.nis});

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final textTheme = Theme.of(context).textTheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Look up real santri data by NIS
    final santriState = context.watch<SantriCubit>().state;
    final halaqohState = context.watch<HalaqohCubit>().state;
    final targetHafalanState = context.watch<TargetHafalanCubit>().state;

    bool isSantriLoading = false;
    SantriModel? santri;
    santriState.maybeWhen(
      initial: () => isSantriLoading = true,
      loading: () => isSantriLoading = true,
      loaded: (list) {
        try {
          santri = list.firstWhere((s) => s.nis == nis);
        } catch (_) {}
      },
      orElse: () {},
    );

    // Look up halaqoh for this santri
    bool isHalaqohLoading = false;
    HalaqohModel? halaqoh;
    if (santri?.halaqohId != null || isSantriLoading) {
      halaqohState.maybeWhen(
        initial: () => isHalaqohLoading = true,
        loading: () => isHalaqohLoading = true,
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

    // Look up extra target juz for this santri
    final extraTargetState = context.watch<SantriExtraTargetCubit>().state;
    final extraJuz = <int>[];
    extraTargetState.maybeWhen(
      loaded: (juzList) => extraJuz.addAll(juzList),
      orElse: () {},
    );

    // Use real data with fallbacks to route params
    final displayName = santri?.nama ?? name;
    final displayNis = santri?.nis ?? nis;
    final displayKelas = santri != null
        ? t.myHalaqohScreen.kelas(kelas: santri!.kelas)
        : '-';
    final displayProgram = santri != null
        ? (santri!.program == 'T'
            ? t.myHalaqohScreen.programTakhassus
            : t.myHalaqohScreen.programReguler)
        : '-';
    final displayHalaqoh = halaqoh?.nama ?? '-';
    final displayPembimbing = halaqoh?.guruNama ?? '-';
    final profilePictureUrl = santri?.profilePicture;

    return Scaffold(
      backgroundColor: colors.background,
      body: SafeArea(
        child: Column(
          children: [
            // ── Top App Bar ───────────────────────────────────────────
            Padding(
              padding: EdgeInsets.only(left: 8.w, top: 8.h, right: 20.w),
              child: Row(
                children: [
                  IconButton(
                    icon: Icon(
                      Icons.arrow_back_rounded,
                      color: colors.textPrimary,
                    ),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  SizedBox(width: 4.w),
                  Text(
                    t.detailSantri.title,
                    style: textTheme.titleLarge?.copyWith(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w700,
                          color: colors.textPrimary,
                        ) ??
                        TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w700,
                          color: colors.textPrimary,
                          fontFamily: 'Poppins',
                        ),
                  ),
                ],
              ),
            ),

            // ── Scrollable Body Content ───────────────────────────────
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 16.h),

                    // 1. Profile Header Hero Card
                    if (isSantriLoading)
                      const ShimmerProfileHeader()
                    else
                      SantriContextHeader(
                        margin: EdgeInsets.symmetric(horizontal: 20.w),
                        name: displayName,
                        nis: displayNis,
                        subtitle: '$displayKelas  •  $displayProgram',
                        profilePictureUrl: profilePictureUrl,
                      ),
                    SizedBox(height: 22.h),

                    // 2. INFORMASI AKADEMIK Section Title (Clean, no icon/subtitle)
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.w),
                      child: _buildSectionTitle(
                        context: context,
                        title: t.detailSantri.informasiAkademik,
                        colors: colors,
                        textTheme: textTheme,
                      ),
                    ),
                    SizedBox(height: 12.h),

                    // Academic Info Card (Stacked format — safe for long pembimbing names)
                    if (isSantriLoading || isHalaqohLoading)
                      const ShimmerAcademicInfo()
                    else
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 20.w),
                        decoration: BoxDecoration(
                          color: colors.surface,
                          borderRadius: BorderRadius.circular(12.r),
                          border: Border.all(
                            color: isDark
                                ? colors.border
                                : colors.border.withValues(alpha: 0.7),
                            width: 0.8,
                          ),
                          boxShadow: isDark
                              ? []
                              : [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.02),
                                    blurRadius: 6,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                        ),
                        child: Column(
                          children: [
                            AcademicInfoRow(
                              icon: Icons.school_rounded,
                              iconColor: colors.primary,
                              iconBgColor:
                                  colors.primary.withValues(alpha: 0.1),
                              label: t.detailSantri.kelas,
                              value: displayKelas,
                            ),
                            AcademicInfoRow(
                              icon: Icons.menu_book_rounded,
                              iconColor: colors.primary,
                              iconBgColor:
                                  colors.primary.withValues(alpha: 0.1),
                              label: t.detailSantri.program,
                              value: displayProgram,
                            ),
                            AcademicInfoRow(
                              icon: Icons.auto_stories_rounded,
                              iconColor: colors.primary,
                              iconBgColor:
                                  colors.primary.withValues(alpha: 0.1),
                              label: t.detailSantri.halaqoh,
                              value: displayHalaqoh,
                            ),
                            AcademicInfoRow(
                              icon: Icons.person_rounded,
                              iconColor: colors.primary,
                              iconBgColor:
                                  colors.primary.withValues(alpha: 0.1),
                              label: t.detailSantri.pembimbing,
                              value: displayPembimbing,
                              showDivider: false,
                            ),
                          ],
                        ),
                      ),
                    SizedBox(height: 22.h),

                    // 3. PROGRESS HAFALAN Section Title (Clean, no icon/subtitle)
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.w),
                      child: _buildSectionTitle(
                        context: context,
                        title: t.detailSantri.progressHafalan,
                        colors: colors,
                        textTheme: textTheme,
                      ),
                    ),
                    SizedBox(height: 12.h),

                    // Progress Hafalan Card
                    BlocBuilder<ProgressHafalanCubit, ProgressHafalanState>(
                      builder: (context, progressState) {
                        bool isProgressLoading = false;
                        OverallHafalanProgress? progressData;
                        progressState.maybeWhen(
                          initial: () => isProgressLoading = true,
                          loading: () => isProgressLoading = true,
                          loaded: (data) => progressData = data,
                          orElse: () {},
                        );
                        if (isSantriLoading ||
                            isHalaqohLoading ||
                            isProgressLoading) {
                          return const ShimmerProgressCard();
                        }
                        return _buildProgressCard(
                          colors: colors,
                          textTheme: textTheme,
                          isDark: isDark,
                          santri: santri,
                          target: target,
                          progressData: progressData,
                          extraJuz: extraJuz,
                        );
                      },
                    ),
                    SizedBox(height: 22.h),

                    // 4. UJIAN SERTIFIKASI Section Title
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.w),
                      child: _buildSectionTitle(
                        context: context,
                        title: 'Ujian Sertifikasi Tahfidz',
                        colors: colors,
                        textTheme: textTheme,
                      ),
                    ),
                    SizedBox(height: 12.h),

                    // Sertifikasi Tahfidz Action Card
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.w),
                      child: Container(
                        padding: EdgeInsets.all(16.w),
                        decoration: BoxDecoration(
                          color: colors.surface,
                          borderRadius: BorderRadius.circular(16.r),
                          border: Border.all(
                            color: isDark
                                ? colors.border
                                : colors.border.withValues(alpha: 0.8),
                            width: 0.8,
                          ),
                          boxShadow: isDark
                              ? []
                              : [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.03),
                                    blurRadius: 8,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  padding: EdgeInsets.all(10.w),
                                  decoration: BoxDecoration(
                                    color: colors.primary.withValues(alpha: 0.12),
                                    borderRadius: BorderRadius.circular(12.r),
                                  ),
                                  child: Icon(
                                    Icons.workspace_premium_rounded,
                                    size: 24.sp,
                                    color: colors.primary,
                                  ),
                                ),
                                SizedBox(width: 12.w),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Ujian Sertifikasi 1 Juz',
                                        style: TextStyle(
                                          fontSize: 14.sp,
                                          fontWeight: FontWeight.w700,
                                          color: colors.textPrimary,
                                          fontFamily: 'Poppins',
                                        ),
                                      ),
                                      SizedBox(height: 2.h),
                                      Text(
                                        'Daftarkan santri ini ke Waka Tahfidz setelah menyelesaikan hafalan 1 juz penuh.',
                                        style: TextStyle(
                                          fontSize: 11.5.sp,
                                          color: colors.textSecondary,
                                          fontFamily: 'Poppins',
                                          height: 1.35,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 14.h),
                            PrimaryButton(
                              onPressed: () {
                                context.router.push(
                                  FormPendaftaranSertifikasiRoute(
                                    preselectedSantri: santri,
                                  ),
                                );
                              },
                              label: 'Daftarkan Sertifikasi',
                              icon: Icons.app_registration_rounded,
                              width: double.infinity,
                              height: 44.h,
                            ),
                          ],
                        ),
                      ),
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

  @override
  Widget wrappedRoute(BuildContext context) {
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

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) {
            final cubit = sl<ProgressHafalanCubit>();
            if (santriId != null) {
              cubit.watchProgress(santriId!);
            }
            return cubit;
          },
        ),
        BlocProvider(
          create: (context) {
            final cubit = sl<SantriExtraTargetCubit>();
            if (santriId != null) {
              cubit.watchExtraJuz(santriId!);
            }
            return cubit;
          },
        ),
      ],
      child: this,
    );
  }

  /// Section title with vertical teal accent bar (▎ Title)
  Widget _buildSectionTitle({
    required BuildContext context,
    required String title,
    required AppColorSet colors,
    required TextTheme textTheme,
  }) {
    return Row(
      children: [
        Container(
          width: 3.5.w,
          height: 16.h,
          decoration: BoxDecoration(
            color: colors.primary,
            borderRadius: BorderRadius.circular(2.r),
          ),
        ),
        SizedBox(width: 8.w),
        Text(
          title,
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
      ],
    );
  }

  /// Progress Hafalan card driven by admin-set and teacher extra memorization targets.
  Widget _buildProgressCard({
    required AppColorSet colors,
    required TextTheme textTheme,
    required bool isDark,
    required SantriModel? santri,
    required TargetHafalanModel? target,
    required OverallHafalanProgress? progressData,
    required List<int> extraJuz,
  }) {
    // ── Admin-defined target juz ──────────────────────────────────────────────
    final adminJuzList = target != null && santri != null
        ? TargetHafalanHelper.getTargetJuzList(
            target,
            santri.kelas,
            santri.program,
          )
        : <int>[];

    // ── Admin progress calculation ────────────────────────────────────────────
    final double juzTargetAdmin = target != null && santri != null
        ? TargetHafalanHelper.getTargetJuzCountDouble(
            target,
            santri.kelas,
            santri.program,
          )
        : 0.0;

    double juzCompletedAdmin = 0.0;
    if (target != null && santri != null && progressData != null) {
      juzCompletedAdmin = TargetHafalanHelper.getCompletedJuzCountDouble(
        targetModel: target,
        kelas: santri.kelas,
        programCode: santri.program,
        progressData: progressData,
      );
    } else if (progressData != null) {
      for (final juzNum in adminJuzList) {
        final jp = progressData.juzProgressList
            .where((j) => j.juzNumber == juzNum)
            .firstOrNull;
        if (jp != null && jp.totalAyat > 0) {
          juzCompletedAdmin += jp.memorizedAyat / jp.totalAyat;
        }
      }
    }

    final double progressAdmin = juzTargetAdmin > 0
        ? (juzCompletedAdmin / juzTargetAdmin).clamp(0.0, 1.0)
        : 0.0;
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
        final jp = progressData.juzProgressList
            .where((j) => j.juzNumber == juzNum)
            .firstOrNull;
        if (jp != null && jp.totalAyat > 0) {
          extraJuzCompleted += jp.memorizedAyat / jp.totalAyat;
        }
      }
    }

    final double progressExtra = juzTargetExtra > 0
        ? (extraJuzCompleted / juzTargetExtra).clamp(0.0, 1.0)
        : 0.0;
    final double percentValueExtra = progressExtra * 100;

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

    String formatJuz(double v) {
      if (v == 0) return '0';
      if (v == v.roundToDouble()) return v.toInt().toString();
      final s = v.toStringAsFixed(2);
      return s.replaceAll(RegExp(r'0+$'), '').replaceAll(RegExp(r'\.$'), '');
    }

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20.w),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: isDark ? colors.border : colors.border.withValues(alpha: 0.7),
          width: 0.8,
        ),
        boxShadow: isDark
            ? []
            : [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.02),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── BLOCK 1: TARGET UTAMA ──
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: '${formatJuz(juzCompletedAdmin)} ',
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
                      style: textTheme.bodySmall?.copyWith(
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

              // Percentage badge
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: colors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Text(
                  '${formatPercent(percentValueAdmin)}%',
                  style: textTheme.titleSmall?.copyWith(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w800,
                        color: colors.primary,
                      ) ??
                      TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w800,
                        color: colors.primary,
                        fontFamily: 'Poppins',
                      ),
                ),
              ),
            ],
          ),
          SizedBox(height: 14.h),

          // Progress bar
          ClipRRect(
            borderRadius: BorderRadius.circular(4.r),
            child: LinearProgressIndicator(
              value: progressAdmin.clamp(0.0, 1.0),
              minHeight: 8.h,
              backgroundColor: colors.primary.withValues(alpha: 0.1),
              valueColor: AlwaysStoppedAnimation<Color>(colors.primary),
            ),
          ),
          SizedBox(height: 10.h),

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

          // ── BLOCK 2: TARGET EKSTRA (Only shown if extraJuzList is not empty) ──
          if (extraJuzList.isNotEmpty) ...[
            SizedBox(height: 14.h),
            Divider(
              color: colors.border.withValues(alpha: 0.5),
              height: 1,
            ),
            SizedBox(height: 14.h),
            Text(
              t.waliSantriDashboard.extraMemorization,
              style: TextStyle(
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
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: '${formatJuz(extraJuzCompleted)} ',
                        style: textTheme.headlineSmall?.copyWith(
                              fontSize: 22.sp,
                              fontWeight: FontWeight.w800,
                              color: colors.textPrimary,
                            ) ??
                            TextStyle(
                              fontSize: 22.sp,
                              fontWeight: FontWeight.w800,
                              color: colors.textPrimary,
                              fontFamily: 'Poppins',
                            ),
                      ),
                      TextSpan(
                        text: t.waliSantriDashboard.juzTerselesaikan,
                        style: textTheme.bodySmall?.copyWith(
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
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: colors.blue.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Text(
                    '${formatPercent(percentValueExtra)}%',
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w800,
                      color: colors.blue,
                      fontFamily: 'Poppins',
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10.h),
            ClipRRect(
              borderRadius: BorderRadius.circular(4.r),
              child: LinearProgressIndicator(
                value: progressExtra.clamp(0.0, 1.0),
                minHeight: 8.h,
                backgroundColor: colors.blue.withValues(alpha: 0.1),
                valueColor: AlwaysStoppedAnimation<Color>(colors.blue),
              ),
            ),
            SizedBox(height: 10.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    t.waliSantriDashboard.juzList(juz: extraJuzList.join(', ')),
                    style: TextStyle(
                      fontSize: 11.5.sp,
                      fontWeight: FontWeight.w500,
                      color: colors.textSecondary,
                      fontFamily: 'Poppins',
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                SizedBox(width: 8.w),
                Text(
                  t.waliSantriDashboard.extraJuzTarget(count: juzTargetExtra),
                  style: TextStyle(
                    fontSize: 11.5.sp,
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
