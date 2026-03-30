import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_halaqoh/gen/i18n/translations.g.dart';
import 'package:my_halaqoh/src/core/router/app_router.dart';
import 'package:my_halaqoh/src/core/theme/app_colors.dart';
import 'package:my_halaqoh/src/modules/master_data/presentation/widgets/data_search_bar.dart';
import 'package:my_halaqoh/src/modules/master_data/presentation/widgets/halaqoh_card.dart';
import 'package:my_halaqoh/src/core/widget/dialog/confirm_delete_dialog.dart';

/// Halaqoh list screen (Tab 3 & Menu Card)
class HalaqohListScreen extends StatefulWidget {
  final bool showBackButton;

  const HalaqohListScreen({super.key, this.showBackButton = false});

  @override
  State<HalaqohListScreen> createState() => _HalaqohListScreenState();
}

class _HalaqohListScreenState extends State<HalaqohListScreen> {
  final _searchController = TextEditingController();

  // Filter values
  String? _filterKelas;
  String? _filterProgram;

  final List<String> _kelasOptions = ['7', '8', '9', '10', '11', '12'];
  final List<String> _programOptions = ['Reguler', 'Takhassus'];

  // Dummy data with R/T program classes
  final List<Map<String, dynamic>> _halaqohData = [
    {
      'name': 'Halaqoh 7R-1',
      'kelas': '7',
      'program': 'R',
      'guru': 'Ust. Ahmad Rofiqi',
      'santri': 10,
    },
    {
      'name': 'Halaqoh 7R-2',
      'kelas': '7',
      'program': 'R',
      'guru': 'Ust. Farhan Majid',
      'santri': 9,
    },
    {
      'name': 'Halaqoh 7T',
      'kelas': '7',
      'program': 'T',
      'guru': 'Ust. Maulana Ilyas',
      'santri': 10,
    },
    {
      'name': 'Halaqoh 8R-1',
      'kelas': '8',
      'program': 'R',
      'guru': 'Ust. Abdullah Faqih',
      'santri': 11,
    },
    {
      'name': 'Halaqoh 8R-2',
      'kelas': '8',
      'program': 'R',
      'guru': 'Ust. Zainal Abidin',
      'santri': 10,
    },
    {
      'name': 'Halaqoh 8T',
      'kelas': '8',
      'program': 'T',
      'guru': 'Ustdz. Siti Aminah, Lc.',
      'santri': 9,
    },
    {
      'name': 'Halaqoh 9R',
      'kelas': '9',
      'program': 'R',
      'guru': 'Ust. Budi Santoso, M.Ag',
      'santri': 12,
    },
    {
      'name': 'Halaqoh 9T',
      'kelas': '9',
      'program': 'T',
      'guru': 'Ustdz. Dewi Sartika, S.Hum',
      'santri': 10,
    },
    {
      'name': 'Halaqoh 10R',
      'kelas': '10',
      'program': 'R',
      'guru': 'Ust. Rahmat Hidayat',
      'santri': 8,
    },
    {
      'name': 'Halaqoh 10T',
      'kelas': '10',
      'program': 'T',
      'guru': 'Ust. Ahmad Fauzi',
      'santri': 7,
    },
    {
      'name': 'Halaqoh 11R',
      'kelas': '11',
      'program': 'R',
      'guru': 'Ustdz. Nurul Huda',
      'santri': 9,
    },
    {
      'name': 'Halaqoh 12T',
      'kelas': '12',
      'program': 'T',
      'guru': 'Ust. Zainal Abidin',
      'santri': 6,
    },
  ];

  List<Map<String, dynamic>> _filteredData = [];

  @override
  void initState() {
    super.initState();
    _filteredData = List.from(_halaqohData);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _applyFilters() {
    setState(() {
      _filteredData = _halaqohData.where((h) {
        final query = _searchController.text.toLowerCase();
        final matchesSearch =
            query.isEmpty ||
            h['name']!.toString().toLowerCase().contains(query) ||
            h['guru']!.toString().toLowerCase().contains(query);

        final matchesKelas = _filterKelas == null || h['kelas'] == _filterKelas;
        final matchesProgram =
            _filterProgram == null ||
            (_filterProgram == 'Reguler' && h['program'] == 'R') ||
            (_filterProgram == 'Takhassus' && h['program'] == 'T');

        return matchesSearch && matchesKelas && matchesProgram;
      }).toList();
    });
  }

  void _onSearch(String query) {
    _applyFilters();
  }

  String _getKelasLabel(Map<String, dynamic> item) {
    final program = item['program'] == 'R' ? 'R' : 'T';
    return 'Kelas ${item['kelas']}$program';
  }

  Future<void> _onEdit(int index) async {
    final item = _filteredData[index];
    final srcIndex = _halaqohData.indexWhere((h) => h['name'] == item['name']);

    // Navigate to AddHalaqohScreen (in edit mode)
    // For now, it doesn't prefill data, but it will return the new data.
    final result = await context.router.push(const AddHalaqohRoute());

    if (result != null && result is Map<String, dynamic> && srcIndex >= 0) {
      setState(() {
        _halaqohData[srcIndex] = result;
        _applyFilters();
      });
    }
  }

  Future<void> _onDelete(int index) async {
    final item = _filteredData[index];
    final confirmed = await ConfirmDeleteDialog.show(context);
    if (!confirmed) return;

    setState(() {
      _halaqohData.removeWhere((h) => h['name'] == item['name']);
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
      body: Column(
        children: [
          SizedBox(height: 8.h),
          // Search
          DataSearchBar(
            searchHint: t.halaqoh.searchHint,
            countText: t.halaqoh.showCount(
              count: _filteredData.length.toString(),
            ),
            filterLabel: t.halaqoh.sort,
            controller: _searchController,
            onChanged: _onSearch,
            showFilterButton: false,
          ),
          SizedBox(height: 8.h),

          // Filter dropdowns
          _buildFilterRow(colors),
          SizedBox(height: 8.h),

          // Card list
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.only(bottom: 80.h),
              itemCount: _filteredData.length,
              itemBuilder: (context, index) {
                final item = _filteredData[index];
                return HalaqohCard(
                  name: item['name'],
                  kelasLabel: _getKelasLabel(item),
                  teacherName: item['guru'],
                  santriCount: t.halaqoh.santriCount(
                    count: item['santri'].toString(),
                  ),
                  onDetailTap: () => _onEdit(index),
                  onDeleteTap: () => _onDelete(index),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: Padding(
        padding: EdgeInsets.only(bottom: 70.h),
        child: FloatingActionButton(
          onPressed: () async {
            final result = await context.router.push(const AddHalaqohRoute());
            if (result != null && result is Map<String, dynamic>) {
              setState(() {
                _halaqohData.add(result);
                _applyFilters();
              });
            }
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
}
