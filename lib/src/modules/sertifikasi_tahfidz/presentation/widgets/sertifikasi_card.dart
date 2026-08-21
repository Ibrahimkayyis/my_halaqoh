import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_halaqoh/src/core/theme/app_colors.dart';
import 'package:my_halaqoh/src/modules/sertifikasi_tahfidz/domain/helpers/sertifikasi_status_helper.dart';
import 'package:my_halaqoh/src/modules/sertifikasi_tahfidz/domain/models/sertifikasi_model.dart';
import 'package:my_halaqoh/src/modules/sertifikasi_tahfidz/presentation/widgets/detail_sertifikasi_sheet.dart';

/// Clean list item displaying a single Tahfidz Certification entry.
/// Shows Santri Name, status badge, and chevron action button.
class SertifikasiCard extends StatelessWidget {
  final SertifikasiModel item;
  final VoidCallback? onTap;

  const SertifikasiCard({
    super.key,
    required this.item,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final textTheme = Theme.of(context).textTheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final statusBg = SertifikasiStatusHelper.getStatusBgColor(item.status, context);
    final statusFg = SertifikasiStatusHelper.getStatusFgColor(item.status, context);
    final statusIcon = SertifikasiStatusHelper.getStatusIcon(item.status);
    final statusLabel = SertifikasiStatusHelper.getStatusLabel(item.status);

    return Material(
      color: colors.surface,
      borderRadius: BorderRadius.circular(10.r),
      child: InkWell(
        onTap: onTap ?? () => DetailSertifikasiSheet.show(context, item),
        borderRadius: BorderRadius.circular(10.r),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.r),
            border: Border.all(
              color: isDark ? colors.border : colors.border.withValues(alpha: 0.6),
              width: 0.8,
            ),
          ),
          child: Row(
            children: [
              // Initial Avatar
              CircleAvatar(
                radius: 18.r,
                backgroundColor: colors.primary.withValues(alpha: 0.12),
                backgroundImage: item.profilePicture != null &&
                        item.profilePicture!.isNotEmpty
                    ? NetworkImage(item.profilePicture!)
                    : null,
                child: item.profilePicture == null ||
                        item.profilePicture!.isEmpty
                    ? Text(
                        item.santriNama.isNotEmpty
                            ? item.santriNama[0].toUpperCase()
                            : 'S',
                        style: textTheme.titleSmall?.copyWith(
                          color: colors.primary,
                          fontWeight: FontWeight.w700,
                        ),
                      )
                    : null,
              ),
              SizedBox(width: 12.w),

              // Santri Name & Juz
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.santriNama,
                      style: textTheme.titleSmall?.copyWith(
                        color: colors.textPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      'Juz ${item.juz} • Kelas ${item.kelas}',
                      style: textTheme.labelSmall?.copyWith(
                        color: colors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(width: 8.w),

              // Status Badge Pill
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 8.w,
                  vertical: 4.h,
                ),
                decoration: BoxDecoration(
                  color: statusBg,
                  borderRadius: BorderRadius.circular(6.r),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(statusIcon, size: 11.sp, color: statusFg),
                    SizedBox(width: 4.w),
                    Text(
                      statusLabel,
                      style: textTheme.labelSmall?.copyWith(
                        color: statusFg,
                        fontWeight: FontWeight.w600,
                        fontSize: 11.sp,
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(width: 4.w),

              // Chevron Action Button
              Icon(
                Icons.chevron_right_rounded,
                size: 20.sp,
                color: colors.textSecondary.withValues(alpha: 0.6),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
