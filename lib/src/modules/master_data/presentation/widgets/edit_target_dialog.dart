import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_halaqoh/gen/i18n/translations.g.dart';
import 'package:my_halaqoh/src/core/theme/app_colors.dart';
import 'package:my_halaqoh/src/core/widget/widgets.dart';

/// Bottom sheet dialog for editing target hafalan per class
class EditTargetDialog extends StatefulWidget {
  final String kelasTitle;
  final String programLabel;
  final Set<int> initialSelectedJuz;
  final void Function(int target, String juzRange)? onSave;

  const EditTargetDialog({
    super.key,
    required this.kelasTitle,
    required this.programLabel,
    this.initialSelectedJuz = const {},
    this.onSave,
  });

  /// Show this dialog as a bottom sheet
  static Future<void> show(
    BuildContext context, {
    required String kelasTitle,
    required String programLabel,
    Set<int> initialSelectedJuz = const {},
    void Function(int target, String juzRange)? onSave,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => EditTargetDialog(
        kelasTitle: kelasTitle,
        programLabel: programLabel,
        initialSelectedJuz: initialSelectedJuz,
        onSave: onSave,
      ),
    );
  }

  @override
  State<EditTargetDialog> createState() => _EditTargetDialogState();
}

class _EditTargetDialogState extends State<EditTargetDialog> {
  late Set<int> _selectedJuz;
  String _selectedTahun = '2023 / 2024';

  final List<String> _tahunList = [
    '2022 / 2023',
    '2023 / 2024',
    '2024 / 2025',
    '2025 / 2026',
  ];

  @override
  void initState() {
    super.initState();
    _selectedJuz = Set<int>.from(widget.initialSelectedJuz);
  }

  void _toggleJuz(int juz) {
    setState(() {
      if (_selectedJuz.contains(juz)) {
        _selectedJuz.remove(juz);
      } else {
        _selectedJuz.add(juz);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);

    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.88,
      ),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.r),
          topRight: Radius.circular(20.r),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header
          Padding(
            padding: EdgeInsets.fromLTRB(20.w, 20.h, 12.w, 0),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    t.editTarget.title,
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w700,
                      color: colors.textPrimary,
                      fontFamily: 'Poppins',
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: Icon(
                    Icons.close,
                    color: colors.textSecondary,
                    size: 22.sp,
                  ),
                ),
              ],
            ),
          ),

          // Scrollable content
          Flexible(
            child: SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Badges
                  Row(
                    children: [
                      _buildBadge(
                        colors,
                        widget.kelasTitle,
                        colors.primary,
                        colors.textOnButton,
                        Icons.verified,
                      ),
                      SizedBox(width: 8.w),
                      _buildBadge(
                        colors,
                        widget.programLabel,
                        colors.border.withValues(alpha: 0.5),
                        colors.textSecondary,
                        Icons.auto_stories,
                      ),
                    ],
                  ),
                  SizedBox(height: 20.h),

                  // Tahun Ajaran
                  Text(
                    t.editTarget.tahunAjaran,
                    style: TextStyle(
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w600,
                      color: colors.textSecondary,
                      letterSpacing: 0.5,
                      fontFamily: 'Poppins',
                    ),
                  ),
                  SizedBox(height: 6.h),
                  CustomDropdown<String>(
                    hintText: 'Pilih Tahun Ajaran',
                    items: _tahunList,
                    initialItem: _selectedTahun,
                    onChanged: (v) {
                      if (v != null) setState(() => _selectedTahun = v);
                    },
                    closedHeaderPadding: EdgeInsets.symmetric(
                      horizontal: 14.w,
                      vertical: 12.h,
                    ),
                    decoration: CustomDropdownDecoration(
                      closedBorderRadius: BorderRadius.circular(10.r),
                      closedBorder: Border.all(color: colors.border),
                      closedFillColor: colors.surface,
                      expandedBorderRadius: BorderRadius.circular(10.r),
                      expandedBorder: Border.all(color: colors.primary),
                      expandedFillColor: colors.surface,
                      headerStyle: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        color: colors.textPrimary,
                        fontFamily: 'Poppins',
                      ),
                      hintStyle: TextStyle(
                        fontSize: 14.sp,
                        color: colors.textSecondary,
                        fontFamily: 'Poppins',
                      ),
                      listItemStyle: TextStyle(
                        fontSize: 14.sp,
                        color: colors.textPrimary,
                        fontFamily: 'Poppins',
                      ),
                    ),
                  ),
                  SizedBox(height: 20.h),

                  // Pilih Juz
                  Text(
                    t.editTarget.pilihJuz,
                    style: TextStyle(
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w600,
                      color: colors.textSecondary,
                      letterSpacing: 0.5,
                      fontFamily: 'Poppins',
                    ),
                  ),
                  SizedBox(height: 10.h),
                  _buildJuzGrid(colors),
                  SizedBox(height: 20.h),

                  // Total target card
                  _buildTotalCard(colors),
                  SizedBox(height: 16.h),
                ],
              ),
            ),
          ),

          // Save button
          Padding(
            padding: EdgeInsets.fromLTRB(20.w, 8.h, 20.w, 16.h),
            child: SafeArea(
              child: PrimaryButton(
                width: double.infinity,
                onPressed: () async {
                  final confirmed = await ConfirmSaveDialog.show(context);
                  if (!confirmed) return;

                  if (widget.onSave != null && _selectedJuz.isNotEmpty) {
                    // Calculate range string
                    final sorted = _selectedJuz.toList()..sort();
                    String juzRangeStr;
                    if (sorted.length == 1) {
                      juzRangeStr = '${sorted.first}';
                    } else {
                      // For simplicity, just show first and last.
                      // It handles wrapping correctly if UI enforces continuous selection.
                      juzRangeStr = '${sorted.first} - ${sorted.last}';
                    }
                    widget.onSave!(sorted.length, juzRangeStr);
                  }

                  if (context.mounted) {
                    Navigator.of(context).pop();
                  }
                },
                icon: Icons.save,
                label: t.editTarget.simpanPerubahan,
                borderRadius: 25.r,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBadge(
    AppColorSet colors,
    String label,
    Color bgColor,
    Color textColor,
    IconData icon,
  ) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14.sp, color: textColor),
          SizedBox(width: 6.w),
          Text(
            label,
            style: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.w600,
              color: textColor,
              fontFamily: 'Poppins',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildJuzGrid(AppColorSet colors) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 6,
        crossAxisSpacing: 8.w,
        mainAxisSpacing: 8.h,
        childAspectRatio: 1.0,
      ),
      itemCount: 30,
      itemBuilder: (context, index) {
        final juz = index + 1;
        final isSelected = _selectedJuz.contains(juz);

        return GestureDetector(
          onTap: () => _toggleJuz(juz),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            decoration: BoxDecoration(
              color: isSelected ? colors.primary : Colors.transparent,
              shape: BoxShape.circle,
              border: Border.all(
                color: isSelected ? colors.primary : colors.border,
                width: 1.5,
              ),
            ),
            child: Center(
              child: Text(
                '$juz',
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                  color: isSelected
                      ? colors.textOnButton
                      : colors.textSecondary,
                  fontFamily: 'Poppins',
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildTotalCard(AppColorSet colors) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 16.h),
      decoration: BoxDecoration(
        color: colors.primary.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(14.r),
      ),
      child: Column(
        children: [
          Text(
            t.editTarget.totalTarget,
            style: TextStyle(
              fontSize: 11.sp,
              fontWeight: FontWeight.w600,
              color: colors.textSecondary,
              letterSpacing: 0.5,
              fontFamily: 'Poppins',
            ),
          ),
          SizedBox(height: 4.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.verified, size: 22.sp, color: colors.primary),
              SizedBox(width: 8.w),
              Text(
                t.editTarget.totalJuz(count: _selectedJuz.length.toString()),
                style: TextStyle(
                  fontSize: 26.sp,
                  fontWeight: FontWeight.w800,
                  color: colors.primary,
                  fontFamily: 'Poppins',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
