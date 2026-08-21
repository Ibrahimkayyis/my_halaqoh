import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:my_halaqoh/gen/i18n/translations.g.dart';
import 'package:my_halaqoh/src/core/helpers/active_session_helper.dart';
import 'package:my_halaqoh/src/core/service_locator/service_locator.dart';
import 'package:my_halaqoh/src/core/theme/app_colors.dart';
import 'package:my_halaqoh/src/core/widget/widgets.dart';
import 'package:my_halaqoh/src/modules/guru_profile/presentation/cubits/guru_profile_cubit.dart';
import 'package:my_halaqoh/src/modules/guru_profile/presentation/cubits/guru_profile_state.dart';
import 'package:my_halaqoh/src/modules/master_data/domain/models/guru_model.dart';
import 'package:my_halaqoh/src/modules/master_data/domain/models/halaqoh_model.dart';
import 'package:my_halaqoh/src/modules/master_data/presentation/cubits/guru_cubit.dart';
import 'package:my_halaqoh/src/modules/master_data/presentation/cubits/halaqoh_cubit.dart';
import 'package:my_halaqoh/src/modules/master_data/presentation/cubits/halaqoh_state.dart';

/// Edit Profile Screen for Guru role with clean form layout,
/// delete photo support, and docked sticky bottom action button.
@RoutePage()
class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _namaController = TextEditingController();
  final _nipController = TextEditingController();
  final _jabatanController = TextEditingController();
  final _nomorHpController = TextEditingController();
  final _emailController = TextEditingController();

  late final GuruProfileCubit _profileCubit;
  String _linkedDocId = '';
  File? _selectedImage;
  String? _currentProfilePictureUrl;
  bool _photoDeleted = false;
  bool _isUploading = false;
  bool _isSaving = false;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _profileCubit = sl<GuruProfileCubit>();
    _linkedDocId = ActiveSessionHelper.getActiveLinkedDocId(context) ?? '';

    if (_linkedDocId.isNotEmpty) {
      _profileCubit.loadProfile(_linkedDocId);
    }
  }

  /// Populate form fields when guru data is loaded
  void _populateFields(GuruModel guru) {
    if (_isInitialized) return;
    _isInitialized = true;

    _namaController.text = guru.nama;
    _nipController.text = guru.nip;
    _nomorHpController.text = guru.phone ?? '';
    _emailController.text = guru.email ?? '';
    _currentProfilePictureUrl = guru.profilePicture;

    // Derive jabatan from halaqoh assignment
    final halaqohState = context.read<HalaqohCubit>().state;
    HalaqohModel? myHalaqoh;
    halaqohState.maybeWhen(
      loaded: (list) {
        try {
          myHalaqoh = list.firstWhere((h) => h.guruId == guru.id);
        } catch (_) {}
      },
      orElse: () {},
    );
    _jabatanController.text = myHalaqoh != null
        ? t.editProfile.pengampu(halaqoh: myHalaqoh!.nama)
        : t.guruProfile.guruHalaqoh;
  }

  /// Show bottom sheet for photo options (Pick new or Delete)
  void _showPhotoOptionsSheet() {
    final colors = AppColors.of(context);
    final hasPhoto = _selectedImage != null ||
        (_currentProfilePictureUrl != null &&
            _currentProfilePictureUrl!.isNotEmpty &&
            !_photoDeleted);

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
                  onTap: () {
                    Navigator.of(ctx).pop();
                    _pickImage();
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
                    onTap: () {
                      Navigator.of(ctx).pop();
                      setState(() {
                        _selectedImage = null;
                        _photoDeleted = true;
                        _currentProfilePictureUrl = null;
                      });
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

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 70,
    );
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
        _photoDeleted = false;
      });
    }
  }

  Future<void> _saveProfile() async {
    if (_isSaving || _isUploading) return;

    setState(() => _isSaving = true);

    // Get the current guru model from cubit state
    final currentGuru = _profileCubit.state.maybeWhen(
      loaded: (guru) => guru,
      updateSuccess: (guru) => guru,
      orElse: () => null,
    );

    if (currentGuru == null) {
      setState(() => _isSaving = false);
      return;
    }

    String? photoUrl = _photoDeleted ? null : _currentProfilePictureUrl;

    // Upload photo if a new one was selected
    if (_selectedImage != null) {
      setState(() => _isUploading = true);
      final url = await _profileCubit.uploadPhoto(
        _linkedDocId,
        _selectedImage!,
      );
      if (mounted) setState(() => _isUploading = false);
      if (url != null) {
        photoUrl = url;
        _currentProfilePictureUrl = url;
      }
    }

    // Build updated model
    final updatedModel = currentGuru.copyWith(
      nama: _namaController.text.trim(),
      phone: _nomorHpController.text.trim().isEmpty
          ? null
          : _nomorHpController.text.trim(),
      email: _emailController.text.trim().isEmpty
          ? null
          : _emailController.text.trim(),
      profilePicture: photoUrl,
      updatedAt: DateTime.now(),
    );

    final success = await _profileCubit.updateProfile(updatedModel);

    if (mounted) {
      setState(() => _isSaving = false);
      if (success) {
        try {
          context.read<GuruCubit>().updateGuru(updatedModel);
        } catch (_) {}

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              t.editProfile.successMessage,
              style: TextStyle(fontFamily: 'Poppins', fontSize: 13.sp),
            ),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
            margin: EdgeInsets.only(bottom: 16.h, left: 16.w, right: 16.w),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.r),
            ),
          ),
        );
        Navigator.of(context).pop(true);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              t.editProfile.failedMessage,
              style: TextStyle(fontFamily: 'Poppins', fontSize: 13.sp),
            ),
            backgroundColor: Colors.redAccent,
            behavior: SnackBarBehavior.floating,
            margin: EdgeInsets.only(bottom: 16.h, left: 16.w, right: 16.w),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.r),
            ),
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    _namaController.dispose();
    _nipController.dispose();
    _jabatanController.dispose();
    _nomorHpController.dispose();
    _emailController.dispose();
    _profileCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);

    return BlocProvider.value(
      value: _profileCubit,
      child: Scaffold(
        backgroundColor: colors.background,
        appBar: AppBar(
          backgroundColor: colors.background,
          elevation: 0,
          scrolledUnderElevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_rounded, color: colors.textPrimary),
            onPressed: () => Navigator.of(context).pop(),
          ),
          centerTitle: true,
          title: Text(
            t.editProfile.title,
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 18.sp,
              fontWeight: FontWeight.w700,
              color: colors.textPrimary,
            ),
          ),
        ),
        body: BlocConsumer<GuruProfileCubit, GuruProfileState>(
          listener: (context, state) {
            state.maybeWhen(
              loaded: (guru) => _populateFields(guru),
              updateSuccess: (_) {},
              error: (message) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      message,
                      style: TextStyle(fontFamily: 'Poppins', fontSize: 13.sp),
                    ),
                    backgroundColor: Colors.redAccent,
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
              orElse: () {},
            );
          },
          builder: (context, state) {
            return state.maybeWhen(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (message) => Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.error_outline,
                        size: 48.sp, color: colors.error),
                    SizedBox(height: 12.h),
                    Text(
                      message,
                      style: TextStyle(
                        color: colors.textSecondary,
                        fontFamily: 'Poppins',
                        fontSize: 14.sp,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 16.h),
                    TextButton(
                      onPressed: () =>
                          _profileCubit.loadProfile(_linkedDocId),
                      child: Text(
                        t.editProfile.tryAgain,
                        style: TextStyle(
                          color: colors.primary,
                          fontFamily: 'Poppins',
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              orElse: () => _buildContent(colors),
            );
          },
        ),
        bottomNavigationBar: _buildStickyBottomBar(colors),
      ),
    );
  }

  Widget _buildContent(AppColorSet colors) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Avatar Picker Section ──
          _buildAvatarPickerCard(colors),
          SizedBox(height: 20.h),

          // ── INFORMASI PRIBADI section ──
          _buildSectionCard(
            colors,
            title: t.editProfile.informasiPribadi,
            children: [
              _buildTextField(
                colors,
                label: t.editProfile.namaLengkap,
                controller: _namaController,
                suffixIcon: Icons.edit_outlined,
                iconColor: colors.textSecondary,
                enabled: true,
              ),
              SizedBox(height: 14.h),
              _buildTextField(
                colors,
                label: t.editProfile.nip,
                controller: _nipController,
                suffixIcon: Icons.lock_outline,
                iconColor: colors.textSecondary.withValues(alpha: 0.4),
                enabled: false,
              ),
              SizedBox(height: 14.h),
              _buildTextField(
                colors,
                label: t.editProfile.jabatan,
                controller: _jabatanController,
                suffixIcon: Icons.lock_outline,
                iconColor: colors.textSecondary.withValues(alpha: 0.4),
                enabled: false,
              ),
            ],
          ),
          SizedBox(height: 20.h),

          // ── KONTAK section ──
          _buildSectionCard(
            colors,
            title: t.editProfile.kontak,
            children: [
              _buildTextField(
                colors,
                label: t.editProfile.nomorHp,
                controller: _nomorHpController,
                suffixIcon: Icons.phone_outlined,
                iconColor: colors.textSecondary.withValues(alpha: 0.5),
                enabled: true,
                keyboardType: TextInputType.phone,
              ),
              SizedBox(height: 14.h),
              _buildTextField(
                colors,
                label: t.editProfile.email,
                controller: _emailController,
                suffixIcon: Icons.email_outlined,
                iconColor: colors.textSecondary.withValues(alpha: 0.5),
                enabled: true,
                keyboardType: TextInputType.emailAddress,
              ),
            ],
          ),
          SizedBox(height: 32.h),
        ],
      ),
    );
  }

  /// Avatar Card with photo preview, change & delete options
  Widget _buildAvatarPickerCard(AppColorSet colors) {
    final hasActivePhoto = !_photoDeleted &&
        (_selectedImage != null ||
            (_currentProfilePictureUrl != null &&
                _currentProfilePictureUrl!.isNotEmpty));

    return Center(
      child: Column(
        children: [
          GestureDetector(
            onTap: _isUploading ? null : _showPhotoOptionsSheet,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  width: 96.w,
                  height: 96.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: colors.surface,
                    border: Border.all(
                      color: colors.primary,
                      width: 2.5,
                    ),
                  ),
                  child: ClipOval(
                    child: _selectedImage != null
                        ? Image.file(
                            _selectedImage!,
                            fit: BoxFit.cover,
                            width: 96.w,
                            height: 96.w,
                          )
                        : (hasActivePhoto && _currentProfilePictureUrl != null)
                            ? Image.network(
                                _currentProfilePictureUrl!,
                                fit: BoxFit.cover,
                                width: 96.w,
                                height: 96.w,
                                errorBuilder: (context, error, stackTrace) => Icon(
                                  Icons.person_rounded,
                                  size: 52.sp,
                                  color: colors.primary,
                                ),
                              )
                            : Icon(
                                Icons.person_rounded,
                                size: 52.sp,
                                color: colors.primary,
                              ),
                  ),
                ),
                // Camera Badge Floating
                Positioned(
                  bottom: -2,
                  right: -2,
                  child: Container(
                    width: 32.w,
                    height: 32.w,
                    decoration: BoxDecoration(
                      color: colors.primary,
                      shape: BoxShape.circle,
                      border: Border.all(color: colors.surface, width: 2),
                    ),
                    child: Icon(
                      Icons.camera_alt_rounded,
                      size: 16.sp,
                      color: Colors.white,
                    ),
                  ),
                ),
                if (_isUploading)
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
          SizedBox(height: 10.h),
          TextButton(
            onPressed: _isUploading ? null : _showPhotoOptionsSheet,
            style: TextButton.styleFrom(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: Text(
              t.editProfile.editFotoProfil,
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 12.sp,
                fontWeight: FontWeight.w600,
                color: colors.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Docked Sticky Bottom Action Bar
  Widget _buildStickyBottomBar(AppColorSet colors) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: colors.surface,
        border: Border(
          top: BorderSide(
            color: colors.border.withValues(alpha: 0.6),
            width: 1,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: PrimaryButton(
          width: double.infinity,
          height: 48.h,
          onPressed: (_isSaving || _isUploading) ? null : _saveProfile,
          isLoading: _isSaving,
          icon: _isSaving ? null : Icons.save_rounded,
          label: _isSaving
              ? t.editProfile.saving
              : t.editProfile.simpanPerubahan,
          borderRadius: 8.r, // Standard radius per MASTER.md
        ),
      ),
    );
  }

  /// Rounded section card with title and fields
  Widget _buildSectionCard(
    AppColorSet colors, {
    required String title,
    required List<Widget> children,
  }) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.w700,
              color: colors.primary,
              fontFamily: 'Poppins',
              letterSpacing: 0.5,
            ),
          ),
          SizedBox(height: 14.h),
          ...children,
        ],
      ),
    );
  }

  /// Styled text field with standard 8.r radius
  Widget _buildTextField(
    AppColorSet colors, {
    required String label,
    required TextEditingController controller,
    required IconData suffixIcon,
    required Color iconColor,
    required bool enabled,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12.sp,
            fontWeight: FontWeight.w500,
            color: colors.textSecondary,
            fontFamily: 'Poppins',
          ),
        ),
        SizedBox(height: 6.h),
        TextFormField(
          controller: controller,
          enabled: enabled,
          keyboardType: keyboardType,
          style: TextStyle(
            fontSize: 13.5.sp,
            fontWeight: FontWeight.w500,
            color: enabled ? colors.textPrimary : colors.textSecondary,
            fontFamily: 'Poppins',
          ),
          decoration: InputDecoration(
            filled: true,
            fillColor: enabled
                ? colors.surface
                : colors.border.withValues(alpha: 0.15),
            contentPadding: EdgeInsets.symmetric(
              horizontal: 14.w,
              vertical: 12.h,
            ),
            suffixIcon: Icon(suffixIcon, size: 18.sp, color: iconColor),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.r),
              borderSide: BorderSide(color: colors.border, width: 1),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.r),
              borderSide: BorderSide(color: colors.border, width: 1),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.r),
              borderSide: BorderSide(color: colors.primary, width: 1.5),
            ),
            disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.r),
              borderSide: BorderSide(
                color: colors.border.withValues(alpha: 0.5),
                width: 1,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
