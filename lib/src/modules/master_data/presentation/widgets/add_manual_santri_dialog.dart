import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_halaqoh/gen/i18n/translations.g.dart';
import 'package:my_halaqoh/src/core/theme/app_colors.dart';
import 'package:my_halaqoh/src/core/widget/widgets.dart';

/// Dialog form for adding/editing a Santri manually
class AddManualSantriDialog extends StatefulWidget {
  final String? initialNis;
  final String? initialNama;
  final String? initialKelas;
  final void Function(String? nis, String? nama, String? kelas)? onSave;

  const AddManualSantriDialog({
    super.key,
    this.initialNis,
    this.initialNama,
    this.initialKelas,
    this.onSave,
  });

  static Future<void> show(
    BuildContext context, {
    String? initialNis,
    String? initialNama,
    String? initialKelas,
    void Function(String? nis, String? nama, String? kelas)? onSave,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => AddManualSantriDialog(
        initialNis: initialNis,
        initialNama: initialNama,
        initialKelas: initialKelas,
        onSave: onSave,
      ),
    );
  }

  @override
  State<AddManualSantriDialog> createState() => _AddManualSantriDialogState();
}

class _AddManualSantriDialogState extends State<AddManualSantriDialog> {
  final _nisController = TextEditingController();
  final _namaController = TextEditingController();
  String? _selectedKelas;

  final List<String> _kelasList = [
    '7R',
    '7T',
    '8R',
    '8T',
    '9R',
    '9T',
    '10R',
    '10T',
    '11R',
    '11T',
    '12R',
    '12T',
  ];

  bool get _isEditMode => widget.initialNis != null;

  @override
  void initState() {
    super.initState();
    if (widget.initialNis != null) _nisController.text = widget.initialNis!;
    if (widget.initialNama != null) _namaController.text = widget.initialNama!;
    if (widget.initialKelas != null &&
        _kelasList.contains(widget.initialKelas)) {
      _selectedKelas = widget.initialKelas;
    }
  }

  @override
  void dispose() {
    _nisController.dispose();
    _namaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Container(
      padding: EdgeInsets.only(
        top: 24.h,
        left: 24.w,
        right: 24.w,
        bottom: bottomInset + 24.h,
      ),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24.r),
          topRight: Radius.circular(24.r),
        ),
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _isEditMode ? 'Edit Data Santri' : t.addData.addSantriManual,
                  style: TextStyle(
                    fontSize: 18.sp,
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
            SizedBox(height: 20.h),

            // Photo avatar
            Center(
              child: Stack(
                children: [
                  Container(
                    width: 80.w,
                    height: 80.w,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: colors.border, width: 2),
                    ),
                    child: Center(
                      child: Icon(
                        Icons.add_a_photo_outlined,
                        color: colors.textSecondary,
                        size: 30.sp,
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      width: 28.w,
                      height: 28.w,
                      decoration: BoxDecoration(
                        color: colors.primary,
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Icon(
                          Icons.edit,
                          color: colors.textOnButton,
                          size: 14.sp,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 24.h),

            // NIS field
            _buildLabel(colors, t.addData.nis),
            SizedBox(height: 8.h),
            _buildTextField(
              colors: colors,
              controller: _nisController,
              hint: t.addData.nisHint,
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 18.h),

            // Nama Lengkap field
            _buildLabel(colors, t.addData.namaLengkap),
            SizedBox(height: 8.h),
            _buildTextField(
              colors: colors,
              controller: _namaController,
              hint: t.addData.namaSantriHint,
            ),
            SizedBox(height: 18.h),

            // Kelas dropdown
            _buildLabel(colors, t.addData.kelas),
            SizedBox(height: 8.h),
            CustomDropdown<String>(
              hintText: t.addData.kelasHint,
              items: _kelasList,
              initialItem: _selectedKelas,
              onChanged: (value) {
                setState(() => _selectedKelas = value);
              },
              closedHeaderPadding: EdgeInsets.symmetric(
                horizontal: 16.w,
                vertical: 14.h,
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
                  color: colors.textPrimary,
                  fontFamily: 'Poppins',
                ),
                hintStyle: TextStyle(
                  fontSize: 14.sp,
                  color: colors.textSecondary.withValues(alpha: 0.5),
                  fontFamily: 'Poppins',
                ),
                listItemStyle: TextStyle(
                  fontSize: 14.sp,
                  color: colors.textPrimary,
                  fontFamily: 'Poppins',
                ),
              ),
            ),
            SizedBox(height: 28.h),

            // Simpan button
            PrimaryButton(
              width: double.infinity,
              onPressed: () async {
                final confirmed = await ConfirmSaveDialog.show(context);
                if (!confirmed) return;

                if (widget.onSave != null) {
                  widget.onSave!(
                    _nisController.text,
                    _namaController.text,
                    _selectedKelas,
                  );
                }
                if (context.mounted) {
                  Navigator.of(context).pop();
                }
              },
              label: t.addData.simpan,
              icon: Icons.check_circle,
              borderRadius: 25.r,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLabel(AppColorSet colors, String label) {
    return Text(
      label,
      style: TextStyle(
        fontSize: 13.sp,
        fontWeight: FontWeight.w600,
        color: colors.textPrimary,
        fontFamily: 'Poppins',
      ),
    );
  }

  Widget _buildTextField({
    required AppColorSet colors,
    required TextEditingController controller,
    required String hint,
    TextInputType? keyboardType,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      style: TextStyle(
        fontSize: 14.sp,
        fontFamily: 'Poppins',
        color: colors.textPrimary,
      ),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(
          fontSize: 14.sp,
          color: colors.textSecondary.withValues(alpha: 0.5),
          fontFamily: 'Poppins',
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.r),
          borderSide: BorderSide(color: colors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.r),
          borderSide: BorderSide(color: colors.primary),
        ),
      ),
    );
  }
}
