import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_halaqoh/gen/i18n/translations.g.dart';
import 'package:my_halaqoh/src/core/quran/hafalan_progress.dart';
import 'package:my_halaqoh/src/core/quran/quran_service.dart';
import 'package:my_halaqoh/src/core/router/app_router.dart';
import 'package:my_halaqoh/src/core/service_locator/service_locator.dart';
import 'package:my_halaqoh/src/core/theme/app_colors.dart';
import 'package:my_halaqoh/src/core/widget/widgets.dart';
import 'package:my_halaqoh/src/modules/guru_hafalan/presentation/cubits/progress_hafalan_cubit.dart';
import 'package:my_halaqoh/src/modules/master_data/domain/helpers/target_hafalan_helper.dart';
import 'package:my_halaqoh/src/modules/master_data/domain/models/santri_model.dart';
import 'package:my_halaqoh/src/modules/master_data/domain/models/target_hafalan_model.dart';
import 'package:my_halaqoh/src/modules/master_data/presentation/cubits/santri_cubit.dart';
import 'package:my_halaqoh/src/modules/master_data/presentation/cubits/santri_state.dart';
import 'package:my_halaqoh/src/modules/master_data/presentation/cubits/santri_extra_target_cubit.dart';
import 'package:my_halaqoh/src/modules/master_data/presentation/cubits/santri_extra_target_state.dart';
import 'package:my_halaqoh/src/modules/master_data/presentation/cubits/target_hafalan_cubit.dart';
import 'package:my_halaqoh/src/modules/master_data/presentation/cubits/target_hafalan_state.dart';

/// Progress Hafalan Per Juz — shows juz-level progress cards for a santri
@RoutePage()
class ProgressHafalanPerJuzScreen extends StatefulWidget
    implements AutoRouteWrapper {
  final String santriId;
  final String name;
  final String nis;

  const ProgressHafalanPerJuzScreen({
    super.key,
    required this.santriId,
    required this.name,
    required this.nis,
  });

  @override
  Widget wrappedRoute(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => sl<ProgressHafalanCubit>()..watchProgress(santriId),
        ),
        BlocProvider(
          create: (_) =>
              sl<SantriExtraTargetCubit>()..watchExtraJuz(santriId),
        ),
      ],
      child: this,
    );
  }

  @override
  State<ProgressHafalanPerJuzScreen> createState() =>
      _ProgressHafalanPerJuzScreenState();
}

class _ProgressHafalanPerJuzScreenState
    extends State<ProgressHafalanPerJuzScreen> {
  /// Returns the juz numbers from official targets (admin + guru) that are
  /// not yet 100% complete. Used only for the warning banner — never to block.
  List<int> _getIncompleteTargetJuz(
    List<Map<String, dynamic>> juzData,
    Set<int> officialTargetJuzNums,
  ) {
    return juzData
        .where((juz) {
          final juzNum = juz['juz'] as int;
          if (!officialTargetJuzNums.contains(juzNum)) return false;
          final total = juz['total'] as int;
          final completed = juz['completed'] as int;
          return total == 0 || completed < total;
        })
        .map((juz) => juz['juz'] as int)
        .toList();
  }

  void _showTambahTargetBottomSheet(
    List<Map<String, dynamic>> currentJuzData,
    Set<int> allTargetJuzNums,
    Set<int> officialTargetJuzNums,
    SantriExtraTargetCubit extraTargetCubit,
  ) {
    final colors = AppColors.of(context);
    final searchController = TextEditingController();
    String searchQuery = '';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (ctx, setSheetState) {
            // Get all 30 juz from QuranService, filter out already-targeted ones
            final allJuz = QuranService.instance.getAllJuz();
            final available = allJuz.where((j) {
              if (allTargetJuzNums.contains(j.number)) return false;
              if (searchQuery.isEmpty) return true;
              return 'Juz ${j.number}'.toLowerCase().contains(
                    searchQuery.toLowerCase(),
                  );
            }).toList();

            return Container(
              height: MediaQuery.of(context).size.height * 0.75,
              decoration: BoxDecoration(
                color: colors.surface,
                borderRadius:
                    BorderRadius.vertical(top: Radius.circular(24.r)),
              ),
              child: Column(
                children: [
                  SizedBox(height: 20.h),

                  // Title
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24.w),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Tambah Target Hafalan',
                        style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w700,
                          color: colors.textPrimary,
                          fontFamily: 'Poppins',
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 14.h),

                  // Warning banner — ditampilkan hanya jika ada target resmi yg belum selesai
                  Builder(builder: (ctx) {
                    final incompleteJuz = _getIncompleteTargetJuz(
                      currentJuzData,
                      officialTargetJuzNums,
                    );
                    if (incompleteJuz.isEmpty) return const SizedBox.shrink();

                    final juzLabels = incompleteJuz
                        .map((n) => 'Juz $n')
                        .join(', ');
                    return Padding(
                      padding: EdgeInsets.fromLTRB(24.w, 0, 24.w, 16.h),
                      child: Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(14.w),
                        decoration: BoxDecoration(
                          color: colors.warning.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(12.r),
                          border: Border.all(
                            color: colors.warning.withValues(alpha: 0.4),
                          ),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(
                              Icons.warning_amber_rounded,
                              size: 18.sp,
                              color: colors.warning,
                            ),
                            SizedBox(width: 8.w),
                            Expanded(
                              child: Text(
                                'Perhatian: $juzLabels belum diselesaikan. '
                                'Pastikan santri tetap menyelesaikan target '
                                'hafalan semester ini. Anda tetap dapat '
                                'menambah target baru, namun target yang '
                                'sudah ditetapkan wajib diselesaikan terlebih dahulu.',
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w500,
                                  color: colors.warning,
                                  fontFamily: 'Poppins',
                                  height: 1.4,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),

                  // Search field
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24.w),
                    child: Container(
                      decoration: BoxDecoration(
                        color: colors.background,
                        borderRadius: BorderRadius.circular(12.r),
                        border: Border.all(color: colors.border, width: 1),
                      ),
                      child: TextField(
                        controller: searchController,
                        onChanged: (v) =>
                            setSheetState(() => searchQuery = v),
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontFamily: 'Poppins',
                          color: colors.textPrimary,
                        ),
                        decoration: InputDecoration(
                          hintText: 'Cari Juz (contoh: Juz 1)',
                          hintStyle: TextStyle(
                            fontSize: 14.sp,
                            fontFamily: 'Poppins',
                            color:
                                colors.textSecondary.withValues(alpha: 0.5),
                          ),
                          prefixIcon: Icon(
                            Icons.search,
                            color: colors.textSecondary,
                            size: 20.sp,
                          ),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 16.w,
                            vertical: 12.h,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 8.h),

                  // Juz list
                  Expanded(
                    child: ListView.builder(
                      padding: EdgeInsets.symmetric(horizontal: 24.w),
                      itemCount: available.length,
                      itemBuilder: (_, idx) {
                        final juzModel = available[idx];
                        final incompleteJuz = _getIncompleteTargetJuz(
                          currentJuzData,
                          officialTargetJuzNums,
                        );
                        final hasWarning = incompleteJuz.isNotEmpty;

                        return Container(
                          margin: EdgeInsets.only(bottom: 10.h),
                          padding: EdgeInsets.symmetric(
                            horizontal: 16.w,
                            vertical: 14.h,
                          ),
                          decoration: BoxDecoration(
                            color: colors.surface,
                            borderRadius: BorderRadius.circular(12.r),
                            border: Border.all(
                              color:
                                  colors.border.withValues(alpha: 0.5),
                              width: 1,
                            ),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Juz ${juzModel.number}',
                                      style: TextStyle(
                                        fontSize: 15.sp,
                                        fontWeight: FontWeight.w700,
                                        color: colors.textPrimary,
                                        fontFamily: 'Poppins',
                                      ),
                                    ),
                                    SizedBox(height: 2.h),
                                    Text(
                                      '${juzModel.surahs.length} Surat',
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
                              GestureDetector(
                                onTap: () async {
                                  // Capture context-dependent values BEFORE any async gap
                                  final messenger =
                                      ScaffoldMessenger.of(context);
                                  final appColors = AppColors.of(context);

                                  // Jika ada target resmi yang belum selesai,
                                  // tampilkan dialog konfirmasi terlebih dahulu
                                  if (hasWarning) {
                                    final juzLabels = incompleteJuz
                                        .map((n) => 'Juz $n')
                                        .join(', ');
                                    final confirmed =
                                        await showDialog<bool>(
                                      context: context,
                                      builder: (dialogCtx) {
                                        final dColors =
                                            AppColors.of(dialogCtx);
                                        return AlertDialog(
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(
                                                    16.r),
                                          ),
                                          backgroundColor: dColors.surface,
                                          title: Row(
                                            children: [
                                              Icon(
                                                Icons.warning_amber_rounded,
                                                color: dColors.warning,
                                                size: 20.sp,
                                              ),
                                              SizedBox(width: 8.w),
                                              Text(
                                                'Target Belum Selesai',
                                                style: TextStyle(
                                                  fontFamily: 'Poppins',
                                                  fontWeight: FontWeight.w700,
                                                  fontSize: 15.sp,
                                                  color: dColors.textPrimary,
                                                ),
                                              ),
                                            ],
                                          ),
                                          content: Text(
                                            '$juzLabels belum diselesaikan semester ini.\n\n'
                                            'Ingatkan santri untuk tetap menyelesaikan '
                                            'target yang sudah ditetapkan. Apakah Anda '
                                            'yakin ingin menambahkan Juz ${juzModel.number} '
                                            'sebagai target tambahan?',
                                            style: TextStyle(
                                              fontFamily: 'Poppins',
                                              fontSize: 13.sp,
                                              color: dColors.textSecondary,
                                              height: 1.6,
                                            ),
                                          ),
                                          actions: [
                                            TextButton(
                                              onPressed: () =>
                                                  Navigator.pop(
                                                      dialogCtx, false),
                                              child: Text(
                                                'Batal',
                                                style: TextStyle(
                                                  fontFamily: 'Poppins',
                                                  color: dColors.textSecondary,
                                                ),
                                              ),
                                            ),
                                            TextButton(
                                              onPressed: () =>
                                                  Navigator.pop(
                                                      dialogCtx, true),
                                              child: Text(
                                                'Ya, Tambahkan',
                                                style: TextStyle(
                                                  fontFamily: 'Poppins',
                                                  fontWeight: FontWeight.w700,
                                                  color: dColors.primary,
                                                ),
                                              ),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                    if (confirmed != true) return;
                                  }

                                  final success =
                                      await extraTargetCubit.addExtraJuz(
                                    widget.santriId,
                                    juzModel.number,
                                  );

                                  setSheetState(() {});

                                  messenger.showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        success
                                            ? 'Juz ${juzModel.number} ditambahkan sebagai target'
                                            : 'Gagal menyimpan target, coba lagi',
                                        style: const TextStyle(
                                          fontFamily: 'Poppins',
                                        ),
                                      ),
                                      backgroundColor: success
                                          ? appColors.primary
                                          : appColors.error,
                                      duration: const Duration(seconds: 2),
                                    ),
                                  );
                                },
                                child: Container(
                                  width: 34.w,
                                  height: 34.w,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: colors.primary
                                        .withValues(alpha: 0.1),
                                  ),
                                  child: Icon(
                                    Icons.add,
                                    size: 20.sp,
                                    color: colors.primary,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),

                  // Tutup button
                  Padding(
                    padding:
                        EdgeInsets.fromLTRB(24.w, 12.h, 24.w, 24.h),
                    child: SizedBox(
                      width: double.infinity,
                      height: 50.h,
                      child: CustomOutlinedButton(
                        height: 50.h,
                        onPressed: () => Navigator.pop(ctx),
                        label: 'Tutup',
                        borderRadius: 14.r,
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);

    // ── Lookup santri ─────────────────────────────────────────────────────────
    final santriState = context.watch<SantriCubit>().state;
    final targetHafalanState = context.watch<TargetHafalanCubit>().state;
    final extraTargetState = context.watch<SantriExtraTargetCubit>().state;
    final extraTargetCubit = context.read<SantriExtraTargetCubit>();

    SantriModel? santri;
    santriState.maybeWhen(
      loaded: (list) {
        try {
          santri = list.firstWhere((s) => s.nis == widget.nis);
        } catch (_) {}
      },
      orElse: () {},
    );

    // ── Admin-defined target juz ──────────────────────────────────────────────
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
    final adminJuzList = target != null && santri != null
        ? TargetHafalanHelper.getTargetJuzList(
            target, santri!.kelas, santri!.program)
        : <int>[];

    // ── Teacher-added extra juz (Firestore-persisted) ─────────────────────────
    final extraJuz = <int>[];
    extraTargetState.maybeWhen(
      loaded: (juzList) => extraJuz.addAll(juzList),
      orElse: () {},
    );

    // ── Get progress data ─────────────────────────────────────────────────────
    final progressState = context.watch<ProgressHafalanCubit>().state;
    OverallHafalanProgress? progressData;
    progressState.maybeWhen(
      loaded: (p) => progressData = p,
      orElse: () {},
    );

    // ── Part 1 fix: always surface juz that already have real memorized ayat ──
    // This ensures progress is visible even when admin changes the semester
    // or when no target is defined at all.
    final progressJuzNums = progressData?.juzProgressList
            .where((jp) => jp.memorizedAyat > 0)
            .map((jp) => jp.juzNumber)
            .toSet() ??
        <int>{};

    // ── Combine all juz sources ───────────────────────────────────────────────
    final allTargetJuzNums = <int>{
      ...adminJuzList,   // admin-defined curriculum targets
      ...extraJuz,       // teacher-added (Firestore-persisted)
      ...progressJuzNums,// any juz with actual progress (never hidden)
    };

    // ── Build display data ────────────────────────────────────────────────────
    final juzDisplayData = allTargetJuzNums.map((juzNum) {
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
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showTambahTargetBottomSheet(
          juzDisplayData,
          allTargetJuzNums,
          {...adminJuzList, ...extraJuz},
          extraTargetCubit,
        ),
        backgroundColor: colors.primary,
        child: Icon(Icons.add, color: colors.textOnButton),
      ),
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
                    _buildProfileCard(colors, santri),
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
                    SizedBox(height: 80.h), // Extra space for FAB
                  ],
                ),
              ),
            ),
          ],
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

    final bool teacherCanAdd = reason.kind == EmptyTargetKind.idadTahsin ||
        reason.kind == EmptyTargetKind.dauroh;

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
            if (teacherCanAdd) ...[
              SizedBox(height: 14.h),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                decoration: BoxDecoration(
                  color: colors.primary.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Icon(Icons.add_circle_outline,
                        size: 14.sp, color: colors.primary),
                    SizedBox(width: 6.w),
                    Flexible(
                      child: Text(
                        'Ketuk + untuk menambah target juz secara manual',
                        style: TextStyle(
                          fontSize: 11.sp,
                          fontWeight: FontWeight.w500,
                          color: colors.primary,
                          fontFamily: 'Poppins',
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildProfileCard(AppColorSet colors, SantriModel? santri) {
    final kelasInfo = santri != null
        ? t.riwayatHafalanSantri.halaqohKelas(
            halaqoh: '', kelas: santri.kelas)
        : '';

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
                  widget.name,
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                    fontFamily: 'Poppins',
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  'NIS: ${widget.nis}',
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w400,
                    color: Colors.white.withValues(alpha: 0.85),
                    fontFamily: 'Poppins',
                  ),
                ),
                if (kelasInfo.isNotEmpty)
                  Text(
                    kelasInfo,
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

    final progressVal = total > 0 ? (completed / total * 100) : 0.0;
    String percentStr;
    if (progressVal == 0 || progressVal == 100) {
      percentStr = progressVal.toInt().toString();
    } else {
      percentStr = progressVal.toStringAsFixed(1);
    }

    final progress = total > 0 ? completed / total : 0.0;

    return GestureDetector(
      onTap: () {
        context.router.push(
          ProgressHafalanPerSuratRoute(
            santriId: widget.santriId,
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
                      '$completed dari $total Ayat Selesai',
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
                  '$percentStr %',
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
