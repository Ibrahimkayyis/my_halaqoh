import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_halaqoh/gen/i18n/translations.g.dart';
import 'package:my_halaqoh/src/core/theme/app_colors.dart';

/// Dialog to choose between manual input or bulk upload
class AddDataMethodDialog extends StatelessWidget {
  final VoidCallback onManualTap;
  final VoidCallback onBulkUploadTap;

  const AddDataMethodDialog({
    super.key,
    required this.onManualTap,
    required this.onBulkUploadTap,
  });

  static Future<void> show(
    BuildContext context, {
    required VoidCallback onManualTap,
    required VoidCallback onBulkUploadTap,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => AddDataMethodDialog(
        onManualTap: onManualTap,
        onBulkUploadTap: onBulkUploadTap,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);

    return Container(
      padding: EdgeInsets.only(
        top: 24.h,
        left: 24.w,
        right: 24.w,
        bottom: MediaQuery.of(context).padding.bottom + 24.h,
      ),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24.r),
          topRight: Radius.circular(24.r),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                t.addData.title,
                style: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w700,
                  color: colors.textPrimary,
                  fontFamily: 'Poppins',
                ),
              ),
              GestureDetector(
                onTap: () => Navigator.of(context).pop(),
                child: Icon(
                  Icons.close,
                  color: colors.textSecondary,
                  size: 22.sp,
                ),
              ),
            ],
          ),
          SizedBox(height: 4.h),
          Text(
            t.addData.subtitle,
            style: TextStyle(
              fontSize: 13.sp,
              fontWeight: FontWeight.w400,
              color: colors.textSecondary,
              fontFamily: 'Poppins',
            ),
          ),
          SizedBox(height: 20.h),

          // Input Manual option
          _buildOptionCard(
            context: context,
            colors: colors,
            icon: Icons.edit,
            title: t.addData.inputManual,
            subtitle: t.addData.inputManualDesc,
            onTap: () {
              Navigator.of(context).pop();
              onManualTap();
            },
          ),
          SizedBox(height: 12.h),

          // Upload Excel option
          _buildOptionCard(
            context: context,
            colors: colors,
            icon: Icons.description,
            title: t.addData.uploadExcel,
            subtitle: t.addData.uploadExcelDesc,
            onTap: () {
              Navigator.of(context).pop();
              onBulkUploadTap();
            },
          ),
        ],
      ),
    );
  }

  Widget _buildOptionCard({
    required BuildContext context,
    required AppColorSet colors,
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: 16.w,
          vertical: 16.h,
        ),
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: colors.border,
            width: 1,
          ),
        ),
        child: Row(
          children: [
            // Icon circle
            Container(
              width: 42.w,
              height: 42.w,
              decoration: BoxDecoration(
                color: colors.primary.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Icon(
                  icon,
                  color: colors.primary,
                  size: 20.sp,
                ),
              ),
            ),
            SizedBox(width: 14.w),
            // Text
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: colors.textPrimary,
                      fontFamily: 'Poppins',
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    subtitle,
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
            // Chevron
            Icon(
              Icons.chevron_right,
              color: colors.textSecondary,
              size: 20.sp,
            ),
          ],
        ),
      ),
    );
  }
}
