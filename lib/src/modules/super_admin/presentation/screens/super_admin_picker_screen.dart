import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_halaqoh/src/core/router/app_router.dart';
import 'package:my_halaqoh/src/core/theme/app_colors.dart';
import 'package:my_halaqoh/src/core/widget/dialog/confirm_logout_dialog.dart';
import 'package:my_halaqoh/src/modules/auth/presentation/cubits/auth_cubit.dart';
import 'package:my_halaqoh/src/modules/auth/presentation/cubits/auth_state.dart';
import 'package:my_halaqoh/src/modules/super_admin/presentation/cubits/impersonation/impersonation_cubit.dart';
import 'package:my_halaqoh/src/modules/super_admin/presentation/widgets/role_access_card.dart';

@RoutePage()
class SuperAdminPickerScreen extends StatelessWidget {
  const SuperAdminPickerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    
    final authState = context.watch<AuthCubit>().state;
    final displayName = authState.maybeWhen(
      authenticated: (user) => user.displayName,
      orElse: () => 'Super Admin',
    );

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        SystemNavigator.pop();
      },
      child: Scaffold(
        backgroundColor: colors.background,
        body: Column(
          children: [
          // ── Header (with dark teal gradient and rounded bottom) ────────────────
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  colors.primary,
                  colors.primary.withValues(alpha: 0.85),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(36.r),
                bottomRight: Radius.circular(36.r),
              ),
            ),
            child: SafeArea(
              bottom: false,
              child: Padding(
                padding: EdgeInsets.fromLTRB(24.w, 16.h, 24.w, 32.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Top Row: Profile info & Logout Button
                    Row(
                      children: [
                        // Sleek profile circle
                        Container(
                          width: 52.w,
                          height: 52.w,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white.withValues(alpha: 0.15),
                            border: Border.all(
                              color: Colors.white.withValues(alpha: 0.25),
                              width: 1.5,
                            ),
                          ),
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              Icon(Icons.shield_outlined, size: 24.sp, color: Colors.white.withValues(alpha: 0.7)),
                              Icon(Icons.person_rounded, size: 14.sp, color: Colors.white),
                            ],
                          ),
                        ),
                        SizedBox(width: 14.w),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'WELCOME BACK',
                              style: TextStyle(
                                fontSize: 10.sp,
                                color: Colors.white.withValues(alpha: 0.7),
                                fontWeight: FontWeight.w600,
                                letterSpacing: 1.2,
                                fontFamily: 'Poppins',
                              ),
                            ),
                            SizedBox(height: 2.h),
                            Text(
                              displayName,
                              style: TextStyle(
                                fontSize: 18.sp,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                                fontFamily: 'Poppins',
                              ),
                            ),
                          ],
                        ),
                        const Spacer(),
                        // Circular Logout Button
                        Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white.withValues(alpha: 0.15),
                          ),
                          child: IconButton(
                            icon: Icon(Icons.logout_rounded, color: Colors.white, size: 20.sp),
                            tooltip: 'Logout',
                            onPressed: () async {
                              final confirmed = await ConfirmLogoutDialog.show(context);
                              if (confirmed && context.mounted) {
                                await context.read<AuthCubit>().logout();
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 32.h),
                    Text(
                      'Pilih Mode Akses',
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                        fontFamily: 'Poppins',
                      ),
                    ),
                    SizedBox(height: 6.h),
                    Text(
                      'Masuk sebagai role tertentu untuk mengoperasikan\naplikasi dari perspektif mereka.',
                      style: TextStyle(
                        fontSize: 12.5.sp,
                        color: Colors.white.withValues(alpha: 0.75),
                        fontFamily: 'Poppins',
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // ── Access Cards ───────────────────────────────────────────────────────
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
              child: Column(
                children: [
                  RoleAccessCard(
                    title: 'Akses sebagai Admin',
                    description: 'Kelola guru, santri, halaqoh, dan target hafalan dengan kontrol penuh.',
                    icon: Icons.domain_rounded,
                    accentColor: colors.blue,
                    iconBgColor: colors.blue.withValues(alpha: 0.1),
                    onTap: () {
                      context.read<ImpersonationCubit>().impersonateAsAdmin();
                      context.router.push(const DashboardWrapperRoute());
                    },
                  ),
                  SizedBox(height: 16.h),
                  RoleAccessCard(
                    title: 'Akses sebagai Guru',
                    description: 'Pilih guru dan masuk ke fitur manajemen absensi & hafalan santri.',
                    icon: Icons.school_rounded,
                    accentColor: colors.green,
                    iconBgColor: colors.green.withValues(alpha: 0.1),
                    onTap: () {
                      context.router.push(const GuruPickerRoute());
                    },
                  ),
                  SizedBox(height: 16.h),
                  RoleAccessCard(
                    title: 'Akses sebagai Wali Santri',
                    description: 'Pantau perkembangan progress hafalan & absensi santri Anda.',
                    icon: Icons.people_alt_rounded,
                    accentColor: const Color(0xFFF97316), // Orange
                    iconBgColor: const Color(0xFFF97316).withValues(alpha: 0.1),
                    onTap: () {
                      context.router.push(const SantriPickerRoute());
                    },
                  ),
                  SizedBox(height: 16.h),
                  RoleAccessCard(
                    title: 'Lihat Log Aktivitas',
                    description: 'Pantau riwayat catatan aktivitas yang dilakukan oleh seluruh administrator.',
                    icon: Icons.manage_history_rounded,
                    accentColor: const Color(0xFF6366F1), // Indigo
                    iconBgColor: const Color(0xFF6366F1).withValues(alpha: 0.1),
                    onTap: () {
                      context.router.push(const ActivityLogRoute());
                    },
                  ),
                  SizedBox(height: 24.h),
                ],
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
}
