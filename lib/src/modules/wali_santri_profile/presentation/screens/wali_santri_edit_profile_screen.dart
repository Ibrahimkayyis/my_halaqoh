import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_halaqoh/gen/i18n/translations.g.dart';
import 'package:my_halaqoh/src/core/theme/app_colors.dart';

/// Edit Profile Screen â€” green header, avatar with camera, form fields
@RoutePage()
class WaliSantriEditProfileScreen extends StatefulWidget {
  const WaliSantriEditProfileScreen({super.key});

  @override
  State<WaliSantriEditProfileScreen> createState() =>
      _WaliSantriEditProfileScreenState();
}

class _WaliSantriEditProfileScreenState
    extends State<WaliSantriEditProfileScreen> {
  final _namaController = TextEditingController(text: 'Ahmad');
  final _nisController = TextEditingController(text: '123456');
  final _kelasController = TextEditingController(text: 'Kelas 7');
  final _programController = TextEditingController(text: 'Reguler');
  final _nomorHpController = TextEditingController(text: '081234567890');
  final _emailController = TextEditingController(text: 'ahmad@myhalaqoh.com');

  @override
  void dispose() {
    _namaController.dispose();
    _nisController.dispose();
    _kelasController.dispose();
    _programController.dispose();
    _nomorHpController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);

    return Scaffold(
      backgroundColor: colors.background,
      body: Column(
        children: [
          // â”€â”€ Green gradient header â”€â”€
          _buildHeader(context, colors),

          // â”€â”€ Form fields â”€â”€
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
                        label: 'NIS',
                        controller: _nisController,
                        suffixIcon: Icons.lock,
                        iconColor: colors.textSecondary.withValues(alpha: 0.4),
                        enabled: false,
                      ),
                      SizedBox(height: 14.h),
                      _buildTextField(
                        colors,
                        label: 'Kelas',
                        controller: _kelasController,
                        suffixIcon: Icons.lock,
                        iconColor: colors.textSecondary.withValues(alpha: 0.4),
                        enabled: false,
                      ),
                      SizedBox(height: 14.h),
                      _buildTextField(
                        colors,
                        label: 'Program',
                        controller: _programController,
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
                    child: ElevatedButton.icon(
                      onPressed: () {
                        // TODO: Save profile
                        Navigator.of(context).pop();
                      },
                      icon: Icon(Icons.save, size: 20.sp),
                      label: Text(
                        t.editProfile.simpanPerubahan,
                        style: TextStyle(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w700,
                          fontFamily: 'Poppins',
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: colors.primary,
                        foregroundColor: colors.textOnButton,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(26.r),
                        ),
                        elevation: 0,
                      ),
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
              Stack(
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
                    child: Icon(Icons.person, size: 52.sp, color: Colors.white),
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
