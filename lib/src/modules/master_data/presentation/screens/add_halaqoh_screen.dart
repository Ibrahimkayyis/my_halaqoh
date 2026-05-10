import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_halaqoh/gen/i18n/translations.g.dart';
import 'package:my_halaqoh/src/core/router/app_router.dart';
import 'package:my_halaqoh/src/core/theme/app_colors.dart';
import 'package:my_halaqoh/src/core/widget/widgets.dart';
import 'package:my_halaqoh/src/modules/master_data/domain/models/guru_model.dart';
import 'package:my_halaqoh/src/modules/master_data/domain/models/halaqoh_model.dart';
import 'package:my_halaqoh/src/modules/master_data/domain/models/santri_model.dart';
import 'package:my_halaqoh/src/modules/master_data/presentation/cubits/guru_cubit.dart';
import 'package:my_halaqoh/src/modules/master_data/presentation/cubits/guru_state.dart';
import 'package:my_halaqoh/src/modules/master_data/presentation/cubits/halaqoh_cubit.dart';
import 'package:my_halaqoh/src/modules/master_data/presentation/cubits/halaqoh_state.dart';
import 'package:my_halaqoh/src/modules/master_data/presentation/cubits/santri_cubit.dart';
import 'package:my_halaqoh/src/modules/master_data/presentation/cubits/santri_state.dart';

/// Screen for creating or editing a Halaqoh group
@RoutePage()
class AddHalaqohScreen extends StatefulWidget {
  final HalaqohModel? existingHalaqoh;

  const AddHalaqohScreen({super.key, this.existingHalaqoh});

  @override
  State<AddHalaqohScreen> createState() => _AddHalaqohScreenState();
}

class _AddHalaqohScreenState extends State<AddHalaqohScreen> {
  final _namaController = TextEditingController();
  String? _selectedKelas;
  String? _selectedProgram;
  GuruModel? _selectedGuru;

  final List<String> _kelasList = ['7', '8', '9', '10', '11', '12'];
  final List<String> _programList = ['Reguler', 'Takhassus'];

  // Selected santri for this halaqoh (now using SantriModel)
  final List<SantriModel> _selectedSantri = [];

  @override
  void initState() {
    super.initState();
    if (widget.existingHalaqoh != null) {
      final existing = widget.existingHalaqoh!;
      _namaController.text = existing.nama;
      _selectedKelas = existing.kelas;
      _selectedProgram = existing.program == 'T' ? 'Takhassus' : 'Reguler';

      final guruList = context.read<GuruCubit>().state.maybeWhen(
        loaded: (list) => list,
        orElse: () => <GuruModel>[],
      );
      try {
        _selectedGuru = guruList.firstWhere((g) => g.id == existing.guruId);
      } catch (_) {}

      final santriList = context.read<SantriCubit>().state.maybeWhen(
        loaded: (list) => list,
        orElse: () => <SantriModel>[],
      );
      for (final sId in existing.santriIds) {
        try {
          _selectedSantri.add(santriList.firstWhere((s) => s.id == sId));
        } catch (_) {}
      }
    }
  }

  @override
  void dispose() {
    _namaController.dispose();
    super.dispose();
  }

  Future<void> _navigateToSelectSantri(Set<String> assignedSantris) async {
    final result = await context.router.push<List<SantriModel>>(
      SelectSantriRoute(assignedSantriIds: assignedSantris),
    );
    if (result != null && result.isNotEmpty) {
      setState(() {
        // Merge with existing, avoid duplicates by ID
        for (final santri in result) {
          if (!_selectedSantri.any((s) => s.id == santri.id)) {
            _selectedSantri.add(santri);
          }
        }
      });
    }
  }

  Future<void> _removeSantri(int index) async {
    final confirmed = await ConfirmDeleteDialog.show(
      context,
      title: 'Hapus Santri?',
      message: 'Apakah Anda yakin ingin menghapus santri ini dari halaqoh?',
    );
    if (!confirmed) return;

    setState(() {
      _selectedSantri.removeAt(index);
    });
  }

  Future<void> _saveHalaqoh() async {
    if (_namaController.text.isEmpty || _selectedGuru == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Lengkapi nama dan pengampu halaqoh')),
      );
      return;
    }

    final confirmed = await ConfirmSaveDialog.show(context);
    if (!confirmed) return;

    final now = DateTime.now();
    final programCode = _selectedProgram == 'Takhassus' ? 'T' : 'R';

    final isEdit = widget.existingHalaqoh != null;

    final model = HalaqohModel(
      id: isEdit
          ? widget.existingHalaqoh!.id
          : '', // will be set by Firestore if empty
      nama: _namaController.text,
      kelas: _selectedKelas ?? '7',
      program: programCode,
      guruId: _selectedGuru!.id,
      guruNama: _selectedGuru!.nama,
      santriIds: _selectedSantri.map((s) => s.id).toList(),
      jumlahSantri: _selectedSantri.length,
      createdAt: isEdit ? widget.existingHalaqoh!.createdAt : now,
      updatedAt: now,
    );

    if (mounted) {
      if (isEdit) {
        await context.read<HalaqohCubit>().updateHalaqoh(model);
      } else {
        await context.read<HalaqohCubit>().addHalaqoh(model);
      }
      if (mounted) context.router.maybePop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);

    // Track assigned Halqoh
    final halaqohState = context.watch<HalaqohCubit>().state;
    final allHalaqoh = halaqohState.maybeWhen(
      loaded: (list) => list,
      orElse: () => <HalaqohModel>[],
    );

    final assignedGuruIds = <String>{};
    final assignedSantriIds = <String>{};

    for (final h in allHalaqoh) {
      if (widget.existingHalaqoh != null &&
          h.id == widget.existingHalaqoh!.id) {
        continue;
      }
      assignedGuruIds.add(h.guruId);
      assignedSantriIds.addAll(h.santriIds);
    }

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        backgroundColor: colors.background,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: Icon(Icons.close, color: colors.textPrimary),
          onPressed: () => context.router.maybePop(),
        ),
        title: Text(
          t.addHalaqoh.title,
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.w700,
            color: colors.textPrimary,
            fontFamily: 'Poppins',
          ),
        ),
        centerTitle: false,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Nama Halaqoh
                  _buildLabel(colors, t.addHalaqoh.namaHalaqoh),
                  SizedBox(height: 8.h),
                  _buildTextField(
                    colors: colors,
                    controller: _namaController,
                    hint: t.addHalaqoh.namaHalaqohHint,
                  ),
                  SizedBox(height: 20.h),

                  // Kelas + Program (side by side)
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildLabel(colors, t.addHalaqoh.kelas),
                            SizedBox(height: 8.h),
                            CustomDropdown<String>(
                              hintText: t.addHalaqoh.kelasHint,
                              items: _kelasList,
                              initialItem: _selectedKelas,
                              onChanged: (v) =>
                                  setState(() => _selectedKelas = v),
                              closedHeaderPadding: EdgeInsets.symmetric(
                                horizontal: 14.w,
                                vertical: 12.h,
                              ),
                              decoration: _dropdownDecoration(colors),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildLabel(colors, t.addHalaqoh.program),
                            SizedBox(height: 8.h),
                            CustomDropdown<String>(
                              hintText: t.addHalaqoh.programHint,
                              items: _programList,
                              initialItem: _selectedProgram,
                              onChanged: (v) =>
                                  setState(() => _selectedProgram = v),
                              closedHeaderPadding: EdgeInsets.symmetric(
                                horizontal: 14.w,
                                vertical: 12.h,
                              ),
                              decoration: _dropdownDecoration(colors),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20.h),

                  // Pengampu (Guru) - searchable dropdown with real data
                  _buildLabel(colors, t.addHalaqoh.pengampu),
                  SizedBox(height: 8.h),
                  BlocBuilder<GuruCubit, GuruState>(
                    builder: (context, state) {
                      final guruList = state.maybeWhen(
                        loaded: (list) => list,
                        orElse: () => <GuruModel>[],
                      );

                      final availableGurus = guruList
                          .where((g) => !assignedGuruIds.contains(g.id))
                          .toList();
                      final filteredCount =
                          guruList.length - availableGurus.length;

                      final guruNames = availableGurus
                          .map((g) => g.nama)
                          .toList();

                      // Cegah crash pada library CustomDropdown:
                      // Jika kita (atau sistem) sudah men-select seorang guru, pastikan namanya SELALU ADA di list dropdown
                      // Hal ini mencegah error saat halaqoh disimpan dan state me-refresh UI secara reaktif.
                      if (_selectedGuru != null && !guruNames.contains(_selectedGuru!.nama)) {
                        guruNames.add(_selectedGuru!.nama);
                      }

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomDropdown<String>.search(
                            hintText: t.addHalaqoh.pengampuHint,
                            items: guruNames,
                            initialItem: _selectedGuru?.nama,
                            excludeSelected: false,
                            onChanged: (name) {
                              setState(() {
                                try {
                                  _selectedGuru = availableGurus.firstWhere(
                                    (g) => g.nama == name,
                                  );
                                } catch (_) {
                                  _selectedGuru = null;
                                }
                              });
                            },
                            closedHeaderPadding: EdgeInsets.symmetric(
                              horizontal: 14.w,
                              vertical: 12.h,
                            ),
                            decoration: _dropdownDecoration(colors),
                          ),
                          if (filteredCount > 0) ...[
                            SizedBox(height: 6.h),
                            Text(
                              '* $filteredCount guru disembunyikan karena telah mengampu halaqoh lain.',
                              style: TextStyle(
                                fontSize: 11.sp,
                                color: colors.primary,
                                fontStyle: FontStyle.italic,
                                fontFamily: 'Poppins',
                              ),
                            ),
                          ],
                        ],
                      );
                    },
                  ),
                  SizedBox(height: 24.h),

                  // Daftar Santri header + Tambah Santri button
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        t.addHalaqoh.daftarSantri,
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                          color: colors.textPrimary,
                          fontFamily: 'Poppins',
                        ),
                      ),
                      GestureDetector(
                        onTap: () => _navigateToSelectSantri(assignedSantriIds),
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 14.w,
                            vertical: 6.h,
                          ),
                          decoration: BoxDecoration(
                            color: colors.primary.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(8.r),
                            border: Border.all(color: colors.primary, width: 1),
                          ),
                          child: Text(
                            t.addHalaqoh.tambahSantri,
                            style: TextStyle(
                              fontSize: 13.sp,
                              fontWeight: FontWeight.w600,
                              color: colors.primary,
                              fontFamily: 'Poppins',
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 12.h),

                  // Santri table
                  _buildSantriTable(colors),
                  SizedBox(height: 8.h),

                  // Total count
                  Text(
                    t.addHalaqoh.totalTerpilih(
                      count: _selectedSantri.length.toString(),
                    ),
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w400,
                      color: colors.textSecondary,
                      fontFamily: 'Poppins',
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Bottom save button
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
            decoration: BoxDecoration(
              color: colors.surface,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, -3),
                ),
              ],
            ),
            child: SafeArea(
              child: SizedBox(
                width: double.infinity,
                height: 50.h,
                child: PrimaryButton(
                  onPressed: _saveHalaqoh,
                  icon: Icons.save,
                  label: t.addHalaqoh.simpanHalaqoh,
                  borderRadius: 25.r,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  CustomDropdownDecoration _dropdownDecoration(AppColorSet colors) {
    return CustomDropdownDecoration(
      closedBorderRadius: BorderRadius.circular(10.r),
      closedBorder: Border.all(color: colors.border),
      closedFillColor: colors.surface,
      expandedBorderRadius: BorderRadius.circular(10.r),
      expandedBorder: Border.all(color: colors.primary),
      expandedFillColor: colors.surface,
      headerStyle: TextStyle(
        fontSize: 13.sp,
        color: colors.textPrimary,
        fontFamily: 'Poppins',
      ),
      hintStyle: TextStyle(
        fontSize: 13.sp,
        color: colors.textSecondary.withValues(alpha: 0.5),
        fontFamily: 'Poppins',
      ),
      listItemStyle: TextStyle(
        fontSize: 13.sp,
        color: colors.textPrimary,
        fontFamily: 'Poppins',
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
  }) {
    return TextField(
      controller: controller,
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

  Widget _buildSantriTable(AppColorSet colors) {
    return Container(
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: colors.border.withValues(alpha: 0.5)),
      ),
      child: Column(
        children: [
          // Table header
          Container(
            padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
            decoration: BoxDecoration(
              color: colors.background,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12.r),
                topRight: Radius.circular(12.r),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    t.santri.identitas,
                    style: TextStyle(
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w600,
                      color: colors.textSecondary,
                      letterSpacing: 0.5,
                      fontFamily: 'Poppins',
                    ),
                  ),
                ),
                SizedBox(
                  width: 40.w,
                  child: Text(
                    t.addHalaqoh.aksi,
                    textAlign: TextAlign.end,
                    style: TextStyle(
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w600,
                      color: colors.textSecondary,
                      letterSpacing: 0.5,
                      fontFamily: 'Poppins',
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Table rows
          if (_selectedSantri.isEmpty)
            Padding(
              padding: EdgeInsets.symmetric(vertical: 24.h),
              child: Text(
                '-',
                style: TextStyle(
                  fontSize: 14.sp,
                  color: colors.textSecondary,
                  fontFamily: 'Poppins',
                ),
              ),
            )
          else
            ...List.generate(_selectedSantri.length, (index) {
              final santri = _selectedSantri[index];
              return Container(
                padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
                decoration: BoxDecoration(
                  border: Border(
                    top: BorderSide(
                      color: colors.border.withValues(alpha: 0.3),
                    ),
                  ),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            santri.nis,
                            style: TextStyle(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w500,
                              color: colors.primary,
                              fontFamily: 'Poppins',
                            ),
                          ),
                          SizedBox(height: 2.h),
                          Text(
                            santri.nama,
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
                    GestureDetector(
                      onTap: () => _removeSantri(index),
                      child: Padding(
                        padding: EdgeInsets.all(4.w),
                        child: Icon(
                          Icons.delete_outline,
                          size: 20.sp,
                          color: colors.textSecondary,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }),
        ],
      ),
    );
  }
}
