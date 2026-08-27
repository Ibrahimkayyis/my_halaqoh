import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_halaqoh/src/modules/sertifikasi_tahfidz/domain/helpers/sertifikasi_status_helper.dart';
import 'package:my_halaqoh/src/modules/sertifikasi_tahfidz/domain/models/sertifikasi_model.dart';
import 'package:my_halaqoh/src/modules/sertifikasi_tahfidz/presentation/widgets/detail_sertifikasi_sheet.dart';

/// A tappable pill badge that displays the sertifikasi status of a specific juz.
///
/// Returns [SizedBox.shrink] when [item] is null.
/// Tapping opens [DetailSertifikasiSheet] to show full sertifikasi details.
class JuzSertifikasiBadge extends StatelessWidget {
  final SertifikasiModel? item;

  const JuzSertifikasiBadge({
    super.key,
    required this.item,
  });

  @override
  Widget build(BuildContext context) {
    if (item == null) return const SizedBox.shrink();

    final textTheme = Theme.of(context).textTheme;

    final bgColor = SertifikasiStatusHelper.getStatusBgColor(item!.status, context);
    final fgColor = SertifikasiStatusHelper.getStatusFgColor(item!.status, context);
    final icon = SertifikasiStatusHelper.getStatusIcon(item!.status);
    final label = SertifikasiStatusHelper.getStatusLabel(item!.status);

    return GestureDetector(
      onTap: () => DetailSertifikasiSheet.show(context, item!),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(6.r),
          border: Border.all(
            color: fgColor.withValues(alpha: 0.3),
            width: 0.8,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(icon, size: 12.sp, color: fgColor),
            SizedBox(width: 4.w),
            Flexible(
              child: Text(
                label,
                style: textTheme.labelSmall?.copyWith(
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w600,
                      color: fgColor,
                    ) ??
                    TextStyle(
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w600,
                      color: fgColor,
                      fontFamily: 'Poppins',
                    ),
                softWrap: false,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            SizedBox(width: 3.w),
            Icon(
              Icons.open_in_new_rounded,
              size: 10.sp,
              color: fgColor.withValues(alpha: 0.7),
            ),
          ],
        ),
      ),
    );
  }
}
