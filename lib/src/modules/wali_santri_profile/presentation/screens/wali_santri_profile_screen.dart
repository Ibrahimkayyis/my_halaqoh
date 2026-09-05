import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:my_halaqoh/gen/i18n/translations.g.dart';
import 'package:my_halaqoh/src/core/constants/legal_constants.dart';
import 'package:my_halaqoh/src/core/helpers/active_session_helper.dart';
import 'package:my_halaqoh/src/core/router/app_router.dart';
import 'package:my_halaqoh/src/core/service_locator/service_locator.dart';
import 'package:my_halaqoh/src/core/theme/app_colors.dart';
import 'package:my_halaqoh/src/core/widget/dialog/confirm_delete_account_dialog.dart';
import 'package:my_halaqoh/src/core/widget/dialog/confirm_logout_dialog.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:my_halaqoh/src/modules/auth/presentation/cubits/auth_cubit.dart';
import 'package:my_halaqoh/src/modules/auth/presentation/cubits/auth_state.dart';
import 'package:my_halaqoh/src/modules/master_data/domain/models/halaqoh_model.dart';
import 'package:my_halaqoh/src/modules/master_data/domain/models/santri_model.dart';
import 'package:my_halaqoh/src/modules/master_data/presentation/cubits/halaqoh_cubit.dart';
import 'package:my_halaqoh/src/modules/master_data/presentation/cubits/halaqoh_state.dart';
import 'package:my_halaqoh/src/modules/master_data/presentation/cubits/santri_cubit.dart';
import 'package:my_halaqoh/src/modules/wali_santri_profile/presentation/cubits/wali_santri_profile_cubit.dart';
import 'package:my_halaqoh/src/modules/wali_santri_profile/presentation/cubits/wali_santri_profile_state.dart';

/// Profile screen for Wali Santri role with Unified Single-Scroll, Hero Identity Card,
/// and direct photo change/delete capability.
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
  bool _isUploadingPhoto = false;

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

  Future<void> _openPrivacyPolicy(BuildContext context) async {
    final uri = Uri.parse(LegalConstants.privacyPolicyUrl);
    try {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (_) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text(
              'Gagal membuka tautan Kebijakan Privasi.',
              style: TextStyle(fontFamily: 'Poppins'),
            ),
            backgroundColor: AppColors.of(context).error,
          ),
        );
      }
    }
  }

  /// Show bottom sheet for photo options (Pick new or Delete directly)
  void _showPhotoOptionsSheet(

    BuildContext context,
    SantriModel? santri,
    String linkedDocId,
  ) {
    if (santri == null || linkedDocId.isEmpty) return;

    final colors = AppColors.of(context);
    final hasPhoto = santri.profilePicture != null && santri.profilePicture!.isNotEmpty;

    showModalBottomSheet(
      context: context,
      backgroundColor: colors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40.w,
                    height: 4.h,
                    decoration: BoxDecoration(
                      color: colors.border,
                      borderRadius: BorderRadius.circular(2.r),
                    ),
                  ),
                ),
                SizedBox(height: 16.h),
                Text(
                  'Foto Profil Santri',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w700,
                    color: colors.textPrimary,
                  ),
                ),
                SizedBox(height: 12.h),
                ListTile(
                  leading: Container(
                    padding: EdgeInsets.all(8.w),
                    decoration: BoxDecoration(
                      color: colors.primary,
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Icon(Icons.photo_library_outlined,
                        color: Colors.white, size: 20.sp),
                  ),
                  title: Text(
                    'Pilih dari Galeri',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                      color: colors.textPrimary,
                    ),
                  ),
                  onTap: () async {
                    Navigator.of(ctx).pop();
                    final picker = ImagePicker();
                    final pickedFile = await picker.pickImage(
                      source: ImageSource.gallery,
                      imageQuality: 70,
                    );
                    if (pickedFile != null && mounted) {
                      setState(() => _isUploadingPhoto = true);
                      final url = await _profileCubit.uploadPhoto(
                        linkedDocId,
                        File(pickedFile.path),
                      );
                      if (!mounted) return;
                      if (url != null) {
                        final updated = santri.copyWith(
                          profilePicture: url,
                          updatedAt: DateTime.now(),
                        );
                        await _profileCubit.updateProfile(updated);
                        if (!mounted) return;
                        _profileCubit.loadProfile(linkedDocId);
                        try {
                          context.read<SantriCubit>().updateSantri(updated);
                        } catch (_) {}

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'Foto profil santri berhasil diperbarui',
                              style: TextStyle(fontFamily: 'Poppins', fontSize: 13.sp),
                            ),
                            backgroundColor: Colors.green,
                            behavior: SnackBarBehavior.floating,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                          ),
                        );
                      }
                      setState(() => _isUploadingPhoto = false);
                    }
                  },
                ),
                if (hasPhoto)
                  ListTile(
                    leading: Container(
                      padding: EdgeInsets.all(8.w),
                      decoration: BoxDecoration(
                        color: colors.error,
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: Icon(Icons.delete_outline_rounded,
                          color: Colors.white, size: 20.sp),
                    ),
                    title: Text(
                      'Hapus Foto Profil',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                        color: colors.error,
                      ),
                    ),
                    onTap: () async {
                      Navigator.of(ctx).pop();
                      setState(() => _isUploadingPhoto = true);
                      final updated = santri.copyWith(
                        profilePicture: null,
                        updatedAt: DateTime.now(),
                      );
                      final success = await _profileCubit.updateProfile(updated);
                      if (!mounted) return;
                      if (success) {
                        _profileCubit.loadProfile(linkedDocId);
                        try {
                          context.read<SantriCubit>().updateSantri(updated);
                        } catch (_) {}

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'Foto profil santri berhasil dihapus',
                              style: TextStyle(fontFamily: 'Poppins', fontSize: 13.sp),
                            ),
                            backgroundColor: Colors.green,
                            behavior: SnackBarBehavior.floating,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                          ),
                        );
                      }
                      setState(() => _isUploadingPhoto = false);
                    },
                  ),
                SizedBox(height: 8.h),
              ],
            ),
          ),
        );
      },
    );
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

          final displayName = santri?.nama ?? (santriName.isNotEmpty ? santriName : t.guruProfile.loading);
          final displayNis = santri?.nis ?? nis;
          final classBadge = myHalaqoh != null
              ? '${t.progressHafalanPerJuz.kelasLabel(kelas: myHalaqoh!.kelas)} | ${myHalaqoh!.program == 'T' ? t.myHalaqohScreen.programTakhassus : t.myHalaqohScreen.programReguler}'
              : (santri != null ? '${t.progressHafalanPerJuz.kelasLabel(kelas: santri!.kelas)} | ${santri!.program == 'T' ? t.myHalaqohScreen.programTakhassus : t.myHalaqohScreen.programReguler}' : '');

          return Scaffold(
            backgroundColor: colors.background,
            body: SafeArea(
              bottom: false,
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
                child: Column(
                  children: [
                    // ── Hero Profile Identity Card ──
                    _buildHeroCard(
                      context: context,
                      colors: colors,
                      santri: santri,
                      name: displayName,
                      nis: displayNis,
                      badge: classBadge,
                      profilePictureUrl: santri?.profilePicture,
                      linkedDocId: linkedDocId,
                    ),
                    SizedBox(height: 24.h),

                    // ── Section 1: Akun & Keamanan ──
                    _buildSectionHeader(colors, 'AKUN & KEAMANAN'),
                    SizedBox(height: 8.h),
                    _buildMenuCard(
                      colors,
                      items: [
                        _MenuItemData(
                          icon: Icons.lock_outline,
                          label: t.guruProfile.ubahPassword,
                          onTap: () => context.router.push(const WaliSantriUbahPasswordRoute()),
                        ),
                      ],
                    ),
                    SizedBox(height: 20.h),

                    // ── Section 2: Preferensi & Informasi ──
                    _buildSectionHeader(colors, 'PREFERENSI & INFORMASI'),
                    SizedBox(height: 8.h),
                    _buildMenuCard(
                      colors,
                      items: [
                        _MenuItemData(
                          icon: Icons.settings_outlined,
                          label: t.guruProfile.pengaturan,
                          onTap: () => context.router.push(const WaliSantriPengaturanRoute()),
                        ),
                        _MenuItemData(
                          icon: Icons.info_outline,
                          label: t.guruProfile.tentangAplikasi,
                          onTap: () => context.router.push(const TentangAplikasiRoute()),
                        ),
                        _MenuItemData(
                          icon: Icons.privacy_tip_outlined,
                          label: t.guruProfile.kebijakanPrivasi,
                          onTap: () => _openPrivacyPolicy(context),
                        ),
                      ],
                    ),
                    SizedBox(height: 20.h),

                    // ── Section 3: Sesi ──
                    _buildSectionHeader(colors, 'SESI'),
                    SizedBox(height: 8.h),
                    _buildMenuCard(
                      colors,
                      items: [
                        _MenuItemData(
                          icon: Icons.logout_rounded,
                          label: 'Keluar Akun',
                          isDestructive: true,
                          onTap: () async {
                            final confirmed = await ConfirmLogoutDialog.show(context);
                            if (confirmed && context.mounted) {
                              final authCubit = context.read<AuthCubit>();
                              context.router.replaceAll([const LoginRoute()]);
                              await authCubit.logout();
                            }
                          },
                        ),
                        _MenuItemData(
                          icon: Icons.delete_forever_rounded,
                          label: t.guruProfile.hapusAkun,
                          isDestructive: true,
                          onTap: () async {
                            final confirmed =
                                await ConfirmDeleteAccountDialog.show(context);
                            if (confirmed && context.mounted) {
                              final authCubit = context.read<AuthCubit>();
                              final colors = AppColors.of(context);
                              final scaffoldMessenger =
                                  ScaffoldMessenger.of(context);

                              showDialog(
                                context: context,
                                barrierDismissible: false,
                                builder: (ctx) => Center(
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 28.w,
                                      vertical: 24.h,
                                    ),
                                    decoration: BoxDecoration(
                                      color: colors.surface,
                                      borderRadius:
                                          BorderRadius.circular(16.r),
                                    ),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        CircularProgressIndicator(
                                          color: colors.error,
                                        ),
                                        SizedBox(height: 16.h),
                                        Text(
                                          'Menghapus akun...',
                                          style: TextStyle(
                                            fontFamily: 'Poppins',
                                            fontSize: 13.sp,
                                            fontWeight: FontWeight.w500,
                                            color: colors.textPrimary,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );

                              final error = await authCubit.deleteAccount();
                              if (context.mounted) {
                                Navigator.of(context, rootNavigator: true)
                                    .pop();
                                if (error == null) {
                                  context.router
                                      .replaceAll([const LoginRoute()]);
                                  scaffoldMessenger.showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        t.guruProfile.deleteAccountSuccess,
                                        style: const TextStyle(
                                          fontFamily: 'Poppins',
                                        ),
                                      ),
                                      backgroundColor: colors.primary,
                                    ),
                                  );
                                } else {
                                  scaffoldMessenger.showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        t.guruProfile.deleteAccountFailed(
                                          error: error,
                                        ),
                                        style: const TextStyle(
                                          fontFamily: 'Poppins',
                                        ),
                                      ),
                                      backgroundColor: colors.error,
                                    ),
                                  );
                                }
                              }
                            }
                          },
                        ),
                      ],
                    ),

                    SizedBox(height: 24.h),

                    // ── App Version Footer ──
                    Text(
                      'MyHalaqoh v1.0.0',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 11.sp,
                        color: colors.textSecondary.withValues(alpha: 0.6),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 100.h), // Safe spacing for bottom navigation
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  /// Hero Profile Identity Card with Avatar (with Camera badge & tap), Name, NIS, Class Badge, and Edit Profile Button
  Widget _buildHeroCard({
    required BuildContext context,
    required AppColorSet colors,
    required SantriModel? santri,
    required String name,
    required String nis,
    required String badge,
    required String linkedDocId,
    String? profilePictureUrl,
  }) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: colors.border.withValues(alpha: 0.6)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Avatar circle with camera badge overlay (tappable to change/delete photo)
          GestureDetector(
            onTap: _isUploadingPhoto
                ? null
                : () => _showPhotoOptionsSheet(context, santri, linkedDocId),
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  width: 84.w,
                  height: 84.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: colors.surface,
                    border: Border.all(
                      color: colors.primary,
                      width: 2.5,
                    ),
                  ),
                  child: ClipOval(
                    child: profilePictureUrl != null && profilePictureUrl.isNotEmpty
                        ? Image.network(
                            profilePictureUrl,
                            fit: BoxFit.cover,
                            width: 84.w,
                            height: 84.w,
                            errorBuilder: (context, error, stackTrace) => Icon(
                              Icons.person_rounded,
                              size: 44.sp,
                              color: colors.primary,
                            ),
                          )
                        : Icon(
                            Icons.person_rounded,
                            size: 44.sp,
                            color: colors.primary,
                          ),
                  ),
                ),
                // Camera Badge Overlay
                Positioned(
                  bottom: -2,
                  right: -2,
                  child: Container(
                    width: 28.w,
                    height: 28.w,
                    decoration: BoxDecoration(
                      color: colors.primary,
                      shape: BoxShape.circle,
                      border: Border.all(color: colors.surface, width: 2),
                    ),
                    child: Icon(
                      Icons.camera_alt_rounded,
                      size: 14.sp,
                      color: Colors.white,
                    ),
                  ),
                ),
                if (_isUploadingPhoto)
                  Positioned.fill(
                    child: Container(
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.black54,
                      ),
                      child: const Center(
                        child: CircularProgressIndicator(color: Colors.white),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          SizedBox(height: 12.h),

          // Name (soft-wrapping)
          Text(
            name,
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 18.sp,
              fontWeight: FontWeight.w700,
              color: colors.textPrimary,
              height: 1.25,
            ),
            textAlign: TextAlign.center,
            softWrap: true,
          ),

          // NIS
          if (nis.isNotEmpty) ...[
            SizedBox(height: 3.h),
            Text(
              t.progressHafalanPerJuz.nisLabel(nis: nis),
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 12.sp,
                fontWeight: FontWeight.w400,
                color: colors.textSecondary,
              ),
            ),
          ],
          if (badge.isNotEmpty) ...[
            SizedBox(height: 10.h),
            // Class & Program Badge (Solid Primary with White Text)
            Container(
              padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 5.h),
              decoration: BoxDecoration(
                color: colors.primary,
                borderRadius: BorderRadius.circular(20.r),
              ),
              child: Text(
                badge,
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ],
          SizedBox(height: 16.h),

          // Quick Action: Edit Profile Button
          SizedBox(
            width: double.infinity,
            height: 38.h,
            child: OutlinedButton.icon(
              onPressed: () async {
                await context.router.push(const WaliSantriEditProfileRoute());
                if (context.mounted && linkedDocId.isNotEmpty) {
                  _profileCubit.loadProfile(linkedDocId);
                  try {
                    context.read<SantriCubit>().watchAll();
                  } catch (_) {}
                }
              },
              icon: Icon(Icons.edit_outlined, size: 16.sp, color: colors.primary),
              label: Text(
                t.guruProfile.editProfile,
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w600,
                  color: colors.primary,
                ),
              ),
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: colors.primary, width: 1.5),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.r),
                ),
                backgroundColor: colors.surface,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Section Header text
  Widget _buildSectionHeader(AppColorSet colors, String title) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: EdgeInsets.only(left: 4.w),
        child: Text(
          title,
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 11.5.sp,
            fontWeight: FontWeight.w600,
            color: colors.textSecondary,
            letterSpacing: 0.8,
          ),
        ),
      ),
    );
  }

  /// Rounded card containing menu items with dividers
  Widget _buildMenuCard(AppColorSet colors, {required List<_MenuItemData> items}) {
    return Container(
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: colors.border.withValues(alpha: 0.6)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          for (int i = 0; i < items.length; i++) ...[
            if (i > 0)
              Divider(
                height: 1,
                thickness: 1,
                indent: 52.w,
                endIndent: 16.w,
                color: colors.border.withValues(alpha: 0.5),
              ),
            _buildMenuItemTile(colors, items[i]),
          ],
        ],
      ),
    );
  }

  /// Single menu tile with Solid Primary / Solid Error Icon Box
  Widget _buildMenuItemTile(AppColorSet colors, _MenuItemData item) {
    final itemColor = item.isDestructive ? colors.error : colors.textPrimary;
    final iconBgColor = item.isDestructive ? colors.error : colors.primary;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: item.onTap,
        borderRadius: BorderRadius.circular(16.r),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 13.h),
          child: Row(
            children: [
              Container(
                width: 36.w,
                height: 36.w,
                decoration: BoxDecoration(
                  color: iconBgColor,
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Icon(item.icon, size: 18.sp, color: Colors.white),
              ),
              SizedBox(width: 14.w),
              Expanded(
                child: Text(
                  item.label,
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 13.5.sp,
                    fontWeight: FontWeight.w500,
                    color: itemColor,
                  ),
                ),
              ),
              Icon(
                Icons.chevron_right_rounded,
                size: 20.sp,
                color: colors.textSecondary.withValues(alpha: 0.5),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MenuItemData {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool isDestructive;

  const _MenuItemData({
    required this.icon,
    required this.label,
    required this.onTap,
    this.isDestructive = false,
  });
}
