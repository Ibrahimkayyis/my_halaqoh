import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_halaqoh/gen/i18n/translations.g.dart';
import 'package:my_halaqoh/src/core/theme/app_colors.dart';
import 'package:my_halaqoh/src/core/router/app_router.dart';
import 'package:my_halaqoh/src/modules/guru_halaqoh/presentation/widgets/halaqoh_info_card.dart';
import 'package:my_halaqoh/src/modules/guru_halaqoh/presentation/widgets/santri_list_item.dart';

/// My Halaqoh screen showing halaqoh info card, search bar, and santri list.
@RoutePage()
class MyHalaqohScreen extends StatefulWidget {
  const MyHalaqohScreen({super.key});

  @override
  State<MyHalaqohScreen> createState() => _MyHalaqohScreenState();
}

class _MyHalaqohScreenState extends State<MyHalaqohScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  // Dummy data with progress
  final List<Map<String, dynamic>> _allSantri = [
    {
      'name': 'Ahmad',
      'nis': '22051214060',
      'completedJuz': 1.5,
      'targetJuz': 5.0,
    },
    {
      'name': 'Bima Sakti',
      'nis': '22051214061',
      'completedJuz': 3.5,
      'targetJuz': 5.0,
    },
    {
      'name': 'Candra Wijaya',
      'nis': '22051214062',
      'completedJuz': 0.5,
      'targetJuz': 5.0,
    },
    {
      'name': 'Dimas Pratama',
      'nis': '22051214063',
      'completedJuz': 4.5,
      'targetJuz': 5.0,
    },
    {
      'name': 'Faris Abdullah',
      'nis': '22051214064',
      'completedJuz': 2.0,
      'targetJuz': 5.0,
    },
    {
      'name': 'Gilang Ramadhan',
      'nis': '22051214065',
      'completedJuz': 5.0,
      'targetJuz': 5.0,
    },
    {
      'name': 'Haris Maulana',
      'nis': '22051214066',
      'completedJuz': 1.0,
      'targetJuz': 5.0,
    },
    {
      'name': 'Irfan Hakim',
      'nis': '22051214067',
      'completedJuz': 3.0,
      'targetJuz': 5.0,
    },
    {
      'name': 'Joko Prasetyo',
      'nis': '22051214068',
      'completedJuz': 2.5,
      'targetJuz': 5.0,
    },
    {
      'name': 'Kurniawan',
      'nis': '22051214069',
      'completedJuz': 4.0,
      'targetJuz': 5.0,
    },
  ];

  List<Map<String, dynamic>> get _filteredSantri {
    if (_searchQuery.isEmpty) return _allSantri;
    return _allSantri.where((s) {
      final name = (s['name'] as String).toLowerCase();
      final nis = s['nis'] as String;
      final query = _searchQuery.toLowerCase();
      return name.contains(query) || nis.contains(query);
    }).toList();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final filtered = _filteredSantri;

    return Scaffold(
      backgroundColor: colors.background,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
           

            // Halaqoh info card
            HalaqohInfoCard(
              kelas: t.myHalaqohScreen.kelas(kelas: '7'),
              program: t.myHalaqohScreen.program(program: 'Reguler'),
              halaqohName: 'Halaqoh Al-Kahfi',
              pengampu: t.myHalaqohScreen.pengampu,
              target: t.myHalaqohScreen.target(count: '2', range: 'Juz 30-29'),
              totalSantri: t.myHalaqohScreen.total(count: '10'),
            ),
            SizedBox(height: 20.h),

            // Search bar
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: Container(
                decoration: BoxDecoration(
                  color: colors.surface,
                  borderRadius: BorderRadius.circular(12.r),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.03),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: TextField(
                  controller: _searchController,
                  onChanged: (value) => setState(() => _searchQuery = value),
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontFamily: 'Poppins',
                    color: colors.textPrimary,
                  ),
                  decoration: InputDecoration(
                    hintText: t.myHalaqohScreen.searchHint,
                    hintStyle: TextStyle(
                      fontSize: 13.sp,
                      fontFamily: 'Poppins',
                      color: colors.textSecondary.withValues(alpha: 0.6),
                    ),
                    prefixIcon: Icon(
                      Icons.search,
                      size: 20.sp,
                      color: colors.textSecondary,
                    ),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 12.h,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 20.h),

            // Daftar Santri header
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    t.myHalaqohScreen.daftarSantri,
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w700,
                      color: colors.textPrimary,
                      fontFamily: 'Poppins',
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 12.w,
                      vertical: 4.h,
                    ),
                    decoration: BoxDecoration(
                      color: colors.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8.r),
                      border: Border.all(
                        color: colors.primary.withValues(alpha: 0.3),
                        width: 1,
                      ),
                    ),
                    child: Text(
                      t.myHalaqohScreen.santriCount(
                        count: '${filtered.length}',
                      ),
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w600,
                        color: colors.primary,
                        fontFamily: 'Poppins',
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 12.h),

            // Santri list
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                itemCount: filtered.length,
                itemBuilder: (context, index) {
                  final santri = filtered[index];
                  final completed = santri['completedJuz'] as double;
                  final target = santri['targetJuz'] as double;
                  final pct = ((completed / target) * 100).round();

                  // Format: remove .0 for whole numbers
                  String formatJuz(double v) {
                    return v == v.roundToDouble()
                        ? v.toInt().toString()
                        : v.toString();
                  }

                  return SantriListItem(
                    name: santri['name'] as String,
                    progressText: t.myHalaqohScreen.progressText(
                      completed: formatJuz(completed),
                      target: formatJuz(target),
                    ),
                    percentage: '$pct%',
                    progress: completed / target,
                    onTap: () {
                      context.router.push(
                        DetailSantriRoute(
                          name: santri['name'] as String,
                          nis: santri['nis'] as String,
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
