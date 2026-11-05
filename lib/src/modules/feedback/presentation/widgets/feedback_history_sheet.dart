import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:my_halaqoh/src/core/service_locator/service_locator.dart';
import 'package:my_halaqoh/src/core/theme/app_colors.dart';
import '../../domain/models/feedback_model.dart';
import '../../domain/repositories/feedback_repository.dart';
import 'detail_feedback_sheet.dart';

/// Modal bottom sheet displaying history of feedback submitted by the user.
class FeedbackHistorySheet extends StatefulWidget {
  final String userId;

  const FeedbackHistorySheet({super.key, required this.userId});

  static Future<void> show(BuildContext context, String userId) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => FeedbackHistorySheet(userId: userId),
    );
  }

  @override
  State<FeedbackHistorySheet> createState() => _FeedbackHistorySheetState();
}

class _FeedbackHistorySheetState extends State<FeedbackHistorySheet> {
  late Future<List<FeedbackModel>> _feedbackFuture;

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  void _loadHistory() {
    _feedbackFuture = sl<FeedbackRepository>().getFeedbackByUserId(widget.userId);
  }

  String _formatDate(DateTime? dt) {
    if (dt == null) return '-';
    return DateFormat('d MMM yyyy, HH:mm', 'id_ID').format(dt);
  }

  String _categoryLabel(String category) {
    switch (category.toLowerCase()) {
      case 'bug':
        return 'Bug';
      case 'saran':
        return 'Saran';
      case 'pertanyaan':
        return 'Tanya';
      default:
        return 'Masukan';
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final textTheme = Theme.of(context).textTheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.85,
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

          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Riwayat Masukan Anda',
                style: textTheme.titleLarge?.copyWith(
                  color: colors.textPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              IconButton(
                icon: Icon(
                  Icons.close_rounded,
                  size: 20.sp,
                  color: colors.textSecondary,
                ),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
          SizedBox(height: 12.h),

          Flexible(
            child: FutureBuilder<List<FeedbackModel>>(
              future: _feedbackFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: Padding(
                      padding: EdgeInsets.all(32.w),
                      child: CircularProgressIndicator(
                        strokeWidth: 2.5,
                        color: colors.primary,
                      ),
                    ),
                  );
                }

                if (snapshot.hasError) {
                  return Center(
                    child: Padding(
                      padding: EdgeInsets.all(24.w),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.error_outline_rounded,
                            size: 36.sp,
                            color: colors.error,
                          ),
                          SizedBox(height: 12.h),
                          Text(
                            'Gagal memuat riwayat masukan.',
                            style: textTheme.bodyMedium?.copyWith(
                              color: colors.textSecondary,
                            ),
                          ),
                          SizedBox(height: 12.h),
                          TextButton(
                            onPressed: () => setState(_loadHistory),
                            child: const Text('Coba Lagi'),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                final items = snapshot.data ?? [];
                if (items.isEmpty) {
                  return Center(
                    child: Padding(
                      padding: EdgeInsets.all(32.w),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 60.w,
                            height: 60.w,
                            decoration: BoxDecoration(
                              color: colors.primary.withValues(alpha: 0.08),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.inbox_rounded,
                              size: 28.sp,
                              color: colors.primary,
                            ),
                          ),
                          SizedBox(height: 14.h),
                          Text(
                            'Belum Ada Riwayat',
                            style: textTheme.titleMedium?.copyWith(
                              color: colors.textPrimary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(height: 4.h),
                          Text(
                            'Masukan atau saran yang Anda kirimkan akan muncul di sini.',
                            textAlign: TextAlign.center,
                            style: textTheme.bodySmall?.copyWith(
                              color: colors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                return ListView.separated(
                  physics: const BouncingScrollPhysics(),
                  itemCount: items.length,
                  separatorBuilder: (context, index) => SizedBox(height: 10.h),
                  itemBuilder: (context, index) {
                    final item = items[index];
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
                        ? 'Selesai'
                        : isInProgress
                            ? 'Diproses'
                            : 'Terkirim';

                    return Material(
                      color: colors.surface,
                      borderRadius: BorderRadius.circular(12.r),
                      child: InkWell(
                        onTap: () {
                          DetailFeedbackSheet.show(context, item);
                        },
                        borderRadius: BorderRadius.circular(12.r),
                        child: Container(
                          padding: EdgeInsets.all(12.w),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12.r),
                            border: Border.all(
                              color: isDark
                                  ? colors.border
                                  : colors.border.withValues(alpha: 0.6),
                              width: 0.8,
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  // Category badge
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 6.w,
                                      vertical: 2.h,
                                    ),
                                    decoration: BoxDecoration(
                                      color: colors.primary.withValues(alpha: 0.1),
                                      borderRadius: BorderRadius.circular(4.r),
                                    ),
                                    child: Text(
                                      _categoryLabel(item.category),
                                      style: textTheme.labelSmall?.copyWith(
                                        color: colors.primary,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 10.sp,
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 8.w),
                                  Expanded(
                                    child: Text(
                                      _formatDate(item.createdAt),
                                      style: textTheme.labelSmall?.copyWith(
                                        color: colors.textSecondary,
                                        fontSize: 10.sp,
                                      ),
                                    ),
                                  ),
                                  // Status pill
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 8.w,
                                      vertical: 2.h,
                                    ),
                                    decoration: BoxDecoration(
                                      color: statusBg,
                                      borderRadius: BorderRadius.circular(6.r),
                                    ),
                                    child: Text(
                                      statusLabel,
                                      style: textTheme.labelSmall?.copyWith(
                                        color: statusFg,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 10.sp,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 8.h),
                              Text(
                                item.title,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: textTheme.bodyMedium?.copyWith(
                                  color: colors.textPrimary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              SizedBox(height: 4.h),
                              Text(
                                item.description,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: textTheme.bodySmall?.copyWith(
                                  color: colors.textSecondary,
                                  height: 1.4,
                                ),
                              ),
                              if (isResolved &&
                                  item.adminResponse != null &&
                                  item.adminResponse!.trim().isNotEmpty) ...[
                                SizedBox(height: 8.h),
                                Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 8.w,
                                    vertical: 6.h,
                                  ),
                                  decoration: BoxDecoration(
                                    color: colors.primary.withValues(alpha: 0.06),
                                    borderRadius: BorderRadius.circular(6.r),
                                  ),
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.reply_rounded,
                                        size: 14.sp,
                                        color: colors.primary,
                                      ),
                                      SizedBox(width: 6.w),
                                      Expanded(
                                        child: Text(
                                          item.adminResponse!,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: textTheme.bodySmall?.copyWith(
                                            color: colors.primary,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 11.sp,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
