import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_halaqoh/src/core/theme/app_colors.dart';

/// A clean squircle quick action button with primary color branding
/// inspired by Wondr by BNI's "Fitur pilihan kamu" grid.
class QuickActionItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback? onTap;

  const QuickActionItem({
    super.key,
    required this.icon,
    required this.label,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final textTheme = Theme.of(context).textTheme;

    return Expanded(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Material(
            color: colors.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(16.r),
            child: InkWell(
              onTap: onTap,
              borderRadius: BorderRadius.circular(16.r),
              splashColor: colors.primary.withValues(alpha: 0.15),
              highlightColor: colors.primary.withValues(alpha: 0.08),
              child: Container(
                width: 52.w,
                height: 52.w,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16.r),
                  border: Border.all(
                    color: colors.primary.withValues(alpha: 0.2),
                    width: 1,
                  ),
                ),
                alignment: Alignment.center,
                child: Icon(
                  icon,
                  size: 24.sp,
                  color: colors.primary,
                ),
              ),
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            label,
            textAlign: TextAlign.center,
            style: textTheme.bodySmall?.copyWith(
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w500,
                  color: colors.textPrimary,
                  height: 1.2,
                ) ??
                TextStyle(
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w500,
                  color: colors.textPrimary,
                  fontFamily: 'Poppins',
                  height: 1.2,
                ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
