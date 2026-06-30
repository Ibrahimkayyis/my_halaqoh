import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_halaqoh/src/core/theme/app_colors.dart';
import 'package:my_halaqoh/src/modules/master_data/domain/models/guru_model.dart';

/// List tile for displaying a [GuruModel] in the guru picker screen.
class GuruPickerTile extends StatelessWidget {
  const GuruPickerTile({
    super.key,
    required this.guru,
    required this.onTap,
  });

  final GuruModel guru;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final isTakhassus = guru.program == 'T';
    final programLabel = isTakhassus ? 'Takhassus' : 'Reguler';
    final accentColor = isTakhassus ? colors.primary : colors.blue;
    final programBg = accentColor.withValues(alpha: 0.08);
    final programBorder = accentColor.withValues(alpha: 0.25);

    return Container(
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          child: IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Left vertical accent strip (stretches dynamically based on card height)
                Container(
                  width: 6.w,
                  color: accentColor,
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Avatar placeholder (Person Icon inside rounded square)
                        Container(
                          width: 44.w,
                          height: 44.w,
                          decoration: BoxDecoration(
                            color: colors.primary.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          child: Icon(
                            Icons.person_rounded,
                            color: colors.primary,
                            size: 22.sp,
                          ),
                        ),
                        SizedBox(width: 14.w),
                        // Info (Name & NIP)
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                guru.nama.toUpperCase(),
                                style: TextStyle(
                                  fontSize: 13.5.sp,
                                  fontWeight: FontWeight.w700,
                                  color: colors.textPrimary,
                                  fontFamily: 'Poppins',
                                ),
                                maxLines: 3, // Allow name to wrap up to 3 lines
                                overflow: TextOverflow.ellipsis,
                              ),
                              SizedBox(height: 2.h),
                              Text(
                                guru.nip,
                                style: TextStyle(
                                  fontSize: 11.5.sp,
                                  color: colors.textSecondary,
                                  fontFamily: 'Poppins',
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: 8.w),
                        // Right side: Program badge & chevron
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                              decoration: BoxDecoration(
                                color: programBg,
                                borderRadius: BorderRadius.circular(8.r),
                                border: Border.all(color: programBorder),
                              ),
                              child: Text(
                                programLabel,
                                style: TextStyle(
                                  fontSize: 10.sp,
                                  fontWeight: FontWeight.w600,
                                  color: accentColor,
                                  fontFamily: 'Poppins',
                                ),
                              ),
                            ),
                            SizedBox(height: 8.h),
                            Icon(
                              Icons.chevron_right_rounded,
                              size: 18.sp,
                              color: colors.textSecondary.withValues(alpha: 0.4),
                            ),
                          ],
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
}
