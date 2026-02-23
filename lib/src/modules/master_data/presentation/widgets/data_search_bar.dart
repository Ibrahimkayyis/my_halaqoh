import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_halaqoh/src/core/theme/app_colors.dart';

/// Reusable search bar with count badge and optional filter button
class DataSearchBar extends StatelessWidget {
  final String searchHint;
  final String countText;
  final String filterLabel;
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onFilterTap;
  final bool showFilterButton;

  const DataSearchBar({
    super.key,
    required this.searchHint,
    required this.countText,
    required this.filterLabel,
    this.controller,
    this.onChanged,
    this.onFilterTap,
    this.showFilterButton = true,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);

    return Column(
      children: [
        // Search field
        Container(
          margin: EdgeInsets.symmetric(horizontal: 16.w),
          decoration: BoxDecoration(
            color: colors.surface,
            borderRadius: BorderRadius.circular(12.r),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: TextField(
            controller: controller,
            onChanged: onChanged,
            style: TextStyle(
              fontSize: 14.sp,
              fontFamily: 'Poppins',
              color: colors.textPrimary,
            ),
            decoration: InputDecoration(
              hintText: searchHint,
              hintStyle: TextStyle(
                fontSize: 14.sp,
                color: colors.textSecondary.withValues(alpha: 0.6),
                fontFamily: 'Poppins',
              ),
              prefixIcon: Icon(
                Icons.search,
                color: colors.textSecondary,
                size: 20.sp,
              ),
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(
                horizontal: 16.w,
                vertical: 14.h,
              ),
            ),
          ),
        ),
        SizedBox(height: 12.h),

        // Count badge + Filter
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Count badge
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 12.w,
                  vertical: 6.h,
                ),
                decoration: BoxDecoration(
                  color: colors.surface,
                  borderRadius: BorderRadius.circular(20.r),
                  border: Border.all(
                    color: colors.border,
                    width: 1,
                  ),
                ),
                child: Text(
                  countText,
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w500,
                    color: colors.textPrimary,
                    fontFamily: 'Poppins',
                  ),
                ),
              ),
              // Filter button (conditionally shown)
              if (showFilterButton)
                GestureDetector(
                  onTap: onFilterTap,
                  child: Row(
                    children: [
                      Icon(
                        Icons.tune,
                        size: 18.sp,
                        color: colors.textPrimary,
                      ),
                      SizedBox(width: 4.w),
                      Text(
                        filterLabel,
                        style: TextStyle(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w500,
                          color: colors.textPrimary,
                          fontFamily: 'Poppins',
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}

