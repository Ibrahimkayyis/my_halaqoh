import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_halaqoh/gen/i18n/translations.g.dart';
import 'package:my_halaqoh/src/core/theme/app_colors.dart';
import 'package:my_halaqoh/src/core/router/app_router.dart';
import 'package:my_halaqoh/src/modules/guru_hafalan/presentation/widgets/hafalan_santri_item.dart';

/// Hafalan Santri Screen — search bar, count badge, and santri card list with actions
@RoutePage()
class HafalanScreen extends StatefulWidget {
  const HafalanScreen({super.key});

  @override
  State<HafalanScreen> createState() => _HafalanScreenState();
}

class _HafalanScreenState extends State<HafalanScreen> {
  String _searchQuery = '';

  final List<Map<String, String>> _santriList = [
    {'name': 'Ahmad', 'nis': '123456'},
    {'name': 'Fauzan', 'nis': '123457'},
    {'name': 'Yusuf', 'nis': '123458'},
    {'name': 'Ibrahim', 'nis': '123459'},
    {'name': 'Khalid', 'nis': '123460'},
    {'name': 'Usman', 'nis': '123461'},
    {'name': 'Ghulam', 'nis': '123462'},
    {'name': 'Haikal', 'nis': '123463'},
    {'name': 'Fikrie', 'nis': '123464'},
    {'name': 'Ghatfhan', 'nis': '123465'},
  ];

  List<Map<String, String>> get _filteredSantri {
    if (_searchQuery.isEmpty) return _santriList;
    return _santriList
        .where(
          (s) =>
              s['name']!.toLowerCase().contains(_searchQuery.toLowerCase()) ||
              s['nis']!.contains(_searchQuery),
        )
        .toList();
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
            SizedBox(height: 16.h),

            // Search bar
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: Container(
                decoration: BoxDecoration(
                  color: colors.surface,
                  borderRadius: BorderRadius.circular(14.r),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.04),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: TextField(
                  onChanged: (value) => setState(() => _searchQuery = value),
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontFamily: 'Poppins',
                    color: colors.textPrimary,
                  ),
                  decoration: InputDecoration(
                    hintText: t.hafalan.cariSantri,
                    hintStyle: TextStyle(
                      fontSize: 14.sp,
                      fontFamily: 'Poppins',
                      color: colors.textSecondary.withValues(alpha: 0.5),
                    ),
                    prefixIcon: Icon(
                      Icons.search,
                      size: 22.sp,
                      color: colors.textSecondary,
                    ),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 14.h,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 20.h),

            // Daftar Santri header with count badge
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    t.hafalan.daftarSantri,
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
                      color: colors.surface,
                      borderRadius: BorderRadius.circular(20.r),
                      border: Border.all(color: colors.border, width: 1),
                    ),
                    child: Text(
                      t.hafalan.santriCount(count: '${filtered.length}'),
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w600,
                        color: colors.textPrimary,
                        fontFamily: 'Poppins',
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 14.h),

            // Santri list
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                itemCount: filtered.length,
                itemBuilder: (context, index) {
                  final santri = filtered[index];
                  return HafalanSantriItem(
                    name: santri['name']!,
                    nis: santri['nis']!,
                    riwayatLabel: t.hafalan.riwayatHafalan,
                    inputLabel: t.hafalan.inputHafalan,
                    onRiwayatTap: () {
                      context.router.push(
                        RiwayatHafalanSantriRoute(
                          name: santri['name']!,
                          nis: santri['nis']!,
                        ),
                      );
                    },
                    onInputTap: () async {
                      final result = await context.router.push(
                        InputHafalanRoute(
                          name: santri['name']!,
                          nis: santri['nis']!,
                        ),
                      );
                      if (result != null && result is Map<String, dynamic>) {
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: const Text(
                                'Hafalan berhasil disimpan!',
                                style: TextStyle(fontFamily: 'Poppins'),
                              ),
                              backgroundColor: colors.primary,
                            ),
                          );
                        }
                      }
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
