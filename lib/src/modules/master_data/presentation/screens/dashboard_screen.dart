import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_halaqoh/gen/i18n/translations.g.dart';
import 'package:my_halaqoh/src/core/router/app_router.dart';
import 'package:auto_route/auto_route.dart';
import 'package:my_halaqoh/src/core/theme/app_colors.dart';
import 'package:my_halaqoh/src/modules/master_data/presentation/cubits/guru_cubit.dart';
import 'package:my_halaqoh/src/modules/master_data/presentation/cubits/guru_state.dart';
import 'package:my_halaqoh/src/modules/master_data/presentation/cubits/santri_cubit.dart';
import 'package:my_halaqoh/src/modules/master_data/presentation/cubits/santri_state.dart';
import 'package:my_halaqoh/src/modules/master_data/presentation/cubits/halaqoh_cubit.dart';
import 'package:my_halaqoh/src/modules/master_data/presentation/cubits/halaqoh_state.dart';
import 'package:my_halaqoh/src/modules/master_data/presentation/widgets/dashboard_header.dart';
import 'package:my_halaqoh/src/modules/master_data/presentation/widgets/stat_card.dart';
import 'package:my_halaqoh/src/modules/master_data/presentation/widgets/menu_card.dart';

/// Dashboard content page (Tab 0)
class DashboardScreen extends StatelessWidget {
  final void Function(int index)? onNavigateToTab;

  const DashboardScreen({super.key, this.onNavigateToTab});

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
              onSettingsTap: () {
                context.router.push(const PengaturanMasterDataRoute());
              },
            ),
            SizedBox(height: 20.h),

            // Stat cards (horizontal scroll) — live counts
            _buildStatCards(context, colors),
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
            _buildMenuGrid(context),
            SizedBox(height: 100.h), // space for bottom bar
          ],
        ),
      ),
    );
  }

  Widget _buildStatCards(BuildContext context, AppColorSet colors) {
    return SizedBox(
      height: 140.h,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        children: [
          // Santri count
          BlocBuilder<SantriCubit, SantriState>(
            builder: (context, state) {
              final count = state.maybeWhen(
                loaded: (list) => list.length.toString(),
                orElse: () => '...',
              );
              return StatCard(
                icon: Icons.groups,
                title: t.dashboard.totalSantri,
                count: count,
                iconColor: colors.primary,
                iconBgColor: colors.primary.withValues(alpha: 0.1),
              );
            },
          ),
          SizedBox(width: 12.w),
          // Guru count
          BlocBuilder<GuruCubit, GuruState>(
            builder: (context, state) {
              final count = state.maybeWhen(
                loaded: (list) => list.length.toString(),
                orElse: () => '...',
              );
              return StatCard(
                icon: Icons.school,
                title: t.dashboard.totalGuru,
                count: count,
                iconColor: colors.blue,
                iconBgColor: colors.blue.withValues(alpha: 0.1),
              );
            },
          ),
          SizedBox(width: 12.w),
          // Halaqoh count
          BlocBuilder<HalaqohCubit, HalaqohState>(
            builder: (context, state) {
              final count = state.maybeWhen(
                loaded: (list) => list.length.toString(),
                orElse: () => '...',
              );
              return StatCard(
                icon: Icons.auto_stories,
                title: t.dashboard.totalHalaqoh,
                count: count,
                iconColor: colors.yellow,
                iconBgColor: colors.yellow.withValues(alpha: 0.1),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildMenuGrid(BuildContext context) {
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
          // Santri count in subtitle
          BlocBuilder<SantriCubit, SantriState>(
            builder: (context, state) {
              final subtitle = state.maybeWhen(
                loaded: (list) => '${list.length} santri',
                orElse: () => t.dashboard.santriCount,
              );
              return MenuCard(
                icon: Icons.groups,
                title: t.dashboard.kelolaSantri,
                subtitle: subtitle,
                onTap: () => onNavigateToTab?.call(1),
              );
            },
          ),
          // Guru count in subtitle
          BlocBuilder<GuruCubit, GuruState>(
            builder: (context, state) {
              final subtitle = state.maybeWhen(
                loaded: (list) => '${list.length} guru',
                orElse: () => t.dashboard.guruCount,
              );
              return MenuCard(
                icon: Icons.school,
                title: t.dashboard.kelolaGuru,
                subtitle: subtitle,
                onTap: () => onNavigateToTab?.call(2),
              );
            },
          ),
          // Halaqoh count in subtitle
          BlocBuilder<HalaqohCubit, HalaqohState>(
            builder: (context, state) {
              final subtitle = state.maybeWhen(
                loaded: (list) => '${list.length} halaqoh',
                orElse: () => t.dashboard.halaqohCount,
              );
              return MenuCard(
                icon: Icons.auto_stories,
                title: t.dashboard.kelolaHalaqoh,
                subtitle: subtitle,
                onTap: () => onNavigateToTab?.call(3),
              );
            },
          ),
          MenuCard(
            icon: Icons.track_changes,
            title: t.dashboard.kelolaTarget,
            subtitle: t.dashboard.perKelas,
            onTap: () => onNavigateToTab?.call(4),
          ),
        ],
      ),
    );
  }
}
