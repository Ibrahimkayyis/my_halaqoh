import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_halaqoh/gen/i18n/translations.g.dart';
import 'package:my_halaqoh/src/core/service_locator/service_locator.dart';
import 'package:my_halaqoh/src/core/theme/app_colors.dart';
import 'package:my_halaqoh/src/core/widget/widgets.dart';
import 'package:my_halaqoh/src/modules/guru_profile/presentation/cubits/guru_profile_cubit.dart';
import 'package:my_halaqoh/src/modules/guru_profile/presentation/cubits/guru_profile_state.dart';

/// Ubah Password Screen — old password, new password, confirm, security tips.
/// Integrates with Firebase Auth via GuruProfileCubit for password change.
@RoutePage()
class UbahPasswordScreen extends StatefulWidget {
  const UbahPasswordScreen({super.key});

  @override
  State<UbahPasswordScreen> createState() => _UbahPasswordScreenState();
}

class _UbahPasswordScreenState extends State<UbahPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _oldPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  late final GuruProfileCubit _profileCubit;

  bool _obscureOld = true;
  bool _obscureNew = true;
  bool _obscureConfirm = true;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _profileCubit = sl<GuruProfileCubit>();
  }

  @override
  void dispose() {
    _oldPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    _profileCubit.close();
    super.dispose();
  }

  // ── Live Validation Helpers ──
  bool get _hasMin8Chars => _newPasswordController.text.length >= 8;

  bool get _hasLetterAndDigit {
    final val = _newPasswordController.text;
    return RegExp(r'[a-zA-Z]').hasMatch(val) && RegExp(r'[0-9]').hasMatch(val);
  }

  bool get _isPasswordMatching {
    final newPass = _newPasswordController.text;
    final confirmPass = _confirmPasswordController.text;
    return confirmPass.isNotEmpty && newPass == confirmPass;
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
            borderRadius: BorderRadius.circular(8.r),
          ),
        ),
      );
      Navigator.of(context).pop();
    } else {
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
            borderRadius: BorderRadius.circular(8.r),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);

    return Scaffold(
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
          t.ubahPassword.title,
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 18.sp,
            fontWeight: FontWeight.w700,
            color: colors.textPrimary,
          ),
        ),
      ),
      body: SafeArea(
        bottom: false,
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // ── Scrollable Form Body ──
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Subtitle Guide
                      Text(
                        t.ubahPassword.subtitle,
                        style: TextStyle(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w400,
                          color: colors.textSecondary,
                          fontFamily: 'Poppins',
                          height: 1.4,
                        ),
                      ),
                      SizedBox(height: 16.h),

                      // ── Card 1: Autentikasi Saat Ini ──
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(16.w),
                        decoration: BoxDecoration(
                          color: colors.surface,
                          borderRadius: BorderRadius.circular(16.r),
                          border: Border.all(
                            color: colors.border.withValues(alpha: 0.6),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.03),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  padding: EdgeInsets.all(6.w),
                                  decoration: BoxDecoration(
                                    color: colors.primary,
                                    borderRadius: BorderRadius.circular(6.r),
                                  ),
                                  child: Icon(
                                    Icons.security_rounded,
                                    size: 14.sp,
                                    color: Colors.white,
                                  ),
                                ),
                                SizedBox(width: 8.w),
                                Text(
                                  'AUTENTIKASI SAAT INI',
                                  style: TextStyle(
                                    fontSize: 11.5.sp,
                                    fontWeight: FontWeight.w700,
                                    color: colors.primary,
                                    fontFamily: 'Poppins',
                                    letterSpacing: 0.5,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 14.h),
                            _buildPasswordField(
                              colors,
                              label: t.ubahPassword.kataSandiLama,
                              controller: _oldPasswordController,
                              obscure: _obscureOld,
                              prefixIcon: Icons.lock_outline_rounded,
                              onToggle: () =>
                                  setState(() => _obscureOld = !_obscureOld),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return t.ubahPassword.errOldPasswordRequired;
                                }
                                return null;
                              },
                            ),
                            SizedBox(height: 6.h),
                            Text(
                              'Masukkan kata sandi lama untuk memverifikasi akun Anda.',
                              style: TextStyle(
                                fontSize: 11.sp,
                                fontWeight: FontWeight.w400,
                                color: colors.textSecondary.withValues(alpha: 0.8),
                                fontFamily: 'Poppins',
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 16.h),

                      // ── Card 2: Kredensial Baru & Syarat Keamanan ──
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(16.w),
                        decoration: BoxDecoration(
                          color: colors.surface,
                          borderRadius: BorderRadius.circular(16.r),
                          border: Border.all(
                            color: colors.border.withValues(alpha: 0.6),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.03),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  padding: EdgeInsets.all(6.w),
                                  decoration: BoxDecoration(
                                    color: colors.primary,
                                    borderRadius: BorderRadius.circular(6.r),
                                  ),
                                  child: Icon(
                                    Icons.key_rounded,
                                    size: 14.sp,
                                    color: Colors.white,
                                  ),
                                ),
                                SizedBox(width: 8.w),
                                Text(
                                  'KREDENSIAL BARU',
                                  style: TextStyle(
                                    fontSize: 11.5.sp,
                                    fontWeight: FontWeight.w700,
                                    color: colors.primary,
                                    fontFamily: 'Poppins',
                                    letterSpacing: 0.5,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 14.h),

                            // Kata Sandi Baru
                            _buildPasswordField(
                              colors,
                              label: t.ubahPassword.kataSandiBaru,
                              controller: _newPasswordController,
                              obscure: _obscureNew,
                              prefixIcon: Icons.lock_reset_rounded,
                              onToggle: () =>
                                  setState(() => _obscureNew = !_obscureNew),
                              onChanged: (_) => setState(() {}),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return t.ubahPassword.errNewPasswordRequired;
                                }
                                if (value.length < 8) {
                                  return t.ubahPassword.errMin8Chars;
                                }
                                final hasLetter =
                                    RegExp(r'[a-zA-Z]').hasMatch(value);
                                final hasDigit =
                                    RegExp(r'[0-9]').hasMatch(value);
                                if (!hasLetter || !hasDigit) {
                                  return t.ubahPassword.errLetterNumberCombo;
                                }
                                return null;
                              },
                            ),
                            SizedBox(height: 14.h),

                            // Konfirmasi Kata Sandi Baru
                            _buildPasswordField(
                              colors,
                              label: t.ubahPassword.konfirmasiKataSandiBaru,
                              controller: _confirmPasswordController,
                              obscure: _obscureConfirm,
                              prefixIcon: Icons.check_circle_outline_rounded,
                              onToggle: () => setState(
                                  () => _obscureConfirm = !_obscureConfirm),
                              onChanged: (_) => setState(() {}),
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
                            SizedBox(height: 16.h),

                            // ── Live Interactive Requirement Checker ──
                            Container(
                              width: double.infinity,
                              padding: EdgeInsets.all(12.w),
                              decoration: BoxDecoration(
                                color: colors.background,
                                borderRadius: BorderRadius.circular(8.r),
                                border: Border.all(
                                  color: colors.border.withValues(alpha: 0.6),
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Syarat Keamanan Kata Sandi:',
                                    style: TextStyle(
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.w600,
                                      color: colors.textPrimary,
                                      fontFamily: 'Poppins',
                                    ),
                                  ),
                                  SizedBox(height: 8.h),
                                  _buildLiveCheckItem(
                                    label: t.ubahPassword.minimal8Karakter,
                                    isMet: _hasMin8Chars,
                                    colors: colors,
                                  ),
                                  SizedBox(height: 6.h),
                                  _buildLiveCheckItem(
                                    label: t.ubahPassword.kombinasiHurufDanAngka,
                                    isMet: _hasLetterAndDigit,
                                    colors: colors,
                                  ),
                                  SizedBox(height: 6.h),
                                  _buildLiveCheckItem(
                                    label: 'Konfirmasi kata sandi cocok',
                                    isMet: _isPasswordMatching,
                                    colors: colors,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 24.h),
                    ],
                  ),
                ),
              ),

              // ── Docked Sticky Bottom Action Button ──
              Container(
                width: double.infinity,
                padding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 20.h),
                decoration: BoxDecoration(
                  color: colors.surface,
                  border: Border(
                    top: BorderSide(
                      color: colors.border.withValues(alpha: 0.6),
                    ),
                  ),
                ),
                child: PrimaryButton(
                  width: double.infinity,
                  height: 48.h,
                  onPressed: _isSubmitting ? null : _onSubmit,
                  isLoading: _isSubmitting,
                  label: _isSubmitting
                      ? t.ubahPassword.processing
                      : t.ubahPassword.ubahKataSandi,
                  borderRadius: 8.r,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Password field with prefix icon, obscure toggle, label, standard 8.r radius, and validation
  Widget _buildPasswordField(
    AppColorSet colors, {
    required String label,
    required TextEditingController controller,
    required bool obscure,
    required IconData prefixIcon,
    required VoidCallback onToggle,
    void Function(String)? onChanged,
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
        SizedBox(height: 6.h),
        TextFormField(
          controller: controller,
          obscureText: obscure,
          validator: validator,
          onChanged: onChanged,
          autovalidateMode: AutovalidateMode.onUserInteraction,
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
              horizontal: 14.w,
              vertical: 12.h,
            ),
            prefixIcon: Icon(
              prefixIcon,
              size: 20.sp,
              color: colors.textSecondary.withValues(alpha: 0.7),
            ),
            suffixIcon: GestureDetector(
              onTap: onToggle,
              child: Icon(
                obscure ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                size: 20.sp,
                color: colors.textSecondary.withValues(alpha: 0.7),
              ),
            ),
            errorStyle: TextStyle(fontSize: 11.sp, fontFamily: 'Poppins'),
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
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.r),
              borderSide: BorderSide(color: colors.error, width: 1),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.r),
              borderSide: BorderSide(color: colors.error, width: 1.5),
            ),
          ),
        ),
      ],
    );
  }

  /// Live Requirement Item with dynamic checkmark / cross icon and text color
  Widget _buildLiveCheckItem({
    required String label,
    required bool isMet,
    required AppColorSet colors,
  }) {
    final activeColor = Colors.green.shade700;
    final inactiveColor = colors.textSecondary.withValues(alpha: 0.6);

    return Row(
      children: [
        Icon(
          isMet ? Icons.check_circle_rounded : Icons.radio_button_unchecked_rounded,
          size: 16.sp,
          color: isMet ? activeColor : inactiveColor,
        ),
        SizedBox(width: 8.w),
        Expanded(
          child: Text(
            label,
            style: TextStyle(
              fontSize: 11.5.sp,
              fontWeight: isMet ? FontWeight.w600 : FontWeight.w400,
              color: isMet ? colors.textPrimary : inactiveColor,
              fontFamily: 'Poppins',
            ),
          ),
        ),
      ],
    );
  }
}
