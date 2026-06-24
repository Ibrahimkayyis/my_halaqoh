import 'dart:io';
import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_halaqoh/gen/i18n/translations.g.dart';
import 'package:my_halaqoh/src/core/service_locator/service_locator.dart';
import 'package:my_halaqoh/src/core/services/storage_service.dart';
import 'package:my_halaqoh/src/core/theme/app_colors.dart';
import 'package:my_halaqoh/src/core/widget/widgets.dart';
import 'package:my_halaqoh/src/modules/master_data/presentation/cubits/santri_cubit.dart';
import 'package:my_halaqoh/src/modules/master_data/presentation/cubits/santri_state.dart';
import 'package:my_halaqoh/src/modules/master_data/presentation/cubits/kelas_cubit.dart';
import 'package:my_halaqoh/src/modules/master_data/presentation/cubits/kelas_state.dart';
import 'package:my_halaqoh/src/modules/master_data/presentation/cubits/program_cubit.dart';
import 'package:my_halaqoh/src/modules/master_data/presentation/cubits/program_state.dart';
import 'package:my_halaqoh/src/modules/master_data/domain/models/kelas_model.dart';
import 'package:my_halaqoh/src/modules/master_data/domain/models/program_model.dart';

/// Dialog form for adding/editing a Santri manually
class AddManualSantriDialog extends StatefulWidget {
  final String? initialNis;
  final String? initialNama;
  final String? initialKelas;
  final String? initialProfilePicture;
  final Future<void> Function(
    String? nis,
    String? nama,
    String? kelas,
    String? profilePicture,
  )?
  onSave;

  const AddManualSantriDialog({
    super.key,
    this.initialNis,
    this.initialNama,
    this.initialKelas,
    this.initialProfilePicture,
    this.onSave,
  });

  static Future<void> show(
    BuildContext context, {
    String? initialNis,
    String? initialNama,
    String? initialKelas,
    String? initialProfilePicture,
    Future<void> Function(
      String? nis,
      String? nama,
      String? kelas,
      String? profilePicture,
    )?
    onSave,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => MultiBlocProvider(
        providers: [
          BlocProvider.value(value: context.read<KelasCubit>()),
          BlocProvider.value(value: context.read<ProgramCubit>()),
        ],
        child: AddManualSantriDialog(
          initialNis: initialNis,
          initialNama: initialNama,
          initialKelas: initialKelas,
          initialProfilePicture: initialProfilePicture,
          onSave: onSave,
        ),
      ),
    );
  }

  @override
  State<AddManualSantriDialog> createState() => _AddManualSantriDialogState();
}

class _AddManualSantriDialogState extends State<AddManualSantriDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nisController = TextEditingController();
  final _namaController = TextEditingController();
  String? _selectedKelas;
  String? _kelasError; // inline validation error for kelas dropdown

  File? _selectedImage;
  String? _currentProfilePicture;
  bool _isUploading = false;
  bool _isSaving = false; // tracks the full save+upload+Firestore flow

  bool get _isEditMode => widget.initialNis != null;

  @override
  void initState() {
    super.initState();
    if (widget.initialNis != null) _nisController.text = widget.initialNis!;
    if (widget.initialNama != null) _namaController.text = widget.initialNama!;
    if (widget.initialKelas != null) {
      _selectedKelas = widget.initialKelas;
    }
    if (widget.initialProfilePicture != null) {
      _currentProfilePicture = widget.initialProfilePicture;
    }
    context.read<KelasCubit>().loadAll();
    context.read<ProgramCubit>().loadAll();
  }

  Future<void> _validateAndSubmit() async {
    // 1. Validate NIS + Nama fields
    final isFormValid = _formKey.currentState!.validate();

    // 2. Validate kelas (inline error)
    if (_selectedKelas == null) {
      setState(() => _kelasError = t.santri.kelasRequired);
    }

    if (!isFormValid || _selectedKelas == null) return;

    // 2.5. Validate if NIS already exists
    final currentState = context.read<SantriCubit>().state;
    bool nisExists = false;
    currentState.maybeWhen(
      loaded: (santriList) {
        if (!_isEditMode || _nisController.text.trim() != widget.initialNis) {
          nisExists = santriList.any((s) => s.nis == _nisController.text.trim());
        }
      },
      orElse: () {},
    );

    if (nisExists) {
      if (mounted) {
        showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text(
              t.general.warning,
              style: TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.bold,
                color: AppColors.of(context).error,
              ),
            ),
            content: Text(
              t.santri.nisExistsError(nis: _nisController.text.trim()),
              style: const TextStyle(fontFamily: 'Poppins'),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(),
                child: Text(t.general.close, style: const TextStyle(fontFamily: 'Poppins')),
              ),
            ],
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
          ),
        );
      }
      return;
    }

    // 3. Show confirmation dialog
    final confirmed = await ConfirmSaveDialog.show(context);
    if (!confirmed) return;
    if (!mounted) return;

    setState(() => _isSaving = true);

    try {
      String? uploadedUrl = _currentProfilePicture;

      // 4. Upload photo if selected
      if (_selectedImage != null) {
        setState(() => _isUploading = true);
        final timestamp = DateTime.now().millisecondsSinceEpoch;
        final ext = _selectedImage!.path.split('.').last;
        final fileName = 'santri_${_nisController.text}_$timestamp.$ext';
        final service = sl<StorageService>();
        final url = await service.uploadFile(
          file: _selectedImage!,
          path: 'profile_pictures/$fileName',
        );
        if (mounted) setState(() => _isUploading = false);
        if (url != null) uploadedUrl = url;
      }

      // 5. Invoke onSave callback and await Firestore operation
      if (widget.onSave != null) {
        await widget.onSave!(
          _nisController.text,
          _namaController.text,
          _selectedKelas,
          uploadedUrl,
        );
      }

      // 6. Close dialog only on success
      if (mounted) Navigator.of(context).pop();

    } catch (e) {
      // Show error to user — previously errors were silently swallowed
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
      if (mounted) setState(() => _isSaving = false);
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

    final kelasState = context.watch<KelasCubit>().state;
    final programState = context.watch<ProgramCubit>().state;

    final kelasList = kelasState.maybeWhen(
      loaded: (list) => list,
      orElse: () => <KelasModel>[],
    );
    final programList = programState.maybeWhen(
      loaded: (list) => list,
      orElse: () => <ProgramModel>[],
    );

    final dynamicKelasList = <String>[];
    for (final k in kelasList) {
      for (final p in programList) {
        dynamicKelasList.add('${k.nama}${p.id}');
      }
    }

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
                    _isEditMode
                        ? t.santri.editTitle
                        : t.addData.addSantriManual,
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
                              : (_currentProfilePicture != null &&
                                    _currentProfilePicture!.isNotEmpty)
                              ? Image.network(
                                  _currentProfilePicture!,
                                  fit: BoxFit.cover,
                                  errorBuilder: (c, o, s) => Icon(
                                    Icons.person,
                                    color: colors.textSecondary,
                                    size: 40.sp,
                                  ),
                                )
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
                              child: CircularProgressIndicator(
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 24.h),

              // NIS field
              _buildLabel(colors, t.addData.nis),
              SizedBox(height: 8.h),
              _buildTextFormField(
                colors: colors,
                controller: _nisController,
                hint: t.addData.nisHint,
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(12),
                ],
                validator: (value) {
                  if (value == null || value.isEmpty) return t.santri.nisRequired;
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
                hint: t.addData.namaSantriHint,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return t.santri.nameRequired;
                  }
                  return null;
                },
              ),
              SizedBox(height: 18.h),

              // Kelas dropdown
              _buildLabel(colors, t.addData.kelas),
              SizedBox(height: 8.h),
              CustomDropdown<String>(
                hintText: t.addData.kelasHint,
                items: dynamicKelasList,
                initialItem: dynamicKelasList.contains(_selectedKelas) ? _selectedKelas : null,
                onChanged: (value) {
                  setState(() {
                    _selectedKelas = value;
                    _kelasError = null; // clear error on selection
                  });
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
              // Inline error for kelas
              if (_kelasError != null)
                Padding(
                  padding: EdgeInsets.only(top: 6.h, left: 4.w),
                  child: Text(
                    _kelasError!,
                    style: TextStyle(
                      fontSize: 11.sp,
                      color: Colors.redAccent,
                      fontFamily: 'Poppins',
                    ),
                  ),
                ),
              SizedBox(height: 28.h),

              // Simpan button
              PrimaryButton(
                width: double.infinity,
                onPressed: _isSaving ? null : _validateAndSubmit,
                label: _isSaving ? t.general.saving : t.addData.simpan,
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
        errorStyle: TextStyle(fontSize: 11.sp, fontFamily: 'Poppins'),
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
