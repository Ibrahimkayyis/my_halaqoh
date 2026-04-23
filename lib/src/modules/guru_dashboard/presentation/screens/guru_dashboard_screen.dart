import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_halaqoh/gen/i18n/translations.g.dart';
import 'package:my_halaqoh/src/core/theme/app_colors.dart';
import 'package:my_halaqoh/src/modules/auth/presentation/cubits/auth_state.dart';
import 'package:my_halaqoh/src/modules/guru_dashboard/presentation/widgets/guru_dashboard_header.dart';
import 'package:my_halaqoh/src/modules/guru_dashboard/presentation/widgets/capaian_card.dart';
import 'package:my_halaqoh/src/modules/guru_dashboard/presentation/widgets/guru_menu_card.dart';
import 'package:my_halaqoh/src/modules/guru_dashboard/presentation/widgets/setoran_item.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_halaqoh/src/modules/auth/presentation/cubits/auth_cubit.dart';
import 'package:my_halaqoh/src/modules/master_data/domain/models/guru_model.dart';
import 'package:my_halaqoh/src/modules/master_data/presentation/cubits/guru_cubit.dart';
import 'package:my_halaqoh/src/modules/master_data/presentation/cubits/guru_state.dart';
import 'package:my_halaqoh/src/modules/master_data/presentation/cubits/halaqoh_cubit.dart';
import 'package:my_halaqoh/src/modules/master_data/domain/models/halaqoh_model.dart';
import 'package:my_halaqoh/src/modules/master_data/presentation/cubits/halaqoh_state.dart';
import 'package:my_halaqoh/src/modules/master_data/presentation/cubits/santri_cubit.dart';
import 'package:my_halaqoh/src/modules/master_data/presentation/cubits/santri_state.dart';
import 'package:my_halaqoh/src/modules/guru_dashboard/presentation/cubits/dashboard_summary_cubit.dart';
import 'package:my_halaqoh/src/modules/guru_dashboard/presentation/cubits/dashboard_summary_state.dart';
import 'package:my_halaqoh/src/core/service_locator/service_locator.dart';

/// Main dashboard content page for Guru role.
///
/// Displays real-time data:
/// - Attendance percentage (latest session today)
/// - Setoran percentage (distinct santri who submitted today)
/// - 3 most recent setoran entries
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

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);

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
        linkedDocId = userMeta.linkedDocId;
      },
      orElse: () {},
    );

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

    // Use real guru name from database, fall back to auth displayName
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              GuruDashboardHeader(
                greeting: t.guruDashboard.greeting,
                name: displayName.isNotEmpty ? displayName : 'Loading...',
                subtitle: 'Awali Halaqoh dengan Do\'a Agar Selalu Diberkahi Allah SWT',
                profilePictureUrl: profilePictureUrl,
              ),
              SizedBox(height: 24.h),

              // Capaian hari ini
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: Text(
                  t.guruDashboard.capaianHariIni,
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w700,
                    color: colors.textPrimary,
                    fontFamily: 'Poppins',
                  ),
                ),
              ),
              SizedBox(height: 12.h),

              // Two circular indicators — powered by DashboardSummaryCubit
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
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
                              percent: attendancePercent,
                              bottomLabel: t.guruDashboard.santriCount(
                                current: attendedCount.toString(),
                                total: totalSantriCount.toString(),
                              ),
                              progressColor: colors.primary,
                            ),
                            SizedBox(width: 12.w),
                            CapaianCard(
                              title: t.guruDashboard.setoranHafalan,
                              percent: setoranPercent,
                              bottomLabel: t.guruDashboard.santriCount(
                                current: setoranCount.toString(),
                                total: totalSantriCount.toString(),
                              ),
                              progressColor: colors.primary,
                            ),
                          ],
                        );
                      },
                      orElse: () {
                        // Default state — show 0% while loading
                        return Row(
                          children: [
                            CapaianCard(
                              title: t.guruDashboard.kehadiranHariIni,
                              percent: 0.0,
                              bottomLabel: t.guruDashboard.santriCount(
                                current: '0',
                                total: santriCount.toString(),
                              ),
                              progressColor: colors.primary,
                            ),
                            SizedBox(width: 12.w),
                            CapaianCard(
                              title: t.guruDashboard.setoranHafalan,
                              percent: 0.0,
                              bottomLabel: t.guruDashboard.santriCount(
                                current: '0',
                                total: santriCount.toString(),
                              ),
                              progressColor: colors.primary,
                            ),
                          ],
                        );
                      },
                    );
                  },
                ),
              ),
              SizedBox(height: 28.h),

              // Menu Utama
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: Text(
                  t.guruDashboard.menuUtama,
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w700,
                    color: colors.textPrimary,
                    fontFamily: 'Poppins',
                  ),
                ),
              ),
              SizedBox(height: 12.h),

              // 3 menu cards in a single row
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: Row(
                  children: [
                    Expanded(
                      child: GuruMenuCard(
                        icon: Icons.groups,
                        label: t.guruDashboard.myHalaqoh,
                        iconColor: colors.primary,
                        iconBgColor: colors.primary.withValues(alpha: 0.1),
                        onTap: () => widget.onNavigateToTab?.call(1),
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: GuruMenuCard(
                        icon: Icons.qr_code_scanner,
                        label: t.guruNav.absensi,
                        iconColor: colors.primary,
                        iconBgColor: colors.primary.withValues(alpha: 0.1),
                        onTap: () => widget.onNavigateToTab?.call(2),
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: GuruMenuCard(
                        icon: Icons.edit_note,
                        label: t.guruNav.hafalan,
                        iconColor: colors.primary,
                        iconBgColor: colors.primary.withValues(alpha: 0.1),
                        onTap: () => widget.onNavigateToTab?.call(3),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 28.h),

              // Setoran Terakhir
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: Text(
                  t.guruDashboard.setoranTerakhir,
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w700,
                    color: colors.textPrimary,
                    fontFamily: 'Poppins',
                  ),
                ),
              ),
              SizedBox(height: 8.h),

              // Setoran list — powered by DashboardSummaryCubit
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
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
                          return _buildEmptySetoran(colors);
                        }
                        return Column(
                          children: latestSetoran
                              .map((item) => SetoranItem(
                                    name: item.santriName,
                                    surahInfo: item.surahInfo,
                                    score: item.score,
                                  ))
                              .toList(),
                        );
                      },
                      orElse: () => _buildEmptySetoran(colors),
                    );
                  },
                ),
              ),
              SizedBox(height: 100.h), // Space for bottom bar
            ],
          ),
        ),
      ),
    );
  }

  /// Empty state widget for when no setoran records exist.
  Widget _buildEmptySetoran(AppColorSet colors) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 24.h),
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
          Icon(
            Icons.menu_book_outlined,
            size: 36.sp,
            color: colors.textSecondary.withValues(alpha: 0.4),
          ),
          SizedBox(height: 8.h),
          Text(
            'Belum ada setoran',
            style: TextStyle(
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
}
