import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_halaqoh/gen/i18n/translations.g.dart';
import 'package:my_halaqoh/src/core/theme/app_colors.dart';
import 'package:my_halaqoh/src/core/widget/widgets.dart';
import 'package:my_halaqoh/src/modules/master_data/domain/models/santri_model.dart';
import 'package:my_halaqoh/src/modules/master_data/presentation/cubits/santri_cubit.dart';
import 'package:my_halaqoh/src/modules/master_data/presentation/cubits/santri_state.dart';
import 'package:my_halaqoh/src/modules/master_data/presentation/widgets/data_search_bar.dart';
import 'package:my_halaqoh/src/modules/master_data/presentation/widgets/data_list_item.dart';
import 'package:my_halaqoh/src/modules/master_data/presentation/widgets/add_data_method_dialog.dart';
import 'package:my_halaqoh/src/modules/master_data/presentation/widgets/add_manual_santri_dialog.dart';
import 'package:my_halaqoh/src/modules/master_data/presentation/widgets/bulk_upload_dialog.dart';
import 'package:my_halaqoh/src/modules/master_data/presentation/widgets/kenaikan_kelas_bottom_sheet.dart';

/// Santri list screen (Tab 1 & Menu Card)
class SantriListScreen extends StatefulWidget {
  final bool showBackButton;

  const SantriListScreen({super.key, this.showBackButton = false});

  @override
  State<SantriListScreen> createState() => _SantriListScreenState();
}

class _SantriListScreenState extends State<SantriListScreen> {
  final _searchController = TextEditingController();
  String _searchQuery = '';

  // Filter values
  String? _filterKelas;
  String? _filterProgram;
  bool _showAlumni = false; // default: alumni disembunyikan

  final List<String> _kelasOptions = ['Semua', '7', '8', '9', '10', '11', '12'];
  final List<String> _programOptions = ['Semua', 'Reguler', 'Takhassus'];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearch(String query) {
    setState(() => _searchQuery = query.toLowerCase());
  }

  List<SantriModel> _applyFilter(List<SantriModel> allSantri) {
    return allSantri.where((s) {
      // Filter alumni: tampilkan hanya alumni ATAU hanya aktif
      if (_showAlumni && !s.isAlumni) return false;
      if (!_showAlumni && s.isAlumni) return false;

      final matchesSearch = _searchQuery.isEmpty ||
          s.nama.toLowerCase().contains(_searchQuery) ||
          s.nis.contains(_searchQuery);

      final matchesKelas = _filterKelas == null || _filterKelas == 'Semua' || s.kelas == _filterKelas;
      final matchesProgram = _filterProgram == null || _filterProgram == 'Semua' ||
          (_filterProgram == 'Reguler' && s.program == 'R') ||
          (_filterProgram == 'Takhassus' && s.program == 'T');

      return matchesSearch && matchesKelas && matchesProgram;
    }).toList();
  }

  Color _getProgramColor(String program) {
    final colors = AppColors.of(context);
    return program == 'R' ? colors.primary : colors.blue;
  }

  String _getBadgeLabel(SantriModel santri) {
    return '${santri.kelas}${santri.program}';
  }

  void _onEdit(SantriModel santri) {
    AddManualSantriDialog.show(
      context,
      initialNis: santri.nis,
      initialNama: santri.nama,
      initialKelas: '${santri.kelas}${santri.program}',
      initialProfilePicture: santri.profilePicture,
      onSave: (nis, nama, kelas, profilePicture) async {
        final k = kelas?.replaceAll(RegExp(r'[RT]'), '') ?? santri.kelas;
        final p = kelas != null && kelas.endsWith('T') ? 'T' : 'R';
        final updated = santri.copyWith(
          nis: nis ?? santri.nis,
          nama: nama ?? santri.nama,
          kelas: k,
          program: p,
          profilePicture: profilePicture ?? santri.profilePicture,
          updatedAt: DateTime.now(),
        );
        await context.read<SantriCubit>().updateSantri(updated);
      },
    );
  }

  Future<void> _onDelete(SantriModel santri) async {
    final confirmed = await ConfirmDeleteDialog.show(context);
    if (!confirmed) return;
    if (!mounted) return;
    context.read<SantriCubit>().deleteSantri(santri.id);
  }

  Future<void> _onResetPassword(SantriModel santri) async {
    if (santri.authUid == null || santri.authUid!.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Santri ini belum memiliki akun yang terhubung.', style: TextStyle(fontFamily: 'Poppins')),
          backgroundColor: AppColors.of(context).error,
        ),
      );
      return;
    }

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        final colors = AppColors.of(context);
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          backgroundColor: colors.surface,
          title: Text(
            'Reset Password',
            style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.bold, color: colors.textPrimary),
          ),
          content: Text(
            'Apakah Anda yakin ingin mereset password untuk ${santri.nama}? Password akan dikembalikan ke default "generasi554".',
            style: TextStyle(fontFamily: 'Poppins', color: colors.textSecondary),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text('Batal', style: TextStyle(fontFamily: 'Poppins', color: colors.textSecondary)),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: Text('Ya, Reset', style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.bold, color: colors.primary)),
            ),
          ],
        );
      },
    );

    if (confirmed != true) return;
    if (!mounted) return;

    // Show loading
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    final error = await context.read<SantriCubit>().resetPassword(santri.authUid!);

    if (!mounted) return;
    Navigator.pop(context); // close loading

    if (error == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Password berhasil direset ke "generasi554".', style: TextStyle(fontFamily: 'Poppins')),
          backgroundColor: AppColors.of(context).success,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error, style: const TextStyle(fontFamily: 'Poppins')),
          backgroundColor: AppColors.of(context).error,
        ),
      );
    }
  }

  void _onAdd() {
    AddDataMethodDialog.show(
      context,
      onManualTap: () => AddManualSantriDialog.show(
        context,
        onSave: (nis, nama, kelas, profilePicture) async {
          final k = kelas?.replaceAll(RegExp(r'[RT]'), '') ?? '7';
          final p = kelas != null && kelas.endsWith('T') ? 'T' : 'R';
          final now = DateTime.now();
          final model = SantriModel(
            id: '', // will be set by Firestore
            nis: nis ?? '',
            nama: nama ?? '',
            kelas: k,
            program: p,
            profilePicture: profilePicture,
            createdAt: now,
            updatedAt: now,
          );
          await context.read<SantriCubit>().addSantri(model);
        },
      ),
      onBulkUploadTap: () => BulkUploadDialog.show(context, importType: BulkImportType.santri),
    );
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
        automaticallyImplyLeading: widget.showBackButton,
        iconTheme: IconThemeData(color: colors.textPrimary),
        title: Text(
          t.santri.title,
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.w700,
            color: colors.textPrimary,
            fontFamily: 'Poppins',
          ),
        ),
        centerTitle: false,
        actions: [
          // Toggle alumni
          BlocBuilder<SantriCubit, SantriState>(
            builder: (context, state) {
              final alumniCount = state.maybeWhen(
                loaded: (list) => list.where((s) => s.isAlumni).length,
                orElse: () => 0,
              );
              if (alumniCount == 0) return const SizedBox.shrink();
              return IconButton(
                tooltip: _showAlumni
                    ? 'Sembunyikan Alumni ($alumniCount)'
                    : 'Tampilkan Alumni ($alumniCount)',
                icon: Icon(
                  _showAlumni
                      ? Icons.unarchive_outlined
                      : Icons.archive_outlined,
                  color: _showAlumni ? colors.primary : colors.textSecondary,
                ),
                onPressed: () => setState(() => _showAlumni = !_showAlumni),
              );
            },
          ),
          // Kenaikan Kelas
          BlocBuilder<SantriCubit, SantriState>(
            builder: (context, state) {
              return Padding(
                padding: EdgeInsets.only(right: 8.w),
                child: Tooltip(
                  message: 'Proses Kenaikan Kelas',
                  child: InkWell(
                    onTap: () {
                      final aktivSantri = state.maybeWhen(
                        loaded: (list) =>
                            list.where((s) => !s.isAlumni).toList(),
                        orElse: () => <SantriModel>[],
                      );
                      if (aktivSantri.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: const Text(
                              'Tidak ada santri aktif untuk diproses.',
                              style: TextStyle(fontFamily: 'Poppins'),
                            ),
                            backgroundColor: colors.error,
                          ),
                        );
                        return;
                      }
                      KenaikanKelasBottomSheet.show(
                        context,
                        aktivSantri: aktivSantri,
                      );
                    },
                    borderRadius: BorderRadius.circular(10.r),
                    child: Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 10.w, vertical: 6.h),
                      decoration: BoxDecoration(
                        color: colors.primary.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.upgrade_rounded,
                            color: colors.primary,
                            size: 18.sp,
                          ),
                          SizedBox(width: 4.w),
                          Text(
                            'Naik Kelas',
                            style: TextStyle(
                              fontSize: 11.sp,
                              fontWeight: FontWeight.w600,
                              color: colors.primary,
                              fontFamily: 'Poppins',
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: BlocBuilder<SantriCubit, SantriState>(
        builder: (context, state) {
          return state.when(
            initial: () => _buildShimmerList(),
            loading: () => _buildShimmerList(),
            error: (message) => Center(
              child: Text(message,
                  style: TextStyle(color: colors.error, fontFamily: 'Poppins')),
            ),
            loaded: (santriList) {
              final filtered = _applyFilter(santriList);
              return Column(
                children: [
                  SizedBox(height: 8.h),
                  DataSearchBar(
                    searchHint: t.santri.searchHint,
                    countText: t.santri.showCount(
                      count: filtered.length.toString(),
                    ),
                    filterLabel: t.santri.filter,
                    controller: _searchController,
                    onChanged: _onSearch,
                    showFilterButton: false,
                  ),
                  SizedBox(height: 8.h),
                  _buildFilterRow(colors),
                  SizedBox(height: 8.h),
                  _buildTableHeader(colors),
                  Expanded(
                    child: filtered.isEmpty
                        ? Center(
                            child: Text(
                              'Belum ada data santri',
                              style: TextStyle(
                                color: colors.textSecondary,
                                fontFamily: 'Poppins',
                              ),
                            ),
                          )
                        : ListView.builder(
                            padding: EdgeInsets.only(bottom: 80.h),
                            itemCount: filtered.length,
                            itemBuilder: (context, index) {
                              final santri = filtered[index];
                              return DataListItem(
                                id: santri.nis,
                                name: santri.nama,
                                badge: _getBadgeLabel(santri),
                                badgeColor: _getProgramColor(santri.program),
                                onEdit: () => _onEdit(santri),
                                onDelete: () => _onDelete(santri),
                                onResetPassword: () => _onResetPassword(santri),
                              );
                            },
                          ),
                  ),
                ],
              );
            },
          );
        },
      ),
      floatingActionButton: Padding(
        padding: EdgeInsets.only(bottom: 70.h),
        child: FloatingActionButton(
          onPressed: _onAdd,
          backgroundColor: colors.primary,
          child: Icon(Icons.add, color: colors.textOnButton),
        ),
      ),
    );
  }

  Widget _buildShimmerList() {
    return ListView.builder(
      padding: EdgeInsets.only(bottom: 80.h, top: 16.h),
      itemCount: 6, // Show 6 shimmer items
      itemBuilder: (context, index) {
        return const ShimmerDataListItem();
      },
    );
  }

  Widget _buildFilterRow(AppColorSet colors) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Row(
        children: [
          Expanded(
            child: CustomDropdown<String>(
              hintText: 'Kelas',
              items: _kelasOptions,
              initialItem: _filterKelas,
              onChanged: (value) {
                setState(() => _filterKelas = value);
              },
              closedHeaderPadding: EdgeInsets.symmetric(
                horizontal: 12.w,
                vertical: 10.h,
              ),
              decoration: CustomDropdownDecoration(
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
                  color: colors.textSecondary,
                  fontFamily: 'Poppins',
                ),
                listItemStyle: TextStyle(
                  fontSize: 13.sp,
                  color: colors.textPrimary,
                  fontFamily: 'Poppins',
                ),
              ),
            ),
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: CustomDropdown<String>(
              hintText: 'Program',
              items: _programOptions,
              initialItem: _filterProgram,
              onChanged: (value) {
                setState(() => _filterProgram = value);
              },
              closedHeaderPadding: EdgeInsets.symmetric(
                horizontal: 12.w,
                vertical: 10.h,
              ),
              decoration: CustomDropdownDecoration(
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
                  color: colors.textSecondary,
                  fontFamily: 'Poppins',
                ),
                listItemStyle: TextStyle(
                  fontSize: 13.sp,
                  color: colors.textPrimary,
                  fontFamily: 'Poppins',
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTableHeader(AppColorSet colors) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Row(
        children: [
          Expanded(
            flex: 3,
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
            width: 50.w,
            child: Text(
              t.santri.kelas,
              textAlign: TextAlign.center,
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
            width: 60.w,
            child: Text(
              t.santri.aksi,
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
    );
  }
}
