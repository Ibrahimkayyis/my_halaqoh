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
import 'package:intl/intl.dart';
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
        child: Column(
          children: [
            // ── Green gradient profile header ──
            _buildProfileHeader(
              colors: colors,
              santriName: santriName.isNotEmpty ? santriName : t.waliSantriDashboard.loading,
              nis: nis,
              halaqohInfo: myHalaqoh != null
                  ? t.waliSantriDashboard.halaqohInfo(kelas: '${myHalaqoh!.kelas}${myHalaqoh!.program}', halaqoh: myHalaqoh!.nama)
                  : t.waliSantriDashboard.notRegisteredHalaqoh,
              guruName: myHalaqoh?.guruNama,
              profilePictureUrl: mySantri?.profilePicture,
            ),
            SizedBox(height: 24.h),

            // ── Progress Hafalan card ──
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
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
                        return _buildProgressHafalanCard(
                          context,
                          colors,
                          mySantri,
                          myTarget,
                          progressData,
                          extraJuz,
                        );
                      },
                    );
                  },
                ),
              ),
            ),
            SizedBox(height: 16.h),

            // ── Kehadiran card ──
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: GestureDetector(
                onTap: () => widget.onNavigateToTab?.call(2),
                child: BlocBuilder<AbsensiCubit, AbsensiState>(
                  builder: (context, state) {
                    List<AbsensiModel> allRecords = [];
                    state.maybeWhen(
                      loaded: (records) => allRecords = records,
                      orElse: () {},
                    );
                    return _buildKehadiranCard(colors, nis, allRecords);
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

  Widget _buildProfileHeader({
    required AppColorSet colors,
    required String santriName,
    required String nis,
    required String halaqohInfo,
    String? guruName,
    String? profilePictureUrl,
  }) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [colors.primary, colors.primary.withValues(alpha: 0.85)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(28.r),
          bottomRight: Radius.circular(28.r),
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: EdgeInsets.fromLTRB(24.w, 20.h, 24.w, 32.h),
          child: Column(
            children: [
              // Avatar
              Container(
                width: 80.w,
                height: 80.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withValues(alpha: 0.2),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.4),
                    width: 3,
                  ),
                  image: profilePictureUrl != null
                      ? DecorationImage(
                          image: NetworkImage(profilePictureUrl),
                          fit: BoxFit.cover,
                        )
                      : null,
                ),
                child: profilePictureUrl == null
                    ? Icon(Icons.person, size: 40.sp, color: Colors.white)
                    : null,
              ),
              SizedBox(height: 14.h),

              // Name
              Text(
                santriName,
                style: TextStyle(
                  fontSize: 22.sp,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                  fontFamily: 'Poppins',
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 4.h),

              // NIS
              if (nis.isNotEmpty)
                Text(
                  t.waliSantriDashboard.nis(nis: nis),
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w500,
                    color: Colors.white.withValues(alpha: 0.9),
                    fontFamily: 'Poppins',
                  ),
                ),
              SizedBox(height: 8.h),

              // Kelas & Halaqoh
              Text(
                halaqohInfo,
                style: TextStyle(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w400,
                  color: Colors.white.withValues(alpha: 0.85),
                  fontFamily: 'Poppins',
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 2.h),

              // Guru
              if (guruName != null)
                Text(
                  t.waliSantriDashboard.guru(name: guruName),
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w400,
                    color: Colors.white.withValues(alpha: 0.85),
                    fontFamily: 'Poppins',
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProgressHafalanCard(
    BuildContext context,
    AppColorSet colors,
    SantriModel? santri,
    TargetHafalanModel? target,
    OverallHafalanProgress? progressData,
    List<int> extraJuz,
  ) {
    // ── Admin-defined target juz ──────────────────────────────────────────────
    final adminJuzList = target != null && santri != null
        ? TargetHafalanHelper.getTargetJuzList(target, santri.kelas, santri.program)
        : <int>[];

    // ── Admin progress calculation ────────────────────────────────────────────
    final int juzTargetAdmin = adminJuzList.length;
    double juzCompletedAdmin = 0.0;
    if (progressData != null) {
      for (final juzNum in adminJuzList) {
        final jp = progressData.juzProgressList
            .where((j) => j.juzNumber == juzNum)
            .firstOrNull;
        if (jp != null && jp.totalAyat > 0) {
          juzCompletedAdmin += jp.memorizedAyat / jp.totalAyat;
        }
      }
    }

    final double progressAdmin = juzTargetAdmin > 0 ? juzCompletedAdmin / juzTargetAdmin : 0.0;
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

    final double progressExtra = juzTargetExtra > 0 ? extraJuzCompleted / juzTargetExtra : 0.0;
    final double percentValueExtra = progressExtra * 100;

    // Format percentage accurately: show up to 2 decimal places, trim trailing zeros
    String formatPercent(double v) {
      if (v == 0) return '0';
      if (v >= 1) {
        // For values >= 1%, show integer if whole, otherwise 1 decimal
        final rounded = double.parse(v.toStringAsFixed(1));
        return rounded == rounded.roundToDouble()
            ? rounded.toInt().toString()
            : rounded.toStringAsFixed(1);
      }
      // For small values < 1%, show up to 2 decimal places, trim trailing zeros
      final s = v.toStringAsFixed(2);
      // Remove trailing zeros after decimal point
      return s.replaceAll(RegExp(r'0+$'), '').replaceAll(RegExp(r'\.$'), '');
    }

    // Format juzCompleted to remove .0 if it's a whole number, otherwise show 2 decimals
    String formatJuz(double v) {
      if (v == 0) return '0';
      return v == v.roundToDouble() ? v.toInt().toString() : v.toStringAsFixed(2);
    }

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(18.w),
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
              Icon(
                Icons.chevron_right,
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
                '${formatPercent(percentValueAdmin)}%',
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
              value: progressAdmin,
              minHeight: 10.h,
              backgroundColor: colors.border.withValues(alpha: 0.3),
              valueColor: AlwaysStoppedAnimation<Color>(colors.primary),
            ),
          ),
          SizedBox(height: 8.h),

          // Target text
          SizedBox(height: 8.h),
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              t.waliSantriDashboard.target(target: '$juzTargetAdmin'),
              style: TextStyle(
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
              children: [
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: '${formatJuz(extraJuzCompleted)} ',
                        style: TextStyle(
                          fontSize: 24.sp,
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
                  '${formatPercent(percentValueExtra)}%',
                  style: TextStyle(
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
                  style: TextStyle(
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w500,
                    color: colors.textSecondary,
                    fontFamily: 'Poppins',
                  ),
                ),
                Text(
                  t.waliSantriDashboard.extraJuzTarget(count: juzTargetExtra),
                  style: TextStyle(
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

  Widget _buildKehadiranCard(
    AppColorSet colors,
    String nis,
    List<AbsensiModel> allRecords,
  ) {
    final now = DateTime.now();
    final stats = _computeMonthlyAttendanceStats(
      allRecords,
      nis,
      now.month,
      now.year,
    );
    final periodName = DateFormat.yMMMM(t.$meta.locale.languageCode).format(now);

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(18.w),
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
              Icon(Icons.calendar_today, size: 18.sp, color: colors.primary),
              SizedBox(width: 8.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      t.waliSantriDashboard.kehadiran,
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w700,
                        color: colors.textPrimary,
                        fontFamily: 'Poppins',
                      ),
                    ),
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
                Icons.chevron_right,
                size: 22.sp,
                color: colors.textSecondary,
              ),
            ],
          ),
          SizedBox(height: 18.h),

          // Attendance stats grid (2x3)
          Row(
            children: [
              Expanded(
                child: _buildAttendanceStat(
                  t.detailAbsensiHariIni.hadirBarcode,
                  '${stats['hadir_barcode']}',
                  colors.primary,
                  colors,
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: _buildAttendanceStat(
                  t.detailAbsensiHariIni.hadirManual,
                  '${stats['hadir_manual']}',
                  colors.green,
                  colors,
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Row(
            children: [
              Expanded(
                child: _buildAttendanceStat(
                  t.detailAbsensiHariIni.terlambat,
                  '${stats['terlambat']}',
                  const Color(0xFFF3722C),
                  colors,
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: _buildAttendanceStat(
                  t.waliSantriDashboard.sakit,
                  '${stats['sakit']}',
                  colors.yellow,
                  colors,
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Row(
            children: [
              Expanded(
                child: _buildAttendanceStat(
                  t.waliSantriDashboard.izin,
                  '${stats['izin']}',
                  colors.blue,
                  colors,
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: _buildAttendanceStat(
                  t.waliSantriDashboard.alpha,
                  '${stats['alfa']}',
                  colors.red,
                  colors,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAttendanceStat(
    String label,
    String value,
    Color dotColor,
    AppColorSet colors,
  ) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: colors.background,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        children: [
          Container(
            width: 10.w,
            height: 10.w,
            decoration: BoxDecoration(shape: BoxShape.circle, color: dotColor),
          ),
          SizedBox(width: 8.w),
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 11.5.sp,
                fontWeight: FontWeight.w500,
                color: colors.textSecondary,
                fontFamily: 'Poppins',
                height: 1.2,
              ),
            ),
          ),
          SizedBox(width: 8.w),
          Text(
            value,
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w700,
              color: colors.textPrimary,
              fontFamily: 'Poppins',
            ),
          ),
        ],
      ),
    );
  }
}
