import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_halaqoh/gen/assets.gen.dart';
import 'package:my_halaqoh/gen/colors.gen.dart';
import 'package:my_halaqoh/gen/i18n/translations.g.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_halaqoh/src/core/router/app_router.dart';
import 'package:my_halaqoh/src/core/theme/app_colors.dart';
import 'package:my_halaqoh/src/modules/auth/presentation/cubits/auth_cubit.dart';
import 'package:my_halaqoh/src/modules/auth/presentation/cubits/auth_state.dart';
import 'package:my_halaqoh/src/modules/master_data/presentation/cubits/guru_cubit.dart';
import 'package:my_halaqoh/src/modules/master_data/presentation/cubits/santri_cubit.dart';
import 'package:my_halaqoh/src/modules/master_data/presentation/cubits/halaqoh_cubit.dart';
import 'package:my_halaqoh/src/modules/master_data/presentation/cubits/target_hafalan_cubit.dart';
import 'package:my_halaqoh/src/modules/auth/presentation/widgets/forgot_password_bottom_sheet.dart';

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

    // ── Validation ─────────────────────────────────────────────────────
    if (username.isEmpty || password.isEmpty) {
      _showError(t.auth.validationEmpty);
      return;
    }

    // NIP/NIS should be alphanumeric (letters and digits only, no special chars)
    final identifierRegex = RegExp(r'^[a-zA-Z0-9]+$');
    if (!identifierRegex.hasMatch(username)) {
      _showError('NIP/NIS hanya boleh mengandung huruf dan angka.');
      return;
    }

    // NIP/NIS should be between 3 and 30 characters
    if (username.length < 3 || username.length > 30) {
      _showError('NIP/NIS harus antara 3 sampai 30 karakter.');
      return;
    }

    // Password minimum length
    if (password.length < 6) {
      _showError('Password minimal 6 karakter.');
      return;
    }

    // Use Cubit to perform native Firebase Authentication
    context.read<AuthCubit>().login(username, password);
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: const TextStyle(fontFamily: 'Poppins')),
        backgroundColor: AppColors.of(context).error,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);

    return Scaffold(
      backgroundColor: colors.background,
      body: BlocListener<AuthCubit, AuthState>(
        // Only react when the state actually changes to a new distinct state.
        // Without this, a stale AuthState.error persisting in the Cubit would
        // re-trigger _showError on every rebuild (e.g. after a successful login
        // causes a route replacement that rebuilds this subtree).
        listenWhen: (previous, next) => previous != next,
        listener: (context, state) {
          state.maybeWhen(
            error: (message) {
              // Clear any previously queued snackbars (from the failed attempt)
              // so they don't surface after a successful login.
              ScaffoldMessenger.of(context).clearSnackBars();
              _showError(message);
              // Reset Cubit to initial so this error won't re-fire if the
              // widget tree is rebuilt while still on this screen.
              context.read<AuthCubit>().reset();
            },
            authenticated: (user) {
              final String programStr =
                  (user.programType == 'T') ? 'takhassus' : 'reguler';

              // Restart the Firestore streams since they failed with Permission Denied on logout
              context.read<GuruCubit>().watchAll();
              context.read<SantriCubit>().watchAll();
              context.read<HalaqohCubit>().watchAll();
              context.read<TargetHafalanCubit>().watchAll();

              // Redirect based on role from UserMetadata
              if (user.role == 'admin') {
                context.router.replace(const DashboardWrapperRoute());
              } else if (user.role == 'guru') {
                context.router.replace(
                  GuruDashboardWrapperRoute(programType: programStr),
                );
              } else if (user.role == 'santri') {
                context.router.replace(
                  WaliSantriDashboardWrapperRoute(programType: programStr),
                );
              } else if (user.role == 'super_admin') {
                context.router.replace(const SuperAdminPickerRoute());
              }
            },
            orElse: () {},
          );
        },
        child: SingleChildScrollView(
          child: Column(
            children: [_buildHeader(colors), _buildLoginCard(colors)],
          ),
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
          colors: [colors.primary, colors.primary.withValues(alpha: 0.85)],
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
              color: ColorName.background,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Image.asset(
                Assets.images.myHalaqohLogoNew.path,
                width: 76.w,
                height: 76.w,
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
          ForgotPasswordBottomSheet.show(context);
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
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        final isLoading = state.maybeWhen(
          loading: () => true,
          orElse: () => false,
        );

        return SizedBox(
          width: double.infinity,
          height: 50.h,
          child: ElevatedButton(
            onPressed: isLoading ? null : _onLoginPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: colors.primary,
              foregroundColor: colors.textOnButton,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25.r),
              ),
              elevation: 0,
            ),
            child: isLoading
                ? SizedBox(
                    width: 20.w,
                    height: 20.w,
                    child: CircularProgressIndicator(
                      color: colors.textOnButton,
                      strokeWidth: 2,
                    ),
                  )
                : Text(
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
      },
    );
  }
}
