import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_halaqoh/src/core/theme/app_colors.dart';

/// Global reusable calendar picker button.
/// Shows an icon button that opens a month/year picker dialog.
///
/// Usage:
/// ```dart
/// AppCalendarPickerButton(
///   currentMonth: _currentMonth,
///   currentYear: _currentYear,
///   onSelected: (month, year) {
///     setState(() {
///       _currentMonth = month;
///       _currentYear = year;
///     });
///   },
/// )
/// ```
class AppCalendarPickerButton extends StatelessWidget {
  final int currentMonth;
  final int currentYear;

  /// Called when user selects a month from the dialog.
  /// Provides the selected [month] (1–12) and [year].
  final void Function(int month, int year) onSelected;

  static const List<String> _monthNames = [
    'Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni',
    'Juli', 'Agustus', 'September', 'Oktober', 'November', 'Desember',
  ];

  const AppCalendarPickerButton({
    super.key,
    required this.currentMonth,
    required this.currentYear,
    required this.onSelected,
  });

  Future<void> _showPicker(BuildContext context, AppColorSet colors) async {
    int pickerYear = currentYear;

    await showDialog<void>(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (ctx, setDialogState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.r)),
              contentPadding:
                  EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 16.h),
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: () =>
                        setDialogState(() => pickerYear--),
                    icon: Icon(Icons.chevron_left,
                        color: colors.primary, size: 24.sp),
                  ),
                  Text(
                    '$pickerYear',
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w700,
                      fontFamily: 'Poppins',
                      color: colors.textPrimary,
                    ),
                  ),
                  IconButton(
                    onPressed: () =>
                        setDialogState(() => pickerYear++),
                    icon: Icon(Icons.chevron_right,
                        color: colors.primary, size: 24.sp),
                  ),
                ],
              ),
              content: SizedBox(
                width: double.maxFinite,
                child: GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate:
                      const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    mainAxisSpacing: 8,
                    crossAxisSpacing: 8,
                    childAspectRatio: 2.2,
                  ),
                  itemCount: 12,
                  itemBuilder: (_, idx) {
                    final m = idx + 1;
                    final isSelected = m == currentMonth &&
                        pickerYear == currentYear;
                    return GestureDetector(
                      onTap: () {
                        Navigator.pop(ctx);
                        onSelected(m, pickerYear);
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 150),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? colors.primary
                              : colors.primary.withValues(alpha: 0.06),
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          _monthNames[idx].substring(0, 3),
                          style: TextStyle(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'Poppins',
                            color: isSelected
                                ? Colors.white
                                : colors.textPrimary,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);

    return GestureDetector(
      onTap: () => _showPicker(context, colors),
      child: Container(
        width: 40.w,
        height: 40.w,
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: colors.border, width: 1),
        ),
        child: Icon(
          Icons.calendar_month,
          size: 20.sp,
          color: colors.primary,
        ),
      ),
    );
  }
}