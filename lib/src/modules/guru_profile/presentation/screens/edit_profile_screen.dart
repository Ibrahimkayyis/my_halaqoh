import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:my_halaqoh/gen/i18n/translations.g.dart';
import 'package:my_halaqoh/src/core/service_locator/service_locator.dart';
import 'package:my_halaqoh/src/core/theme/app_colors.dart';
import 'package:my_halaqoh/src/core/widget/widgets.dart';
import 'package:my_halaqoh/src/core/helpers/active_session_helper.dart';
import 'package:my_halaqoh/src/modules/guru_profile/presentation/cubits/guru_profile_cubit.dart';
import 'package:my_halaqoh/src/modules/guru_profile/presentation/cubits/guru_profile_state.dart';
import 'package:my_halaqoh/src/modules/master_data/domain/models/guru_model.dart';
import 'package:my_halaqoh/src/modules/master_data/domain/models/halaqoh_model.dart';
import 'package:my_halaqoh/src/modules/master_data/presentation/cubits/halaqoh_cubit.dart';
import 'package:my_halaqoh/src/modules/master_data/presentation/cubits/halaqoh_state.dart';

/// Edit Profile Screen — green header, avatar with camera, form fields.
/// Reads real data from Firestore via GuruProfileCubit and saves updates.
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

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 70,
    );
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
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

    String? photoUrl = _currentProfilePictureUrl;

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
              borderRadius: BorderRadius.circular(10.r),
            ),
          ),
        );
        Navigator.of(context).pop();
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
              borderRadius: BorderRadius.circular(10.r),
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
                      style:
                          TextStyle(fontFamily: 'Poppins', fontSize: 13.sp),
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
      ),
    );
  }

  Widget _buildContent(AppColorSet colors) {
    return Column(
      children: [
        // ── Green gradient header ──
        _buildHeader(context, colors),

        // ── Form fields ──
        Expanded(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 24.h),

                // INFORMASI PRIBADI section
                _buildSectionCard(
                  colors,
                  title: t.editProfile.informasiPribadi,
                  children: [
                    _buildTextField(
                      colors,
                      label: t.editProfile.namaLengkap,
                      controller: _namaController,
                      suffixIcon: Icons.edit,
                      iconColor: colors.textSecondary,
                      enabled: true,
                    ),
                    SizedBox(height: 14.h),
                    _buildTextField(
                      colors,
                      label: t.editProfile.nip,
                      controller: _nipController,
                      suffixIcon: Icons.lock,
                      iconColor: colors.textSecondary.withValues(alpha: 0.4),
                      enabled: false,
                    ),
                    SizedBox(height: 14.h),
                    _buildTextField(
                      colors,
                      label: t.editProfile.jabatan,
                      controller: _jabatanController,
                      suffixIcon: Icons.lock,
                      iconColor: colors.textSecondary.withValues(alpha: 0.4),
                      enabled: false,
                    ),
                  ],
                ),
                SizedBox(height: 14.h),

                // KONTAK section
                _buildSectionCard(
                  colors,
                  title: t.editProfile.kontak,
                  children: [
                    _buildTextField(
                      colors,
                      label: t.editProfile.nomorHp,
                      controller: _nomorHpController,
                      suffixIcon: Icons.phone,
                      iconColor: colors.textSecondary.withValues(alpha: 0.5),
                      enabled: true,
                      keyboardType: TextInputType.phone,
                    ),
                    SizedBox(height: 14.h),
                    _buildTextField(
                      colors,
                      label: t.editProfile.email,
                      controller: _emailController,
                      suffixIcon: Icons.email,
                      iconColor: colors.textSecondary.withValues(alpha: 0.5),
                      enabled: true,
                      keyboardType: TextInputType.emailAddress,
                    ),
                  ],
                ),
                SizedBox(height: 24.h),

                // Simpan Perubahan button
                SizedBox(
                  width: double.infinity,
                  height: 52.h,
                  child: PrimaryButton(
                    width: double.infinity,
                    height: 52.h,
                    onPressed: (_isSaving || _isUploading) ? null : _saveProfile,
                    icon: _isSaving ? null : Icons.save,
                    label: _isSaving
                        ? t.editProfile.saving
                        : t.editProfile.simpanPerubahan,
                    borderRadius: 26.r,
                  ),
                ),
                SizedBox(height: 32.h),
              ],
            ),
          ),
        ),
      ],
    );
  }

  /// Green gradient header with back arrow, title, avatar + camera icon
  Widget _buildHeader(BuildContext context, AppColorSet colors) {
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
          padding: EdgeInsets.only(bottom: 28.h),
          child: Column(
            children: [
              // Back arrow + title
              Padding(
                padding: EdgeInsets.only(left: 8.w, top: 4.h, right: 24.w),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                    SizedBox(width: 4.w),
                    Text(
                      t.editProfile.title,
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                        fontFamily: 'Poppins',
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16.h),

              // Avatar with camera overlay
              GestureDetector(
                onTap: _isUploading ? null : _pickImage,
                child: Stack(
                  children: [
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
                      ),
                      child: ClipOval(
                        child: _selectedImage != null
                            ? Image.file(
                                _selectedImage!,
                                fit: BoxFit.cover,
                                width: 100.w,
                                height: 100.w,
                              )
                            : (_currentProfilePictureUrl != null &&
                                    _currentProfilePictureUrl!.isNotEmpty)
                                ? Image.network(
                                    _currentProfilePictureUrl!,
                                    fit: BoxFit.cover,
                                    width: 100.w,
                                    height: 100.w,
                                    errorBuilder: (_, __, ___) => Icon(
                                      Icons.person,
                                      size: 52.sp,
                                      color: Colors.white,
                                    ),
                                  )
                                : Icon(
                                    Icons.person,
                                    size: 52.sp,
                                    color: Colors.white,
                                  ),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        width: 32.w,
                        height: 32.w,
                        decoration: BoxDecoration(
                          color: colors.textPrimary.withValues(alpha: 0.7),
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                        child: Icon(
                          Icons.camera_alt,
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
                            child: CircularProgressIndicator(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              SizedBox(height: 8.h),
              Text(
                t.editProfile.editFotoProfil,
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w400,
                  color: Colors.white.withValues(alpha: 0.85),
                  fontFamily: 'Poppins',
                ),
              ),
            ],
          ),
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
      padding: EdgeInsets.all(18.w),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(18.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
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
              fontSize: 13.sp,
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

  /// Styled text field matching the mockup
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
            fontSize: 14.sp,
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
              horizontal: 16.w,
              vertical: 14.h,
            ),
            suffixIcon: Icon(suffixIcon, size: 20.sp, color: iconColor),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14.r),
              borderSide: BorderSide(color: colors.border, width: 1),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14.r),
              borderSide: BorderSide(color: colors.border, width: 1),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14.r),
              borderSide: BorderSide(color: colors.primary, width: 1.5),
            ),
            disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14.r),
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
