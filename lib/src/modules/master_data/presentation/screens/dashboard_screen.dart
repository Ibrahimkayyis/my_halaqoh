import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_halaqoh/gen/i18n/translations.g.dart';
import 'package:my_halaqoh/src/core/theme/app_colors.dart';
import 'package:my_halaqoh/src/modules/master_data/presentation/widgets/dashboard_header.dart';
import 'package:my_halaqoh/src/modules/master_data/presentation/widgets/stat_card.dart';
import 'package:my_halaqoh/src/modules/master_data/presentation/widgets/menu_card.dart';

/// Dashboard content page (Tab 0)
class DashboardScreen extends StatelessWidget {
  final void Function(int index)? onNavigateToTab;

  const DashboardScreen({
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
            DashboardHeader(
              greeting: t.dashboard.greeting,
              name: t.dashboard.admin,
            ),
            SizedBox(height: 20.h),

            // Stat cards (horizontal scroll)
            _buildStatCards(colors),
            SizedBox(height: 28.h),

            // Menu Utama title
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: Text(
                t.dashboard.menuUtama,
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w700,
                  color: colors.textPrimary,
                  fontFamily: 'Poppins',
                ),
              ),
            ),
            SizedBox(height: 8.h),

            // Menu grid
            _buildMenuGrid(),
            SizedBox(height: 100.h), // space for bottom bar
          ],
        ),
      ),
    );
  }

  Widget _buildStatCards(AppColorSet colors) {
    return SizedBox(
      height: 140.h,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        children: [
          StatCard(
            icon: Icons.groups,
            title: t.dashboard.totalSantri,
            count: '261',
            iconColor: colors.primary,
            iconBgColor: colors.primary.withValues(alpha: 0.1),
          ),
          SizedBox(width: 12.w),
          StatCard(
            icon: Icons.school,
            title: t.dashboard.totalGuru,
            count: '28',
            iconColor: colors.blue,
            iconBgColor: colors.blue.withValues(alpha: 0.1),
          ),
          SizedBox(width: 12.w),
          StatCard(
            icon: Icons.auto_stories,
            title: t.dashboard.totalHalaqoh,
            count: '20',
            iconColor: colors.yellow,
            iconBgColor: colors.yellow.withValues(alpha: 0.1),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuGrid() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: GridView.count(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisCount: 2,
        crossAxisSpacing: 12.w,
        mainAxisSpacing: 12.h,
        childAspectRatio: 0.95,
        children: [
          MenuCard(
            icon: Icons.groups,
            title: t.dashboard.kelolaSantri,
            subtitle: t.dashboard.santriCount,
            onTap: () => onNavigateToTab?.call(1), // Tab 1 = Santri
          ),
          MenuCard(
            icon: Icons.school,
            title: t.dashboard.kelolaGuru,
            subtitle: t.dashboard.guruCount,
            onTap: () => onNavigateToTab?.call(2), // Tab 2 = Guru
          ),
          MenuCard(
            icon: Icons.auto_stories,
            title: t.dashboard.kelolaHalaqoh,
            subtitle: t.dashboard.halaqohCount,
            onTap: () => onNavigateToTab?.call(3), // Tab 3 = Halaqoh
          ),
          MenuCard(
            icon: Icons.track_changes,
            title: t.dashboard.kelolaTarget,
            subtitle: t.dashboard.perKelas,
            onTap: () => onNavigateToTab?.call(4), // Tab 4 = Target
          ),
        ],
      ),
    );
  }
}
