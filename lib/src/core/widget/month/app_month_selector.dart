import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_halaqoh/src/core/theme/app_colors.dart';

/// Global reusable month selector widget with prev/next arrows.
///
/// Usage:
/// ```dart
/// AppMonthSelector(
///   month: _currentMonth,
///   year: _currentYear,
///   onPrev: _prevMonth,
///   onNext: _nextMonth,
/// )
/// ```
class AppMonthSelector extends StatelessWidget {
  final int month;
  final int year;
  final VoidCallback onPrev;
  final VoidCallback onNext;

  static const List<String> _monthNames = [
    'Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni',
    'Juli', 'Agustus', 'September', 'Oktober', 'November', 'Desember',
  ];

  const AppMonthSelector({
    super.key,
    required this.month,
    required this.year,
    required this.onPrev,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: colors.border, width: 1),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: onPrev,
            child: Icon(Icons.chevron_left,
                color: colors.primary, size: 24.sp),
          ),
          Text(
            '${_monthNames[month - 1]} $year',
            style: TextStyle(
              fontSize: 15.sp,
              fontWeight: FontWeight.w700,
              color: colors.textPrimary,
              fontFamily: 'Poppins',
            ),
          ),
          GestureDetector(
            onTap: onNext,
            child: Icon(Icons.chevron_right,
                color: colors.primary, size: 24.sp),
          ),
        ],
      ),
    );
  }
}