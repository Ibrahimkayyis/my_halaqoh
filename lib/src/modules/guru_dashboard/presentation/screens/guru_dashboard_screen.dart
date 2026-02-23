import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_halaqoh/gen/i18n/translations.g.dart';
import 'package:my_halaqoh/src/core/theme/app_colors.dart';
import 'package:my_halaqoh/src/modules/guru_dashboard/presentation/widgets/guru_dashboard_header.dart';
import 'package:my_halaqoh/src/modules/guru_dashboard/presentation/widgets/capaian_card.dart';
import 'package:my_halaqoh/src/modules/guru_dashboard/presentation/widgets/guru_menu_card.dart';
import 'package:my_halaqoh/src/modules/guru_dashboard/presentation/widgets/setoran_item.dart';

/// Main dashboard content page for Guru role
class GuruDashboardScreen extends StatelessWidget {
  final void Function(int index)? onNavigateToTab;

  const GuruDashboardScreen({
    super.key,
    this.onNavigateToTab,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);

    return Scaffold(
      backgroundColor: colors.background,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            GuruDashboardHeader(
              greeting: t.guruDashboard.greeting,
              name: 'Ustadz Kayyis',
              subtitle: t.guruDashboard.subtitle,
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

            // Two circular indicators
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: Row(
                children: [
                  CapaianCard(
                    title: t.guruDashboard.kehadiranHariIni,
                    percent: 0.8,
                    bottomLabel: t.guruDashboard.santriCount(
                      current: '8',
                      total: '10',
                    ),
                    progressColor: colors.primary,
                  ),
                  SizedBox(width: 12.w),
                  CapaianCard(
                    title: t.guruDashboard.setoranHafalan,
                    percent: 0.5,
                    bottomLabel: t.guruDashboard.santriCount(
                      current: '5',
                      total: '10',
                    ),
                    progressColor: colors.primary,
                  ),
                ],
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

            // 2x2 menu grid
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: GuruMenuCard(
                          icon: Icons.groups,
                          label: t.guruDashboard.myHalaqoh,
                          iconColor: colors.primary,
                          iconBgColor:
                              colors.primary.withValues(alpha: 0.1),
                          onTap: () => onNavigateToTab?.call(1),
                        ),
                      ),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: GuruMenuCard(
                          icon: Icons.qr_code_scanner,
                          label: t.guruDashboard.scanAbsensi,
                          iconColor: colors.primary,
                          iconBgColor:
                              colors.primary.withValues(alpha: 0.1),
                          onTap: () {
                            // TODO: Navigate to scan absensi
                          },
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 12.h),
                  Row(
                    children: [
                      Expanded(
                        child: GuruMenuCard(
                          icon: Icons.edit_note,
                          label: t.guruDashboard.inputHafalan,
                          iconColor: colors.primary,
                          iconBgColor:
                              colors.primary.withValues(alpha: 0.1),
                          onTap: () {
                            // TODO: Navigate to input hafalan
                          },
                        ),
                      ),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: GuruMenuCard(
                          icon: Icons.bar_chart,
                          label: t.guruDashboard.laporan,
                          iconColor: colors.primary,
                          iconBgColor:
                              colors.primary.withValues(alpha: 0.1),
                          onTap: () => onNavigateToTab?.call(2),
                        ),
                      ),
                    ],
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

            // Setoran list
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: Column(
                children: const [
                  SetoranItem(
                    name: 'Ahmad',
                    surahInfo: 'Al Mulk 1 - 9',
                    score: 90,
                  ),
                  SetoranItem(
                    name: 'Bima',
                    surahInfo: 'Al - Qalam 10 - 12',
                    score: 80,
                  ),
                  SetoranItem(
                    name: 'Rafi',
                    surahInfo: 'An - Naba 6 - 10',
                    score: 85,
                  ),
                ],
              ),
            ),
            SizedBox(height: 100.h), // Space for bottom bar
          ],
        ),
      ),
    );
  }
}
