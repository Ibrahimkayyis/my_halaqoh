import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_halaqoh/src/core/theme/app_colors.dart';

/// 4-Column Action Bar for main daily features: Absensi, Hafalan, Halaqoh, and Sertifikasi.
/// Separated with elegant vertical dividers and primary themed icon boxes.
class DashboardActionBar extends StatelessWidget {
  final VoidCallback onAbsensiTap;
  final VoidCallback onHafalanTap;
  final VoidCallback onHalaqohTap;
  final VoidCallback onSertifikasiTap;

  const DashboardActionBar({
    super.key,
    required this.onAbsensiTap,
    required this.onHafalanTap,
    required this.onHalaqohTap,
    required this.onSertifikasiTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final textTheme = Theme.of(context).textTheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20.w),
      padding: EdgeInsets.symmetric(vertical: 14.h, horizontal: 4.w),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(18.r),
        border: Border.all(
          color: isDark
              ? colors.border
              : colors.border.withValues(alpha: 0.7),
          width: 0.8,
        ),
        boxShadow: isDark
            ? []
            : [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.03),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
      ),
      child: Row(
        children: [
          // 1. Absensi
          _buildActionItem(
            context: context,
            icon: Icons.event_available_rounded,
            label: 'Absensi',
            onTap: onAbsensiTap,
            colors: colors,
            textTheme: textTheme,
          ),

          // Vertical Divider
          Container(
            width: 1,
            height: 38.h,
            color: colors.border.withValues(alpha: 0.6),
          ),

          // 2. Hafalan
          _buildActionItem(
            context: context,
            icon: Icons.menu_book_rounded,
            label: 'Setoran',
            onTap: onHafalanTap,
            colors: colors,
            textTheme: textTheme,
          ),

          // Vertical Divider
          Container(
            width: 1,
            height: 38.h,
            color: colors.border.withValues(alpha: 0.6),
          ),

          // 3. Halaqoh
          _buildActionItem(
            context: context,
            icon: Icons.groups_rounded,
            label: 'Halaqoh',
            onTap: onHalaqohTap,
            colors: colors,
            textTheme: textTheme,
          ),

          // Vertical Divider
          Container(
            width: 1,
            height: 38.h,
            color: colors.border.withValues(alpha: 0.6),
          ),

          // 4. Sertifikasi
          _buildActionItem(
            context: context,
            icon: Icons.workspace_premium_rounded,
            label: 'Sertifikasi',
            onTap: onSertifikasiTap,
            colors: colors,
            textTheme: textTheme,
          ),
        ],
      ),
    );
  }

  Widget _buildActionItem({
    required BuildContext context,
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    required AppColorSet colors,
    required TextTheme textTheme,
  }) {
    return Expanded(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12.r),
          splashColor: colors.primary.withValues(alpha: 0.1),
          highlightColor: colors.primary.withValues(alpha: 0.05),
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 4.h),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 44.w,
                  height: 44.w,
                  decoration: BoxDecoration(
                    color: colors.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(
                      color: colors.primary.withValues(alpha: 0.2),
                      width: 1,
                    ),
                  ),
                  alignment: Alignment.center,
                  child: Icon(
                    icon,
                    size: 22.sp,
                    color: colors.primary,
                  ),
                ),
                SizedBox(height: 8.h),
                Text(
                  label,
                  style: textTheme.bodySmall?.copyWith(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w600,
                        color: colors.textPrimary,
                      ) ??
                      TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w600,
                        color: colors.textPrimary,
                        fontFamily: 'Poppins',
                      ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
