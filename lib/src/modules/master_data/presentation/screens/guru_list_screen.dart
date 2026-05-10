import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_halaqoh/gen/i18n/translations.g.dart';
import 'package:my_halaqoh/src/core/theme/app_colors.dart';
import 'package:my_halaqoh/src/modules/master_data/domain/models/guru_model.dart';
import 'package:my_halaqoh/src/modules/master_data/presentation/cubits/guru_cubit.dart';
import 'package:my_halaqoh/src/modules/master_data/presentation/cubits/guru_state.dart';
import 'package:my_halaqoh/src/modules/master_data/presentation/widgets/data_search_bar.dart';
import 'package:my_halaqoh/src/modules/master_data/presentation/widgets/data_list_item.dart';
import 'package:my_halaqoh/src/modules/master_data/presentation/widgets/add_data_method_dialog.dart';
import 'package:my_halaqoh/src/modules/master_data/presentation/widgets/add_manual_guru_dialog.dart';
import 'package:my_halaqoh/src/modules/master_data/presentation/widgets/bulk_upload_dialog.dart';
import 'package:my_halaqoh/src/core/widget/dialog/confirm_delete_dialog.dart';

/// Guru list screen (Tab 2 & Menu Card)
class GuruListScreen extends StatefulWidget {
  final bool showBackButton;

  const GuruListScreen({super.key, this.showBackButton = false});

  @override
  State<GuruListScreen> createState() => _GuruListScreenState();
}

class _GuruListScreenState extends State<GuruListScreen> {
  final _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearch(String query) {
    setState(() => _searchQuery = query.toLowerCase());
  }

  List<GuruModel> _applyFilter(List<GuruModel> allGuru) {
    if (_searchQuery.isEmpty) return allGuru;
    return allGuru
        .where((g) =>
            g.nama.toLowerCase().contains(_searchQuery) ||
            g.nip.contains(_searchQuery))
        .toList();
  }

  void _onEdit(GuruModel guru) {
    AddManualGuruDialog.show(
      context,
      initialNip: guru.nip,
      initialNama: guru.nama,
      initialPhone: guru.phone,
      initialProgram: guru.program,
      initialProfilePicture: guru.profilePicture,
      onSave: (nip, nama, phone, program, profilePicture) {
        final updated = guru.copyWith(
          nip: nip ?? guru.nip,
          nama: nama ?? guru.nama,
          phone: phone, // Null is allowed for phone
          program: program ?? guru.program,
          profilePicture: profilePicture ?? guru.profilePicture,
          updatedAt: DateTime.now(),
        );
        context.read<GuruCubit>().updateGuru(updated);
      },
    );
  }

  Future<void> _onDelete(GuruModel guru) async {
    final confirmed = await ConfirmDeleteDialog.show(context);
    if (!confirmed) return;
    if (!mounted) return;
    context.read<GuruCubit>().deleteGuru(guru.id);
  }

  Future<void> _onResetPassword(GuruModel guru) async {
    if (guru.authUid == null || guru.authUid!.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Guru ini belum memiliki akun yang terhubung.', style: TextStyle(fontFamily: 'Poppins')),
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
            'Apakah Anda yakin ingin mereset password untuk ${guru.nama}? Password akan dikembalikan ke default "generasi554".',
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

    final error = await context.read<GuruCubit>().resetPassword(guru.authUid!);

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
      onManualTap: () => AddManualGuruDialog.show(
        context,
        onSave: (nip, nama, phone, program, profilePicture) {
          final now = DateTime.now();
          final model = GuruModel(
            id: '', // will be set by Firestore
            nip: nip ?? '',
            nama: nama ?? '',
            phone: phone, // null allowed
            program: program ?? 'R',
            profilePicture: profilePicture,
            createdAt: now,
            updatedAt: now,
          );
          context.read<GuruCubit>().addGuru(model);
        },
      ),
      onBulkUploadTap: () => BulkUploadDialog.show(context, importType: BulkImportType.guru),
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
          t.guru.title,
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.w700,
            color: colors.textPrimary,
            fontFamily: 'Poppins',
          ),
        ),
        centerTitle: false,
      ),
      body: BlocBuilder<GuruCubit, GuruState>(
        builder: (context, state) {
          return state.when(
            initial: () => const SizedBox.shrink(),
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (message) => Center(
              child: Text(message,
                  style: TextStyle(color: colors.error, fontFamily: 'Poppins')),
            ),
            loaded: (guruList) {
              final filtered = _applyFilter(guruList);
              return Column(
                children: [
                  SizedBox(height: 8.h),
                  DataSearchBar(
                    searchHint: t.guru.searchHint,
                    countText:
                        t.guru.showCount(count: filtered.length.toString()),
                    filterLabel: t.guru.filter,
                    controller: _searchController,
                    onChanged: _onSearch,
                    showFilterButton: false,
                  ),
                  SizedBox(height: 12.h),
                  _buildTableHeader(colors),
                  Expanded(
                    child: filtered.isEmpty
                        ? Center(
                            child: Text(
                              'Belum ada data guru',
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
                              final guru = filtered[index];
                              return DataListItem(
                                id: guru.nip,
                                name: guru.nama,
                                onEdit: () => _onEdit(guru),
                                onDelete: () => _onDelete(guru),
                                onResetPassword: () => _onResetPassword(guru),
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

  Widget _buildTableHeader(AppColorSet colors) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Row(
        children: [
          Expanded(
            child: Text(
              t.guru.identitas,
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
              t.guru.aksi,
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
