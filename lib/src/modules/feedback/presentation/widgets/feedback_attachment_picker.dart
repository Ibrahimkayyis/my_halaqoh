import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:my_halaqoh/gen/i18n/translations.g.dart';
import 'package:my_halaqoh/src/core/theme/app_colors.dart';

/// Widget that allows users to pick and preview up to 3 screenshot attachments.
/// Conforms to MASTER.md design tokens and ui-ux-pro-max guidelines.
class FeedbackAttachmentPicker extends StatelessWidget {
  final List<String> filePaths;
  final ValueChanged<List<String>> onChanged;
  final int maxPhotos;

  const FeedbackAttachmentPicker({
    super.key,
    required this.filePaths,
    required this.onChanged,
    this.maxPhotos = 3,
  });

  Future<void> _pickImage(BuildContext context, ImageSource source) async {
    if (filePaths.length >= maxPhotos) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(t.feedback.maxFoto, style: const TextStyle(fontFamily: 'Poppins')),
          backgroundColor: AppColors.of(context).warning,
        ),
      );
      return;
    }

    try {
      final picker = ImagePicker();
      final picked = await picker.pickImage(
        source: source,
        maxWidth: 1920,
        maxHeight: 1920,
        imageQuality: 80,
      );

      if (picked != null) {
        final updated = List<String>.from(filePaths)..add(picked.path);
        onChanged(updated);
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal memilih foto: $e', style: const TextStyle(fontFamily: 'Poppins')),
            backgroundColor: AppColors.of(context).error,
          ),
        );
      }
    }
  }

  void _showSourceModal(BuildContext context) {
    final colors = AppColors.of(context);
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: colors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40.w,
                height: 4.h,
                decoration: BoxDecoration(
                  color: colors.border,
                  borderRadius: BorderRadius.circular(4.r),
                ),
              ),
              SizedBox(height: 16.h),
              Text(
                t.feedback.tambahFoto,
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: colors.textPrimary,
                  fontFamily: 'Poppins',
                ),
              ),
              SizedBox(height: 16.h),
              ListTile(
                leading: Container(
                  padding: EdgeInsets.all(8.w),
                  decoration: BoxDecoration(
                    color: colors.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Icon(Icons.photo_library_outlined, color: colors.primary),
                ),
                title: Text(
                  'Galeri Foto',
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                    color: colors.textPrimary,
                    fontFamily: 'Poppins',
                  ),
                ),
                onTap: () {
                  Navigator.pop(ctx);
                  _pickImage(context, ImageSource.gallery);
                },
              ),
              ListTile(
                leading: Container(
                  padding: EdgeInsets.all(8.w),
                  decoration: BoxDecoration(
                    color: colors.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Icon(Icons.camera_alt_outlined, color: colors.primary),
                ),
                title: Text(
                  'Kamera',
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                    color: colors.textPrimary,
                    fontFamily: 'Poppins',
                  ),
                ),
                onTap: () {
                  Navigator.pop(ctx);
                  _pickImage(context, ImageSource.camera);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showPreviewDialog(BuildContext context, String path, int index) {
    showDialog<void>(
      context: context,
      builder: (ctx) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 24.h),
        child: Stack(
          alignment: Alignment.topRight,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(16.r),
              child: Image.file(
                File(path),
                fit: BoxFit.contain,
              ),
            ),
            Positioned(
              top: 12.h,
              right: 12.w,
              child: GestureDetector(
                onTap: () => Navigator.pop(ctx),
                child: Container(
                  padding: EdgeInsets.all(6.w),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.7),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.close_rounded,
                    size: 20.sp,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _removeAt(int index) {
    final updated = List<String>.from(filePaths)..removeAt(index);
    onChanged(updated);
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final canAddMore = filePaths.length < maxPhotos;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              t.feedback.lampiran,
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                color: colors.textPrimary,
                fontFamily: 'Poppins',
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
              decoration: BoxDecoration(
                color: colors.primary.withValues(alpha: isDark ? 0.2 : 0.08),
                borderRadius: BorderRadius.circular(6.r),
              ),
              child: Text(
                '${filePaths.length}/$maxPhotos',
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w600,
                  color: colors.primary,
                  fontFamily: 'Poppins',
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 4.h),
        Text(
          t.feedback.lampiranDesc,
          style: TextStyle(
            fontSize: 11.sp,
            color: colors.textSecondary,
            fontFamily: 'Poppins',
          ),
        ),
        SizedBox(height: 12.h),
        SizedBox(
          height: 84.h,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: filePaths.length + (canAddMore ? 1 : 0),
            separatorBuilder: (context, index) => SizedBox(width: 10.w),
            itemBuilder: (context, index) {
              if (index < filePaths.length) {
                return _buildThumbnail(context, filePaths[index], index, colors, isDark);
              }
              return _buildAddButton(context, colors, isDark);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildThumbnail(
    BuildContext context,
    String path,
    int index,
    AppColorSet colors,
    bool isDark,
  ) {
    return GestureDetector(
      onTap: () => _showPreviewDialog(context, path, index),
      child: Stack(
        children: [
          Container(
            width: 84.w,
            height: 84.h,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(
                color: isDark ? colors.border : colors.border.withValues(alpha: 0.8),
              ),
              boxShadow: !isDark
                  ? [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.04),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ]
                  : null,
              image: DecorationImage(
                image: FileImage(File(path)),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Positioned(
            top: 4.h,
            right: 4.w,
            child: GestureDetector(
              onTap: () => _removeAt(index),
              child: Container(
                padding: EdgeInsets.all(4.w),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.65),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.close_rounded,
                  size: 13.sp,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddButton(BuildContext context, AppColorSet colors, bool isDark) {
    return InkWell(
      onTap: () => _showSourceModal(context),
      borderRadius: BorderRadius.circular(12.r),
      child: Container(
        width: 84.w,
        height: 84.h,
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: colors.primary.withValues(alpha: 0.35),
            width: 1.2,
          ),
          boxShadow: !isDark
              ? [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.02),
                    blurRadius: 4,
                    offset: const Offset(0, 1),
                  ),
                ]
              : null,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(6.w),
              decoration: BoxDecoration(
                color: colors.primary.withValues(alpha: isDark ? 0.2 : 0.08),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.add_a_photo_outlined,
                size: 18.sp,
                color: colors.primary,
              ),
            ),
            SizedBox(height: 5.h),
            Text(
              t.feedback.tambahFoto,
              style: TextStyle(
                fontSize: 10.sp,
                fontWeight: FontWeight.w600,
                color: colors.primary,
                fontFamily: 'Poppins',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
