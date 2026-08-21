import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_halaqoh/gen/assets.gen.dart';
import 'package:my_halaqoh/gen/colors.gen.dart';
import 'package:my_halaqoh/gen/i18n/translations.g.dart';
import 'package:my_halaqoh/src/core/router/app_router.dart';
import 'package:my_halaqoh/src/core/theme/app_colors.dart';
import 'package:my_halaqoh/src/core/widget/widgets.dart';
import 'package:my_halaqoh/src/modules/auth/presentation/cubits/auth_cubit.dart';
import 'package:my_halaqoh/src/modules/auth/presentation/cubits/auth_state.dart';
import 'package:my_halaqoh/src/modules/auth/presentation/widgets/forgot_password_bottom_sheet.dart';
import 'package:my_halaqoh/src/modules/master_data/presentation/cubits/guru_cubit.dart';
import 'package:my_halaqoh/src/modules/master_data/presentation/cubits/halaqoh_cubit.dart';
import 'package:my_halaqoh/src/modules/master_data/presentation/cubits/santri_cubit.dart';
import 'package:my_halaqoh/src/modules/master_data/presentation/cubits/target_hafalan_cubit.dart';

@RoutePage()
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  String? _usernameError;
  String? _passwordError;

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onUsernameChanged(String value) {
    if (_usernameError != null && value.trim().isNotEmpty) {
      setState(() {
        _usernameError = null;
      });
    }
  }

  void _onPasswordChanged(String value) {
    if (_passwordError != null && value.trim().isNotEmpty) {
      setState(() {
        _passwordError = null;
      });
    }
  }

  void _onLoginPressed() {
    // Dismiss keyboard
    FocusScope.of(context).unfocus();

    final username = _usernameController.text.trim();
    final password = _passwordController.text.trim();

    String? usernameErr;
    String? passwordErr;

    // ── Local Validation ───────────────────────────────────────────────
    if (username.isEmpty) {
      usernameErr = t.auth.validationEmpty;
    } else {
      final identifierRegex = RegExp(r'^[a-zA-Z0-9]+$');
      if (!identifierRegex.hasMatch(username)) {
        usernameErr = 'NIP/NIS hanya boleh berisi huruf dan angka.';
      } else if (username.length < 3 || username.length > 30) {
        usernameErr = 'NIP/NIS harus antara 3 sampai 30 karakter.';
      }
    }

    if (password.isEmpty) {
      passwordErr = t.auth.validationEmpty;
    } else if (password.length < 6) {
      passwordErr = 'Password minimal 6 karakter.';
    }

    if (usernameErr != null || passwordErr != null) {
      setState(() {
        _usernameError = usernameErr;
        _passwordError = passwordErr;
      });
      return;
    }

    // Reset inline errors when submitting valid format
    setState(() {
      _usernameError = null;
      _passwordError = null;
    });

    // Native Firebase Authentication through Cubit
    context.read<AuthCubit>().login(username, password);
  }

  void _showServerAuthError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 13.sp,
            color: Colors.white,
          ),
        ),
        backgroundColor: AppColors.of(context).error,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
        margin: EdgeInsets.all(16.w),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: colors.background,
      body: BlocListener<AuthCubit, AuthState>(
        listenWhen: (previous, next) => previous != next,
        listener: (context, state) {
          state.maybeWhen(
            error: (message) {
              ScaffoldMessenger.of(context).clearSnackBars();
              _showServerAuthError(message);
              context.read<AuthCubit>().reset();
            },
            authenticated: (user) {
              final String programStr =
                  (user.programType == 'T') ? 'takhassus' : 'reguler';

              // Restart Firestore streams
              context.read<GuruCubit>().watchAll();
              context.read<SantriCubit>().watchAll();
              context.read<HalaqohCubit>().watchAll();
              context.read<TargetHafalanCubit>().watchAll();

              // Redirect based on role
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
        child: SafeArea(
          top: false,
          child: SingleChildScrollView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            child: Column(
              children: [
                _buildHeader(colors, textTheme),
                _buildLoginCard(colors, textTheme),
                SizedBox(height: 32.h),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(AppColorSet colors, TextTheme textTheme) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 24.h,
        bottom: 56.h,
      ),
      decoration: BoxDecoration(
        gradient: colors.primaryGradient,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(20.r),
          bottomRight: Radius.circular(20.r),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 84.w,
            height: 84.w,
            decoration: BoxDecoration(
              color: ColorName.background,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.08),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Center(
              child: Image.asset(
                Assets.images.myHalaqohLogoNew.path,
                width: 62.w,
                height: 62.w,
              ),
            ),
          ),
          SizedBox(height: 14.h),
          Text(
            t.app.title,
            style: textTheme.displaySmall?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 24.sp,
                ) ??
                TextStyle(
                  fontSize: 24.sp,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                  fontFamily: 'Poppins',
                ),
          ),
          SizedBox(height: 2.h),
          Text(
            t.splash.subtitle,
            textAlign: TextAlign.center,
            style: textTheme.labelMedium?.copyWith(
                  color: Colors.white.withValues(alpha: 0.9),
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w400,
                  letterSpacing: 1.2,
                ) ??
                TextStyle(
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w400,
                  color: Colors.white.withValues(alpha: 0.9),
                  letterSpacing: 1.2,
                  fontFamily: 'Poppins',
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoginCard(AppColorSet colors, TextTheme textTheme) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Transform.translate(
      offset: Offset(0, -28.h),
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 20.w),
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: BorderRadius.circular(20.r),
          border: isDark
              ? Border.all(color: colors.border, width: 0.5)
              : null,
          boxShadow: isDark
              ? []
              : [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.08),
                    blurRadius: 20,
                    offset: const Offset(0, 6),
                  ),
                ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Center(
              child: Text(
                t.auth.loginTitle,
                style: textTheme.titleLarge?.copyWith(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w700,
                      color: colors.textPrimary,
                    ) ??
                    TextStyle(
                      fontSize: 18.sp,
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
                textAlign: TextAlign.center,
                style: textTheme.bodySmall?.copyWith(
                      fontSize: 12.sp,
                      color: colors.textSecondary,
                    ) ??
                    TextStyle(
                      fontSize: 12.sp,
                      color: colors.textSecondary,
                      fontFamily: 'Poppins',
                    ),
              ),
            ),
            SizedBox(height: 24.h),
            AppTextField(
              controller: _usernameController,
              label: t.auth.usernameLabel,
              hintText: t.auth.usernameHint,
              errorText: _usernameError,
              prefixIconData: Icons.person_outline,
              textInputAction: TextInputAction.next,
              onChanged: _onUsernameChanged,
            ),
            SizedBox(height: 16.h),
            AppTextField(
              controller: _passwordController,
              label: t.auth.passwordLabel,
              hintText: t.auth.passwordHint,
              errorText: _passwordError,
              prefixIconData: Icons.lock_outline,
              isPassword: true,
              textInputAction: TextInputAction.done,
              onChanged: _onPasswordChanged,
              onSubmitted: (_) => _onLoginPressed(),
            ),
            SizedBox(height: 8.h),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () => ForgotPasswordBottomSheet.show(context),
                style: TextButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 4.h),
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  foregroundColor: colors.primary,
                ),
                child: Text(
                  t.auth.forgotPassword,
                  style: textTheme.labelLarge?.copyWith(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w600,
                        color: colors.primary,
                      ) ??
                      TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w600,
                        color: colors.primary,
                        fontFamily: 'Poppins',
                      ),
                ),
              ),
            ),
            SizedBox(height: 20.h),
            BlocBuilder<AuthCubit, AuthState>(
              builder: (context, state) {
                final isLoading = state.maybeWhen(
                  loading: () => true,
                  orElse: () => false,
                );

                return PrimaryButton(
                  onPressed: _onLoginPressed,
                  label: t.auth.loginButton,
                  isLoading: isLoading,
                  width: double.infinity,
                  height: 48.h,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
