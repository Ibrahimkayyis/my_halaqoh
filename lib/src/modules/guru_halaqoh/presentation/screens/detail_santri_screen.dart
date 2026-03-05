import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_halaqoh/gen/i18n/translations.g.dart';
import 'package:my_halaqoh/src/core/theme/app_colors.dart';
import 'package:my_halaqoh/src/modules/guru_halaqoh/presentation/widgets/academic_info_row.dart';

/// Detail santri screen showing profile header, academic info, and progress hafalan
@RoutePage()
class DetailSantriScreen extends StatelessWidget {
  final String name;
  final String nis;

  const DetailSantriScreen({super.key, required this.name, required this.nis});

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);

    return Scaffold(
      backgroundColor: colors.background,
      body: SafeArea(
        child: Column(
          children: [
            // Back arrow + title
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
                    t.detailSantri.title,
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

            // Scrollable content
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 8.h),

                    // Profile header card
                    _buildProfileHeader(colors),
                    SizedBox(height: 28.h),

                    // INFORMASI AKADEMIK section
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 24.w),
                      child: Text(
                        t.detailSantri.informasiAkademik,
                        style: TextStyle(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w600,
                          color: colors.textSecondary,
                          letterSpacing: 0.8,
                          fontFamily: 'Poppins',
                        ),
                      ),
                    ),
                    SizedBox(height: 12.h),

                    // Info card
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 24.w),
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
                          AcademicInfoRow(
                            icon: Icons.school,
                            iconColor: colors.primary,
                            iconBgColor: colors.primary.withValues(alpha: 0.1),
                            label: t.detailSantri.kelas,
                            value: 'Kelas 7',
                          ),
                          AcademicInfoRow(
                            icon: Icons.menu_book,
                            iconColor: colors.blue,
                            iconBgColor: colors.blue.withValues(alpha: 0.1),
                            label: t.detailSantri.program,
                            value: 'Reguler',
                          ),
                          AcademicInfoRow(
                            icon: Icons.auto_stories,
                            iconColor: colors.primary,
                            iconBgColor: colors.primary.withValues(alpha: 0.1),
                            label: t.detailSantri.halaqoh,
                            value: 'Al-Kahfi',
                          ),
                          AcademicInfoRow(
                            icon: Icons.groups,
                            iconColor: colors.red,
                            iconBgColor: colors.red.withValues(alpha: 0.1),
                            label: t.detailSantri.pembimbing,
                            value: 'Ustadz Kayyis',
                            showDivider: false,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 28.h),

                    // PROGRESS HAFALAN section
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 24.w),
                      child: Text(
                        t.detailSantri.progressHafalan,
                        style: TextStyle(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w600,
                          color: colors.textSecondary,
                          letterSpacing: 0.8,
                          fontFamily: 'Poppins',
                        ),
                      ),
                    ),
                    SizedBox(height: 12.h),

                    // Progress card
                    _buildProgressCard(colors),
                    SizedBox(height: 40.h),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Green gradient profile header with avatar, name, NIS
  Widget _buildProfileHeader(AppColorSet colors) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 24.w),
      padding: EdgeInsets.symmetric(vertical: 28.h),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [colors.primary, colors.primary.withValues(alpha: 0.82)],
        ),
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Column(
        children: [
          // Avatar
          Container(
            width: 80.w,
            height: 80.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: colors.textOnButton.withValues(alpha: 0.2),
              border: Border.all(
                color: colors.textOnButton.withValues(alpha: 0.4),
                width: 3,
              ),
            ),
            child: Icon(Icons.person, size: 40.sp, color: colors.textOnButton),
          ),
          SizedBox(height: 14.h),
          // Name
          Text(
            name,
            style: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.w700,
              color: colors.textOnButton,
              fontFamily: 'Poppins',
            ),
          ),
          SizedBox(height: 4.h),
          // NIS
          Text(
            'NIS: $nis',
            style: TextStyle(
              fontSize: 13.sp,
              fontWeight: FontWeight.w400,
              color: colors.textOnButton.withValues(alpha: 0.85),
              fontFamily: 'Poppins',
            ),
          ),
        ],
      ),
    );
  }

  /// Progress Hafalan card with total, sertifikasi info, and progress bar
  Widget _buildProgressCard(AppColorSet colors) {
    // Dummy data
    const int totalHafalan = 12;
    const int sertifikasiDone = 8;
    const int sertifikasiTotal = 12;
    final double sertifikasiPct = sertifikasiDone / sertifikasiTotal;
    final int sertifikasiPctInt = (sertifikasiPct * 100).round();

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 24.w),
      padding: EdgeInsets.all(20.w),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Total Hafalan row
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Left: label + value
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      t.detailSantri.totalHafalan,
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w400,
                        color: colors.textSecondary,
                        fontFamily: 'Poppins',
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      '$totalHafalan Juz',
                      style: TextStyle(
                        fontSize: 24.sp,
                        fontWeight: FontWeight.w700,
                        color: colors.primary,
                        fontFamily: 'Poppins',
                      ),
                    ),
                  ],
                ),
              ),
              // Right: book icon
              Container(
                width: 44.w,
                height: 44.w,
                decoration: BoxDecoration(
                  color: colors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Icon(
                  Icons.menu_book,
                  size: 22.sp,
                  color: colors.primary,
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),

          // Sertifikasi label + percentage
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    t.detailSantri.sertifikasiInfo(
                      done: '$sertifikasiDone',
                      total: '$sertifikasiTotal',
                    ),
                    style: TextStyle(
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w400,
                      color: colors.textSecondary,
                      fontFamily: 'Poppins',
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    t.detailSantri.sertifikasiJuz,
                    style: TextStyle(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w600,
                      color: colors.textPrimary,
                      fontFamily: 'Poppins',
                    ),
                  ),
                ],
              ),
              Text(
                '$sertifikasiPctInt%',
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w700,
                  color: colors.textPrimary,
                  fontFamily: 'Poppins',
                ),
              ),
            ],
          ),
          SizedBox(height: 10.h),

          // Progress bar
          ClipRRect(
            borderRadius: BorderRadius.circular(6.r),
            child: LinearProgressIndicator(
              value: sertifikasiPct,
              minHeight: 10.h,
              backgroundColor: colors.border.withValues(alpha: 0.3),
              valueColor: AlwaysStoppedAnimation<Color>(colors.primary),
            ),
          ),
        ],
      ),
    );
  }
}
