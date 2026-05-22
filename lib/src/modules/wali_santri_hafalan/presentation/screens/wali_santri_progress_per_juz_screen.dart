import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_halaqoh/gen/i18n/translations.g.dart';
import 'package:my_halaqoh/src/core/quran/quran_service.dart';
import 'package:my_halaqoh/src/core/router/app_router.dart';
import 'package:my_halaqoh/src/core/theme/app_colors.dart';
import 'package:my_halaqoh/src/modules/auth/presentation/cubits/auth_cubit.dart';
import 'package:my_halaqoh/src/modules/auth/presentation/cubits/auth_state.dart';
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
import 'package:my_halaqoh/src/core/quran/hafalan_progress.dart';
import 'package:my_halaqoh/src/modules/wali_santri_hafalan/presentation/cubits/wali_santri_progress_hafalan_cubit.dart';
import 'package:my_halaqoh/src/modules/master_data/presentation/cubits/santri_extra_target_cubit.dart';
import 'package:my_halaqoh/src/modules/master_data/presentation/cubits/santri_extra_target_state.dart';

/// Progress Hafalan Per Juz — shows juz-level progress cards for a santri (Wali Santri view)
@RoutePage()
class WaliSantriProgressPerJuzScreen extends StatefulWidget {
  final String name;
  final String nis;

  const WaliSantriProgressPerJuzScreen({
    super.key,
    required this.name,
    required this.nis,
  });

  @override
  State<WaliSantriProgressPerJuzScreen> createState() =>
      _WaliSantriProgressPerJuzScreenState();
}

class _WaliSantriProgressPerJuzScreenState
    extends State<WaliSantriProgressPerJuzScreen> {
  late WaliSantriProgressHafalanCubit _progressCubit;
  late SantriExtraTargetCubit _extraTargetCubit;
  String? _loadedLinkedDocId;

  @override
  void initState() {
    super.initState();
    _progressCubit = sl<WaliSantriProgressHafalanCubit>();
    _extraTargetCubit = sl<SantriExtraTargetCubit>();
  }

  @override
  void dispose() {
    _progressCubit.close();
    _extraTargetCubit.close();
    super.dispose();
  }

  void _checkAndLoadData(String linkedDocId) {
    if (linkedDocId.isNotEmpty && linkedDocId != _loadedLinkedDocId) {
      _loadedLinkedDocId = linkedDocId;
      _progressCubit.watchProgress(linkedDocId);
      // linkedDocId == santriId for wali santri accounts
      _extraTargetCubit.watchExtraJuz(linkedDocId);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);

    // Look up the santri — try by linkedDocId first (most reliable for wali),
    // then fall back to NIS lookup
    final authState = context.watch<AuthCubit>().state;
    final santriState = context.watch<SantriCubit>().state;
    final targetHafalanState = context.watch<TargetHafalanCubit>().state;

    String linkedDocId = '';
    authState.maybeWhen(
      authenticated: (userMeta) {
        linkedDocId = userMeta.linkedDocId;
      },
      orElse: () {},
    );

    // Fetch data if needed
    _checkAndLoadData(linkedDocId);

    SantriModel? santri;
    santriState.maybeWhen(
      loaded: (list) {
        try {
          santri = list.firstWhere((s) => s.id == linkedDocId);
        } catch (_) {
          try {
            santri = list.firstWhere((s) => s.nis == widget.nis);
          } catch (_) {}
        }
      },
      orElse: () {},
    );

    // Find the admin-defined target for this santri's kelas + program
    TargetHafalanModel? target;
    targetHafalanState.maybeWhen(
      loaded: (targets) {
        if (santri != null) {
          target = TargetHafalanHelper.findTarget(
            targets,
            santri!.kelas,
            santri!.program,
          );
        }
      },
      orElse: () {},
    );

    return BlocProvider.value(
      value: _progressCubit,
      child: BlocProvider.value(
        value: _extraTargetCubit,
        child: BlocBuilder<WaliSantriProgressHafalanCubit, WaliSantriProgressHafalanState>(
        builder: (context, progressState) {
          OverallHafalanProgress? progressData;
          progressState.maybeWhen(
            loaded: (data) => progressData = data,
            orElse: () {},
          );

          // ── Extra juz added by teacher (Firestore-persisted) ─────────────
          final extraJuzState = context.watch<SantriExtraTargetCubit>().state;
          final extraJuz = <int>[];
          extraJuzState.maybeWhen(
            loaded: (juzList) => extraJuz.addAll(juzList),
            orElse: () {},
          );

          // ── Part 1 fix: always surface juz with real memorized ayat ──────
          // Keeps progress visible even when admin changes the semester.
          final progressJuzNums = progressData?.juzProgressList
                  .where((jp) => jp.memorizedAyat > 0)
                  .map((jp) => jp.juzNumber)
                  .toSet() ??
              <int>{};

          // ── Combine all juz sources ──────────────────────────────────────
          final adminJuzList = target != null && santri != null
              ? TargetHafalanHelper.getTargetJuzList(
                  target, santri!.kelas, santri!.program)
              : <int>[];

          final allJuzNums = <int>{
            ...adminJuzList,    // admin-defined curriculum targets
            ...extraJuz,        // teacher-added (Firestore-persisted)
            ...progressJuzNums, // any juz with actual progress (never hidden)
          };

          // Build juz display data from combined juz set + QuranService
          final juzDisplayData = allJuzNums.map((juzNum) {
            final juzModel = QuranService.instance.getJuzByNumber(juzNum);
            int totalAyat = juzModel?.totalAyat ?? 0;
            int memorizedAyat = 0;

            if (progressData != null) {
              final juzProgress = progressData!.juzProgressList
                  .where((jp) => jp.juzNumber == juzNum)
                  .firstOrNull;
              if (juzProgress != null) {
                totalAyat = juzProgress.totalAyat;
                memorizedAyat = juzProgress.memorizedAyat;
              }
            }

            return {
              'juz': juzNum,
              'total': totalAyat,
              'completed': memorizedAyat,
            };
          }).toList()
            ..sort((a, b) => (b['juz'] as int).compareTo(a['juz'] as int));

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
                          t.progressHafalanPerJuz.title,
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
                          _buildProfileCard(context, colors, santri),
                          SizedBox(height: 20.h),

                          // Target Hafalan header
                          Text(
                            t.progressHafalanPerJuz.targetHafalan,
                            style: TextStyle(
                              fontSize: 18.sp,
                              fontWeight: FontWeight.w700,
                              color: colors.textPrimary,
                              fontFamily: 'Poppins',
                            ),
                          ),
                          SizedBox(height: 4.h),
                          Text(
                            t.progressHafalanPerJuz.pilihJuz,
                            style: TextStyle(
                              fontSize: 13.sp,
                              fontWeight: FontWeight.w400,
                              color: colors.textSecondary,
                              fontFamily: 'Poppins',
                            ),
                          ),
                          SizedBox(height: 14.h),

                          // Juz cards or contextual empty state
                          if (juzDisplayData.isEmpty)
                            _buildEmptyState(colors, target, santri)
                          else
                            ...juzDisplayData.map(
                              (juz) => _buildJuzCard(context, juz, colors),
                            ),
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
      ),
    ),
  );
}

  Widget _buildEmptyState(
    AppColorSet colors,
    TargetHafalanModel? target,
    SantriModel? santri,
  ) {
    final reason = TargetHafalanHelper.getEmptyStateReason(
      target: target,
      kelas: santri?.kelas,
      programCode: santri?.program,
    );

    // Icon per reason kind — accent is always colors.primary (no hardcoded hex)
    final IconData icon;
    switch (reason.kind) {
      case EmptyTargetKind.idadTahsin:
        icon = Icons.auto_stories_outlined;
        break;
      case EmptyTargetKind.dauroh:
        icon = Icons.bolt_outlined;
        break;
      case EmptyTargetKind.uat:
        icon = Icons.verified_outlined;
        break;
      case EmptyTargetKind.unknownCurriculum:
        icon = Icons.help_outline;
        break;
      case EmptyTargetKind.noAdminConfig:
        icon = Icons.settings_outlined;
        break;
    }

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 24.h),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(20.w),
        decoration: BoxDecoration(
          color: colors.primary.withValues(alpha: 0.07),
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(color: colors.primary.withValues(alpha: 0.25), width: 1),
        ),
        child: Column(
          children: [
            Container(
              width: 56.w,
              height: 56.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: colors.primary.withValues(alpha: 0.12),
              ),
              child: Icon(icon, size: 28.sp, color: colors.primary),
            ),
            SizedBox(height: 14.h),
            Text(
              reason.label,
              style: TextStyle(
                fontSize: 15.sp,
                fontWeight: FontWeight.w700,
                color: colors.primary,
                fontFamily: 'Poppins',
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 8.h),
            Text(
              reason.description,
              style: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.w400,
                color: colors.textSecondary,
                fontFamily: 'Poppins',
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileCard(
      BuildContext context, AppColorSet colors, SantriModel? santri) {
    // Use real santri data, fall back to route params
    final displayName = santri?.nama ?? widget.name;
    final displayNis = santri?.nis ?? widget.nis;

    // Look up halaqoh for kelas info
    final halaqohState = context.watch<HalaqohCubit>().state;
    HalaqohModel? myHalaqoh;
    halaqohState.maybeWhen(
      loaded: (list) {
        try {
          if (santri != null) {
            myHalaqoh = list.firstWhere(
                (h) => h.santriIds.contains(santri.id));
          }
        } catch (_) {}
      },
      orElse: () {},
    );

    final halaqohInfo = myHalaqoh != null
        ? t.riwayatHafalanSantri.halaqohKelas(
            halaqoh: myHalaqoh!.nama, kelas: myHalaqoh!.kelas)
        : (santri != null ? 'Kelas ${santri.kelas}' : '');

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
              image: santri?.profilePicture != null
                  ? DecorationImage(
                      image: NetworkImage(santri!.profilePicture!),
                      fit: BoxFit.cover,
                    )
                  : null,
            ),
            child: santri?.profilePicture == null
                ? Icon(Icons.person, size: 26.sp, color: Colors.white)
                : null,
          ),
          SizedBox(width: 14.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  displayName,
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                    fontFamily: 'Poppins',
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  'NIS: $displayNis',
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w400,
                    color: Colors.white.withValues(alpha: 0.85),
                    fontFamily: 'Poppins',
                  ),
                ),
                if (halaqohInfo.isNotEmpty)
                  Text(
                    halaqohInfo,
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

  Widget _buildJuzCard(
    BuildContext context,
    Map<String, dynamic> juz,
    AppColorSet colors,
  ) {
    final juzNum = juz['juz'] as int;
    final total = juz['total'] as int;
    final completed = juz['completed'] as int;
    final percent = total > 0 ? (completed / total * 100).round() : 0;
    final progress = total > 0 ? completed / total : 0.0;

    return GestureDetector(
      onTap: () {
        context.router.push(
          WaliSantriProgressPerSuratRoute(
            name: widget.name,
            nis: widget.nis,
            juzNumber: juzNum,
          ),
        );
      },
      child: Container(
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Juz $juzNum',
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w700,
                        color: colors.textPrimary,
                        fontFamily: 'Poppins',
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      t.progressHafalanPerJuz.suratSelesai(
                        completed: '$completed',
                        total: '$total',
                      ),
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
                  '$percent %',
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
            Row(
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(4.r),
                    child: LinearProgressIndicator(
                      value: progress,
                      minHeight: 6.h,
                      backgroundColor: colors.border,
                      valueColor:
                          AlwaysStoppedAnimation<Color>(colors.primary),
                    ),
                  ),
                ),
                SizedBox(width: 12.w),
                Icon(
                  Icons.chevron_right,
                  size: 22.sp,
                  color: colors.textSecondary,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
