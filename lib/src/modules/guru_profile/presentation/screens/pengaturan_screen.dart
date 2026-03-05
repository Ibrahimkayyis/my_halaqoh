import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_halaqoh/gen/i18n/translations.g.dart';
import 'package:my_halaqoh/src/core/locale/cubit/locale_cubit.dart';
import 'package:my_halaqoh/src/core/theme/app_colors.dart';
import 'package:my_halaqoh/src/core/theme/cubit/theme_cubit.dart';
import 'package:my_halaqoh/src/core/theme/theme_mode.dart';

/// Pengaturan Screen — language and theme settings with dialogs
@RoutePage()
class PengaturanScreen extends StatelessWidget {
  const PengaturanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);

    return Scaffold(
      backgroundColor: colors.background,
      body: SafeArea(
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
                    t.pengaturanScreen.title,
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
            SizedBox(height: 16.h),

            // Settings card
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: Container(
                decoration: BoxDecoration(
                  color: colors.surface,
                  borderRadius: BorderRadius.circular(16.r),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.04),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    // Bahasa — reactive subtitle
                    BlocBuilder<LocaleCubit, LocaleState>(
                      builder: (context, localeState) {
                        final currentLocale = localeState.maybeWhen(
                          loaded: (locale) => locale,
                          orElse: () => AppLocale.id,
                        );
                        final subtitle = currentLocale == AppLocale.id
                            ? t.pengaturanScreen.bahasaIndonesia
                            : t.pengaturanScreen.english;

                        return _buildSettingItem(
                          colors,
                          icon: Icons.language,
                          title: t.pengaturanScreen.bahasa,
                          subtitle: subtitle,
                          onTap: () => _showLanguageDialog(
                            context,
                            colors,
                            currentLocale,
                          ),
                        );
                      },
                    ),
                    Divider(
                      height: 1,
                      indent: 60.w,
                      endIndent: 20.w,
                      color: colors.border.withValues(alpha: 0.5),
                    ),
                    // Tema — reactive subtitle
                    BlocBuilder<ThemeCubit, ThemeState>(
                      builder: (context, themeState) {
                        final currentMode = themeState.maybeWhen(
                          loaded: (mode) => mode,
                          orElse: () => AppThemeMode.light,
                        );
                        final subtitle = currentMode == AppThemeMode.dark
                            ? t.pengaturanScreen.gelapDark
                            : t.pengaturanScreen.terangLight;

                        return _buildSettingItem(
                          colors,
                          icon: currentMode == AppThemeMode.dark
                              ? Icons.dark_mode
                              : Icons.light_mode,
                          title: t.pengaturanScreen.tema,
                          subtitle: subtitle,
                          onTap: () => _showThemeDialog(
                            context,
                            colors,
                            currentMode,
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Language selection dialog ──
  void _showLanguageDialog(
    BuildContext context,
    AppColorSet colors,
    AppLocale currentLocale,
  ) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: colors.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.r),
          ),
          title: Text(
            t.pengaturanScreen.pilihBahasa,
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w700,
              color: colors.textPrimary,
              fontFamily: 'Poppins',
            ),
          ),
          contentPadding: EdgeInsets.only(top: 8.h, bottom: 8.h),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildRadioOption(
                colors,
                title: t.pengaturanScreen.bahasaIndonesia,
                isSelected: currentLocale == AppLocale.id,
                onTap: () {
                  context.read<LocaleCubit>().setLocale(AppLocale.id);
                  Navigator.of(dialogContext).pop();
                },
              ),
              _buildRadioOption(
                colors,
                title: t.pengaturanScreen.english,
                isSelected: currentLocale == AppLocale.en,
                onTap: () {
                  context.read<LocaleCubit>().setLocale(AppLocale.en);
                  Navigator.of(dialogContext).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  // ── Theme selection dialog ──
  void _showThemeDialog(
    BuildContext context,
    AppColorSet colors,
    AppThemeMode currentMode,
  ) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: colors.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.r),
          ),
          title: Text(
            t.pengaturanScreen.pilihTema,
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w700,
              color: colors.textPrimary,
              fontFamily: 'Poppins',
            ),
          ),
          contentPadding: EdgeInsets.only(top: 8.h, bottom: 8.h),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildRadioOption(
                colors,
                title: t.pengaturanScreen.terangLight,
                isSelected: currentMode == AppThemeMode.light,
                onTap: () {
                  context.read<ThemeCubit>().setThemeMode(AppThemeMode.light);
                  Navigator.of(dialogContext).pop();
                },
              ),
              _buildRadioOption(
                colors,
                title: t.pengaturanScreen.gelapDark,
                isSelected: currentMode == AppThemeMode.dark,
                onTap: () {
                  context.read<ThemeCubit>().setThemeMode(AppThemeMode.dark);
                  Navigator.of(dialogContext).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  // ── Radio option row ──
  Widget _buildRadioOption(
    AppColorSet colors, {
    required String title,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
        child: Row(
          children: [
            Icon(
              isSelected ? Icons.radio_button_checked : Icons.radio_button_off,
              size: 22.sp,
              color: isSelected ? colors.primary : colors.textSecondary,
            ),
            SizedBox(width: 12.w),
            Text(
              title,
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                color: isSelected ? colors.primary : colors.textPrimary,
                fontFamily: 'Poppins',
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Setting item row ──
  Widget _buildSettingItem(
    AppColorSet colors, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16.r),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 16.h),
        child: Row(
          children: [
            // Icon circle
            Container(
              width: 40.w,
              height: 40.w,
              decoration: BoxDecoration(
                color: colors.primary.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 20.sp, color: colors.primary),
            ),
            SizedBox(width: 14.w),

            // Title + subtitle
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w600,
                      color: colors.textPrimary,
                      fontFamily: 'Poppins',
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w400,
                      color: colors.textSecondary,
                      fontFamily: 'Poppins',
                    ),
                  ),
                ],
              ),
            ),

            // Chevron
            Icon(
              Icons.chevron_right,
              size: 22.sp,
              color: colors.textSecondary,
            ),
          ],
        ),
      ),
    );
  }
}
