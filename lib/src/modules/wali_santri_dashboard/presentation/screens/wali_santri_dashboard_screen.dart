import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_halaqoh/gen/i18n/translations.g.dart';
import 'package:my_halaqoh/src/core/theme/app_colors.dart';

/// Dashboard content page for Wali Santri role
class WaliSantriDashboardScreen extends StatelessWidget {
  final void Function(int index)? onNavigateToTab;

  const WaliSantriDashboardScreen({super.key, this.onNavigateToTab});

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);

    return Scaffold(
      backgroundColor: colors.background,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // ── Green gradient profile header ──
            _buildProfileHeader(colors),
            SizedBox(height: 24.h),

            // ── Progress Hafalan card ──
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: GestureDetector(
                onTap: () => onNavigateToTab?.call(1),
                child: _buildProgressHafalanCard(context, colors),
              ),
            ),
            SizedBox(height: 16.h),

            // ── Kehadiran card ──
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: GestureDetector(
                onTap: () => onNavigateToTab?.call(2),
                child: _buildKehadiranCard(colors),
              ),
            ),
            SizedBox(height: 100.h), // Space for bottom bar
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader(AppColorSet colors) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [colors.primary, colors.primary.withValues(alpha: 0.85)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(28.r),
          bottomRight: Radius.circular(28.r),
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: EdgeInsets.fromLTRB(24.w, 20.h, 24.w, 32.h),
          child: Column(
            children: [
              // Avatar
              Container(
                width: 80.w,
                height: 80.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withValues(alpha: 0.2),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.4),
                    width: 3,
                  ),
                ),
                child: Icon(Icons.person, size: 40.sp, color: Colors.white),
              ),
              SizedBox(height: 14.h),

              // Name
              Text(
                'Ahmad',
                style: TextStyle(
                  fontSize: 22.sp,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                  fontFamily: 'Poppins',
                ),
              ),
              SizedBox(height: 4.h),

              // NIS
              Text(
                'NIS: 123456',
                style: TextStyle(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w500,
                  color: Colors.white.withValues(alpha: 0.9),
                  fontFamily: 'Poppins',
                ),
              ),
              SizedBox(height: 8.h),

              // Kelas & Halaqoh
              Text(
                'Kelas 7 | Halaqoh 1',
                style: TextStyle(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w400,
                  color: Colors.white.withValues(alpha: 0.85),
                  fontFamily: 'Poppins',
                ),
              ),
              SizedBox(height: 2.h),

              // Guru
              Text(
                'Guru: Ustadz Kayyis',
                style: TextStyle(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w400,
                  color: Colors.white.withValues(alpha: 0.85),
                  fontFamily: 'Poppins',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProgressHafalanCard(BuildContext context, AppColorSet colors) {
    const int juzCompleted = 3;
    const int juzTarget = 5;
    const double progress = juzCompleted / juzTarget;
    final int percent = (progress * 100).round();

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(18.w),
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
          // Header row
          Row(
            children: [
              Icon(Icons.menu_book, size: 20.sp, color: colors.primary),
              SizedBox(width: 8.w),
              Expanded(
                child: Text(
                  t.waliSantriDashboard.progressHafalan,
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w700,
                    color: colors.textPrimary,
                    fontFamily: 'Poppins',
                  ),
                ),
              ),
              Icon(
                Icons.chevron_right,
                size: 22.sp,
                color: colors.textSecondary,
              ),
            ],
          ),
          SizedBox(height: 16.h),

          // Juz completed + percentage
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: '$juzCompleted ',
                      style: TextStyle(
                        fontSize: 28.sp,
                        fontWeight: FontWeight.w800,
                        color: colors.textPrimary,
                        fontFamily: 'Poppins',
                      ),
                    ),
                    TextSpan(
                      text: t.waliSantriDashboard.juzTerselesaikan,
                      style: TextStyle(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w400,
                        color: colors.textSecondary,
                        fontFamily: 'Poppins',
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                '$percent%',
                style: TextStyle(
                  fontSize: 24.sp,
                  fontWeight: FontWeight.w800,
                  color: colors.primary,
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
              value: progress,
              minHeight: 10.h,
              backgroundColor: colors.border.withValues(alpha: 0.3),
              valueColor: AlwaysStoppedAnimation<Color>(colors.primary),
            ),
          ),
          SizedBox(height: 8.h),

          // Target text
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              t.waliSantriDashboard.target(target: '$juzTarget'),
              style: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.w500,
                color: colors.textSecondary,
                fontFamily: 'Poppins',
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildKehadiranCard(AppColorSet colors) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(18.w),
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
          // Header row
          Row(
            children: [
              Icon(Icons.calendar_today, size: 18.sp, color: colors.primary),
              SizedBox(width: 8.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      t.waliSantriDashboard.kehadiran,
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w700,
                        color: colors.textPrimary,
                        fontFamily: 'Poppins',
                      ),
                    ),
                    Text(
                      t.waliSantriDashboard.periode(periode: 'Januari 2026'),
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
              Icon(
                Icons.chevron_right,
                size: 22.sp,
                color: colors.textSecondary,
              ),
            ],
          ),
          SizedBox(height: 18.h),

          // Attendance stats grid (2x2)
          Row(
            children: [
              Expanded(
                child: _buildAttendanceStat(
                  t.waliSantriDashboard.hadir,
                  '25',
                  colors.primary,
                  colors,
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: _buildAttendanceStat(
                  t.waliSantriDashboard.sakit,
                  '4',
                  colors.yellow,
                  colors,
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Row(
            children: [
              Expanded(
                child: _buildAttendanceStat(
                  t.waliSantriDashboard.izin,
                  '1',
                  colors.blue,
                  colors,
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: _buildAttendanceStat(
                  t.waliSantriDashboard.alpha,
                  '0',
                  colors.red,
                  colors,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAttendanceStat(
    String label,
    String value,
    Color dotColor,
    AppColorSet colors,
  ) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: colors.background,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        children: [
          Container(
            width: 10.w,
            height: 10.w,
            decoration: BoxDecoration(shape: BoxShape.circle, color: dotColor),
          ),
          SizedBox(width: 8.w),
          Text(
            label,
            style: TextStyle(
              fontSize: 13.sp,
              fontWeight: FontWeight.w500,
              color: colors.textSecondary,
              fontFamily: 'Poppins',
            ),
          ),
          const Spacer(),
          Text(
            value,
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w700,
              color: colors.textPrimary,
              fontFamily: 'Poppins',
            ),
          ),
        ],
      ),
    );
  }
}
