import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_halaqoh/gen/assets.gen.dart';
import 'package:my_halaqoh/gen/i18n/translations.g.dart';
import 'package:my_halaqoh/src/core/theme/app_colors.dart';
import 'package:url_launcher/url_launcher.dart';

@RoutePage()
class TentangAplikasiScreen extends StatelessWidget {
  const TentangAplikasiScreen({super.key});

  static const _version = '1.0.0';
  static const _adminWhatsApp = '+6285850132215';
  static const _pesantrenName =
      'Pondok Pesantren Hidayatullah Luqman Al-Hakim Surabaya';

  Future<void> _openWhatsApp(BuildContext context) async {
    const message = 'Assalamu\'alaikum, saya ingin menghubungi tim MyHalaqoh.';
    final uri = Uri.parse(
      'https://wa.me/$_adminWhatsApp?text=${Uri.encodeComponent(message)}',
    );
    try {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (_) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Gagal membuka WhatsApp.',
              style: TextStyle(fontFamily: 'Poppins'),
            ),
            backgroundColor: AppColors.of(context).error,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final s = t.tentangAplikasiScreen;

    return Scaffold(
      backgroundColor: colors.background,
      body: CustomScrollView(
        slivers: [
          // ── Collapsing Header ──────────────────────────────────────────
          SliverAppBar(
            expandedHeight: 260.h,
            pinned: true,
            backgroundColor: colors.primary,
            iconTheme: const IconThemeData(color: Colors.white),
            flexibleSpace: FlexibleSpaceBar(
              background: _buildHeader(colors, s),
            ),
            title: Text(
              s.title,
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w700,
                color: Colors.white,
                fontFamily: 'Poppins',
              ),
            ),
            centerTitle: false,
          ),

          // ── Content ────────────────────────────────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 24.h),

                  // ── About section ─────────────────────────────
                  _buildSectionCard(
                    colors: colors,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildSectionTitle(s.sectionTentang, colors),
                        SizedBox(height: 12.h),
                        Text(
                          s.deskripsi1,
                          style: TextStyle(
                            fontSize: 13.sp,
                            color: colors.textSecondary,
                            fontFamily: 'Poppins',
                            height: 1.7,
                          ),
                        ),
                        SizedBox(height: 8.h),
                        Text(
                          s.deskripsi2(pesantren: _pesantrenName),
                          style: TextStyle(
                            fontSize: 13.sp,
                            color: colors.textSecondary,
                            fontFamily: 'Poppins',
                            height: 1.7,
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 16.h),

                  // ── Features section ──────────────────────────
                  _buildSectionCard(
                    colors: colors,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildSectionTitle(s.sectionFitur, colors),
                        SizedBox(height: 16.h),
                        _buildFeatureItem(
                          icon: Icons.qr_code_scanner_rounded,
                          color: const Color(0xFF2196F3),
                          title: s.fiturAbsensiJudul,
                          description: s.fiturAbsensiDesc,
                          colors: colors,
                        ),
                        _buildFeatureDivider(colors),
                        _buildFeatureItem(
                          icon: Icons.menu_book_rounded,
                          color: const Color(0xFF4CAF50),
                          title: s.fiturHafalanJudul,
                          description: s.fiturHafalanDesc,
                          colors: colors,
                        ),
                        _buildFeatureDivider(colors),
                        _buildFeatureItem(
                          icon: Icons.notifications_active_rounded,
                          color: const Color(0xFFFF9800),
                          title: s.fiturNotifJudul,
                          description: s.fiturNotifDesc,
                          colors: colors,
                        ),
                        _buildFeatureDivider(colors),
                        _buildFeatureItem(
                          icon: Icons.people_alt_rounded,
                          color: const Color(0xFF9C27B0),
                          title: s.fiturMultiRoleJudul,
                          description: s.fiturMultiRoleDesc,
                          colors: colors,
                        ),
                        _buildFeatureDivider(colors),
                        _buildFeatureItem(
                          icon: Icons.wifi_off_rounded,
                          color: const Color(0xFF607D8B),
                          title: s.fiturOfflineJudul,
                          description: s.fiturOfflineDesc,
                          colors: colors,
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 16.h),

                  // ── App Info section ──────────────────────────
                  _buildSectionCard(
                    colors: colors,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildSectionTitle(s.sectionInfo, colors),
                        SizedBox(height: 12.h),
                        _buildInfoRow(s.infoNamaApp, s.appName, colors),
                        _buildInfoRow(s.infoVersi, _version, colors),
                        _buildInfoRow(
                          s.infoPlatform,
                          s.infoPlatformValue,
                          colors,
                        ),
                        _buildInfoRow(s.infoLembaga, _pesantrenName, colors),
                      ],
                    ),
                  ),

                  SizedBox(height: 16.h),

                  // ── Contact section ───────────────────────────
                  _buildSectionCard(
                    colors: colors,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildSectionTitle(s.sectionKontak, colors),
                        SizedBox(height: 12.h),
                        Text(
                          s.kontakDeskripsi,
                          style: TextStyle(
                            fontSize: 13.sp,
                            color: colors.textSecondary,
                            fontFamily: 'Poppins',
                            height: 1.7,
                          ),
                        ),
                        SizedBox(height: 16.h),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: () => _openWhatsApp(context),
                            icon: const Icon(
                              Icons.chat_rounded,
                              color: Colors.white,
                            ),
                            label: Text(
                              s.kontakButton,
                              style: TextStyle(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                                fontFamily: 'Poppins',
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF25D366),
                              padding: EdgeInsets.symmetric(vertical: 14.h),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12.r),
                              ),
                              elevation: 0,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 24.h),

                  // ── Footer ────────────────────────────────────
                  Center(
                    child: Column(
                      children: [
                        Text(
                          s.copyright,
                          style: TextStyle(
                            fontSize: 11.sp,
                            color: colors.textSecondary.withValues(alpha: 0.5),
                            fontFamily: 'Poppins',
                          ),
                        ),
                        SizedBox(height: 40.h),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Gradient header with logo, app name, version, and pesantren name
  Widget _buildHeader(
    AppColorSet colors,
    TranslationsTentangAplikasiScreenEn s,
  ) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [colors.primary, colors.primary.withValues(alpha: 0.75)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 16.h),
            // Logo circle
            Container(
              width: 88.w,
              height: 88.w,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.15),
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.3),
                  width: 2,
                ),
              ),
              padding: EdgeInsets.all(16.w),
              child: Assets.images.myHalaqohLogo.image(
                fit: BoxFit.contain,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 14.h),
            Text(
              s.appName,
              style: TextStyle(
                fontSize: 26.sp,
                fontWeight: FontWeight.w800,
                color: Colors.white,
                fontFamily: 'Poppins',
                letterSpacing: 0.5,
              ),
            ),
            SizedBox(height: 4.h),
            Text(
              s.tagline,
              style: TextStyle(
                fontSize: 12.sp,
                color: Colors.white.withValues(alpha: 0.85),
                fontFamily: 'Poppins',
              ),
            ),
            SizedBox(height: 10.h),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 5.h),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(20.r),
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.4),
                  width: 1,
                ),
              ),
              child: Text(
                '${s.version} $_version',
                style: TextStyle(
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                  fontFamily: 'Poppins',
                  letterSpacing: 0.5,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Rounded card container for each content section
  Widget _buildSectionCard({
    required AppColorSet colors,
    required Widget child,
  }) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(18.w),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: child,
    );
  }

  Widget _buildSectionTitle(String title, AppColorSet colors) {
    return Row(
      children: [
        Container(
          width: 4.w,
          height: 18.h,
          decoration: BoxDecoration(
            color: colors.primary,
            borderRadius: BorderRadius.circular(4.r),
          ),
        ),
        SizedBox(width: 10.w),
        Text(
          title,
          style: TextStyle(
            fontSize: 15.sp,
            fontWeight: FontWeight.w700,
            color: colors.textPrimary,
            fontFamily: 'Poppins',
          ),
        ),
      ],
    );
  }

  Widget _buildFeatureItem({
    required IconData icon,
    required Color color,
    required String title,
    required String description,
    required AppColorSet colors,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 44.w,
            height: 44.w,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Icon(icon, size: 22.sp, color: color),
          ),
          SizedBox(width: 14.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: colors.textPrimary,
                    fontFamily: 'Poppins',
                  ),
                ),
                SizedBox(height: 3.h),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: colors.textSecondary,
                    fontFamily: 'Poppins',
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureDivider(AppColorSet colors) {
    return Divider(
      height: 1,
      indent: 58.w,
      color: colors.border.withValues(alpha: 0.4),
    );
  }

  Widget _buildInfoRow(String label, String value, AppColorSet colors) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 110.w,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 13.sp,
                color: colors.textSecondary,
                fontFamily: 'Poppins',
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 13.sp,
                fontWeight: FontWeight.w600,
                color: colors.textPrimary,
                fontFamily: 'Poppins',
              ),
            ),
          ),
        ],
      ),
    );
  }
}
