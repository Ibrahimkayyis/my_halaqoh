import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_halaqoh/gen/i18n/translations.g.dart';
import 'package:my_halaqoh/src/core/service_locator/service_locator.dart';
import 'package:my_halaqoh/src/core/theme/app_colors.dart';
import 'package:my_halaqoh/src/core/widget/widgets.dart';
import 'package:my_halaqoh/src/modules/wali_santri_profile/presentation/cubits/wali_santri_profile_cubit.dart';
import 'package:my_halaqoh/src/modules/wali_santri_profile/presentation/cubits/wali_santri_profile_state.dart';

/// Ubah Password Screen — old password, new password, confirm, security tips.
/// Integrates with Firebase Auth via WaliSantriProfileCubit for password change.
@RoutePage()
class WaliSantriUbahPasswordScreen extends StatefulWidget {
  const WaliSantriUbahPasswordScreen({super.key});

  @override
  State<WaliSantriUbahPasswordScreen> createState() =>
      _WaliSantriUbahPasswordScreenState();
}

class _WaliSantriUbahPasswordScreenState
    extends State<WaliSantriUbahPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _oldPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  late final WaliSantriProfileCubit _profileCubit;

  bool _obscureOld = true;
  bool _obscureNew = true;
  bool _obscureConfirm = true;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _profileCubit = sl<WaliSantriProfileCubit>();
  }

  @override
  void dispose() {
    _oldPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    _profileCubit.close();
    super.dispose();
  }

  /// Validate and submit password change
  Future<void> _onSubmit() async {
    if (!_formKey.currentState!.validate()) return;
    if (_isSubmitting) return;

    setState(() => _isSubmitting = true);

    final success = await _profileCubit.changePassword(
      currentPassword: _oldPasswordController.text,
      newPassword: _newPasswordController.text,
    );

    if (!mounted) return;

    setState(() => _isSubmitting = false);

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            t.ubahPassword.successMessage,
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
      // Extract error message from cubit state
      final errorMessage = _profileCubit.state.maybeWhen(
        error: (msg) => msg,
        orElse: () => t.ubahPassword.failedMessage,
      );
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            errorMessage,
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

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);

    return BlocProvider.value(
      value: _profileCubit,
      child: Scaffold(
        backgroundColor: colors.background,
        body: SafeArea(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                // AppBar
                Padding(
                  padding: EdgeInsets.only(left: 8.w, top: 8.h, right: 24.w),
                  child: Row(
                    children: [
                      IconButton(
                        icon: Icon(Icons.arrow_back, color: colors.textPrimary),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                      SizedBox(width: 4.w),
                      Text(
                        t.ubahPassword.title,
                        style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w700,
                          color: colors.textPrimary,
                          fontFamily: 'Poppins',
                        ),
                      ),
                    ],
                  ),
                ),

                // Content
                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.symmetric(horizontal: 24.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 12.h),

                        // Subtitle
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8.w),
                          child: Text(
                            t.ubahPassword.subtitle,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 13.sp,
                              fontWeight: FontWeight.w400,
                              color: colors.textSecondary,
                              fontFamily: 'Poppins',
                            ),
                          ),
                        ),
                        SizedBox(height: 24.h),

                        // Kata Sandi Lama
                        _buildPasswordField(
                          colors,
                          label: t.ubahPassword.kataSandiLama,
                          controller: _oldPasswordController,
                          obscure: _obscureOld,
                          prefixIcon: Icons.lock_outline,
                          onToggle: () =>
                              setState(() => _obscureOld = !_obscureOld),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return t.ubahPassword.errOldPasswordRequired;
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 18.h),

                        // Kata Sandi Baru
                        _buildPasswordField(
                          colors,
                          label: t.ubahPassword.kataSandiBaru,
                          controller: _newPasswordController,
                          obscure: _obscureNew,
                          prefixIcon: Icons.lock_outline,
                          onToggle: () =>
                              setState(() => _obscureNew = !_obscureNew),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return t.ubahPassword.errNewPasswordRequired;
                            }
                            if (value.length < 8) {
                              return t.ubahPassword.errMin8Chars;
                            }
                            final hasLetter =
                                RegExp(r'[a-zA-Z]').hasMatch(value);
                            final hasDigit = RegExp(r'[0-9]').hasMatch(value);
                            if (!hasLetter || !hasDigit) {
                              return t.ubahPassword.errLetterNumberCombo;
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 18.h),

                        // Konfirmasi Kata Sandi Baru
                        _buildPasswordField(
                          colors,
                          label: t.ubahPassword.konfirmasiKataSandiBaru,
                          controller: _confirmPasswordController,
                          obscure: _obscureConfirm,
                          prefixIcon: Icons.check_circle_outline,
                          onToggle: () =>
                              setState(() => _obscureConfirm = !_obscureConfirm),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return t.ubahPassword.errConfirmRequired;
                            }
                            if (value != _newPasswordController.text) {
                              return t.ubahPassword.errMismatch;
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 24.h),

                        // Syarat Keamanan card
                        Container(
                          width: double.infinity,
                          padding: EdgeInsets.all(16.w),
                          decoration: BoxDecoration(
                            color: colors.primary.withValues(alpha: 0.06),
                            borderRadius: BorderRadius.circular(14.r),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                t.ubahPassword.syaratKeamanan,
                                style: TextStyle(
                                  fontSize: 13.sp,
                                  fontWeight: FontWeight.w700,
                                  color: colors.primary,
                                  fontFamily: 'Poppins',
                                ),
                              ),
                              SizedBox(height: 8.h),
                              _buildSecurityItem(
                                t.ubahPassword.minimal8Karakter,
                                colors,
                              ),
                              SizedBox(height: 4.h),
                              _buildSecurityItem(
                                t.ubahPassword.kombinasiHurufDanAngka,
                                colors,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 32.h),
                      ],
                    ),
                  ),
                ),

                // Ubah Kata Sandi button
                Padding(
                  padding: EdgeInsets.fromLTRB(24.w, 0, 24.w, 24.h),
                  child: SizedBox(
                    width: double.infinity,
                    height: 52.h,
                    child: _isSubmitting
                        ? const Center(child: CircularProgressIndicator())
                        : PrimaryButton(
                            width: double.infinity,
                            height: 52.h,
                            onPressed: _onSubmit,
                            label: t.ubahPassword.ubahKataSandi,
                            borderRadius: 26.r,
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Password field with prefix icon, obscure toggle, label, and validator
  Widget _buildPasswordField(
    AppColorSet colors, {
    required String label,
    required TextEditingController controller,
    required bool obscure,
    required IconData prefixIcon,
    required VoidCallback onToggle,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 13.sp,
            fontWeight: FontWeight.w600,
            color: colors.textPrimary,
            fontFamily: 'Poppins',
          ),
        ),
        SizedBox(height: 8.h),
        TextFormField(
          controller: controller,
          obscureText: obscure,
          validator: validator,
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w500,
            color: colors.textPrimary,
            fontFamily: 'Poppins',
          ),
          decoration: InputDecoration(
            filled: true,
            fillColor: colors.surface,
            contentPadding: EdgeInsets.symmetric(
              horizontal: 16.w,
              vertical: 14.h,
            ),
            prefixIcon: Icon(
              prefixIcon,
              size: 20.sp,
              color: colors.textSecondary.withValues(alpha: 0.5),
            ),
            suffixIcon: GestureDetector(
              onTap: onToggle,
              child: Icon(
                obscure ? Icons.visibility_off : Icons.visibility,
                size: 20.sp,
                color: colors.textSecondary.withValues(alpha: 0.5),
              ),
            ),
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
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14.r),
              borderSide: BorderSide(color: colors.error, width: 1),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14.r),
              borderSide: BorderSide(color: colors.error, width: 1.5),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSecurityItem(String text, AppColorSet colors) {
    return Row(
      children: [
        Container(
          width: 6.w,
          height: 6.w,
          decoration: BoxDecoration(
            color: colors.primary,
            shape: BoxShape.circle,
          ),
        ),
        SizedBox(width: 8.w),
        Text(
          text,
          style: TextStyle(
            fontSize: 12.sp,
            fontWeight: FontWeight.w400,
            color: colors.primary,
            fontFamily: 'Poppins',
          ),
        ),
      ],
    );
  }
}
