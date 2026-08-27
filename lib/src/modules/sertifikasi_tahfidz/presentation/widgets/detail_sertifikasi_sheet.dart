import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:my_halaqoh/src/core/theme/app_colors.dart';
import 'package:my_halaqoh/src/core/widget/widgets.dart';
import 'package:my_halaqoh/src/modules/sertifikasi_tahfidz/domain/helpers/sertifikasi_status_helper.dart';
import 'package:my_halaqoh/src/modules/sertifikasi_tahfidz/domain/models/sertifikasi_model.dart';

/// Modal bottom sheet showing complete details of a Santri Tahfidz Certification.
/// Strictly adheres to MASTER.md:
/// - Top border radius: radius.xl (20.r)
/// - Inner cards: radius.md (12.r)
/// - Badges & Buttons: radius.sm (8.r)
/// - Typography: Theme.of(context).textTheme tokens
/// - Spacing: 4dp grid (4, 8, 12, 16, 20, 24)
class DetailSertifikasiSheet extends StatelessWidget {
  final SertifikasiModel item;

  const DetailSertifikasiSheet({super.key, required this.item});

  static Future<void> show(BuildContext context, SertifikasiModel item) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DetailSertifikasiSheet(item: item),
    );
  }

  String _formatDate(DateTime? date) {
    if (date == null) return '-';
    return DateFormat('EEEE, d MMMM yyyy', 'id_ID').format(date);
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final textTheme = Theme.of(context).textTheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final statusBg = SertifikasiStatusHelper.getStatusBgColor(item.status, context);
    final statusFg = SertifikasiStatusHelper.getStatusFgColor(item.status, context);
    final statusIcon = SertifikasiStatusHelper.getStatusIcon(item.status);
    final statusLabel = SertifikasiStatusHelper.getStatusLabel(item.status);

    return Container(
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
        border: isDark ? Border.all(color: colors.border, width: 0.5) : null,
      ),
      padding: EdgeInsets.only(
        left: 20.w,
        right: 20.w,
        top: 12.h,
        bottom: MediaQuery.of(context).padding.bottom + 20.h,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Drag Handle
            Center(
              child: Container(
                width: 40.w,
                height: 4.h,
                decoration: BoxDecoration(
                  color: colors.border,
                  borderRadius: BorderRadius.circular(4.r),
                ),
              ),
            ),
            SizedBox(height: 16.h),

            // Header Title + Status Pill
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Rincian Sertifikasi',
                  style: textTheme.titleLarge?.copyWith(
                    color: colors.textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: statusBg,
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(statusIcon, size: 12.sp, color: statusFg),
                      SizedBox(width: 4.w),
                      Text(
                        statusLabel,
                        style: textTheme.labelSmall?.copyWith(
                          color: statusFg,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.h),

            // ── Section 1: Santri Context Header (Core Widget) ───────────
            SantriContextHeader(
              name: item.santriNama,
              nis: item.nis,
              subtitle: 'Kelas ${item.kelas} (${item.program == "T" ? "Takhassus" : "Reguler"}) • ${item.halaqohNama}',
              profilePictureUrl: item.profilePicture,
              margin: EdgeInsets.only(bottom: 16.h),
            ),

            // ── Section 2: Jadwal & Penguji ─────────────────────────────
            _buildSectionTitle('Informasi Ujian & Penguji', colors, textTheme),
            SizedBox(height: 8.h),
            _buildInfoRow('Target Sertifikasi', 'Juz ${item.juz}', colors, textTheme),
            if (item.status == SertifikasiStatusHelper.statusScheduled ||
                item.status == SertifikasiStatusHelper.statusPassed ||
                item.status == SertifikasiStatusHelper.statusFailed) ...[
              _buildInfoRow('Tanggal Ujian', _formatDate(item.tanggalUjian), colors, textTheme),
              _buildInfoRow('Sesi / Waktu', item.sesiUjian ?? 'Sesuai Jadwal', colors, textTheme),
              _buildInfoRow('Ustadz Penguji', item.pengujiNama ?? 'Tim Penguji Tahfidz', colors, textTheme),
              if (item.catatanAdmin != null && item.catatanAdmin!.isNotEmpty)
                _buildInfoRow('Catatan Waka', item.catatanAdmin!, colors, textTheme),
            ] else ...[
              _buildInfoRow('Status Pengajuan', 'Menunggu persetujuan Waka Tahfidz', colors, textTheme),
            ],
            SizedBox(height: 16.h),

            // ── Section 3: Hasil & Nilai (If Passed / Failed) ─────────────
            if (item.status == SertifikasiStatusHelper.statusPassed ||
                item.status == SertifikasiStatusHelper.statusFailed) ...[
              _buildSectionTitle('Hasil Penilaian Ujian', colors, textTheme),
              SizedBox(height: 8.h),
              Container(
                padding: EdgeInsets.all(12.w),
                decoration: BoxDecoration(
                  color: item.status == SertifikasiStatusHelper.statusPassed
                      ? colors.success.withValues(alpha: 0.08)
                      : colors.error.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(
                    color: item.status == SertifikasiStatusHelper.statusPassed
                        ? colors.success.withValues(alpha: 0.25)
                        : colors.error.withValues(alpha: 0.25),
                    width: 0.8,
                  ),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Nilai Ujian',
                          style: textTheme.titleMedium?.copyWith(
                            color: colors.textPrimary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          '${item.nilai ?? "-"} / 100',
                          style: textTheme.headlineSmall?.copyWith(
                            color: item.status == SertifikasiStatusHelper.statusPassed
                                ? colors.success
                                : colors.error,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                    if (item.predikat != null) ...[
                      SizedBox(height: 4.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Predikat',
                            style: textTheme.labelMedium?.copyWith(
                              color: colors.textSecondary,
                            ),
                          ),
                          Text(
                            item.predikat!,
                            style: textTheme.titleSmall?.copyWith(
                              color: colors.textPrimary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
              if (item.catatanPenguji != null && item.catatanPenguji!.isNotEmpty) ...[
                SizedBox(height: 8.h),
                _buildInfoRow('Catatan Penguji', item.catatanPenguji!, colors, textTheme),
              ],
              SizedBox(height: 16.h),
            ],

            // ── Section 4: Alasan Penolakan (If Rejected) ─────────────────
            if (item.status == SertifikasiStatusHelper.statusRejected) ...[
              _buildSectionTitle('Alasan Penolakan', colors, textTheme),
              SizedBox(height: 8.h),
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(12.w),
                decoration: BoxDecoration(
                  color: colors.error.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(8.r),
                  border: Border.all(
                    color: colors.error.withValues(alpha: 0.25),
                    width: 0.8,
                  ),
                ),
                child: Text(
                  item.alasanPenolakan ?? 'Pendaftaran belum dapat disetujui.',
                  style: textTheme.bodySmall?.copyWith(
                    color: colors.error,
                  ),
                ),
              ),
              SizedBox(height: 16.h),
            ],

            // Teacher's note if any
            if (item.catatanGuru != null && item.catatanGuru!.isNotEmpty) ...[
              _buildSectionTitle('Catatan Pengantar Guru', colors, textTheme),
              SizedBox(height: 6.h),
              Text(
                item.catatanGuru!,
                style: textTheme.bodySmall?.copyWith(
                  color: colors.textSecondary,
                ),
              ),
              SizedBox(height: 16.h),
            ],

            // Close button
            PrimaryButton(
              onPressed: () => Navigator.of(context).pop(),
              label: 'Tutup',
              width: double.infinity,
              height: 44.h,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title, AppColorSet colors, TextTheme textTheme) {
    return Text(
      title,
      style: textTheme.titleSmall?.copyWith(
        color: colors.textPrimary,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  Widget _buildInfoRow(
    String label,
    String value,
    AppColorSet colors,
    TextTheme textTheme,
  ) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120.w,
            child: Text(
              label,
              style: textTheme.labelMedium?.copyWith(
                color: colors.textSecondary,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: textTheme.titleSmall?.copyWith(
                color: colors.textPrimary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }


}
