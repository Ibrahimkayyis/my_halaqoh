import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:my_halaqoh/gen/i18n/translations.g.dart';
import 'package:my_halaqoh/src/core/locale/cubit/locale_cubit.dart';
import 'package:my_halaqoh/src/core/service_locator/service_locator.dart';
import 'package:my_halaqoh/src/core/theme/app_colors.dart';
import 'package:my_halaqoh/src/core/theme/cubit/theme_cubit.dart';
import 'package:my_halaqoh/src/core/theme/theme_mode.dart';
import 'package:my_halaqoh/src/modules/auth/presentation/cubits/auth_cubit.dart';
import 'package:my_halaqoh/src/modules/auth/presentation/cubits/auth_state.dart';
import 'package:my_halaqoh/src/modules/notifications/presentation/cubits/notification_cubit.dart';
import 'package:my_halaqoh/src/modules/notifications/presentation/cubits/notification_state.dart';

@RoutePage()
class WaliSantriPengaturanScreen extends StatelessWidget {
  const WaliSantriPengaturanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);

    return BlocProvider.value(
      value: sl<NotificationCubit>(),
      child: BlocListener<NotificationCubit, NotificationState>(
        listener: (context, state) {
          state.maybeWhen(
            needsSystemSettings: () {
              _showSettingsDialog(context, colors);
            },
            error: (msg) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(msg)),
              );
            },
            orElse: () {},
          );
        },
        child: Scaffold(
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
                        t.WaliSantriPengaturanScreen.title,
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
                                ? t.WaliSantriPengaturanScreen.bahasaIndonesia
                                : t.WaliSantriPengaturanScreen.english;

                            return _buildSettingItem(
                              colors,
                              icon: Icons.language,
                              title: t.WaliSantriPengaturanScreen.bahasa,
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

                        // Notifikasi Toggle Row
                        BlocBuilder<NotificationCubit, NotificationState>(
                          builder: (context, notificationState) {
                            final authState = context.read<AuthCubit>().state;
                            final uid = authState.maybeWhen(
                              authenticated: (userMeta) => userMeta.uid,
                              orElse: () => '',
                            );

                            if (uid.isEmpty) return const SizedBox.shrink();

                            final isEnabled = notificationState.maybeWhen(
                              notificationEnabled: () => true,
                              notificationDisabled: () => false,
                              needsSystemSettings: () => false,
                              tokenSaved: () => true,
                              permissionDenied: () => false,
                              orElse: () {
                                return context.read<NotificationCubit>().isNotificationEnabledLocally(uid);
                              },
                            );

                            return _buildSettingItem(
                              colors,
                              icon: Icons.notifications_active_outlined,
                              title: t.WaliSantriPengaturanScreen.notifikasi,
                              subtitle: isEnabled
                                  ? t.WaliSantriPengaturanScreen.notifikasiAktif
                                  : t.WaliSantriPengaturanScreen.notifikasiNonAktif,
                              trailing: Switch(
                                value: isEnabled,
                                activeThumbColor: colors.primary,
                                onChanged: (value) {
                                  _onNotificationToggleChanged(context, uid, value);
                                },
                              ),
                              onTap: () {
                                _onNotificationToggleChanged(context, uid, !isEnabled);
                              },
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
                                ? t.WaliSantriPengaturanScreen.gelapDark
                                : t.WaliSantriPengaturanScreen.terangLight;

                            return _buildSettingItem(
                              colors,
                              icon: currentMode == AppThemeMode.dark
                                  ? Icons.dark_mode
                                  : Icons.light_mode,
                              title: t.WaliSantriPengaturanScreen.tema,
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
        ),
      ),
    );
  }

  void _onNotificationToggleChanged(BuildContext context, String uid, bool value) {
    if (value) {
      context.read<NotificationCubit>().enableNotification(uid);
    } else {
      context.read<NotificationCubit>().disableNotification(uid);
    }
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
            t.WaliSantriPengaturanScreen.pilihBahasa,
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
                title: t.WaliSantriPengaturanScreen.bahasaIndonesia,
                isSelected: currentLocale == AppLocale.id,
                onTap: () {
                  context.read<LocaleCubit>().setLocale(AppLocale.id);
                  Navigator.of(dialogContext).pop();
                },
              ),
              _buildRadioOption(
                colors,
                title: t.WaliSantriPengaturanScreen.english,
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
    final effectiveMode = currentMode == AppThemeMode.system
        ? (Theme.of(context).brightness == Brightness.dark
            ? AppThemeMode.dark
            : AppThemeMode.light)
        : currentMode;

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: colors.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.r),
          ),
          title: Text(
            t.WaliSantriPengaturanScreen.pilihTema,
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
                title: t.WaliSantriPengaturanScreen.terangLight,
                isSelected: effectiveMode == AppThemeMode.light,
                onTap: () {
                  context.read<ThemeCubit>().setThemeMode(AppThemeMode.light);
                  Navigator.of(dialogContext).pop();
                },
              ),
              _buildRadioOption(
                colors,
                title: t.WaliSantriPengaturanScreen.gelapDark,
                isSelected: effectiveMode == AppThemeMode.dark,
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

  // ── Settings permission dialog ──
  void _showSettingsDialog(BuildContext context, AppColorSet colors) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: colors.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.r),
          ),
          title: Text(
            t.WaliSantriPengaturanScreen.notifikasiDialogTitle,
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w700,
              color: colors.textPrimary,
              fontFamily: 'Poppins',
            ),
          ),
          content: Text(
            t.WaliSantriPengaturanScreen.notifikasiDialogMessage,
            style: TextStyle(
              fontSize: 14.sp,
              color: colors.textPrimary,
              fontFamily: 'Poppins',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: Text(
                t.dialogs.batal,
                style: TextStyle(
                  color: colors.textSecondary,
                  fontFamily: 'Poppins',
                ),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: colors.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.r),
                ),
              ),
              onPressed: () async {
                Navigator.of(dialogContext).pop();
                try {
                  await launchUrl(
                    Uri.parse('app-settings:'),
                    mode: LaunchMode.externalApplication,
                  );
                } catch (e) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Gagal membuka Pengaturan secara otomatis. Silakan buka Pengaturan HP Anda secara manual.',
                        ),
                      ),
                    );
                  }
                }
              },
              child: Text(
                t.WaliSantriPengaturanScreen.bukaSettingHp,
                style: const TextStyle(
                  color: Colors.white,
                  fontFamily: 'Poppins',
                ),
              ),
            ),
          ],
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
    VoidCallback? onTap,
    Widget? trailing,
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

            // Trailing component (chevron or Switch)
            trailing ?? Icon(
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

