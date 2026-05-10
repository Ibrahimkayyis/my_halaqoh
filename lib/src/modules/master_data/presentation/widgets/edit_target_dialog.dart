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
  final int? initialSemesterAktif;
  final String? initialTahunAjaran;
  final void Function(int? semesterAktif, String tahunAjaran)? onSave;

  const EditTargetDialog({
    super.key,
    required this.kelasTitle,
    required this.programLabel,
    this.initialSemesterAktif,
    this.initialTahunAjaran,
    this.onSave,
  });

  /// Show this dialog as a bottom sheet
  static Future<void> show(
    BuildContext context, {
    required String kelasTitle,
    required String programLabel,
    int? initialSemesterAktif,
    String? initialTahunAjaran,
    void Function(int? semesterAktif, String tahunAjaran)? onSave,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => EditTargetDialog(
        kelasTitle: kelasTitle,
        programLabel: programLabel,
        initialSemesterAktif: initialSemesterAktif,
        initialTahunAjaran: initialTahunAjaran,
        onSave: onSave,
      ),
    );
  }

  @override
  State<EditTargetDialog> createState() => _EditTargetDialogState();
}

class _EditTargetDialogState extends State<EditTargetDialog> {
  late String _selectedTahun;
  late List<String> _tahunList;
  int? _selectedSemester;

  /// Auto-compute academic year list based on current date.
  static List<String> _buildTahunList() {
    final now = DateTime.now();
    // Academic year starts in July
    final baseYear = now.month >= 7 ? now.year : now.year - 1;
    return [
      for (int y = baseYear - 2; y <= baseYear + 2; y++) '$y / ${y + 1}',
    ];
  }

  static String _currentTahunAjaran() {
    final now = DateTime.now();
    final baseYear = now.month >= 7 ? now.year : now.year - 1;
    return '$baseYear / ${baseYear + 1}';
  }

  @override
  void initState() {
    super.initState();
    _selectedSemester = widget.initialSemesterAktif;
    _tahunList = _buildTahunList();
    final initial = widget.initialTahunAjaran;
    if (initial != null && initial.isNotEmpty && _tahunList.contains(initial)) {
      _selectedTahun = initial;
    } else {
      _selectedTahun = _currentTahunAjaran();
    }
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
                  SizedBox(height: 24.h),

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
                  SizedBox(height: 24.h),

                  // Semester Aktif
                  Text(
                    t.editTarget.semesterAktif,
                    style: TextStyle(
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w600,
                      color: colors.textSecondary,
                      letterSpacing: 0.5,
                      fontFamily: 'Poppins',
                    ),
                  ),
                  SizedBox(height: 6.h),
                  Text(
                    t.editTarget.pilihSemester,
                    style: TextStyle(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w400,
                      color: colors.textSecondary,
                      fontFamily: 'Poppins',
                    ),
                  ),
                  SizedBox(height: 12.h),

                  // Semester selector
                  Column(
                    children: [
                      _buildSemesterOption(
                        colors,
                        value: 1,
                        label: t.targetHafalan.semester1,
                      ),
                      SizedBox(height: 10.h),
                      _buildSemesterOption(
                        colors,
                        value: 2,
                        label: t.targetHafalan.semester2,
                      ),
                      SizedBox(height: 10.h),
                      _buildSemesterOption(
                        colors,
                        value: null,
                        label: t.targetHafalan.belumDitetapkan,
                        isDanger: true,
                      ),
                    ],
                  ),
                  SizedBox(height: 24.h),
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

                  if (widget.onSave != null) {
                    widget.onSave!(_selectedSemester, _selectedTahun);
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

  Widget _buildSemesterOption(
    AppColorSet colors, {
    required int? value,
    required String label,
    bool isDanger = false,
  }) {
    final isSelected = _selectedSemester == value;
    final primaryColor = isDanger ? colors.red : colors.primary;

    return GestureDetector(
      onTap: () => setState(() => _selectedSemester = value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
        decoration: BoxDecoration(
          color: isSelected
              ? primaryColor.withValues(alpha: 0.08)
              : colors.surface,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: isSelected ? primaryColor : colors.border,
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            Icon(
              isSelected ? Icons.radio_button_checked : Icons.radio_button_off,
              color: isSelected ? primaryColor : colors.textSecondary,
              size: 20.sp,
            ),
            SizedBox(width: 12.w),
            Text(
              label,
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                color: isSelected ? primaryColor : colors.textPrimary,
                fontFamily: 'Poppins',
              ),
            ),
          ],
        ),
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
}

