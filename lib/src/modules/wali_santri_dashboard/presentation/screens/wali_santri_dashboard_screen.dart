import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_halaqoh/gen/i18n/translations.g.dart';
import 'package:my_halaqoh/src/core/theme/app_colors.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_halaqoh/src/modules/auth/presentation/cubits/auth_cubit.dart';
import 'package:my_halaqoh/src/modules/auth/presentation/cubits/auth_state.dart';
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
  String? _loadedLinkedDocId;
  String? _loadedHalaqohId;

  @override
  void initState() {
    super.initState();
    _progressHafalanCubit = sl<WaliSantriProgressHafalanCubit>();
    _absensiCubit = sl<AbsensiCubit>();
  }

  @override
  void dispose() {
    _progressHafalanCubit.close();
    _absensiCubit.close();
    super.dispose();
  }

  void _checkAndLoadData(String linkedDocId, String? halaqohId) {
    if (linkedDocId.isNotEmpty && linkedDocId != _loadedLinkedDocId) {
      _loadedLinkedDocId = linkedDocId;
      _progressHafalanCubit.watchProgress(linkedDocId);
    }
    if (halaqohId != null && halaqohId != _loadedHalaqohId) {
      _loadedHalaqohId = halaqohId;
      _absensiCubit.watchByHalaqoh(halaqohId);
    }
  }

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

    return {'hadir': hadir, 'sakit': sakit, 'izin': izin, 'alfa': alfa};
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);

    // Retrieve contextual states
    final authState = context.watch<AuthCubit>().state;
    final halaqohState = context.watch<HalaqohCubit>().state;
    final santriState = context.watch<SantriCubit>().state;
    final targetHafalanState = context.watch<TargetHafalanCubit>().state;

    String santriName = '';
    String linkedDocId = '';
    String nis = '';

    authState.maybeWhen(
      authenticated: (userMeta) {
        santriName = userMeta.displayName;
        linkedDocId = userMeta.linkedDocId;
        nis = userMeta.identifier;
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
      ],
      child: Scaffold(
      backgroundColor: colors.background,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // ── Green gradient profile header ──
            _buildProfileHeader(
              colors: colors,
              santriName: santriName.isNotEmpty ? santriName : 'Memuat...',
              nis: nis,
              halaqohInfo: myHalaqoh != null
                  ? 'Kelas ${myHalaqoh!.kelas}${myHalaqoh!.program} | Halaqoh ${myHalaqoh!.nama}'
                  : 'Belum terdaftar di Halaqoh mana pun',
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
                  builder: (context, state) {
                    OverallHafalanProgress? progressData;
                    state.maybeWhen(
                      loaded: (data) => progressData = data,
                      orElse: () {},
                    );
                    return _buildProgressHafalanCard(
                      context,
                      colors,
                      mySantri,
                      myTarget,
                      progressData,
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
                  'NIS: $nis',
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
                  'Guru: $guruName',
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
  ) {
    final int juzTarget = target != null && santri != null 
        ? TargetHafalanHelper.getTargetJuzCount(target, santri.kelas, santri.program) 
        : 0;
    
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
    final periodName = DateFormat.yMMMM('id').format(now);

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

          // Attendance stats grid (2x2)
          Row(
            children: [
              Expanded(
                child: _buildAttendanceStat(
                  t.waliSantriDashboard.hadir,
                  '${stats['hadir']}',
                  colors.primary,
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
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
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
          Text(
            label,
            style: TextStyle(
              fontSize: 13.sp,
              fontWeight: FontWeight.w500,
              color: colors.textSecondary,
              fontFamily: 'Poppins',
            ),
          ),
          const Spacer(),
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
