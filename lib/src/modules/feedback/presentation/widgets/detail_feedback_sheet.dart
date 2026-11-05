import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:my_halaqoh/src/core/theme/app_colors.dart';
import 'package:my_halaqoh/src/core/widget/widgets.dart';
import '../../domain/models/feedback_model.dart';

/// Modal bottom sheet showing detailed feedback report and admin follow-up.
class DetailFeedbackSheet extends StatelessWidget {
  final FeedbackModel item;

  const DetailFeedbackSheet({super.key, required this.item});

  static Future<void> show(BuildContext context, FeedbackModel item) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DetailFeedbackSheet(item: item),
    );
  }

  String _formatDateTime(DateTime? dt) {
    if (dt == null) return '-';
    return DateFormat('d MMMM yyyy, HH:mm', 'id_ID').format(dt);
  }

  String _categoryLabel(String category) {
    switch (category.toLowerCase()) {
      case 'bug':
        return 'Laporan Kendala (Bug)';
      case 'saran':
        return 'Saran & Masukan';
      case 'pertanyaan':
        return 'Pertanyaan';
      default:
        return 'Masukan';
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final textTheme = Theme.of(context).textTheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final isResolved = item.status.toLowerCase() == 'resolved';
    final isInProgress = item.status.toLowerCase() == 'in_progress';

    final Color statusBg = isResolved
        ? colors.success.withValues(alpha: 0.12)
        : isInProgress
            ? colors.blue.withValues(alpha: 0.12)
            : colors.warning.withValues(alpha: 0.12);

    final Color statusFg = isResolved
        ? colors.success
        : isInProgress
            ? colors.blue
            : colors.warning;

    final String statusLabel = isResolved
        ? 'Selesai Ditindaklanjuti'
        : isInProgress
            ? 'Sedang Diproses'
            : 'Menunggu Ditindaklanjuti';

    final IconData statusIcon = isResolved
        ? Icons.check_circle_rounded
        : isInProgress
            ? Icons.sync_rounded
            : Icons.schedule_rounded;

    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.88,
      ),
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
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Drag handle
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

          // Header: Title & Status pill
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  'Rincian Masukan',
                  style: textTheme.titleLarge?.copyWith(
                    color: colors.textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: statusBg,
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(statusIcon, size: 13.sp, color: statusFg),
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

          Flexible(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Admin Follow-up Card (if resolved or has response) ────────
                  if (item.adminResponse != null &&
                      item.adminResponse!.trim().isNotEmpty) ...[
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(14.w),
                      decoration: BoxDecoration(
                        color: colors.primary.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(12.r),
                        border: Border.all(
                          color: colors.primary.withValues(alpha: 0.25),
                          width: 0.8,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: EdgeInsets.all(6.w),
                                decoration: BoxDecoration(
                                  color: colors.primary.withValues(alpha: 0.15),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  Icons.mark_email_read_rounded,
                                  size: 16.sp,
                                  color: colors.primary,
                                ),
                              ),
                              SizedBox(width: 8.w),
                              Expanded(
                                child: Text(
                                  'Tindak Lanjut Pengurus',
                                  style: textTheme.titleSmall?.copyWith(
                                    color: colors.primary,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 10.h),
                          Text(
                            item.adminResponse!,
                            style: textTheme.bodyMedium?.copyWith(
                              color: colors.textPrimary,
                              height: 1.45,
                            ),
                          ),
                          if (item.resolvedAt != null) ...[
                            SizedBox(height: 10.h),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Icon(
                                  Icons.schedule_rounded,
                                  size: 11.sp,
                                  color: colors.textSecondary,
                                ),
                                SizedBox(width: 4.w),
                                Text(
                                  _formatDateTime(item.resolvedAt),
                                  style: textTheme.labelSmall?.copyWith(
                                    color: colors.textSecondary,
                                    fontSize: 10.sp,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ],
                      ),
                    ),
                    SizedBox(height: 16.h),
                  ],

                  // ── Report Details ──────────────────────────────────────────
                  Text(
                    'Informasi Masukan',
                    style: textTheme.titleSmall?.copyWith(
                      color: colors.textPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 10.h),

                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(14.w),
                    decoration: BoxDecoration(
                      color: colors.surface,
                      borderRadius: BorderRadius.circular(12.r),
                      border: Border.all(
                        color: colors.border.withValues(alpha: 0.6),
                        width: 0.8,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildDetailItem(
                          'Kategori',
                          _categoryLabel(item.category),
                          colors,
                          textTheme,
                        ),
                        SizedBox(height: 8.h),
                        _buildDetailItem(
                          'Judul',
                          item.title,
                          colors,
                          textTheme,
                        ),
                        SizedBox(height: 8.h),
                        _buildDetailItem(
                          'Waktu Dikirim',
                          _formatDateTime(item.createdAt),
                          colors,
                          textTheme,
                        ),
                        SizedBox(height: 12.h),
                        Text(
                          'Deskripsi:',
                          style: textTheme.labelMedium?.copyWith(
                            color: colors.textSecondary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          item.description,
                          style: textTheme.bodyMedium?.copyWith(
                            color: colors.textPrimary,
                            height: 1.45,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // ── Attachments (if any) ────────────────────────────────────
                  if (item.attachmentUrls.isNotEmpty) ...[
                    SizedBox(height: 16.h),
                    Text(
                      'Tangkapan Layar (${item.attachmentUrls.length})',
                      style: textTheme.titleSmall?.copyWith(
                        color: colors.textPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 10.h),
                    SizedBox(
                      height: 100.h,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        physics: const BouncingScrollPhysics(),
                        itemCount: item.attachmentUrls.length,
                        separatorBuilder: (context, index) => SizedBox(width: 8.w),
                        itemBuilder: (context, index) {
                          final url = item.attachmentUrls[index];
                          return GestureDetector(
                            onTap: () => _openImagePreview(context, url),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8.r),
                              child: Container(
                                width: 100.h,
                                height: 100.h,
                                decoration: BoxDecoration(
                                  color: colors.border.withValues(alpha: 0.3),
                                  border: Border.all(
                                    color: colors.border,
                                    width: 0.8,
                                  ),
                                ),
                                child: Image.network(
                                  url,
                                  fit: BoxFit.cover,
                                  loadingBuilder: (context, child, progress) {
                                    if (progress == null) return child;
                                    return Center(
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: colors.primary,
                                      ),
                                    );
                                  },
                                  errorBuilder: (context, error, stackTrace) => Icon(
                                    Icons.broken_image_rounded,
                                    color: colors.textSecondary,
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),

          SizedBox(height: 16.h),
          PrimaryButton(
            label: 'Tutup',
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailItem(
    String label,
    String value,
    AppColorSet colors,
    TextTheme textTheme,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 90.w,
          child: Text(
            label,
            style: textTheme.bodySmall?.copyWith(
              color: colors.textSecondary,
            ),
          ),
        ),
        Text(
          ': ',
          style: textTheme.bodySmall?.copyWith(
            color: colors.textSecondary,
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: textTheme.bodySmall?.copyWith(
              color: colors.textPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  void _openImagePreview(BuildContext context, String url) {
    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: EdgeInsets.all(12.w),
        child: Stack(
          alignment: Alignment.topRight,
          children: [
            InteractiveViewer(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12.r),
                child: Image.network(
                  url,
                  fit: BoxFit.contain,
                ),
              ),
            ),
            IconButton(
              icon: Container(
                padding: EdgeInsets.all(4.w),
                decoration: const BoxDecoration(
                  color: Colors.black54,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.close_rounded, color: Colors.white),
              ),
              onPressed: () => Navigator.of(ctx).pop(),
            ),
          ],
        ),
      ),
    );
  }
}
