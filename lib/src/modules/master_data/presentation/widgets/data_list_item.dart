import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_halaqoh/src/core/theme/app_colors.dart';

/// Reusable list item for Santri/Guru data lists
class DataListItem extends StatelessWidget {
  final String id;
  final String name;
  final String? badge;
  final Color? badgeColor;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final VoidCallback? onResetPassword;

  const DataListItem({
    super.key,
    required this.id,
    required this.name,
    this.badge,
    this.badgeColor,
    this.onEdit,
    this.onDelete,
    this.onResetPassword,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 16.w,
        vertical: 12.h,
      ),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: colors.border.withValues(alpha: 0.5),
            width: 0.5,
          ),
        ),
      ),
      child: Row(
        children: [
          // Identity column (ID + Name)
          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  id,
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w500,
                    color: colors.primary,
                    fontFamily: 'Poppins',
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  name,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: colors.textPrimary,
                    fontFamily: 'Poppins',
                  ),
                ),
              ],
            ),
          ),

          // Badge column (optional - for kelas)
          if (badge != null) ...[
            SizedBox(width: 8.w),
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: 10.w,
                vertical: 4.h,
              ),
              decoration: BoxDecoration(
                color: (badgeColor ?? colors.primary).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(6.r),
              ),
              child: Text(
                badge!,
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w600,
                  color: badgeColor ?? colors.primary,
                  fontFamily: 'Poppins',
                ),
              ),
            ),
          ],

          // Action buttons
          SizedBox(width: 8.w),
          GestureDetector(
            onTap: onEdit,
            child: Padding(
              padding: EdgeInsets.all(4.w),
              child: Icon(
                Icons.edit_outlined,
                size: 20.sp,
                color: colors.textSecondary,
              ),
            ),
          ),
          if (onResetPassword != null) ...[
            SizedBox(width: 4.w),
            GestureDetector(
              onTap: onResetPassword,
              child: Padding(
                padding: EdgeInsets.all(4.w),
                child: Icon(
                  Icons.lock_reset_outlined,
                  size: 20.sp,
                  color: colors.primary,
                ),
              ),
            ),
          ],
          SizedBox(width: 4.w),
          GestureDetector(
            onTap: onDelete,
            child: Padding(
              padding: EdgeInsets.all(4.w),
              child: Icon(
                Icons.delete_outlined,
                size: 20.sp,
                color: colors.textSecondary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
