import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_halaqoh/src/core/helpers/active_session_helper.dart';
import 'package:my_halaqoh/src/core/router/app_router.dart';
import 'package:my_halaqoh/src/core/service_locator/service_locator.dart';
import 'package:my_halaqoh/src/core/theme/app_colors.dart';
import 'package:my_halaqoh/src/core/widget/widgets.dart';
import 'package:my_halaqoh/src/modules/sertifikasi_tahfidz/domain/helpers/sertifikasi_status_helper.dart';
import 'package:my_halaqoh/src/modules/sertifikasi_tahfidz/presentation/cubits/sertifikasi_cubit.dart';
import 'package:my_halaqoh/src/modules/sertifikasi_tahfidz/presentation/cubits/sertifikasi_state.dart';
import 'package:my_halaqoh/src/modules/sertifikasi_tahfidz/presentation/widgets/sertifikasi_card.dart';

/// Main screen for viewing Santri Tahfidz Certifications.
/// Connected to real-time Firestore stream via SertifikasiCubit.
@RoutePage()
class DaftarSertifikasiScreen extends StatefulWidget {
  const DaftarSertifikasiScreen({super.key});

  @override
  State<DaftarSertifikasiScreen> createState() => _DaftarSertifikasiScreenState();
}

class _DaftarSertifikasiScreenState extends State<DaftarSertifikasiScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  late final SertifikasiCubit _cubit;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      if (mounted) setState(() {});
    });

    _cubit = sl<SertifikasiCubit>();
    final currentGuruId = ActiveSessionHelper.getActiveLinkedDocId(context);
    if (currentGuruId != null && currentGuruId.isNotEmpty) {
      _cubit.watchByGuruId(currentGuruId);
    } else {
      _cubit.watchAll();
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    _cubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final textTheme = Theme.of(context).textTheme;

    return BlocProvider.value(
      value: _cubit,
      child: Scaffold(
        backgroundColor: colors.background,
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            context.router.push(FormPendaftaranSertifikasiRoute());
          },
          backgroundColor: colors.primary,
          foregroundColor: colors.textOnButton,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.r),
          ),
          icon: const Icon(Icons.add_task_rounded),
          label: Text(
            'Daftarkan Santri',
            style: textTheme.labelLarge?.copyWith(
              color: colors.textOnButton,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        body: SafeArea(
          child: Column(
            children: [
              // ── Top App Bar (Uniform with detail_santri_screen) ───────
              Padding(
                padding: EdgeInsets.only(left: 8.w, top: 8.h, right: 20.w),
                child: Row(
                  children: [
                    IconButton(
                      icon: Icon(
                        Icons.arrow_back_rounded,
                        color: colors.textPrimary,
                      ),
                      onPressed: () => context.router.maybePop(),
                    ),
                    SizedBox(width: 4.w),
                    Text(
                      'Sertifikasi Ujian Tahfidz',
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
              SizedBox(height: 8.h),

              // ── Tab Selector (Clean, No Counters) ─────────────────────
              Container(
                color: colors.surface,
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
                child: AppTabSelector(
                  controller: _tabController,
                  horizontalPadding: 0,
                  tabs: const [
                    'Sedang Berjalan',
                    'Riwayat Selesai',
                  ],
                ),
              ),

              // ── List of Items (Real data from Cubit) ─────────────────
              Expanded(
                child: BlocBuilder<SertifikasiCubit, SertifikasiState>(
                  builder: (context, state) {
                    return state.when(
                      initial: () => const SizedBox.shrink(),
                      loading: () => Center(
                        child: CircularProgressIndicator(
                          strokeWidth: 2.5,
                          color: colors.primary,
                        ),
                      ),
                      error: (message) => Center(
                        child: Padding(
                          padding: EdgeInsets.all(24.w),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.error_outline_rounded,
                                size: 36.sp,
                                color: colors.error,
                              ),
                              SizedBox(height: 12.h),
                              Text(
                                message,
                                style: textTheme.bodyMedium?.copyWith(
                                  color: colors.textSecondary,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      ),
                      loaded: (items) {
                        final activeItems = items.where((item) {
                          if (_tabController.index == 0) {
                            // Tab 0: Sedang Berjalan (Pending & Scheduled)
                            return item.status ==
                                    SertifikasiStatusHelper.statusPending ||
                                item.status ==
                                    SertifikasiStatusHelper.statusScheduled;
                          } else {
                            // Tab 1: Riwayat Selesai (Passed, Failed, Rejected)
                            return item.status ==
                                    SertifikasiStatusHelper.statusPassed ||
                                item.status ==
                                    SertifikasiStatusHelper.statusFailed ||
                                item.status ==
                                    SertifikasiStatusHelper.statusRejected;
                          }
                        }).toList();

                        return AnimatedSwitcher(
                          duration: const Duration(milliseconds: 200),
                          switchInCurve: Curves.easeOutCubic,
                          switchOutCurve: Curves.easeInCubic,
                          child: activeItems.isEmpty
                              ? _buildEmptyState(context, colors, textTheme)
                              : ListView.separated(
                                  key: ValueKey<int>(_tabController.index),
                                  physics: const BouncingScrollPhysics(),
                                  padding: EdgeInsets.only(
                                    left: 20.w,
                                    right: 20.w,
                                    top: 14.h,
                                    bottom: 80.h,
                                  ),
                                  itemCount: activeItems.length,
                                  separatorBuilder: (context, index) =>
                                      SizedBox(height: 8.h),
                                  itemBuilder: (context, index) {
                                    final item = activeItems[index];
                                    return SertifikasiCard(item: item);
                                  },
                                ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Empty State strictly compliant with MASTER.md Section 5B
  Widget _buildEmptyState(
    BuildContext context,
    AppColorSet colors,
    TextTheme textTheme,
  ) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(24.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 64.w,
              height: 64.w,
              decoration: BoxDecoration(
                color: colors.primary.withValues(alpha: 0.08),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.assignment_outlined,
                size: 32.sp,
                color: colors.primary,
              ),
            ),
            SizedBox(height: 16.h),
            Text(
              'Belum Ada Data Sertifikasi',
              style: textTheme.titleMedium?.copyWith(
                color: colors.textPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 6.h),
            Text(
              'Gunakan tombol "Daftarkan Santri" untuk mengajukan ujian.',
              style: textTheme.bodySmall?.copyWith(
                color: colors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
