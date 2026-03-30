import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_halaqoh/gen/i18n/translations.g.dart';
import 'package:my_halaqoh/src/core/theme/app_colors.dart';
import 'package:my_halaqoh/src/modules/master_data/presentation/widgets/data_search_bar.dart';
import 'package:my_halaqoh/src/modules/master_data/presentation/widgets/data_list_item.dart';
import 'package:my_halaqoh/src/modules/master_data/presentation/widgets/add_data_method_dialog.dart';
import 'package:my_halaqoh/src/modules/master_data/presentation/widgets/add_manual_santri_dialog.dart';
import 'package:my_halaqoh/src/modules/master_data/presentation/widgets/bulk_upload_dialog.dart';
import 'package:my_halaqoh/src/core/widget/dialog/confirm_delete_dialog.dart';

/// Santri list screen (Tab 1 & Menu Card)
class SantriListScreen extends StatefulWidget {
  final bool showBackButton;

  const SantriListScreen({super.key, this.showBackButton = false});

  @override
  State<SantriListScreen> createState() => _SantriListScreenState();
}

class _SantriListScreenState extends State<SantriListScreen> {
  final _searchController = TextEditingController();

  // Filter values
  String? _filterKelas;
  String? _filterProgram;

  final List<String> _kelasOptions = ['7', '8', '9', '10', '11', '12'];
  final List<String> _programOptions = ['Reguler', 'Takhassus'];

  // Dummy data with R/T program classes
  final List<Map<String, String>> _santriData = [
    {
      'nis': '202512340001',
      'name': 'Agha Adli Putrathandie',
      'kelas': '7',
      'program': 'R',
    },
    {
      'nis': '202512340002',
      'name': 'Akmal Satria Wiryawan',
      'kelas': '7',
      'program': 'R',
    },
    {
      'nis': '202512340003',
      'name': 'Daffa Zein Pratama',
      'kelas': '7',
      'program': 'T',
    },
    {
      'nis': '202512340004',
      'name': 'Humam Rasyid Ramadhan',
      'kelas': '8',
      'program': 'R',
    },
    {
      'nis': '202512340005',
      'name': 'Muh. Abhirama Arsanta',
      'kelas': '8',
      'program': 'R',
    },
    {
      'nis': '202512340006',
      'name': 'Radanar Athaullah Henka',
      'kelas': '8',
      'program': 'T',
    },
    {
      'nis': '202512340007',
      'name': 'Raihan Abdul Malik',
      'kelas': '9',
      'program': 'R',
    },
    {
      'nis': '202512340008',
      'name': 'Faris Abdurrahman',
      'kelas': '9',
      'program': 'T',
    },
    {
      'nis': '202512340009',
      'name': 'Azka Maulana Ibrahim',
      'kelas': '10',
      'program': 'R',
    },
    {
      'nis': '202512340010',
      'name': 'Zidane Putra Pratama',
      'kelas': '10',
      'program': 'T',
    },
    {
      'nis': '202512340011',
      'name': 'Haikal Putra Ramadhan',
      'kelas': '11',
      'program': 'R',
    },
    {
      'nis': '202512340012',
      'name': 'Farrel Athallah Putra',
      'kelas': '12',
      'program': 'T',
    },
  ];

  List<Map<String, String>> _filteredData = [];

  @override
  void initState() {
    super.initState();
    _filteredData = List.from(_santriData);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _applyFilters() {
    setState(() {
      _filteredData = _santriData.where((s) {
        final query = _searchController.text.toLowerCase();
        final matchesSearch =
            query.isEmpty ||
            s['name']!.toLowerCase().contains(query) ||
            s['nis']!.contains(query);

        final matchesKelas = _filterKelas == null || s['kelas'] == _filterKelas;
        final matchesProgram =
            _filterProgram == null ||
            (_filterProgram == 'Reguler' && s['program'] == 'R') ||
            (_filterProgram == 'Takhassus' && s['program'] == 'T');

        return matchesSearch && matchesKelas && matchesProgram;
      }).toList();
    });
  }

  void _onSearch(String query) {
    _applyFilters();
  }

  Color _getProgramColor(String program) {
    final colors = AppColors.of(context);
    return program == 'R' ? colors.primary : colors.blue;
  }

  String _getBadgeLabel(Map<String, String> item) {
    final program = item['program'] == 'R' ? 'R' : 'T';
    return '${item['kelas']}$program';
  }

  void _onEdit(int index) {
    final item = _filteredData[index];
    // Find actual index in source list
    final srcIndex = _santriData.indexWhere((s) => s['nis'] == item['nis']);

    AddManualSantriDialog.show(
      context,
      initialNis: item['nis'],
      initialNama: item['name'],
      initialKelas: '${item['kelas']}${item['program']}',
      onSave: (nis, nama, kelas) {
        if (srcIndex >= 0) {
          setState(() {
            // Parse kelas back: e.g. "7R" -> kelas:"7", program:"R"
            final k = kelas?.replaceAll(RegExp(r'[RT]'), '') ?? item['kelas']!;
            final p = kelas != null && kelas.endsWith('T') ? 'T' : 'R';
            _santriData[srcIndex] = {
              'nis': nis ?? item['nis']!,
              'name': nama ?? item['name']!,
              'kelas': k,
              'program': p,
            };
            _applyFilters();
          });
        }
      },
    );
  }

  Future<void> _onDelete(int index) async {
    final item = _filteredData[index];
    final confirmed = await ConfirmDeleteDialog.show(context);
    if (!confirmed) return;

    setState(() {
      _santriData.removeWhere((s) => s['nis'] == item['nis']);
      _applyFilters();
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
      ),
      body: Column(
        children: [
          SizedBox(height: 8.h),
          // Search
          DataSearchBar(
            searchHint: t.santri.searchHint,
            countText: t.santri.showCount(
              count: _filteredData.length.toString(),
            ),
            filterLabel: t.santri.filter,
            controller: _searchController,
            onChanged: _onSearch,
            showFilterButton: false,
          ),
          SizedBox(height: 8.h),

          // Filter dropdowns
          _buildFilterRow(colors),
          SizedBox(height: 8.h),

          // Table header
          _buildTableHeader(colors),

          // List
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.only(bottom: 80.h),
              itemCount: _filteredData.length,
              itemBuilder: (context, index) {
                final item = _filteredData[index];
                return DataListItem(
                  id: item['nis']!,
                  name: item['name']!,
                  badge: _getBadgeLabel(item),
                  badgeColor: _getProgramColor(item['program']!),
                  onEdit: () => _onEdit(index),
                  onDelete: () => _onDelete(index),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: Padding(
        padding: EdgeInsets.only(bottom: 70.h),
        child: FloatingActionButton(
          onPressed: () {
            AddDataMethodDialog.show(
              context,
              onManualTap: () => AddManualSantriDialog.show(
                context,
                onSave: (nis, nama, kelas) {
                  setState(() {
                    final k = kelas?.replaceAll(RegExp(r'[RT]'), '') ?? '7';
                    final p = kelas != null && kelas.endsWith('T') ? 'T' : 'R';
                    _santriData.add({
                      'nis': nis ?? '',
                      'name': nama ?? '',
                      'kelas': k,
                      'program': p,
                    });
                    _applyFilters();
                  });
                },
              ),
              onBulkUploadTap: () => BulkUploadDialog.show(context),
            );
          },
          backgroundColor: colors.primary,
          child: Icon(Icons.add, color: colors.textOnButton),
        ),
      ),
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
                _filterKelas = value;
                _applyFilters();
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
                _filterProgram = value;
                _applyFilters();
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
