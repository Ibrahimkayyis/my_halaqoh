import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_halaqoh/gen/i18n/translations.g.dart';
import 'package:my_halaqoh/src/core/router/app_router.dart';
import 'package:my_halaqoh/src/core/theme/app_colors.dart';

/// Screen for creating a new Halaqoh group
@RoutePage()
class AddHalaqohScreen extends StatefulWidget {
  const AddHalaqohScreen({super.key});

  @override
  State<AddHalaqohScreen> createState() => _AddHalaqohScreenState();
}

class _AddHalaqohScreenState extends State<AddHalaqohScreen> {
  final _namaController = TextEditingController();
  String? _selectedKelas;
  String? _selectedProgram;
  String? _selectedGuru;

  final List<String> _kelasList = ['7', '8', '9', '10', '11', '12'];
  final List<String> _programList = ['Reguler', 'Takhassus'];
  final List<String> _guruList = [
    'Ust. Ahmad Rofiqi',
    'Ust. Farhan Majid',
    'Ust. Maulana Ilyas',
    'Ust. Abdullah Faqih',
    'Ust. Zainal Abidin',
    'Ustdz. Siti Aminah, Lc.',
    'Ust. Budi Santoso, M.Ag',
    'Ustdz. Dewi Sartika, S.Hum',
  ];

  // Selected santri for this halaqoh
  List<Map<String, String>> _selectedSantri = [];

  @override
  void dispose() {
    _namaController.dispose();
    super.dispose();
  }

  Future<void> _navigateToSelectSantri() async {
    final result = await context.router.push<List<Map<String, String>>>(
      const SelectSantriRoute(),
    );
    if (result != null && result.isNotEmpty) {
      setState(() {
        // Merge with existing, avoid duplicates
        for (final santri in result) {
          if (!_selectedSantri.any((s) => s['nis'] == santri['nis'])) {
            _selectedSantri.add(santri);
          }
        }
      });
    }
  }

  void _removeSantri(int index) {
    setState(() {
      _selectedSantri.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);

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
                              onChanged: (v) => setState(() => _selectedKelas = v),
                              closedHeaderPadding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
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
                              onChanged: (v) => setState(() => _selectedProgram = v),
                              closedHeaderPadding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
                              decoration: _dropdownDecoration(colors),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20.h),

                  // Pengampu (Guru) - searchable dropdown
                  _buildLabel(colors, t.addHalaqoh.pengampu),
                  SizedBox(height: 8.h),
                  CustomDropdown<String>.search(
                    hintText: t.addHalaqoh.pengampuHint,
                    items: _guruList,
                    initialItem: _selectedGuru,
                    excludeSelected: false,
                    onChanged: (v) => setState(() => _selectedGuru = v),
                    closedHeaderPadding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
                    decoration: _dropdownDecoration(colors),
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
                        onTap: _navigateToSelectSantri,
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 14.w,
                            vertical: 6.h,
                          ),
                          decoration: BoxDecoration(
                            color: colors.primary.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(8.r),
                            border: Border.all(
                              color: colors.primary,
                              width: 1,
                            ),
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
                child: ElevatedButton.icon(
                  onPressed: () {
                    // TODO: Save halaqoh
                    context.router.maybePop();
                  },
                  icon: Icon(Icons.save, size: 20.sp),
                  label: Text(
                    t.addHalaqoh.simpanHalaqoh,
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w700,
                      fontFamily: 'Poppins',
                      letterSpacing: 0.5,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colors.primary,
                    foregroundColor: colors.textOnButton,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25.r),
                    ),
                    elevation: 0,
                  ),
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
        contentPadding: EdgeInsets.symmetric(
          horizontal: 16.w,
          vertical: 14.h,
        ),
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
                SizedBox(
                  width: 50.w,
                  child: Text(
                    t.addHalaqoh.nis,
                    style: TextStyle(
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w600,
                      color: colors.textSecondary,
                      letterSpacing: 0.5,
                      fontFamily: 'Poppins',
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    t.addHalaqoh.namaSantri,
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
                padding: EdgeInsets.symmetric(
                  horizontal: 14.w,
                  vertical: 12.h,
                ),
                decoration: BoxDecoration(
                  border: Border(
                    top: BorderSide(
                      color: colors.border.withValues(alpha: 0.3),
                    ),
                  ),
                ),
                child: Row(
                  children: [
                    SizedBox(
                      width: 50.w,
                      child: Text(
                        santri['nis'] ?? '',
                        style: TextStyle(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w400,
                          color: colors.textSecondary,
                          fontFamily: 'Poppins',
                        ),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        santri['name'] ?? '',
                        style: TextStyle(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w500,
                          color: colors.textPrimary,
                          fontFamily: 'Poppins',
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
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
