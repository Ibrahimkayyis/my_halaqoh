import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_halaqoh/gen/i18n/translations.g.dart';
import 'package:my_halaqoh/src/core/router/app_router.dart';
import 'package:my_halaqoh/src/core/theme/app_colors.dart';
import 'package:my_halaqoh/src/modules/master_data/domain/models/halaqoh_model.dart';
import 'package:my_halaqoh/src/modules/master_data/presentation/cubits/halaqoh_cubit.dart';
import 'package:my_halaqoh/src/modules/master_data/presentation/cubits/halaqoh_state.dart';
import 'package:my_halaqoh/src/modules/master_data/presentation/widgets/data_search_bar.dart';
import 'package:my_halaqoh/src/modules/master_data/presentation/widgets/halaqoh_card.dart';
import 'package:my_halaqoh/src/core/widget/widgets.dart';
import 'package:my_halaqoh/src/modules/master_data/presentation/cubits/kelas_cubit.dart';
import 'package:my_halaqoh/src/modules/master_data/presentation/cubits/kelas_state.dart';
import 'package:my_halaqoh/src/modules/master_data/presentation/cubits/program_cubit.dart';
import 'package:my_halaqoh/src/modules/master_data/presentation/cubits/program_state.dart';
import 'package:my_halaqoh/src/modules/master_data/domain/models/program_model.dart';

/// Halaqoh list screen (Tab 3 & Menu Card)
class HalaqohListScreen extends StatefulWidget {
  final bool showBackButton;

  const HalaqohListScreen({super.key, this.showBackButton = false});

  @override
  State<HalaqohListScreen> createState() => _HalaqohListScreenState();
}

class _HalaqohListScreenState extends State<HalaqohListScreen> {
  final _searchController = TextEditingController();
  String _searchQuery = '';

  // Filter values
  String? _filterKelas;
  String? _filterProgram;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearch(String query) {
    setState(() => _searchQuery = query.toLowerCase());
  }

  List<HalaqohModel> _applyFilter(List<HalaqohModel> allHalaqoh) {
    return allHalaqoh.where((h) {
      final matchesSearch = _searchQuery.isEmpty ||
          h.nama.toLowerCase().contains(_searchQuery) ||
          h.guruNama.toLowerCase().contains(_searchQuery);

      final matchesKelas = _filterKelas == null || _filterKelas == t.halaqoh.all || h.kelas == _filterKelas;
      final matchesProgram = _filterProgram == null || _filterProgram == t.halaqoh.all ||
          (() {
            final programs = context.read<ProgramCubit>().state.maybeWhen(
              loaded: (list) => list,
              orElse: () => <ProgramModel>[],
            );
            try {
              final selectedProg = programs.firstWhere((p) => p.nama == _filterProgram);
              return h.program == selectedProg.id;
            } catch (_) {
              if (_filterProgram == t.targetHafalan.reguler && h.program == 'R') return true;
              if (_filterProgram == t.targetHafalan.takhassus && h.program == 'T') return true;
              return false;
            }
          })();

      return matchesSearch && matchesKelas && matchesProgram;
    }).toList();
  }

  String _getKelasLabel(HalaqohModel halaqoh) {
    return t.halaqoh.kelasProgramLabel(kelas: halaqoh.kelas, program: halaqoh.program);
  }

  Future<void> _onEdit(HalaqohModel halaqoh) async {
    // Navigate to AddHalaqohScreen, passing existing halaqoh
    await context.router.push(AddHalaqohRoute(existingHalaqoh: halaqoh));
  }

  Future<void> _onDelete(HalaqohModel halaqoh) async {
    final confirmed = await ConfirmDeleteDialog.show(context);
    if (!confirmed) return;
    if (!mounted) return;
    context.read<HalaqohCubit>().deleteHalaqoh(halaqoh.id);
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
          t.halaqoh.title,
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.w700,
            color: colors.textPrimary,
            fontFamily: 'Poppins',
          ),
        ),
        centerTitle: false,
      ),
      body: BlocBuilder<HalaqohCubit, HalaqohState>(
        builder: (context, state) {
          return state.when(
            initial: () => _buildShimmerList(),
            loading: () => _buildShimmerList(),
            error: (message) => Center(
              child: Text(message,
                  style: TextStyle(color: colors.error, fontFamily: 'Poppins')),
            ),
            loaded: (halaqohList) {
              final filtered = _applyFilter(halaqohList);
              return Column(
                children: [
                  SizedBox(height: 8.h),
                  DataSearchBar(
                    searchHint: t.halaqoh.searchHint,
                    countText: t.halaqoh.showCount(
                      count: filtered.length.toString(),
                    ),
                    filterLabel: t.halaqoh.sort,
                    controller: _searchController,
                    onChanged: _onSearch,
                    showFilterButton: false,
                  ),
                  SizedBox(height: 8.h),
                  _buildFilterRow(colors),
                  SizedBox(height: 8.h),
                  Expanded(
                    child: filtered.isEmpty
                        ? Center(
                            child: Text(
                              t.halaqoh.emptyList,
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
                              final halaqoh = filtered[index];
                              return HalaqohCard(
                                name: halaqoh.nama,
                                kelasLabel: _getKelasLabel(halaqoh),
                                teacherName: halaqoh.guruNama,
                                santriCount: t.halaqoh.santriCount(
                                  count: halaqoh.jumlahSantri.toString(),
                                ),
                                onDetailTap: () => _onEdit(halaqoh),
                                onDeleteTap: () => _onDelete(halaqoh),
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
          onPressed: () async {
            await context.router.push(AddHalaqohRoute());
          },
          backgroundColor: colors.primary,
          child: Icon(Icons.add, color: colors.textOnButton),
        ),
      ),
    );
  }

  Widget _buildShimmerList() {
    return ListView.builder(
      padding: EdgeInsets.only(bottom: 80.h, top: 8.h),
      itemCount: 4, // Show 4 shimmer items for Halaqoh
      itemBuilder: (context, index) {
        return const ShimmerHalaqohCard();
      },
    );
  }

  Widget _buildFilterRow(AppColorSet colors) {
    final kelasState = context.watch<KelasCubit>().state;
    final kelasOptions = [
      t.halaqoh.all,
      ...kelasState.maybeWhen(
        loaded: (list) => list.map((k) => k.nama).toList(),
        orElse: () => <String>[],
      ),
    ];

    final programState = context.watch<ProgramCubit>().state;
    final programOptions = [
      t.halaqoh.all,
      ...programState.maybeWhen(
        loaded: (list) => list.map((p) => p.nama).toList(),
        orElse: () => <String>[],
      ),
    ];

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Row(
        children: [
          Expanded(
            child: CustomDropdown<String>(
              hintText: t.addData.kelas,
              items: kelasOptions,
              initialItem: kelasOptions.contains(_filterKelas) ? _filterKelas : null,
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
              hintText: t.addHalaqoh.program,
              items: programOptions,
              initialItem: programOptions.contains(_filterProgram) ? _filterProgram : null,
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
}
