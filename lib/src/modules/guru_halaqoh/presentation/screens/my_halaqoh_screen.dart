import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_halaqoh/gen/i18n/translations.g.dart';
import 'package:my_halaqoh/src/core/helpers/active_session_helper.dart';
import 'package:my_halaqoh/src/core/quran/hafalan_progress.dart';
import 'package:my_halaqoh/src/core/router/app_router.dart';
import 'package:my_halaqoh/src/core/service_locator/service_locator.dart';
import 'package:my_halaqoh/src/core/theme/app_colors.dart';
import 'package:my_halaqoh/src/core/widget/widgets.dart';
import 'package:my_halaqoh/src/modules/guru_hafalan/presentation/cubits/progress_hafalan_cubit.dart';
import 'package:my_halaqoh/src/modules/guru_halaqoh/presentation/widgets/halaqoh_info_card.dart';
import 'package:my_halaqoh/src/modules/guru_halaqoh/presentation/widgets/santri_list_item.dart';
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

/// My Halaqoh screen showing halaqoh info card, search bar, and santri list.
/// Uses CustomScrollView for a smooth, unified scrolling experience.
@RoutePage()
class MyHalaqohScreen extends StatefulWidget {
  const MyHalaqohScreen({super.key});

  @override
  State<MyHalaqohScreen> createState() => _MyHalaqohScreenState();
}

class _MyHalaqohScreenState extends State<MyHalaqohScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  String _formatJuz(double v) {
    if (v == 0) return '0';
    if (v == v.roundToDouble()) return v.toInt().toString();
    final s = v.toStringAsFixed(2);
    return s.replaceAll(RegExp(r'0+$'), '').replaceAll(RegExp(r'\.$'), '');
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final textTheme = Theme.of(context).textTheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Retrieve States
    final halaqohState = context.watch<HalaqohCubit>().state;
    final santriState = context.watch<SantriCubit>().state;
    final targetHafalanState = context.watch<TargetHafalanCubit>().state;

    // Active session linked doc ID (supports super_admin impersonation)
    final linkedDocId = ActiveSessionHelper.getActiveLinkedDocId(context) ?? '';

    HalaqohModel? myHalaqoh;
    bool isHalaqohLoading = false;
    halaqohState.maybeWhen(
      initial: () => isHalaqohLoading = true,
      loading: () => isHalaqohLoading = true,
      loaded: (list) {
        try {
          myHalaqoh = list.firstWhere((h) => h.guruId == linkedDocId);
        } catch (_) {}
      },
      orElse: () {},
    );

    List<SantriModel> mySantriList = [];
    bool isSantriLoading = false;
    if (myHalaqoh != null || isHalaqohLoading) {
      santriState.maybeWhen(
        initial: () => isSantriLoading = true,
        loading: () => isSantriLoading = true,
        loaded: (sList) {
          mySantriList = sList
              .where((s) => myHalaqoh!.santriIds.contains(s.id) && !s.isAlumni)
              .toList();
        },
        orElse: () {},
      );
    }

    // Derive effective kelas/program from actual santri data.
    final effectiveKelas = mySantriList.isNotEmpty
        ? mySantriList.first.kelas
        : (myHalaqoh?.kelas ?? '');
    final effectiveProgram = mySantriList.isNotEmpty
        ? mySantriList.first.program
        : (myHalaqoh?.program ?? 'R');

    // Look up the admin-defined target using effective kelas for the summary card.
    TargetHafalanModel? myTarget;
    if (myHalaqoh != null) {
      targetHafalanState.maybeWhen(
        loaded: (targets) {
          myTarget = TargetHafalanHelper.findTarget(
            targets,
            effectiveKelas,
            effectiveProgram,
          );
        },
        orElse: () {},
      );
    }

    // Extract all targets for per-santri lookup
    final List<TargetHafalanModel> allTargets = [];
    targetHafalanState.maybeWhen(
      loaded: (targets) => allTargets.addAll(targets),
      orElse: () {},
    );

    final filtered = mySantriList.where((santri) {
      if (_searchQuery.isEmpty) return true;
      final q = _searchQuery.toLowerCase();
      return santri.nama.toLowerCase().contains(q) || santri.nis.contains(q);
    }).toList();

    return Scaffold(
      backgroundColor: colors.background,
      body: SafeArea(
        bottom: false,
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(
            parent: AlwaysScrollableScrollPhysics(),
          ),
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          slivers: [
            // --- HEADER SECTION ---
            SliverToBoxAdapter(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: colors.surface,
                  borderRadius: BorderRadius.vertical(
                    bottom: Radius.circular(24.r),
                  ),
                  border: isDark
                      ? Border.all(color: colors.border, width: 0.5)
                      : null,
                  boxShadow: isDark
                      ? []
                      : [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.04),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 12.h),

                    // Halaqoh info card
                    if (isHalaqohLoading)
                      const ShimmerHalaqohInfoCard()
                    else if (myHalaqoh != null)
                      HalaqohInfoCard(
                        kelas: t.myHalaqohScreen.kelas(kelas: effectiveKelas),
                        program: t.myHalaqohScreen.program(
                          program: effectiveProgram == 'T'
                              ? t.myHalaqohScreen.programTakhassus
                              : t.myHalaqohScreen.programReguler,
                        ),
                        halaqohName: myHalaqoh!.nama,
                        pengampu: myHalaqoh!.guruNama.isNotEmpty
                            ? myHalaqoh!.guruNama
                            : t.myHalaqohScreen.pengampu,
                        target: t.myHalaqohScreen.target(
                          count: myTarget != null
                              ? _formatJuz(
                                  TargetHafalanHelper.getTargetJuzCountDouble(
                                    myTarget!,
                                    effectiveKelas,
                                    effectiveProgram,
                                  ),
                                )
                              : '0',
                          range: myTarget != null
                              ? TargetHafalanHelper.getActiveSemesterSummary(
                                    myTarget!,
                                    effectiveKelas,
                                    effectiveProgram,
                                  ) ??
                                  '-'
                              : '-',
                        ),
                        totalSantri: t.myHalaqohScreen.total(
                          count: mySantriList.length.toString(),
                        ),
                      )
                    else
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 20.w,
                          vertical: 12.h,
                        ),
                        child: Text(
                          t.myHalaqohScreen.noHalaqohAssigned,
                          style: textTheme.bodyMedium?.copyWith(
                                color: colors.textSecondary,
                              ) ??
                              TextStyle(
                                color: colors.textSecondary,
                                fontFamily: 'Poppins',
                              ),
                        ),
                      ),
                    SizedBox(height: 18.h),

                    // Search bar using shared AppTextField
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.w),
                      child: AppTextField(
                        controller: _searchController,
                        hintText: t.myHalaqohScreen.searchHint,
                        prefixIconData: Icons.search_rounded,
                        textInputAction: TextInputAction.search,
                        onChanged: (value) =>
                            setState(() => _searchQuery = value),
                      ),
                    ),
                    SizedBox(height: 20.h),

                    // Daftar Santri section header (unified ▎ bar + pill badge)
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.w),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
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
                                t.myHalaqohScreen.daftarSantri,
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
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 10.w,
                              vertical: 4.h,
                            ),
                            decoration: BoxDecoration(
                              color: colors.primary.withValues(alpha: 0.08),
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                            child: Text(
                              t.myHalaqohScreen.santriCount(
                                count: '${filtered.length}',
                              ),
                              style: textTheme.labelSmall?.copyWith(
                                    fontSize: 11.5.sp,
                                    fontWeight: FontWeight.w600,
                                    color: colors.primary,
                                  ) ??
                                  TextStyle(
                                    fontSize: 11.5.sp,
                                    fontWeight: FontWeight.w600,
                                    color: colors.primary,
                                    fontFamily: 'Poppins',
                                  ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 16.h),
                  ],
                ),
              ),
            ),

            // --- SCROLLABLE LIST SECTION ---
            if (isSantriLoading || isHalaqohLoading)
              SliverPadding(
                padding: EdgeInsets.only(
                  top: 16.h,
                  left: 20.w,
                  right: 20.w,
                  bottom: MediaQuery.of(context).padding.bottom + 24.h,
                ),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate((context, index) {
                    return Padding(
                      padding: EdgeInsets.only(bottom: 12.h),
                      child: const ShimmerSantriListItem(),
                    );
                  }, childCount: 4),
                ),
              )
            else if (filtered.isEmpty)
              SliverFillRemaining(
                hasScrollBody: false,
                child: Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 20.w,
                      vertical: 32.h,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.search_off_rounded,
                          size: 40.sp,
                          color: colors.textSecondary.withValues(alpha: 0.4),
                        ),
                        SizedBox(height: 12.h),
                        Text(
                          t.myHalaqohScreen.santriNotFound,
                          textAlign: TextAlign.center,
                          style: textTheme.bodyMedium?.copyWith(
                                fontSize: 13.sp,
                                fontWeight: FontWeight.w500,
                                color: colors.textSecondary,
                              ) ??
                              TextStyle(
                                fontSize: 13.sp,
                                fontWeight: FontWeight.w500,
                                color: colors.textSecondary,
                                fontFamily: 'Poppins',
                              ),
                        ),
                      ],
                    ),
                  ),
                ),
              )
            else
              SliverPadding(
                padding: EdgeInsets.only(
                  top: 16.h,
                  left: 20.w,
                  right: 20.w,
                  bottom: MediaQuery.of(context).padding.bottom + 24.h,
                ),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate((context, index) {
                    final santri = filtered[index];

                    return BlocProvider(
                      key: ValueKey(santri.id),
                      create: (_) =>
                          sl<ProgressHafalanCubit>()..watchProgress(santri.id),
                      child:
                          BlocBuilder<
                            ProgressHafalanCubit,
                            ProgressHafalanState
                          >(
                            builder: (context, state) {
                              OverallHafalanProgress? progressData;
                              state.maybeWhen(
                                loaded: (p) => progressData = p,
                                orElse: () {},
                              );

                              final santriTarget = TargetHafalanHelper.findTarget(
                                allTargets,
                                santri.kelas,
                                santri.program,
                              );

                              double completed = 0.0;
                              if (santriTarget != null && progressData != null) {
                                completed = TargetHafalanHelper.getCompletedJuzCountDouble(
                                  targetModel: santriTarget,
                                  kelas: santri.kelas,
                                  programCode: santri.program,
                                  progressData: progressData,
                                );
                              } else {
                                final pData = progressData;
                                if (pData != null) {
                                  for (final jp in pData.juzProgressList) {
                                    if (jp.totalAyat > 0) {
                                      completed += jp.memorizedAyat / jp.totalAyat;
                                    }
                                  }
                                }
                              }
                              final targetJuz = santriTarget != null
                                  ? TargetHafalanHelper.getTargetJuzCountDouble(
                                      santriTarget,
                                      santri.kelas,
                                      santri.program,
                                    )
                                  : 0.0;

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

                              final progress = targetJuz > 0
                                  ? completed / targetJuz
                                  : 0.0;
                              final pct = formatPercent(progress * 100);

                              return Padding(
                                padding: EdgeInsets.only(bottom: 4.h),
                                child: SantriListItem(
                                  name: santri.nama,
                                  profilePictureUrl: santri.profilePicture,
                                  progressText: t.myHalaqohScreen.progressText(
                                    completed: _formatJuz(completed),
                                    target: _formatJuz(targetJuz),
                                  ),
                                  percentage: '$pct%',
                                  progress: progress,
                                  onTap: () {
                                    context.router.push(
                                      DetailSantriRoute(
                                        name: santri.nama,
                                        nis: santri.nis,
                                      ),
                                    );
                                  },
                                ),
                              );
                            },
                          ),
                    );
                  }, childCount: filtered.length),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
