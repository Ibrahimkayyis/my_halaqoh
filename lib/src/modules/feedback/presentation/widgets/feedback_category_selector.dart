import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_halaqoh/gen/i18n/translations.g.dart';
import 'package:my_halaqoh/src/core/theme/app_colors.dart';

/// Data object defining a feedback category option.
class _CategoryItem {
  final String key;
  final String label;
  final IconData icon;

  const _CategoryItem({
    required this.key,
    required this.label,
    required this.icon,
  });
}

/// Selector allowing users to choose the category of feedback:
/// Bug, Saran, or Pertanyaan.
///
/// Refined with strict adherence to MyHalaqoh Design System (MASTER.md) & ui-ux-pro-max:
/// - Ergonomic touch target (minHeight: 46.h ~ 48dp).
/// - Standard radius.sm (8.r).
/// - FittedBox prevents text clipping or truncation on all mobile screen widths.
/// - Calibrated subtle semantic tints (Bug: red, Saran: primary, Pertanyaan: blue).
class FeedbackCategorySelector extends StatelessWidget {
  final String selectedCategory;
  final ValueChanged<String> onSelected;

  const FeedbackCategorySelector({
    super.key,
    required this.selectedCategory,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final fb = t.feedback;

    final items = [
      _CategoryItem(
        key: 'bug',
        label: fb.bug,
        icon: Icons.bug_report_outlined,
      ),
      _CategoryItem(
        key: 'saran',
        label: fb.saran,
        icon: Icons.lightbulb_outline,
      ),
      _CategoryItem(
        key: 'pertanyaan',
        label: fb.pertanyaan,
        icon: Icons.help_outline_rounded,
      ),
    ];

    return Row(
      children: items.map((item) {
        final isSelected = selectedCategory == item.key;

        // Subtle semantic accent per category
        Color activeColor;
        switch (item.key) {
          case 'bug':
            activeColor = colors.red;
            break;
          case 'saran':
            activeColor = colors.primary;
            break;
          case 'pertanyaan':
            activeColor = colors.blue;
            break;
          default:
            activeColor = colors.primary;
        }

        return Expanded(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 4.w),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () => onSelected(item.key),
                borderRadius: BorderRadius.circular(8.r),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  curve: Curves.easeInOut,
                  constraints: BoxConstraints(minHeight: 46.h),
                  padding: EdgeInsets.symmetric(
                    horizontal: 6.w,
                    vertical: 8.h,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? activeColor.withValues(alpha: isDark ? 0.18 : 0.08)
                        : colors.surface,
                    borderRadius: BorderRadius.circular(8.r),
                    border: Border.all(
                      color: isSelected
                          ? activeColor
                          : (isDark
                              ? colors.border
                              : colors.border.withValues(alpha: 0.8)),
                      width: isSelected ? 1.4 : 1.0,
                    ),
                    boxShadow: isSelected && !isDark
                        ? [
                            BoxShadow(
                              color: activeColor.withValues(alpha: 0.10),
                              blurRadius: 6,
                              offset: const Offset(0, 2),
                            ),
                          ]
                        : (!isDark
                            ? [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.02),
                                  blurRadius: 4,
                                  offset: const Offset(0, 1),
                                ),
                              ]
                            : null),
                  ),
                  child: Center(
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            item.icon,
                            size: 18.sp,
                            color: isSelected ? activeColor : colors.textSecondary,
                          ),
                          SizedBox(width: 6.w),
                          Text(
                            item.label,
                            style: TextStyle(
                              fontSize: 12.sp,
                              fontWeight: isSelected
                                  ? FontWeight.w600
                                  : FontWeight.w500,
                              color:
                                  isSelected ? activeColor : colors.textPrimary,
                              fontFamily: 'Poppins',
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
