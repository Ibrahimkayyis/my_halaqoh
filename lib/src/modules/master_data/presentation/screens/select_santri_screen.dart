import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_halaqoh/gen/i18n/translations.g.dart';
import 'package:my_halaqoh/src/core/theme/app_colors.dart';

/// Screen for selecting santri to add to a halaqoh
@RoutePage()
class SelectSantriScreen extends StatefulWidget {
  const SelectSantriScreen({super.key});

  @override
  State<SelectSantriScreen> createState() => _SelectSantriScreenState();
}

class _SelectSantriScreenState extends State<SelectSantriScreen> {
  final _searchController = TextEditingController();
  List<Map<String, String>> _filteredData = [];
  final Set<String> _selectedNis = {};

  // Dummy data
  final List<Map<String, String>> _allSantri = [
    {'nis': '12345', 'name': 'Abdullah Azzam', 'kelas': '7A'},
    {'nis': '12346', 'name': 'Muhammad Fatih', 'kelas': '7A'},
    {'nis': '12347', 'name': 'Umar bin Khattab', 'kelas': '8B'},
    {'nis': '12348', 'name': 'Ali bin Abi Thalib', 'kelas': '8B'},
    {'nis': '12349', 'name': 'Usman bin Affan', 'kelas': '7A'},
    {'nis': '12350', 'name': 'Abdurrahman bin Auf', 'kelas': '9C'},
    {'nis': '12351', 'name': 'Sa\'ad bin Abi Waqqash', 'kelas': '8A'},
    {'nis': '12352', 'name': 'Zubair bin Awwam', 'kelas': '10B'},
    {'nis': '12353', 'name': 'Talhah bin Ubaidillah', 'kelas': '7C'},
    {'nis': '12354', 'name': 'Abu Ubaidah bin Jarrah', 'kelas': '9A'},
  ];

  @override
  void initState() {
    super.initState();
    _filteredData = _allSantri;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearch(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredData = _allSantri;
      } else {
        _filteredData = _allSantri
            .where((s) =>
                s['name']!.toLowerCase().contains(query.toLowerCase()) ||
                s['nis']!.contains(query))
            .toList();
      }
    });
  }

  void _toggleSelect(String nis) {
    setState(() {
      if (_selectedNis.contains(nis)) {
        _selectedNis.remove(nis);
      } else {
        _selectedNis.add(nis);
      }
    });
  }

  void _confirmSelection() {
    final selected = _allSantri
        .where((s) => _selectedNis.contains(s['nis']))
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
      body: Column(
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
                      Icon(Icons.tune, size: 16.sp, color: colors.textSecondary),
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
                  t.selectSantri.countLabel(count: _allSantri.length.toString()),
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

          // Table header
          _buildTableHeader(colors),
          SizedBox(height: 4.h),

          // List
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.only(bottom: 16.h),
              itemCount: _filteredData.length,
              itemBuilder: (context, index) {
                final item = _filteredData[index];
                final isSelected = _selectedNis.contains(item['nis']);
                return _buildRow(colors, item, isSelected);
              },
            ),
          ),

          // Bottom bar
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
                  onPressed: _selectedNis.isEmpty ? null : _confirmSelection,
                  icon: Icon(Icons.check, size: 20.sp),
                  label: Text(
                    t.selectSantri.tambahkanButton(
                      count: _selectedNis.length.toString(),
                    ),
                    style: TextStyle(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w700,
                      fontFamily: 'Poppins',
                      letterSpacing: 0.5,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colors.primary,
                    foregroundColor: colors.textOnButton,
                    disabledBackgroundColor: colors.primary.withValues(alpha: 0.4),
                    disabledForegroundColor: colors.textOnButton.withValues(alpha: 0.6),
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

  Widget _buildRow(AppColorSet colors, Map<String, String> item, bool isSelected) {
    return InkWell(
      onTap: () => _toggleSelect(item['nis']!),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        child: Row(
          children: [
            // NIS
            SizedBox(
              width: 55.w,
              child: Text(
                item['nis']!,
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
                item['name']!,
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
                    item['kelas']!,
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
