import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_halaqoh/gen/i18n/translations.g.dart';
import 'package:my_halaqoh/src/core/theme/app_colors.dart';
import 'package:my_halaqoh/src/core/widget/widgets.dart';
import 'package:my_halaqoh/src/modules/master_data/domain/models/santri_model.dart';
import 'package:my_halaqoh/src/modules/master_data/presentation/cubits/santri_cubit.dart';
import 'package:my_halaqoh/src/modules/master_data/presentation/cubits/santri_state.dart';

/// Screen for selecting santri to add to a halaqoh
@RoutePage()
class SelectSantriScreen extends StatefulWidget {
  final Set<String> assignedSantriIds;

  const SelectSantriScreen({
    super.key,
    this.assignedSantriIds = const {},
  });

  @override
  State<SelectSantriScreen> createState() => _SelectSantriScreenState();
}

class _SelectSantriScreenState extends State<SelectSantriScreen> {
  final _searchController = TextEditingController();
  String _searchQuery = '';
  final Set<String> _selectedIds = {};

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearch(String query) {
    setState(() => _searchQuery = query.toLowerCase());
  }

  List<SantriModel> _applyFilter(List<SantriModel> allSantri) {
    // Filter out those already assigned
    final available = allSantri
        .where((s) => !widget.assignedSantriIds.contains(s.id))
        .toList();

    if (_searchQuery.isEmpty) return available;
    return available
        .where((s) =>
            s.nama.toLowerCase().contains(_searchQuery) ||
            s.nis.contains(_searchQuery))
        .toList();
  }

  void _toggleSelect(String id) {
    setState(() {
      if (_selectedIds.contains(id)) {
        _selectedIds.remove(id);
      } else {
        _selectedIds.add(id);
      }
    });
  }

  void _confirmSelection(List<SantriModel> allSantri) {
    final selected = allSantri
        .where((s) => _selectedIds.contains(s.id))
        .toList();
    context.router.maybePop(selected);
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
        iconTheme: IconThemeData(color: colors.textPrimary),
        title: Text(
          t.selectSantri.title,
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.w700,
            color: colors.textPrimary,
            fontFamily: 'Poppins',
          ),
        ),
        centerTitle: false,
      ),
      body: BlocBuilder<SantriCubit, SantriState>(
        builder: (context, state) {
          return state.when(
            initial: () => const SizedBox.shrink(),
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (message) => Center(
              child: Text(message,
                  style: TextStyle(color: colors.error, fontFamily: 'Poppins')),
            ),
            loaded: (santriList) {
              final filtered = _applyFilter(santriList);
              return Column(
                children: [
                  SizedBox(height: 8.h),
                  // Search field
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    child: TextField(
                      controller: _searchController,
                      onChanged: _onSearch,
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontFamily: 'Poppins',
                        color: colors.textPrimary,
                      ),
                      decoration: InputDecoration(
                        hintText: t.selectSantri.searchHint,
                        hintStyle: TextStyle(
                          fontSize: 14.sp,
                          color: colors.textSecondary.withValues(alpha: 0.5),
                          fontFamily: 'Poppins',
                        ),
                        prefixIcon: Icon(
                          Icons.search,
                          color: colors.textSecondary,
                          size: 20.sp,
                        ),
                        contentPadding: EdgeInsets.symmetric(vertical: 12.h),
                        filled: true,
                        fillColor: colors.surface,
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.r),
                          borderSide: BorderSide(color: colors.border),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.r),
                          borderSide: BorderSide(color: colors.primary),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 10.h),

                  // Filter + count
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    child: Row(
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 12.w,
                            vertical: 6.h,
                          ),
                          decoration: BoxDecoration(
                            color: colors.surface,
                            borderRadius: BorderRadius.circular(8.r),
                            border: Border.all(color: colors.border),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.tune,
                                  size: 16.sp, color: colors.textSecondary),
                              SizedBox(width: 6.w),
                              Text(
                                t.selectSantri.filter,
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w600,
                                  color: colors.textPrimary,
                                  fontFamily: 'Poppins',
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Spacer(),
                        Text(
                          t.selectSantri.countLabel(
                              count: santriList.length.toString()),
                          style: TextStyle(
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w500,
                            color: colors.textSecondary,
                            fontFamily: 'Poppins',
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 12.h),

                  // Info Text if any hidden
                  if (widget.assignedSantriIds.isNotEmpty) ...[
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      child: Text(
                        '* ${widget.assignedSantriIds.length} santri disembunyikan karena sudah berada di halaqoh lain.',
                        style: TextStyle(
                          fontSize: 11.sp,
                          color: colors.primary,
                          fontStyle: FontStyle.italic,
                          fontFamily: 'Poppins',
                        ),
                      ),
                    ),
                    SizedBox(height: 8.h),
                  ],

                  // Table header
                  _buildTableHeader(colors),
                  SizedBox(height: 4.h),

                  // List
                  Expanded(
                    child: filtered.isEmpty
                        ? Center(
                            child: Text(
                              'Tidak ada santri',
                              style: TextStyle(
                                color: colors.textSecondary,
                                fontFamily: 'Poppins',
                              ),
                            ),
                          )
                        : ListView.builder(
                            padding: EdgeInsets.only(bottom: 16.h),
                            itemCount: filtered.length,
                            itemBuilder: (context, index) {
                              final santri = filtered[index];
                              final isSelected =
                                  _selectedIds.contains(santri.id);
                              return _buildRow(colors, santri, isSelected);
                            },
                          ),
                  ),

                  // Bottom bar
                  Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
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
                          onPressed: _selectedIds.isEmpty
                              ? null
                              : () => _confirmSelection(santriList),
                          icon: Icons.check,
                          label: t.selectSantri.tambahkanButton(
                            count: _selectedIds.length.toString(),
                          ),
                          borderRadius: 25.r,
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildTableHeader(AppColorSet colors) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Row(
        children: [
          SizedBox(
            width: 55.w,
            child: Text(
              t.selectSantri.nis,
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
              t.selectSantri.nama,
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
              t.selectSantri.kelas,
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
          SizedBox(width: 36.w), // checkbox space
        ],
      ),
    );
  }

  Widget _buildRow(AppColorSet colors, SantriModel santri, bool isSelected) {
    return InkWell(
      onTap: () => _toggleSelect(santri.id),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        child: Row(
          children: [
            // NIS
            SizedBox(
              width: 55.w,
              child: Text(
                santri.nis,
                style: TextStyle(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w400,
                  color: colors.textSecondary,
                  fontFamily: 'Poppins',
                ),
              ),
            ),
            // Name
            Expanded(
              child: Text(
                santri.nama,
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
            // Kelas badge
            SizedBox(
              width: 50.w,
              child: Center(
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 8.w,
                    vertical: 2.h,
                  ),
                  decoration: BoxDecoration(
                    color: colors.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(6.r),
                  ),
                  child: Text(
                    '${santri.kelas}${santri.program}',
                    style: TextStyle(
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w600,
                      color: colors.primary,
                      fontFamily: 'Poppins',
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(width: 12.w),
            // Checkbox circle
            Container(
              width: 24.w,
              height: 24.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected ? colors.primary : Colors.transparent,
                border: Border.all(
                  color: isSelected ? colors.primary : colors.border,
                  width: 2,
                ),
              ),
              child: isSelected
                  ? Center(
                      child: Icon(
                        Icons.check,
                        size: 14.sp,
                        color: colors.textOnButton,
                      ),
                    )
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}
