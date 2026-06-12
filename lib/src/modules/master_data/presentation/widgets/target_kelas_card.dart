import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_halaqoh/gen/i18n/translations.g.dart';
import 'package:my_halaqoh/src/core/theme/app_colors.dart';
import 'package:my_halaqoh/src/modules/master_data/domain/helpers/curriculum_data.dart';
import 'package:my_halaqoh/src/modules/master_data/domain/models/target_hafalan_model.dart';

/// Card widget for displaying a class curriculum and its active settings.
class TargetKelasCard extends StatelessWidget {
  final KelasKurikulum kurikulum;
  final TargetHafalanModel? config;
  final VoidCallback onEditTap;

  const TargetKelasCard({
    super.key,
    required this.kurikulum,
    this.config,
    required this.onEditTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final isSma = int.parse(kurikulum.kelas) >= 10;
    final jenjang = isSma ? 'SMA' : 'SMP';
    final activeSem = config?.semesterAktif;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
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
        border: Border.all(
          color: colors.border.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header (Kelas & Metadata)
          Container(
            padding: EdgeInsets.fromLTRB(16.w, 14.h, 16.w, 12.h),
            decoration: BoxDecoration(
              color: colors.primary.withValues(alpha: 0.08),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16.r),
                topRight: Radius.circular(16.r),
              ),
              border: Border(
                bottom: BorderSide(
                  color: colors.primary.withValues(alpha: 0.1),
                ),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: colors.primary,
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Text(
                    kurikulum.kelas,
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w700,
                      color: colors.textOnButton,
                      fontFamily: 'Poppins',
                    ),
                  ),
                ),
                SizedBox(width: 10.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Kelas ${kurikulum.kelas} $jenjang',
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w700,
                          color: colors.textPrimary,
                          fontFamily: 'Poppins',
                        ),
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        'TA: ${config?.tahunAjaran.isNotEmpty == true ? config!.tahunAjaran : t.targetHafalan.belumDitetapkan} • Sem: ${activeSem ?? t.targetHafalan.belumDitetapkan}',
                        style: TextStyle(
                          fontSize: 11.sp,
                          fontWeight: FontWeight.w500,
                          color: colors.textSecondary,
                          fontFamily: 'Poppins',
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: onEditTap,
                  icon: Icon(Icons.settings, size: 20.sp, color: colors.primary),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ],
            ),
          ),

          // Curriculum Table
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
            child: Column(
              children: [
                _buildSemesterSection(
                  colors,
                  1,
                  kurikulum.semester1,
                  isActive: activeSem == 1,
                ),
                SizedBox(height: 16.h),
                _buildSemesterSection(
                  colors,
                  2,
                  kurikulum.semester2,
                  isActive: activeSem == 2,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSemesterSection(
    AppColorSet colors,
    int semesterNum,
    SemesterTarget target, {
    required bool isActive,
  }) {
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: isActive ? colors.primary.withValues(alpha: 0.05) : Colors.transparent,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(
          color: isActive ? colors.primary.withValues(alpha: 0.3) : colors.border.withValues(alpha: 0.5),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'SEMESTER $semesterNum',
                style: TextStyle(
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w700,
                  color: isActive ? colors.primary : colors.textSecondary,
                  letterSpacing: 0.5,
                  fontFamily: 'Poppins',
                ),
              ),
              if (isActive) ...[
                SizedBox(width: 6.w),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                  decoration: BoxDecoration(
                    color: colors.primary,
                    borderRadius: BorderRadius.circular(4.r),
                  ),
                  child: Text(
                    'AKTIF',
                    style: TextStyle(
                      fontSize: 8.sp,
                      fontWeight: FontWeight.w700,
                      color: colors.textOnButton,
                    ),
                  ),
                ),
              ],
            ],
          ),
          SizedBox(height: 8.h),
          _buildPeriodeRow(colors, 'UTS', target.uts),
          SizedBox(height: 6.h),
          _buildPeriodeRow(colors, 'UAS', target.uas),
        ],
      ),
    );
  }

  Widget _buildPeriodeRow(AppColorSet colors, String label, PeriodeTarget pt) {
    // If it's a special type, use the type name as fallback
    final title = pt.deskripsi ?? _getTypeName(pt.tipe);
    
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 32.w,
          margin: EdgeInsets.only(top: 2.h),
          padding: EdgeInsets.symmetric(vertical: 2.h),
          decoration: BoxDecoration(
            color: colors.background,
            borderRadius: BorderRadius.circular(4.r),
            border: Border.all(color: colors.border.withValues(alpha: 0.5)),
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: TextStyle(
              fontSize: 9.sp,
              fontWeight: FontWeight.w600,
              color: colors.textSecondary,
            ),
          ),
        ),
        SizedBox(width: 8.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w600,
                  color: colors.textPrimary,
                  fontFamily: 'Poppins',
                  height: 1.2,
                ),
              ),
              if (pt.fraksi != null)
                Text(
                  pt.fraksi!,
                  style: TextStyle(
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w400,
                    color: colors.textSecondary,
                    fontFamily: 'Poppins',
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }

  String _getTypeName(TipeHafalan tipe) {
    switch (tipe) {
      case TipeHafalan.ziyadah:
        return 'Ziyadah';
      case TipeHafalan.murajaah:
        return t.targetHafalan.tipeMurajaah;
      case TipeHafalan.idadTahsin:
        return t.targetHafalan.tipeIdadTahsin;
      case TipeHafalan.dauroh:
        return t.targetHafalan.tipeDauroh;
      case TipeHafalan.uat:
        return t.targetHafalan.tipeUAT;
    }
  }
}

