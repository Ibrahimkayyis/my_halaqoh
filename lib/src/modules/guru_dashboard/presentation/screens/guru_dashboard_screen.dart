import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_halaqoh/gen/i18n/translations.g.dart';
import 'package:my_halaqoh/src/core/helpers/active_session_helper.dart';
import 'package:my_halaqoh/src/core/service_locator/service_locator.dart';
import 'package:my_halaqoh/src/core/theme/app_colors.dart';
import 'package:my_halaqoh/src/core/widget/widgets.dart';
import 'package:my_halaqoh/src/modules/auth/presentation/cubits/auth_cubit.dart';
import 'package:my_halaqoh/src/modules/auth/presentation/cubits/auth_state.dart';
import 'package:my_halaqoh/src/modules/guru_dashboard/presentation/cubits/dashboard_summary_cubit.dart';
import 'package:my_halaqoh/src/modules/guru_dashboard/presentation/cubits/dashboard_summary_state.dart';
import 'package:my_halaqoh/src/modules/guru_dashboard/presentation/widgets/capaian_card.dart';
import 'package:my_halaqoh/src/modules/guru_dashboard/presentation/widgets/dashboard_action_bar.dart';
import 'package:my_halaqoh/src/modules/guru_dashboard/presentation/widgets/guru_dashboard_header.dart';
import 'package:my_halaqoh/src/modules/guru_dashboard/presentation/widgets/setoran_item.dart';
import 'package:my_halaqoh/src/modules/master_data/domain/models/guru_model.dart';
import 'package:my_halaqoh/src/modules/master_data/domain/models/halaqoh_model.dart';
import 'package:my_halaqoh/src/modules/master_data/presentation/cubits/guru_cubit.dart';
import 'package:my_halaqoh/src/modules/master_data/presentation/cubits/guru_state.dart';
import 'package:my_halaqoh/src/modules/master_data/presentation/cubits/halaqoh_cubit.dart';
import 'package:my_halaqoh/src/modules/master_data/presentation/cubits/halaqoh_state.dart';
import 'package:my_halaqoh/src/modules/master_data/presentation/cubits/santri_cubit.dart';
import 'package:my_halaqoh/src/modules/master_data/presentation/cubits/santri_state.dart';

/// Main dashboard content page for Guru role matching reference design:
/// - Open top bar with logo & logout
/// - Islamic hero card with mosque silhouette & halaqoh pill
/// - 3-column action bar (Absensi, Setoran, Santri)
/// - Vertical accent bar section titles
/// - Primary-themed Capaian Hari Ini circular gauges
/// - Setoran Terakhir feed with "Nilai [score]" badges
class GuruDashboardScreen extends StatefulWidget {
  final void Function(int index)? onNavigateToTab;
  final String programType;

  const GuruDashboardScreen({
    super.key,
    this.onNavigateToTab,
    this.programType = 'reguler',
  });

  @override
  State<GuruDashboardScreen> createState() => _GuruDashboardScreenState();
}

class _GuruDashboardScreenState extends State<GuruDashboardScreen> {
  late final DashboardSummaryCubit _dashboardCubit;
  bool _initialized = false;

  @override
  void initState() {
    super.initState();
    _dashboardCubit = sl<DashboardSummaryCubit>();
  }

  @override
  void dispose() {
    _dashboardCubit.close();
    super.dispose();
  }

  /// Initialize the dashboard cubit once the halaqoh + santri data is available.
  void _initDashboardIfReady({
    required HalaqohModel halaqoh,
    required Map<String, String> santriNameMap,
  }) {
    if (_initialized) return;
    _initialized = true;

    _dashboardCubit.loadDashboardData(
      halaqohId: halaqoh.id,
      santriIds: halaqoh.santriIds,
      santriNameMap: santriNameMap,
    );
  }

  /// Formats current date in Indonesian locale: "Selasa, 18 Agustus 2026"
  String _getFormattedDate() {
    final now = DateTime.now();
    const days = [
      'Senin', 'Selasa', 'Rabu', 'Kamis', 'Jumat', 'Sabtu', 'Minggu',
    ];
    const months = [
      'Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni',
      'Juli', 'Agustus', 'September', 'Oktober', 'November', 'Desember',
    ];
    return '${days[now.weekday - 1]}, ${now.day} ${months[now.month - 1]} ${now.year}';
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final textTheme = Theme.of(context).textTheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Retrieve contextual states
    final authState = context.watch<AuthCubit>().state;
    final halaqohState = context.watch<HalaqohCubit>().state;
    final guruState = context.watch<GuruCubit>().state;
    final santriState = context.watch<SantriCubit>().state;

    String guruName = '';
    String linkedDocId = '';

    authState.maybeWhen(
      authenticated: (userMeta) {
        guruName = userMeta.displayName;
      },
      orElse: () {},
    );

    // Active session linked doc ID (supports super_admin impersonation)
    linkedDocId = ActiveSessionHelper.getActiveLinkedDocId(context) ?? '';

    // Look up real guru data for name and profile picture
    GuruModel? myGuru;
    guruState.maybeWhen(
      loaded: (list) {
        try {
          myGuru = list.firstWhere((g) => g.id == linkedDocId);
        } catch (_) {}
      },
      orElse: () {},
    );

    final displayName = myGuru?.nama ?? guruName;
    final profilePictureUrl = myGuru?.profilePicture;

    HalaqohModel? myHalaqoh;
    halaqohState.maybeWhen(
      loaded: (list) {
        try {
          myHalaqoh = list.firstWhere((h) => h.guruId == linkedDocId);
        } catch (_) {}
      },
      orElse: () {},
    );

    final santriCount = myHalaqoh?.jumlahSantri ?? 0;
    final halaqohName = myHalaqoh?.nama ?? '';

    // Build santri name map for the cubit
    Map<String, String> santriNameMap = {};
    santriState.maybeWhen(
      loaded: (list) {
        for (final s in list) {
          santriNameMap[s.id] = s.nama;
        }
      },
      orElse: () {},
    );

    // Initialize dashboard data once halaqoh is available
    if (myHalaqoh != null && santriNameMap.isNotEmpty) {
      _initDashboardIfReady(
        halaqoh: myHalaqoh!,
        santriNameMap: santriNameMap,
      );
    }

    return BlocProvider.value(
      value: _dashboardCubit,
      child: Scaffold(
        backgroundColor: colors.background,
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── 1. Header (Logo + Logout + Mosque Silhouette Card) ──
              if (guruState.maybeWhen(
                initial: () => true,
                loading: () => true,
                orElse: () => false,
              ))
                const ShimmerDashboardHeader()
              else
                GuruDashboardHeader(
                  name: displayName,
                  profilePictureUrl: profilePictureUrl,
                  dateText: _getFormattedDate(),
                  halaqohName: halaqohName,
                  santriCount: santriCount,
                ),
              SizedBox(height: 16.h),

              // ── 2. Action Bar (3 Columns: Absensi, Hafalan, Halaqoh) ─
              DashboardActionBar(
                onAbsensiTap: () => widget.onNavigateToTab?.call(2),
                onHafalanTap: () => widget.onNavigateToTab?.call(3),
                onHalaqohTap: () => widget.onNavigateToTab?.call(1),
              ),
              SizedBox(height: 22.h),

              // ── 3. Section 1: Capaian Hari Ini ─────────────────────
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: _buildSectionTitle(
                  context: context,
                  title: t.guruDashboard.capaianHariIni,
                  colors: colors,
                  textTheme: textTheme,
                ),
              ),
              SizedBox(height: 12.h),

              // Side-by-Side Horizontal Metric Cards in primary theme
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: BlocBuilder<DashboardSummaryCubit, DashboardSummaryState>(
                  builder: (context, state) {
                    return state.maybeWhen(
                      loaded: (
                        attendedCount,
                        totalSantriCount,
                        attendancePercent,
                        setoranCount,
                        setoranPercent,
                        latestSetoran,
                      ) {
                        return Row(
                          children: [
                            CapaianCard(
                              title: t.guruDashboard.kehadiranHariIni,
                              icon: Icons.how_to_reg_rounded,
                              percent: attendancePercent,
                              bottomLabel:
                                  '$attendedCount / $totalSantriCount Santri Hadir',
                              onTap: () => widget.onNavigateToTab?.call(2),
                            ),
                            SizedBox(width: 12.w),
                            CapaianCard(
                              title: t.guruDashboard.setoranHafalan,
                              icon: Icons.menu_book_rounded,
                              percent: setoranPercent,
                              bottomLabel:
                                  '$setoranCount / $totalSantriCount Santri Setor',
                              onTap: () => widget.onNavigateToTab?.call(3),
                            ),
                          ],
                        );
                      },
                      orElse: () {
                        return Row(
                          children: [
                            CapaianCard(
                              title: t.guruDashboard.kehadiranHariIni,
                              icon: Icons.how_to_reg_rounded,
                              percent: 0.0,
                              bottomLabel: '0 / $santriCount Santri Hadir',
                              onTap: () => widget.onNavigateToTab?.call(2),
                            ),
                            SizedBox(width: 12.w),
                            CapaianCard(
                              title: t.guruDashboard.setoranHafalan,
                              icon: Icons.menu_book_rounded,
                              percent: 0.0,
                              bottomLabel: '0 / $santriCount Santri Setor',
                              onTap: () => widget.onNavigateToTab?.call(3),
                            ),
                          ],
                        );
                      },
                    );
                  },
                ),
              ),
              SizedBox(height: 22.h),

              // ── 4. Section 2: Setoran Terakhir ─────────────────────
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: _buildSectionTitle(
                  context: context,
                  title: t.guruDashboard.setoranTerakhir,
                  colors: colors,
                  textTheme: textTheme,
                ),
              ),
              SizedBox(height: 12.h),

              // Setoran Feed Cards
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: BlocBuilder<DashboardSummaryCubit, DashboardSummaryState>(
                  builder: (context, state) {
                    return state.maybeWhen(
                      loaded: (
                        attendedCount,
                        totalSantriCount,
                        attendancePercent,
                        setoranCount,
                        setoranPercent,
                        latestSetoran,
                      ) {
                        if (latestSetoran.isEmpty) {
                          return _buildEmptySetoran(colors, textTheme, isDark);
                        }

                        return Column(
                          children: latestSetoran.map((item) {
                            return SetoranItem(
                              name: item.santriName,
                              surahInfo: item.surahInfo,
                              score: item.score,
                            );
                          }).toList(),
                        );
                      },
                      orElse: () => _buildShimmerSetoranList(),
                    );
                  },
                ),
              ),
              SizedBox(height: 100.h), // Space for bottom navigation bar
            ],
          ),
        ),
      ),
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

  /// Empty state widget when no setoran records exist.
  Widget _buildEmptySetoran(
    AppColorSet colors,
    TextTheme textTheme,
    bool isDark,
  ) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 28.h, horizontal: 16.w),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(16.r),
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
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.menu_book_outlined,
            size: 36.sp,
            color: colors.textSecondary.withValues(alpha: 0.4),
          ),
          SizedBox(height: 10.h),
          Text(
            t.guruDashboard.belumAdaSetoran,
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
    );
  }

  /// Shimmer loading list for setoran records.
  Widget _buildShimmerSetoranList() {
    return Column(
      children: List.generate(
        3,
        (index) => const ShimmerSetoranItem(),
      ),
    );
  }
}
