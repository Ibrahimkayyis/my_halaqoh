import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_halaqoh/gen/i18n/translations.g.dart';
import 'package:my_halaqoh/src/core/theme/app_colors.dart';
import 'package:my_halaqoh/src/modules/master_data/presentation/widgets/data_search_bar.dart';
import 'package:my_halaqoh/src/modules/master_data/presentation/widgets/data_list_item.dart';
import 'package:my_halaqoh/src/modules/master_data/presentation/widgets/add_data_method_dialog.dart';
import 'package:my_halaqoh/src/modules/master_data/presentation/widgets/add_manual_guru_dialog.dart';
import 'package:my_halaqoh/src/modules/master_data/presentation/widgets/bulk_upload_dialog.dart';

/// Guru list screen (Tab 2 & Menu Card)
class GuruListScreen extends StatefulWidget {
  final bool showBackButton;

  const GuruListScreen({
    super.key,
    this.showBackButton = false,
  });

  @override
  State<GuruListScreen> createState() => _GuruListScreenState();
}

class _GuruListScreenState extends State<GuruListScreen> {
  final _searchController = TextEditingController();
  List<Map<String, String>> _filteredData = [];

  // Dummy data
  final List<Map<String, String>> _guruData = [
    {'nip': '198501012010011001', 'name': 'Ustadz Ahmad Fauzi, S.Pd.I', 'phone': '081234567890'},
    {'nip': '198805122011012003', 'name': 'Ustadzah Siti Aminah, Lc.', 'phone': '081234567891'},
    {'nip': '199003152015021005', 'name': 'Ustadz Budi Santoso, M.Ag', 'phone': '081234567892'},
    {'nip': '199207202018012002', 'name': 'Ustadzah Dewi Sartika, S.Hum', 'phone': '081234567893'},
    {'nip': '198711102012011004', 'name': 'Ustadz Rahmat Hidayat, Al-Hafizh', 'phone': '081234567894'},
    {'nip': '199502282019022001', 'name': 'Ustadzah Nurul Huda', 'phone': '081234567895'},
    {'nip': '198909092014011002', 'name': 'Ustadz Zainal Abidin', 'phone': '081234567896'},
    {'nip': '199304142017011003', 'name': 'Ustadz Abdullah Faqih', 'phone': '081234567897'},
  ];

  @override
  void initState() {
    super.initState();
    _filteredData = List.from(_guruData);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearch(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredData = List.from(_guruData);
      } else {
        _filteredData = _guruData
            .where((g) =>
                g['name']!.toLowerCase().contains(query.toLowerCase()) ||
                g['nip']!.contains(query))
            .toList();
      }
    });
  }

  void _onEdit(int index) {
    final item = _filteredData[index];
    final srcIndex = _guruData.indexWhere((g) => g['nip'] == item['nip']);

    AddManualGuruDialog.show(
      context,
      initialNip: item['nip'],
      initialNama: item['name'],
      initialPhone: item['phone'],
      onSave: (nip, nama, phone) {
        if (srcIndex >= 0) {
          setState(() {
            _guruData[srcIndex] = {
              'nip': nip ?? item['nip']!,
              'name': nama ?? item['name']!,
              'phone': phone ?? item['phone'] ?? '',
            };
            _onSearch(_searchController.text);
          });
        }
      },
    );
  }

  void _onDelete(int index) {
    final item = _filteredData[index];
    setState(() {
      _guruData.removeWhere((g) => g['nip'] == item['nip']);
      _onSearch(_searchController.text);
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
      body: Column(
        children: [
          SizedBox(height: 8.h),
          // Search (no filter button)
          DataSearchBar(
            searchHint: t.guru.searchHint,
            countText: t.guru.showCount(count: _filteredData.length.toString()),
            filterLabel: t.guru.filter,
            controller: _searchController,
            onChanged: _onSearch,
            showFilterButton: false,
          ),
          SizedBox(height: 12.h),

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
                  id: item['nip']!,
                  name: item['name']!,
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
              onManualTap: () => AddManualGuruDialog.show(context),
              onBulkUploadTap: () => BulkUploadDialog.show(context),
            );
          },
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
