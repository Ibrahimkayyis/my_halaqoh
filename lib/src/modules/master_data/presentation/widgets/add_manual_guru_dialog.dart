import 'dart:io';
import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:my_halaqoh/gen/i18n/translations.g.dart';
import 'package:my_halaqoh/src/core/service_locator/service_locator.dart';
import 'package:my_halaqoh/src/core/services/storage_service.dart';
import 'package:my_halaqoh/src/core/theme/app_colors.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_halaqoh/src/core/widget/widgets.dart';
import 'package:my_halaqoh/src/modules/master_data/presentation/cubits/guru_cubit.dart';
import 'package:my_halaqoh/src/modules/master_data/presentation/cubits/guru_state.dart';

/// Dialog form for adding/editing a Guru manually
class AddManualGuruDialog extends StatefulWidget {
  final String? initialNip;
  final String? initialNama;
  final String? initialPhone;
  final String? initialProgram;
  final String? initialProfilePicture;
  final Future<void> Function(String? nip, String? nama, String? phone, String? program, String? profilePicture)? onSave;

  const AddManualGuruDialog({
    super.key,
    this.initialNip,
    this.initialNama,
    this.initialPhone,
    this.initialProgram,
    this.initialProfilePicture,
    this.onSave,
  });

  static Future<void> show(
    BuildContext context, {
    String? initialNip,
    String? initialNama,
    String? initialPhone,
    String? initialProgram,
    String? initialProfilePicture,
    Future<void> Function(String? nip, String? nama, String? phone, String? program, String? profilePicture)? onSave,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => AddManualGuruDialog(
        initialNip: initialNip,
        initialNama: initialNama,
        initialPhone: initialPhone,
        initialProgram: initialProgram,
        initialProfilePicture: initialProfilePicture,
        onSave: onSave,
      ),
    );
  }

  @override
  State<AddManualGuruDialog> createState() => _AddManualGuruDialogState();
}

class _AddManualGuruDialogState extends State<AddManualGuruDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nipController = TextEditingController();
  final _namaController = TextEditingController();
  final _phoneController = TextEditingController();
  String? _selectedProgram;

  File? _selectedImage;
  String? _currentProfilePicture;
  bool _isUploading = false;
  bool _isSaving = false;

  final List<String> _programList = ['Reguler', 'Takhassus'];

  bool get _isEditMode => widget.initialNip != null;

  @override
  void initState() {
    super.initState();
    if (widget.initialNip != null) _nipController.text = widget.initialNip!;
    if (widget.initialNama != null) _namaController.text = widget.initialNama!;
    if (widget.initialPhone != null) {
      _phoneController.text = widget.initialPhone!;
    }
    if (widget.initialProgram != null) {
      _selectedProgram = widget.initialProgram == 'T' ? 'Takhassus' : 'Reguler';
    }
    if (widget.initialProfilePicture != null) {
      _currentProfilePicture = widget.initialProfilePicture;
    }
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 70,
      maxWidth: 256,
      maxHeight: 256,
    );
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  Future<void> _validateAndSubmit() async {
    if (!_formKey.currentState!.validate()) return;

    // Validate if NIP already exists (only on add, or when NIP has changed during edit)
    final currentState = context.read<GuruCubit>().state;
    bool nipExists = false;
    currentState.maybeWhen(
      loaded: (guruList) {
        if (!_isEditMode || _nipController.text.trim() != widget.initialNip) {
          nipExists = guruList.any((g) => g.nip == _nipController.text.trim());
        }
      },
      orElse: () {},
    );

    if (nipExists) {
      if (mounted) {
        showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text(
              'Peringatan',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.bold,
                color: AppColors.of(context).error,
              ),
            ),
            content: Text(
              'Guru dengan NIP ${_nipController.text.trim()} sudah terdaftar di sistem.',
              style: const TextStyle(fontFamily: 'Poppins'),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(),
                child: const Text('Tutup', style: TextStyle(fontFamily: 'Poppins')),
              ),
            ],
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
          ),
        );
      }
      return;
    }

    final confirmed = await ConfirmSaveDialog.show(context);
    if (!confirmed) return;
    if (!mounted) return;

    setState(() => _isSaving = true);

    try {
      final p = _selectedProgram == 'Takhassus' ? 'T' : 'R';
      String? uploadedUrl = _currentProfilePicture;

      // Upload process
      if (_selectedImage != null) {
        setState(() => _isUploading = true);
        final timestamp = DateTime.now().millisecondsSinceEpoch;
        final ext = _selectedImage!.path.split('.').last;
        final fileName = 'guru_${_nipController.text}_$timestamp.$ext';
        final service = sl<StorageService>();
        final url = await service.uploadFile(
          file: _selectedImage!,
          path: 'profile_pictures/$fileName',
        );
        if (mounted) setState(() => _isUploading = false);
        if (url != null) {
          uploadedUrl = url;
        }
      }

      if (widget.onSave != null) {
        await widget.onSave!(
          _nipController.text,
          _namaController.text,
          _phoneController.text,
          p,
          uploadedUrl,
        );
      }
      
      if (mounted) {
        Navigator.of(context).pop();
      }
    } catch (e) {
      if (mounted) {
        final colors = AppColors.of(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              e.toString().replaceAll('Exception: ', ''),
              style: const TextStyle(fontFamily: 'Poppins'),
            ),
            backgroundColor: colors.error,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  @override
  void dispose() {
    _nipController.dispose();
    _namaController.dispose();
    _phoneController.dispose();
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
        child: Form(
          key: _formKey,
          child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _isEditMode ? 'Edit Data Guru' : t.addData.addGuruManual,
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
              child: GestureDetector(
                onTap: _isUploading ? null : _pickImage,
                child: Stack(
                  children: [
                    Container(
                      width: 80.w,
                      height: 80.w,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: colors.background,
                        border: Border.all(color: colors.border, width: 2),
                      ),
                      child: ClipOval(
                        child: _selectedImage != null
                            ? Image.file(_selectedImage!, fit: BoxFit.cover)
                            : (_currentProfilePicture != null && _currentProfilePicture!.isNotEmpty)
                                ? Image.network(_currentProfilePicture!, fit: BoxFit.cover, errorBuilder: (c, o, s) => Icon(Icons.person, color: colors.textSecondary, size: 40.sp))
                                : Center(
                                    child: Icon(
                                      Icons.add_a_photo_outlined,
                                      color: colors.textSecondary,
                                      size: 30.sp,
                                    ),
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
                    if (_isUploading)
                      Positioned.fill(
                        child: Container(
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.black54,
                          ),
                          child: const Center(
                            child: CircularProgressIndicator(color: Colors.white),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 24.h),

            // NIP field
            _buildLabel(colors, t.addData.nip),
            SizedBox(height: 8.h),
            _buildTextFormField(
              colors: colors,
              controller: _nipController,
              hint: t.addData.nipHint,
              keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(13)],
              validator: (value) {
                if (value == null || value.isEmpty) return 'NIP wajib diisi';
                if (value.length < 12 || value.length > 13) return 'NIP harus 12 atau 13 digit';
                return null;
              },
            ),
            SizedBox(height: 18.h),

            // Nama Lengkap field
            _buildLabel(colors, t.addData.namaLengkap),
            SizedBox(height: 8.h),
            _buildTextFormField(
              colors: colors,
              controller: _namaController,
              hint: t.addData.namaGuruHint,
              validator: (value) {
                if (value == null || value.trim().isEmpty) return 'Nama wajib diisi';
                return null;
              },
            ),
            SizedBox(height: 18.h),

            // Nomor HP field
            _buildLabel(colors, t.addData.nomorHp),
            SizedBox(height: 8.h),
            _buildTextFormField(
              colors: colors,
              controller: _phoneController,
              hint: t.addData.nomorHpHint,
              keyboardType: TextInputType.phone,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(13)],
              validator: (value) {
                if (value != null && value.isNotEmpty) {
                  if (value.length < 10 || value.length > 13) return 'Nomor HP harus 10-13 digit (jika diisi)';
                }
                return null;
              },
            ),
            SizedBox(height: 18.h),

            // Program field
            _buildLabel(colors, 'Program Halaqoh'),
            SizedBox(height: 8.h),
            CustomDropdown<String>(
              hintText: 'Pilih Program',
              items: _programList,
              initialItem: _selectedProgram,
              onChanged: (value) {
                setState(() {
                  _selectedProgram = value;
                });
              },
              decoration: CustomDropdownDecoration(
                closedFillColor: Colors.transparent,
                expandedFillColor: colors.surface,
                closedBorder: Border.all(color: colors.border),
                closedBorderRadius: BorderRadius.circular(10.r),
                hintStyle: TextStyle(
                  fontSize: 14.sp,
                  color: colors.textSecondary.withValues(alpha: 0.5),
                  fontFamily: 'Poppins',
                ),
                headerStyle: TextStyle(
                  fontSize: 14.sp,
                  color: colors.textPrimary,
                  fontFamily: 'Poppins',
                ),
                listItemStyle: TextStyle(
                  fontSize: 14.sp,
                  color: colors.textPrimary,
                  fontFamily: 'Poppins',
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Program wajib dipilih';
                }
                return null;
              },
            ),
            SizedBox(height: 28.h),

            // Simpan button
            PrimaryButton(
              width: double.infinity,
              onPressed: _isSaving ? null : _validateAndSubmit,
              label: _isSaving ? 'Menyimpan...' : t.addData.simpan,
              icon: _isSaving ? Icons.hourglass_top : Icons.check_circle,
              borderRadius: 25.r,
            ),
          ],
          ),
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

  Widget _buildTextFormField({
    required AppColorSet colors,
    required TextEditingController controller,
    required String hint,
    TextInputType? keyboardType,
    List<TextInputFormatter>? inputFormatters,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      validator: validator,
      autovalidateMode: AutovalidateMode.onUserInteraction,
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
        errorStyle: TextStyle(
          fontSize: 11.sp,
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
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.r),
          borderSide: const BorderSide(color: Colors.redAccent),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.r),
          borderSide: const BorderSide(color: Colors.redAccent),
        ),
      ),
    );
  }
}
