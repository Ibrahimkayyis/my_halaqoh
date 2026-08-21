import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:my_halaqoh/gen/i18n/translations.g.dart';
import 'package:my_halaqoh/src/core/helpers/active_session_helper.dart';
import 'package:my_halaqoh/src/core/router/app_router.dart';
import 'package:my_halaqoh/src/core/service_locator/service_locator.dart';
import 'package:my_halaqoh/src/core/theme/app_colors.dart';
import 'package:my_halaqoh/src/core/widget/dialog/confirm_logout_dialog.dart';
import 'package:my_halaqoh/src/modules/auth/presentation/cubits/auth_cubit.dart';
import 'package:my_halaqoh/src/modules/guru_profile/presentation/cubits/guru_profile_cubit.dart';
import 'package:my_halaqoh/src/modules/guru_profile/presentation/cubits/guru_profile_state.dart';
import 'package:my_halaqoh/src/modules/master_data/domain/models/guru_model.dart';
import 'package:my_halaqoh/src/modules/master_data/domain/models/halaqoh_model.dart';
import 'package:my_halaqoh/src/modules/master_data/presentation/cubits/guru_cubit.dart';
import 'package:my_halaqoh/src/modules/master_data/presentation/cubits/guru_state.dart';
import 'package:my_halaqoh/src/modules/master_data/presentation/cubits/halaqoh_cubit.dart';
import 'package:my_halaqoh/src/modules/master_data/presentation/cubits/halaqoh_state.dart';

/// Profile screen for Guru role with Unified Single-Scroll, Hero Identity Card,
/// and direct photo change/delete capability.
class GuruProfileScreen extends StatefulWidget {
  const GuruProfileScreen({super.key});

  @override
  State<GuruProfileScreen> createState() => _GuruProfileScreenState();
}

class _GuruProfileScreenState extends State<GuruProfileScreen> {
  late final GuruProfileCubit _profileCubit;
  String? _lastLoadedId;
  bool _isUploadingPhoto = false;

  @override
  void initState() {
    super.initState();
    _profileCubit = sl<GuruProfileCubit>();
  }

  @override
  void dispose() {
    _profileCubit.close();
    super.dispose();
  }

  /// Show bottom sheet for photo options (Pick new or Delete directly)
  void _showPhotoOptionsSheet(
    BuildContext context,
    GuruModel? guru,
    String linkedDocId,
  ) {
    if (guru == null || linkedDocId.isEmpty) return;

    final colors = AppColors.of(context);
    final hasPhoto = guru.profilePicture != null && guru.profilePicture!.isNotEmpty;

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
                  'Foto Profil',
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
                        final updated = guru.copyWith(
                          profilePicture: url,
                          updatedAt: DateTime.now(),
                        );
                        await _profileCubit.updateProfile(updated);
                        if (!mounted) return;
                        _profileCubit.loadProfile(linkedDocId);
                        try {
                          context.read<GuruCubit>().updateGuru(updated);
                        } catch (_) {}

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'Foto profil berhasil diperbarui',
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
                      final updated = guru.copyWith(
                        profilePicture: null,
                        updatedAt: DateTime.now(),
                      );
                      final success = await _profileCubit.updateProfile(updated);
                      if (!mounted) return;
                      if (success) {
                        _profileCubit.loadProfile(linkedDocId);
                        try {
                          context.read<GuruCubit>().updateGuru(updated);
                        } catch (_) {}

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'Foto profil berhasil dihapus',
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

    // Dynamically load profile when linked teacher doc is present
    if (linkedDocId.isNotEmpty && linkedDocId != _lastLoadedId) {
      _lastLoadedId = linkedDocId;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _profileCubit.loadProfile(linkedDocId);
      });
    }

    final guruState = context.watch<GuruCubit>().state;
    final halaqohState = context.watch<HalaqohCubit>().state;

    // Fallback GuruModel from GuruCubit's streamed list
    GuruModel? fallbackGuru;
    guruState.maybeWhen(
      loaded: (list) {
        try {
          fallbackGuru = list.firstWhere((g) => g.id == linkedDocId);
        } catch (_) {}
      },
      orElse: () {},
    );

    // Find halaqoh assignment for role badge
    HalaqohModel? myHalaqoh;
    halaqohState.maybeWhen(
      loaded: (list) {
        try {
          myHalaqoh = list.firstWhere((h) => h.guruId == linkedDocId);
        } catch (_) {}
      },
      orElse: () {},
    );

    final roleBadge = myHalaqoh != null
        ? t.guruProfile.pengampu(halaqoh: myHalaqoh!.nama)
        : t.guruProfile.guruHalaqoh;

    return BlocProvider.value(
      value: _profileCubit,
      child: BlocBuilder<GuruProfileCubit, GuruProfileState>(
        builder: (context, profileState) {
          GuruModel? currentGuru;
          profileState.maybeWhen(
            loaded: (g) => currentGuru = g,
            updateSuccess: (g) => currentGuru = g,
            orElse: () {},
          );
          currentGuru ??= fallbackGuru;

          final guruName = currentGuru?.nama ?? t.guruProfile.loading;
          final guruNip = currentGuru?.nip ?? '';
          final profilePictureUrl = currentGuru?.profilePicture;

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
                      guru: currentGuru,
                      name: guruName,
                      nip: guruNip,
                      role: roleBadge,
                      profilePictureUrl: profilePictureUrl,
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
                          onTap: () => context.router.push(const UbahPasswordRoute()),
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
                          onTap: () => context.router.push(const PengaturanRoute()),
                        ),
                        _MenuItemData(
                          icon: Icons.info_outline,
                          label: t.guruProfile.tentangAplikasi,
                          onTap: () => context.router.push(const TentangAplikasiRoute()),
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

  /// Hero Profile Identity Card with Avatar (with Camera badge & tap), Name, NIP, Role Badge, and Edit Profile Button
  Widget _buildHeroCard({
    required BuildContext context,
    required AppColorSet colors,
    required GuruModel? guru,
    required String name,
    required String nip,
    required String role,
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
                : () => _showPhotoOptionsSheet(context, guru, linkedDocId),
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

          // NIP
          if (nip.isNotEmpty) ...[
            SizedBox(height: 3.h),
            Text(
              t.guruProfile.nipLabel(nip: nip),
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 12.sp,
                fontWeight: FontWeight.w400,
                color: colors.textSecondary,
              ),
            ),
          ],
          SizedBox(height: 10.h),

          // Role / Pengampu Badge (Solid Primary with White Text)
          Container(
            padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 5.h),
            decoration: BoxDecoration(
              color: colors.primary,
              borderRadius: BorderRadius.circular(20.r),
            ),
            child: Text(
              role,
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 12.sp,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
          SizedBox(height: 16.h),

          // Quick Action: Edit Profile Button
          SizedBox(
            width: double.infinity,
            height: 38.h,
            child: OutlinedButton.icon(
              onPressed: () async {
                await context.router.push(const EditProfileRoute());
                if (context.mounted && linkedDocId.isNotEmpty) {
                  _profileCubit.loadProfile(linkedDocId);
                  try {
                    context.read<GuruCubit>().watchAll();
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
