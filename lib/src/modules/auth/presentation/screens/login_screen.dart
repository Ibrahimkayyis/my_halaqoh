import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_halaqoh/gen/assets.gen.dart';
import 'package:my_halaqoh/gen/i18n/translations.g.dart';
import 'package:my_halaqoh/src/core/router/app_router.dart';
import 'package:my_halaqoh/src/core/theme/app_colors.dart';

@RoutePage()
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _obscurePassword = true;
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onLoginPressed() {
    final username = _usernameController.text.trim();
    final password = _passwordController.text.trim();

    if (username.isEmpty || password.isEmpty) {
      _showError(t.auth.validationEmpty);
      return;
    }

    // Role detection based on credentials
    if (username == 'admin' && password == 'admin') {
      // Admin role → admin dashboard
      context.router.replace(const DashboardWrapperRoute());
    } else if (RegExp(r'^\d{13}$').hasMatch(username)) {
      // Guru role → NIP is 13 digits
      context.router.replace(const GuruDashboardWrapperRoute());
    } else if (RegExp(r'^\d{12}$').hasMatch(username)) {
      // Wali Santri role → NIS is 12 digits
      context.router.replace(const WaliSantriDashboardWrapperRoute());
    } else {
      _showError(t.auth.validationInvalid);
      return;
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(fontFamily: 'Poppins'),
        ),
        backgroundColor: AppColors.of(context).error,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.r),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);

    return Scaffold(
      backgroundColor: colors.background,
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildHeader(colors),
            _buildLoginCard(colors),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(AppColorSet colors) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(top: 60.h, bottom: 80.h),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            colors.primary,
            colors.primary.withValues(alpha: 0.85),
          ],
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30.r),
          bottomRight: Radius.circular(30.r),
        ),
      ),
      child: Column(
        children: [
          Container(
            width: 100.w,
            height: 100.w,
            decoration: BoxDecoration(
              color: colors.surface.withValues(alpha: 0.2),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Image.asset(
                Assets.images.myHalaqohLogo.path,
                width: 60.w,
                height: 60.w,
                color: colors.surface,
              ),
            ),
          ),
          SizedBox(height: 16.h),
          Text(
            t.app.title,
            style: TextStyle(
              fontSize: 28.sp,
              fontWeight: FontWeight.w700,
              color: colors.surface,
              fontFamily: 'Poppins',
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            t.splash.subtitle,
            style: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.w400,
              color: colors.surface.withValues(alpha: 0.9),
              letterSpacing: 1.5,
              fontFamily: 'Poppins',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoginCard(AppColorSet colors) {
    return Transform.translate(
      offset: Offset(0, -40.h),
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 24.w),
        padding: EdgeInsets.all(24.w),
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: BorderRadius.circular(20.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 20,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(
                t.auth.loginTitle,
                style: TextStyle(
                  fontSize: 22.sp,
                  fontWeight: FontWeight.w700,
                  color: colors.textPrimary,
                  fontFamily: 'Poppins',
                ),
              ),
            ),
            SizedBox(height: 4.h),
            Center(
              child: Text(
                t.auth.loginSubtitle,
                style: TextStyle(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w400,
                  color: colors.textSecondary,
                  fontFamily: 'Poppins',
                ),
              ),
            ),
            SizedBox(height: 28.h),
            _buildUsernameField(colors),
            SizedBox(height: 20.h),
            _buildPasswordField(colors),
            SizedBox(height: 12.h),
            _buildForgotPassword(colors),
            SizedBox(height: 24.h),
            _buildLoginButton(colors),
          ],
        ),
      ),
    );
  }

  Widget _buildUsernameField(AppColorSet colors) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          t.auth.usernameLabel,
          style: TextStyle(
            fontSize: 11.sp,
            fontWeight: FontWeight.w600,
            color: colors.textSecondary,
            letterSpacing: 0.5,
            fontFamily: 'Poppins',
          ),
        ),
        SizedBox(height: 8.h),
        TextField(
          controller: _usernameController,
          decoration: InputDecoration(
            hintText: t.auth.usernameHint,
            hintStyle: TextStyle(
              fontSize: 14.sp,
              color: colors.textSecondary.withValues(alpha: 0.6),
              fontFamily: 'Poppins',
            ),
            prefixIcon: Icon(
              Icons.person_outline,
              color: colors.textSecondary,
              size: 20.sp,
            ),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: colors.border),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: colors.primary),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPasswordField(AppColorSet colors) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          t.auth.passwordLabel,
          style: TextStyle(
            fontSize: 11.sp,
            fontWeight: FontWeight.w600,
            color: colors.textSecondary,
            letterSpacing: 0.5,
            fontFamily: 'Poppins',
          ),
        ),
        SizedBox(height: 8.h),
        TextField(
          controller: _passwordController,
          obscureText: _obscurePassword,
          decoration: InputDecoration(
            hintText: t.auth.passwordHint,
            hintStyle: TextStyle(
              fontSize: 14.sp,
              color: colors.textSecondary.withValues(alpha: 0.6),
              fontFamily: 'Poppins',
            ),
            prefixIcon: Icon(
              Icons.lock_outline,
              color: colors.textSecondary,
              size: 20.sp,
            ),
            suffixIcon: IconButton(
              icon: Icon(
                _obscurePassword
                    ? Icons.visibility_off_outlined
                    : Icons.visibility_outlined,
                color: colors.textSecondary,
                size: 20.sp,
              ),
              onPressed: () {
                setState(() {
                  _obscurePassword = !_obscurePassword;
                });
              },
            ),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: colors.border),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: colors.primary),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildForgotPassword(AppColorSet colors) {
    return Align(
      alignment: Alignment.centerRight,
      child: TextButton(
        onPressed: () {
          // TODO: Navigate to forgot password
        },
        style: TextButton.styleFrom(
          padding: EdgeInsets.zero,
          minimumSize: Size.zero,
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
        child: Text(
          t.auth.forgotPassword,
          style: TextStyle(
            fontSize: 13.sp,
            fontWeight: FontWeight.w600,
            color: colors.primary,
            fontFamily: 'Poppins',
          ),
        ),
      ),
    );
  }

  Widget _buildLoginButton(AppColorSet colors) {
    return SizedBox(
      width: double.infinity,
      height: 50.h,
      child: ElevatedButton(
        onPressed: _onLoginPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: colors.primary,
          foregroundColor: colors.textOnButton,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25.r),
          ),
          elevation: 0,
        ),
        child: Text(
          t.auth.loginButton,
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
            fontFamily: 'Poppins',
            letterSpacing: 1.0,
          ),
        ),
      ),
    );
  }
}
