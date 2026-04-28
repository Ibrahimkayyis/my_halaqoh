import 'dart:io';

import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:my_halaqoh/gen/i18n/translations.g.dart';
import 'package:my_halaqoh/src/core/service_locator/service_locator.dart';
import 'package:my_halaqoh/src/core/theme/app_colors.dart';
import 'package:my_halaqoh/src/core/widget/widgets.dart';
import 'package:my_halaqoh/src/modules/auth/presentation/cubits/auth_cubit.dart';
import 'package:my_halaqoh/src/modules/auth/presentation/cubits/auth_state.dart';
import 'package:my_halaqoh/src/modules/master_data/domain/models/santri_model.dart';
import 'package:my_halaqoh/src/modules/master_data/domain/models/wali_santri_model.dart';
import 'package:my_halaqoh/src/modules/wali_santri_profile/presentation/cubits/wali_santri_profile_cubit.dart';
import 'package:my_halaqoh/src/modules/wali_santri_profile/presentation/cubits/wali_santri_profile_state.dart';

/// Edit Profile Screen — green header, avatar with camera, form fields.
/// Reads real data from Firestore via WaliSantriProfileCubit and saves updates.
@RoutePage()
class WaliSantriEditProfileScreen extends StatefulWidget {
  const WaliSantriEditProfileScreen({super.key});

  @override
  State<WaliSantriEditProfileScreen> createState() =>
      _WaliSantriEditProfileScreenState();
}

class _WaliSantriEditProfileScreenState
    extends State<WaliSantriEditProfileScreen> {
  final _namaController = TextEditingController();
  final _nisController = TextEditingController();
  final _kelasController = TextEditingController();
  final _programController = TextEditingController();
  // Guardian contact fields
  final _waliNamaController = TextEditingController();
  final _waliPhoneController = TextEditingController();
  // Hubungan is managed as a dropdown selection string
  String? _selectedHubungan;

  /// Dropdown options for guardian relationship
  static const List<String> _hubunganOptions = ['Ayah', 'Ibu', 'Saudara'];

  late final WaliSantriProfileCubit _profileCubit;
  String _linkedDocId = '';
  File? _selectedImage;
  String? _currentProfilePictureUrl;
  bool _isUploading = false;
  bool _isSaving = false;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _profileCubit = sl<WaliSantriProfileCubit>();

    // Get linkedDocId from AuthCubit and load profile
    final authState = context.read<AuthCubit>().state;
    authState.maybeWhen(
      authenticated: (userMeta) {
        _linkedDocId = userMeta.linkedDocId;
      },
      orElse: () {},
    );

    if (_linkedDocId.isNotEmpty) {
      _profileCubit.loadProfile(_linkedDocId);
    }
  }

  /// Populate form fields when santri data is loaded
  void _populateFields(SantriModel santri) {
    if (_isInitialized) return;
    _isInitialized = true;

    _namaController.text = santri.nama;
    _nisController.text = santri.nis;
    _kelasController.text = 'Kelas ${santri.kelas}';
    _programController.text =
        santri.program == 'T' ? 'Takhassus' : 'Reguler';
    _currentProfilePictureUrl = santri.profilePicture;

    // Guardian info (waliSantri)
    if (santri.waliSantri != null) {
      _waliNamaController.text = santri.waliSantri!.nama;
      _waliPhoneController.text = santri.waliSantri!.phone;
      // Pre-select hubungan in dropdown — fallback to null if value not in list
      final hub = santri.waliSantri!.hubungan;
      setState(() {
        _selectedHubungan =
            _hubunganOptions.contains(hub) ? hub : null;
      });
    }
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

    // Get the current santri model from cubit state
    final currentSantri = _profileCubit.state.maybeWhen(
      loaded: (s) => s,
      updateSuccess: (s) => s,
      orElse: () => null,
    );

    if (currentSantri == null) {
      setState(() => _isSaving = false);
      return;
    }

    String? photoUrl = _currentProfilePictureUrl;

    // Upload photo if a new one was selected
    if (_selectedImage != null) {
      setState(() => _isUploading = true);
      final url = await _profileCubit.uploadPhoto(_linkedDocId, _selectedImage!);
      if (mounted) setState(() => _isUploading = false);
      if (url != null) {
        photoUrl = url;
        _currentProfilePictureUrl = url;
      }
    }

    // Build updated waliSantri sub-model
    final updatedWaliSantri = WaliSantriModel(
      nama: _waliNamaController.text.trim(),
      phone: _waliPhoneController.text.trim(),
      hubungan: _selectedHubungan ??
          (currentSantri.waliSantri?.hubungan ?? 'Ayah'),
    );

    // Build updated santri model — only mutable fields change
    final updatedModel = currentSantri.copyWith(
      nama: _namaController.text.trim(),
      profilePicture: photoUrl,
      waliSantri: updatedWaliSantri,
      updatedAt: DateTime.now(),
    );

    final success = await _profileCubit.updateProfile(updatedModel);

    if (mounted) {
      setState(() => _isSaving = false);
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Profil berhasil diperbarui',
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
              'Gagal memperbarui profil',
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
    _nisController.dispose();
    _kelasController.dispose();
    _programController.dispose();
    _waliNamaController.dispose();
    _waliPhoneController.dispose();
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
        body: BlocConsumer<WaliSantriProfileCubit, WaliSantriProfileState>(
          listener: (context, state) {
            state.maybeWhen(
              loaded: (santri) => _populateFields(santri),
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
                      onPressed: () {
                        if (_linkedDocId.isNotEmpty) {
                          _profileCubit.loadProfile(_linkedDocId);
                        }
                      },
                      child: Text(
                        'Coba Lagi',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          color: colors.primary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              orElse: () => Column(
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

                          // INFORMASI SANTRI section
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
                                label: 'NIS',
                                controller: _nisController,
                                suffixIcon: Icons.lock,
                                iconColor:
                                    colors.textSecondary.withValues(alpha: 0.4),
                                enabled: false,
                              ),
                              SizedBox(height: 14.h),
                              _buildTextField(
                                colors,
                                label: 'Kelas',
                                controller: _kelasController,
                                suffixIcon: Icons.lock,
                                iconColor:
                                    colors.textSecondary.withValues(alpha: 0.4),
                                enabled: false,
                              ),
                              SizedBox(height: 14.h),
                              _buildTextField(
                                colors,
                                label: 'Program',
                                controller: _programController,
                                suffixIcon: Icons.lock,
                                iconColor:
                                    colors.textSecondary.withValues(alpha: 0.4),
                                enabled: false,
                              ),
                            ],
                          ),
                          SizedBox(height: 14.h),

                          // KONTAK WALI section
                          _buildSectionCard(
                            colors,
                            title: 'Kontak Wali',
                            children: [
                              _buildTextField(
                                colors,
                                label: 'Nama Wali',
                                controller: _waliNamaController,
                                suffixIcon: Icons.edit,
                                iconColor: colors.textSecondary,
                                enabled: true,
                              ),
                              SizedBox(height: 14.h),
                              // Hubungan dropdown
                              _buildHubunganDropdown(colors),
                              SizedBox(height: 14.h),
                              _buildTextField(
                                colors,
                                label: t.editProfile.nomorHp,
                                controller: _waliPhoneController,
                                suffixIcon: Icons.phone,
                                iconColor:
                                    colors.textSecondary.withValues(alpha: 0.5),
                                enabled: true,
                                keyboardType: TextInputType.phone,
                              ),
                            ],
                          ),
                          SizedBox(height: 24.h),

                          // Simpan Perubahan button
                          SizedBox(
                            width: double.infinity,
                            height: 52.h,
                            child: _isSaving || _isUploading
                                ? const Center(
                                    child: CircularProgressIndicator())
                                : PrimaryButton(
                                    width: double.infinity,
                                    height: 52.h,
                                    onPressed: _saveProfile,
                                    icon: Icons.save,
                                    label: t.editProfile.simpanPerubahan,
                                    borderRadius: 26.r,
                                  ),
                          ),
                          SizedBox(height: 32.h),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  /// Green gradient header with back arrow, title, avatar + camera icon
  Widget _buildHeader(BuildContext context, AppColorSet colors) {
    // Determine avatar source: newly picked file takes priority, then network URL
    ImageProvider? avatarImage;
    if (_selectedImage != null) {
      avatarImage = FileImage(_selectedImage!);
    } else if (_currentProfilePictureUrl != null) {
      avatarImage = NetworkImage(_currentProfilePictureUrl!);
    }

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
                onTap: _pickImage,
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
                        image: avatarImage != null
                            ? DecorationImage(
                                image: avatarImage,
                                fit: BoxFit.cover,
                              )
                            : null,
                      ),
                      child: avatarImage == null
                          ? Icon(Icons.person, size: 52.sp, color: Colors.white)
                          : null,
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

  /// Styled text field
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

  /// Animated dropdown for guardian relationship selection
  Widget _buildHubunganDropdown(AppColorSet colors) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Hubungan',
          style: TextStyle(
            fontSize: 12.sp,
            fontWeight: FontWeight.w500,
            color: colors.textSecondary,
            fontFamily: 'Poppins',
          ),
        ),
        SizedBox(height: 6.h),
        CustomDropdown<String>(
          hintText: 'Pilih hubungan',
          items: _hubunganOptions,
          initialItem: _selectedHubungan,
          onChanged: (value) => setState(() => _selectedHubungan = value),
          closedHeaderPadding: EdgeInsets.symmetric(
            horizontal: 16.w,
            vertical: 14.h,
          ),
          decoration: CustomDropdownDecoration(
            closedBorderRadius: BorderRadius.circular(14.r),
            closedBorder: Border.all(color: colors.border),
            closedFillColor: colors.surface,
            expandedBorderRadius: BorderRadius.circular(14.r),
            expandedBorder: Border.all(color: colors.primary),
            expandedFillColor: colors.surface,
            headerStyle: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
              color: colors.textPrimary,
              fontFamily: 'Poppins',
            ),
            hintStyle: TextStyle(
              fontSize: 14.sp,
              color: colors.textSecondary.withValues(alpha: 0.5),
              fontFamily: 'Poppins',
            ),
            listItemStyle: TextStyle(
              fontSize: 14.sp,
              color: colors.textPrimary,
              fontFamily: 'Poppins',
            ),
          ),
        ),
      ],
    );
  }
}
