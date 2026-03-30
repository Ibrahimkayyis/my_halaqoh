import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_halaqoh/gen/i18n/translations.g.dart';
import 'package:my_halaqoh/src/core/theme/app_colors.dart';
import 'package:my_halaqoh/src/core/widget/widgets.dart';

/// Dialog for bulk uploading data via Excel/CSV file
class BulkUploadDialog extends StatelessWidget {
  const BulkUploadDialog({super.key});

  static Future<void> show(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const BulkUploadDialog(),
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
        children: [
          // Title row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      t.addData.bulkTitle,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.w700,
                        color: colors.textPrimary,
                        fontFamily: 'Poppins',
                      ),
                    ),
                    SizedBox(height: 6.h),
                    Text(
                      t.addData.bulkSubtitle,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w400,
                        color: colors.textSecondary,
                        fontFamily: 'Poppins',
                      ),
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () => Navigator.of(context).pop(),
                child: Icon(
                  Icons.close,
                  color: colors.textSecondary,
                  size: 20.sp,
                ),
              ),
            ],
          ),
          SizedBox(height: 24.h),

          // Upload area (dashed border)
          GestureDetector(
            onTap: () {
              // TODO: File picker
            },
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 32.h),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(
                  color: colors.primary.withValues(alpha: 0.4),
                  width: 1.5,
                  strokeAlign: BorderSide.strokeAlignInside,
                ),
                color: colors.primary.withValues(alpha: 0.03),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Excel icon
                  Container(
                    width: 52.w,
                    height: 52.w,
                    decoration: BoxDecoration(
                      color: colors.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Center(
                      child: Icon(
                        Icons.table_chart,
                        color: colors.primary,
                        size: 28.sp,
                      ),
                    ),
                  ),
                  SizedBox(height: 14.h),
                  Text(
                    t.addData.bulkTapUpload,
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: colors.textPrimary,
                      fontFamily: 'Poppins',
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    t.addData.bulkFormat,
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
          ),
          SizedBox(height: 24.h),

          // Upload button
          PrimaryButton(
            width: double.infinity,
            onPressed: () {
              // TODO: Upload file
              Navigator.of(context).pop();
            },
            icon: Icons.cloud_upload,
            label: t.addData.bulkUploadButton,
            borderRadius: 25.r,
          ),
        ],
      ),
    );
  }
}
