import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_halaqoh/gen/assets.gen.dart';
import 'package:my_halaqoh/gen/i18n/translations.g.dart';
import 'package:my_halaqoh/src/core/theme/app_colors.dart';
import 'package:my_halaqoh/src/core/router/app_router.dart';

@RoutePage()
class SplashScreen extends StatefulWidget {
  final Duration splashDuration;

  const SplashScreen({
    super.key,
    this.splashDuration = const Duration(seconds: 3),
  });

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  Timer? _timer;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    
    // Setup animation
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );
    
    _animationController.forward();
    
    // Setup navigation timer (trigger slightly before to allow for fade-out)
    final navigationDelay = widget.splashDuration - const Duration(milliseconds: 500);
    _timer = Timer(
      navigationDelay.isNegative ? widget.splashDuration : navigationDelay,
      _navigateToLogin,
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    _animationController.dispose();
    super.dispose();
  }

  void _navigateToLogin() {
    if (mounted) {
      // Fade out current screen first
      _animationController.reverse().then((_) {
        if (mounted) {
          context.router.replace(const LoginRoute());
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    
    return Scaffold(
      backgroundColor: colors.surface,
      body: Center(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Spacer(flex: 2),
              _buildLogo(),
              SizedBox(height: 24.h),
              _buildTitle(),
              SizedBox(height: 8.h),
              _buildSubtitle(),
              const Spacer(flex: 2),
              _buildVersion(),
              SizedBox(height: 32.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLogo() {
    final colors = AppColors.of(context);
    
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.8, end: 1.0),
      duration: const Duration(milliseconds: 800),
      curve: Curves.elasticOut,
      builder: (context, scale, child) {
        return Transform.scale(
          scale: scale,
          child: child,
        );
      },
      child: Container(
        width: 120.w,
        height: 120.w,
        decoration: BoxDecoration(
          color: colors.primary,
          shape: BoxShape.circle,
        ),
        child: Center(
          child: Image.asset(
            Assets.images.myHalaqohLogo.path,
            width: 70.w,
            height: 70.w,
            color: colors.surface,
          ),
        ),
      ),
    );
  }

  Widget _buildTitle() {
    final colors = AppColors.of(context);
    
    return Text(
      t.app.title,
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: 28.sp,
        fontWeight: FontWeight.w700,
        color: colors.primary,
        fontFamily: 'Poppins',
      ),
    );
  }

  Widget _buildSubtitle() {
    final colors = AppColors.of(context);
    
    return Text(
      t.splash.subtitle,
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: 14.sp,
        fontWeight: FontWeight.w400,
        color: colors.textSecondary,
        letterSpacing: 2.0,
        fontFamily: 'Poppins',
      ),
    );
  }

  Widget _buildVersion() {
    final colors = AppColors.of(context);
    
    return Text(
      t.splash.version,
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: 12.sp,
        fontWeight: FontWeight.w300,
        color: colors.textSecondary,
        fontFamily: 'Poppins',
      ),
    );
  }
}
