import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_halaqoh/gen/i18n/translations.g.dart';
import 'package:my_halaqoh/src/core/theme/app_colors.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_halaqoh/src/modules/auth/presentation/cubits/auth_cubit.dart';
import 'package:my_halaqoh/src/modules/auth/presentation/cubits/auth_state.dart';
import 'package:my_halaqoh/src/core/helpers/active_session_helper.dart';
import 'package:my_halaqoh/src/modules/master_data/presentation/cubits/halaqoh_cubit.dart';
import 'package:my_halaqoh/src/modules/master_data/domain/models/halaqoh_model.dart';
import 'package:my_halaqoh/src/modules/master_data/presentation/cubits/halaqoh_state.dart';
import 'package:my_halaqoh/src/modules/master_data/presentation/cubits/santri_cubit.dart';
import 'package:my_halaqoh/src/modules/master_data/presentation/cubits/santri_state.dart';
import 'package:my_halaqoh/src/modules/master_data/domain/models/santri_model.dart';
import 'package:my_halaqoh/src/modules/master_data/domain/models/target_hafalan_model.dart';
import 'package:my_halaqoh/src/modules/master_data/domain/helpers/target_hafalan_helper.dart';
import 'package:my_halaqoh/src/modules/master_data/presentation/cubits/target_hafalan_cubit.dart';
import 'package:my_halaqoh/src/modules/master_data/presentation/cubits/target_hafalan_state.dart';
import 'package:my_halaqoh/src/modules/master_data/presentation/cubits/santri_extra_target_cubit.dart';
import 'package:my_halaqoh/src/modules/master_data/presentation/cubits/santri_extra_target_state.dart';
import 'package:my_halaqoh/src/modules/wali_santri_dashboard/presentation/widgets/wali_santri_dashboard_header.dart';
import 'package:my_halaqoh/src/modules/wali_santri_dashboard/presentation/widgets/wali_santri_progress_card.dart';
import 'package:my_halaqoh/src/modules/wali_santri_dashboard/presentation/widgets/wali_santri_attendance_card.dart';
import 'package:my_halaqoh/src/core/service_locator/service_locator.dart';
import 'package:my_halaqoh/src/modules/wali_santri_hafalan/presentation/cubits/wali_santri_progress_hafalan_cubit.dart';
import 'package:my_halaqoh/src/core/quran/hafalan_progress.dart';
import 'package:my_halaqoh/src/modules/guru_absensi/domain/models/absensi_model.dart';
import 'package:my_halaqoh/src/modules/guru_absensi/presentation/cubits/absensi_cubit.dart';
import 'package:my_halaqoh/src/modules/guru_absensi/presentation/cubits/absensi_state.dart';

/// Dashboard content page for Wali Santri role
class WaliSantriDashboardScreen extends StatefulWidget {
  final void Function(int index)? onNavigateToTab;
  final String programType;

  const WaliSantriDashboardScreen({
    super.key,
    this.onNavigateToTab,
    this.programType = 'reguler',
  });

  @override
  State<WaliSantriDashboardScreen> createState() =>
      _WaliSantriDashboardScreenState();
}

class _WaliSantriDashboardScreenState extends State<WaliSantriDashboardScreen> {
  late WaliSantriProgressHafalanCubit _progressHafalanCubit;
  late AbsensiCubit _absensiCubit;
  late SantriExtraTargetCubit _extraTargetCubit;
  String? _loadedLinkedDocId;
  String? _loadedHalaqohId;

  @override
  void initState() {
    super.initState();
    _progressHafalanCubit = sl<WaliSantriProgressHafalanCubit>();
    _absensiCubit = sl<AbsensiCubit>();
    _extraTargetCubit = sl<SantriExtraTargetCubit>();
  }

  @override
  void dispose() {
    _progressHafalanCubit.close();
    _absensiCubit.close();
    _extraTargetCubit.close();
    super.dispose();
  }

  void _checkAndLoadData(String linkedDocId, String? halaqohId) {
    if (linkedDocId.isNotEmpty && linkedDocId != _loadedLinkedDocId) {
      _loadedLinkedDocId = linkedDocId;
      _progressHafalanCubit.watchProgress(linkedDocId);
      _extraTargetCubit.watchExtraJuz(linkedDocId);
    }
    if (halaqohId != null && halaqohId != _loadedHalaqohId) {
      _loadedHalaqohId = halaqohId;
      _absensiCubit.watchByHalaqohFromRemote(halaqohId);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);

    // Retrieve contextual states
    final authState = context.watch<AuthCubit>().state;
    final halaqohState = context.watch<HalaqohCubit>().state;
    final santriState = context.watch<SantriCubit>().state;
    final targetHafalanState = context.watch<TargetHafalanCubit>().state;

    final linkedDocId = ActiveSessionHelper.getActiveLinkedDocId(context) ?? '';

    // Fallback values from AuthCubit
    String authSantriName = '';
    String authNis = '';
    authState.maybeWhen(
      authenticated: (userMeta) {
        authSantriName = userMeta.displayName;
        authNis = userMeta.identifier;
      },
      orElse: () {},
    );

    HalaqohModel? myHalaqoh;
    halaqohState.maybeWhen(
      loaded: (list) {
        try {
          myHalaqoh = list.firstWhere((h) => h.santriIds.contains(linkedDocId));
        } catch (_) {}
      },
      orElse: () {},
    );

    // Trigger data loading once context is known
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkAndLoadData(linkedDocId, myHalaqoh?.id);
    });

    // Look up the linked santri to get kelas and program
    SantriModel? mySantri;
    santriState.maybeWhen(
      loaded: (list) {
        try {
          mySantri = list.firstWhere((s) => s.id == linkedDocId);
        } catch (_) {}
      },
      orElse: () {},
    );

    final santriName = mySantri?.nama ?? authSantriName;
    final nis = mySantri?.nis ?? authNis;

    // Look up the admin-defined target for this santri's kelas + program
    TargetHafalanModel? myTarget;
    if (mySantri != null) {
      targetHafalanState.maybeWhen(
        loaded: (targets) {
          myTarget = TargetHafalanHelper.findTarget(
            targets,
            mySantri!.kelas,
            mySantri!.program,
          );
        },
        orElse: () {},
      );
    }

    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: _progressHafalanCubit),
        BlocProvider.value(value: _absensiCubit),
        BlocProvider.value(value: _extraTargetCubit),
      ],
      child: Scaffold(
        backgroundColor: colors.background,
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── 1. Header (Logo + Logout + Mosque Silhouette Card) ──
              WaliSantriDashboardHeader(
                santriName: santriName.isNotEmpty ? santriName : t.waliSantriDashboard.loading,
                nis: nis,
                halaqohInfo: myHalaqoh != null
                    ? t.waliSantriDashboard.halaqohInfo(kelas: '${myHalaqoh!.kelas}${myHalaqoh!.program}', halaqoh: myHalaqoh!.nama)
                    : t.waliSantriDashboard.notRegisteredHalaqoh,
                guruName: myHalaqoh?.guruNama,
                profilePictureUrl: mySantri?.profilePicture,
              ),
              SizedBox(height: 20.h),

              // ── 2. Section 1: Progress Hafalan ────────────────────
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: _buildSectionTitle(
                  title: t.waliSantriDashboard.progressHafalan,
                  colors: colors,
                  textTheme: Theme.of(context).textTheme,
                ),
              ),
              SizedBox(height: 12.h),

              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: GestureDetector(
                  onTap: () => widget.onNavigateToTab?.call(1),
                  child: BlocBuilder<WaliSantriProgressHafalanCubit, WaliSantriProgressHafalanState>(
                    builder: (context, progressState) {
                      OverallHafalanProgress? progressData;
                      progressState.maybeWhen(
                        loaded: (data) => progressData = data,
                        orElse: () {},
                      );
                      return BlocBuilder<SantriExtraTargetCubit, SantriExtraTargetState>(
                        builder: (context, extraState) {
                          final extraJuz = <int>[];
                          extraState.maybeWhen(
                            loaded: (juzList) => extraJuz.addAll(juzList),
                            orElse: () {},
                          );

                          return WaliSantriProgressCard(
                            santri: mySantri,
                            target: myTarget,
                            progressData: progressData,
                            extraJuz: extraJuz,
                          );
                        },
                      );
                    },
                  ),
                ),
              ),
              SizedBox(height: 22.h),

              // ── 3. Section 2: Kehadiran Santri ────────────────────
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: _buildSectionTitle(
                  title: t.waliSantriDashboard.kehadiran,
                  colors: colors,
                  textTheme: Theme.of(context).textTheme,
                ),
              ),
              SizedBox(height: 12.h),

              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: GestureDetector(
                  onTap: () => widget.onNavigateToTab?.call(2),
                  child: BlocBuilder<AbsensiCubit, AbsensiState>(
                    builder: (context, state) {
                      List<AbsensiModel> allRecords = [];
                      state.maybeWhen(
                        loaded: (records) => allRecords = records,
                        orElse: () {},
                      );
                      return WaliSantriAttendanceCard(
                        nis: nis,
                        allRecords: allRecords,
                        programType: mySantri?.program ?? widget.programType,
                      );
                    },
                  ),
                ),
              ),
              SizedBox(height: 100.h), // Space for bottom bar
            ],
          ),
        ),
      ),
    );
  }

  /// Section title with vertical teal accent bar (matching Guru Dashboard)
  Widget _buildSectionTitle({
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
}
