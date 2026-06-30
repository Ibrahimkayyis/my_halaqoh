import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_halaqoh/gen/i18n/translations.g.dart';
import 'package:my_halaqoh/src/core/router/app_router.dart';
import 'package:my_halaqoh/src/core/service_locator/service_locator.dart';
import 'package:my_halaqoh/src/core/theme/app_colors.dart';
import 'package:my_halaqoh/src/core/widget/dialog/confirm_logout_dialog.dart';
import 'package:my_halaqoh/src/modules/auth/presentation/cubits/auth_cubit.dart';
import 'package:my_halaqoh/src/modules/auth/presentation/cubits/auth_state.dart';
import 'package:my_halaqoh/src/core/helpers/active_session_helper.dart';
import 'package:my_halaqoh/src/modules/master_data/domain/models/halaqoh_model.dart';
import 'package:my_halaqoh/src/modules/master_data/domain/models/santri_model.dart';
import 'package:my_halaqoh/src/modules/master_data/presentation/cubits/halaqoh_cubit.dart';
import 'package:my_halaqoh/src/modules/master_data/presentation/cubits/halaqoh_state.dart';
import 'package:my_halaqoh/src/modules/wali_santri_profile/presentation/cubits/wali_santri_profile_cubit.dart';
import 'package:my_halaqoh/src/modules/wali_santri_profile/presentation/cubits/wali_santri_profile_state.dart';

/// Profile screen for Wali Santri role — avatar, name, class badge, menu items, logout
@RoutePage()
class WaliSantriProfileScreen extends StatefulWidget {
  const WaliSantriProfileScreen({super.key});

  @override
  State<WaliSantriProfileScreen> createState() =>
      _WaliSantriProfileScreenState();
}

class _WaliSantriProfileScreenState extends State<WaliSantriProfileScreen> {
  late final WaliSantriProfileCubit _profileCubit;
  String? _lastLoadedId;

  @override
  void initState() {
    super.initState();
    _profileCubit = sl<WaliSantriProfileCubit>();
  }

  @override
  void dispose() {
    _profileCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);

    final linkedDocId = ActiveSessionHelper.getActiveLinkedDocId(context) ?? '';

    // Dynamically load profile when linked student switches
    if (linkedDocId.isNotEmpty && linkedDocId != _lastLoadedId) {
      _lastLoadedId = linkedDocId;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _profileCubit.loadProfile(linkedDocId);
      });
    }

    final authState = context.watch<AuthCubit>().state;
    final halaqohState = context.watch<HalaqohCubit>().state;

    String santriName = '';
    String nis = '';

    final realRole = authState.maybeWhen(
      authenticated: (user) => user.role,
      orElse: () => null,
    );
    final activeRole = ActiveSessionHelper.getActiveRole(context);
    final isImpersonation = realRole == 'super_admin' && activeRole != 'super_admin';

    authState.maybeWhen(
      authenticated: (userMeta) {
        if (!isImpersonation) {
          santriName = userMeta.displayName;
          nis = userMeta.identifier;
        }
      },
      orElse: () {},
    );

    HalaqohModel? myHalaqoh;
    halaqohState.maybeWhen(
      loaded: (list) {
        try {
          myHalaqoh = list.firstWhere(
            (h) => h.santriIds.contains(linkedDocId),
          );
        } catch (_) {}
      },
      orElse: () {},
    );

    return BlocProvider.value(
      value: _profileCubit,
      child: BlocBuilder<WaliSantriProfileCubit, WaliSantriProfileState>(
        builder: (context, profileState) {
          // Extract profile picture URL from loaded santri data
          SantriModel? santri;
          profileState.maybeWhen(
            loaded: (s) => santri = s,
            updateSuccess: (s) => santri = s,
            orElse: () {},
          );

          return Scaffold(
            backgroundColor: colors.background,
            body: Column(
              children: [
                _buildHeader(
                  colors: colors,
                  name: santri?.nama ?? (santriName.isNotEmpty ? santriName : t.guruProfile.loading),
                  nis: santri?.nis ?? nis,
                  badge: myHalaqoh != null
                      ? '${t.progressHafalanPerJuz.kelasLabel(kelas: myHalaqoh!.kelas)} | ${myHalaqoh!.program == 'T' ? t.myHalaqohScreen.programTakhassus : t.myHalaqohScreen.programReguler}'
                      : '${t.progressHafalanPerJuz.kelasLabel(kelas: '?')} | ?',
                  profilePictureUrl: santri?.profilePicture,
                ),
                // ── Menu sections ──
                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.symmetric(horizontal: 24.w),
                    child: Column(
                      children: [
                        SizedBox(height: 24.h),

                        // Card 1 — Edit Profile & Ubah Password
                        _buildMenuCard(
                          colors,
                          items: [
                            _MenuItem(
                              icon: Icons.person,
                              label: t.guruProfile.editProfile,
                              onTap: () {
                                context.router.push(
                                  const WaliSantriEditProfileRoute(),
                                );
                              },
                            ),
                            _MenuItem(
                              icon: Icons.lock,
                              label: t.guruProfile.ubahPassword,
                              onTap: () {
                                context.router.push(
                                  const WaliSantriUbahPasswordRoute(),
                                );
                              },
                            ),
                          ],
                        ),
                        SizedBox(height: 14.h),

                        // Card 2 — Pengaturan & Tentang Aplikasi
                        _buildMenuCard(
                          colors,
                          items: [
                            _MenuItem(
                              icon: Icons.settings,
                              label: t.guruProfile.pengaturan,
                              onTap: () {
                                context.router.push(
                                  const WaliSantriPengaturanRoute(),
                                );
                              },
                            ),
                            _MenuItem(
                              icon: Icons.info_outline,
                              label: t.guruProfile.tentangAplikasi,
                              onTap: () {
                                context.router.push(
                                  const TentangAplikasiRoute(),
                                );
                              },
                            ),
                          ],
                        ),
                        SizedBox(height: 14.h),

                        // Logout button
                        _buildLogoutCard(colors, context),
                        SizedBox(height: 16.h),
                        SizedBox(height: 100.h), // space for bottom nav
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  /// Green gradient header with avatar, santri name, and class badge
  Widget _buildHeader({
    required AppColorSet colors,
    required String name,
    required String nis,
    required String badge,
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
          bottomLeft: Radius.circular(32.r),
          bottomRight: Radius.circular(32.r),
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: EdgeInsets.only(top: 24.h, bottom: 32.h),
          child: Column(
            children: [
              // Avatar circle — shows profile picture if available
              Container(
                width: 100.w,
                height: 100.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withValues(alpha: 0.2),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.5),
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
                    ? Icon(Icons.person, size: 52.sp, color: Colors.white)
                    : null,
              ),
              SizedBox(height: 14.h),

              // Name
              Text(
                name,
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
                  t.progressHafalanPerJuz.nisLabel(nis: nis),
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w400,
                    color: Colors.white.withValues(alpha: 0.85),
                    fontFamily: 'Poppins',
                  ),
                ),
              SizedBox(height: 6.h),

              // Class badge
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 5.h),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: Text(
                  badge,
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                    fontFamily: 'Poppins',
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Rounded card containing menu items with dividers between them
  Widget _buildMenuCard(AppColorSet colors, {required List<_MenuItem> items}) {
    return Container(
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
          for (int i = 0; i < items.length; i++) ...[
            _buildMenuItem(items[i], colors),
            if (i < items.length - 1)
              Divider(
                height: 1,
                indent: 60.w,
                endIndent: 20.w,
                color: colors.border.withValues(alpha: 0.5),
              ),
          ],
        ],
      ),
    );
  }

  Widget _buildMenuItem(_MenuItem item, AppColorSet colors) {
    return InkWell(
      onTap: item.onTap,
      borderRadius: BorderRadius.circular(16.r),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 16.h),
        child: Row(
          children: [
            // Icon circle
            Container(
              width: 40.w,
              height: 40.w,
              decoration: BoxDecoration(
                color: colors.primary.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(item.icon, size: 20.sp, color: colors.primary),
            ),
            SizedBox(width: 14.w),

            // Label
            Expanded(
              child: Text(
                item.label,
                style: TextStyle(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w500,
                  color: colors.textPrimary,
                  fontFamily: 'Poppins',
                ),
              ),
            ),

            // Chevron
            Icon(Icons.chevron_right, size: 22.sp, color: colors.primary),
          ],
        ),
      ),
    );
  }

  /// Logout card
  Widget _buildLogoutCard(AppColorSet colors, BuildContext context) {
    return Container(
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
      child: InkWell(
        onTap: () async {
          final confirmed = await ConfirmLogoutDialog.show(context);
          if (confirmed && context.mounted) {
            final authCubit = context.read<AuthCubit>();
            context.router.replaceAll([const LoginRoute()]);
            await authCubit.logout();
          }
        },
        borderRadius: BorderRadius.circular(16.r),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 16.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.logout, size: 20.sp, color: Colors.redAccent),
              SizedBox(width: 8.w),
              Text(
                t.guruProfile.keluar,
                style: TextStyle(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.redAccent,
                  fontFamily: 'Poppins',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Helper model for menu items
class _MenuItem {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _MenuItem({
    required this.icon,
    required this.label,
    required this.onTap,
  });
}
