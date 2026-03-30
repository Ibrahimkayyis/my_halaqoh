import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_halaqoh/gen/i18n/translations.g.dart';
import 'package:my_halaqoh/src/core/router/app_router.dart';
import 'package:my_halaqoh/src/core/theme/app_colors.dart';
import 'package:my_halaqoh/src/core/widget/widgets.dart';

/// Riwayat Hafalan Santri — individual student memorization history
@RoutePage()
class RiwayatHafalanSantriScreen extends StatefulWidget {
  final String name;
  final String nis;

  const RiwayatHafalanSantriScreen({
    super.key,
    required this.name,
    required this.nis,
  });

  @override
  State<RiwayatHafalanSantriScreen> createState() =>
      _RiwayatHafalanSantriScreenState();
}

class _RiwayatHafalanSantriScreenState
    extends State<RiwayatHafalanSantriScreen> {
  int _currentMonth = 11;
  int _currentYear = 2025;

  final List<String> _dayNames = [
    'AHA',
    'SEN',
    'SEL',
    'RAB',
    'KAM',
    'JUM',
    'SAB',
  ];

  final List<Map<String, dynamic>> _records = [
    {
      'day': 1,
      'type': 'baru',
      'surah': 'Al - Mulk',
      'ayat': 'Ayat 1 - 10',
      'score': 90,
    },
    {
      'day': 1,
      'type': 'baru',
      'surah': 'Al - Mulk',
      'ayat': 'Ayat 1 - 10',
      'score': 90,
    },
    {
      'day': 2,
      'type': 'murajaah',
      'surah': 'An - Naba',
      'ayat': 'Ayat 1 - 40',
      'score': 85,
    },
    {
      'day': 3,
      'type': 'baru',
      'surah': 'Al - Qalam',
      'ayat': 'Ayat 1 - 15',
      'score': 88,
    },
    {
      'day': 5,
      'type': 'murajaah',
      'surah': 'Al - Mulk',
      'ayat': 'Ayat 1 - 30',
      'score': 92,
    },
    {
      'day': 7,
      'type': 'baru',
      'surah': 'Al - Haaqqa',
      'ayat': 'Ayat 1 - 12',
      'score': 87,
    },
    {
      'day': 10,
      'type': 'murajaah',
      'surah': 'Al - Qalam',
      'ayat': 'Ayat 1 - 15',
      'score': 95,
    },
    {
      'day': 12,
      'type': 'baru',
      'surah': "Al - Ma'arij",
      'ayat': 'Ayat 1 - 10',
      'score': 82,
    },
    {
      'day': 14,
      'type': 'murajaah',
      'surah': 'Al - Haaqqa',
      'ayat': 'Ayat 1 - 12',
      'score': 90,
    },
    {
      'day': 15,
      'type': 'baru',
      'surah': 'Nuh',
      'ayat': 'Ayat 1 - 28',
      'score': 88,
    },
    {
      'day': 18,
      'type': 'baru',
      'surah': 'Al - Jinn',
      'ayat': 'Ayat 1 - 10',
      'score': 85,
    },
    {
      'day': 19,
      'type': 'murajaah',
      'surah': 'Al - Mulk',
      'ayat': 'Ayat 1 - 30',
      'score': 94,
    },
    {
      'day': 20,
      'type': 'baru',
      'surah': 'Al - Muzzammil',
      'ayat': 'Ayat 1 - 10',
      'score': 86,
    },
    {
      'day': 22,
      'type': 'murajaah',
      'surah': 'Nuh',
      'ayat': 'Ayat 1 - 28',
      'score': 91,
    },
    {
      'day': 24,
      'type': 'baru',
      'surah': 'Al - Muddathir',
      'ayat': 'Ayat 1 - 15',
      'score': 89,
    },
    {
      'day': 25,
      'type': 'murajaah',
      'surah': "Al - Ma'arij",
      'ayat': 'Ayat 1 - 10',
      'score': 93,
    },
    {
      'day': 27,
      'type': 'baru',
      'surah': 'Al - Qiyamah',
      'ayat': 'Ayat 1 - 20',
      'score': 87,
    },
    {
      'day': 28,
      'type': 'murajaah',
      'surah': 'Al - Jinn',
      'ayat': 'Ayat 1 - 10',
      'score': 90,
    },
  ];

  int? _activeDeleteIndex;

  final List<String> _filterOptions = [
    'Semua Tipe',
    'Hafalan Baru',
    "Muraja'ah",
  ];
  String _selectedFilterLabel = 'Semua Tipe';

  String get _filterKey {
    if (_selectedFilterLabel == 'Hafalan Baru') return 'baru';
    if (_selectedFilterLabel == "Muraja'ah") return 'murajaah';
    return 'semua';
  }

  List<Map<String, dynamic>> get _filteredRecords {
    List<Map<String, dynamic>> list;
    if (_filterKey == 'semua') {
      list = List.from(_records);
    } else {
      list = _records.where((r) => r['type'] == _filterKey).toList();
    }
    list.sort((a, b) => (b['day'] as int).compareTo(a['day'] as int));
    return list;
  }

  int get _totalBaru => _records.where((r) => r['type'] == 'baru').length;
  int get _totalMurajaah =>
      _records.where((r) => r['type'] == 'murajaah').length;

  String _getDayName(int day) {
    final date = DateTime(_currentYear, _currentMonth, day);
    return _dayNames[date.weekday % 7];
  }

  void _prevMonth() {
    setState(() {
      _currentMonth--;
      if (_currentMonth < 1) {
        _currentMonth = 12;
        _currentYear--;
      }
    });
  }

  void _nextMonth() {
    setState(() {
      _currentMonth++;
      if (_currentMonth > 12) {
        _currentMonth = 1;
        _currentYear++;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final filtered = _filteredRecords;

    return Scaffold(
      backgroundColor: colors.background,
      body: SafeArea(
        child: Column(
          children: [
            // ── AppBar ──
            Padding(
              padding: EdgeInsets.only(left: 8.w, top: 8.h, right: 24.w),
              child: Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_back, color: colors.textPrimary),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  SizedBox(width: 4.w),
                  Text(
                    t.riwayatHafalanSantri.title,
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w700,
                      color: colors.textPrimary,
                      fontFamily: 'Poppins',
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 8.h),

            // ── Content ──
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Profile card
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(18.w),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            colors.primary,
                            colors.primary.withValues(alpha: 0.8),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(16.r),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 50.w,
                            height: 50.w,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white.withValues(alpha: 0.2),
                            ),
                            child: Icon(
                              Icons.person,
                              size: 26.sp,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(width: 14.w),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.name,
                                style: TextStyle(
                                  fontSize: 18.sp,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                  fontFamily: 'Poppins',
                                ),
                              ),
                              SizedBox(height: 2.h),
                              Text(
                                'NIS: ${widget.nis}',
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  color: Colors.white.withValues(alpha: 0.85),
                                  fontFamily: 'Poppins',
                                ),
                              ),
                              Text(
                                t.riwayatHafalanSantri.halaqohKelas(
                                  halaqoh: 'A',
                                  kelas: '7',
                                ),
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  color: Colors.white.withValues(alpha: 0.85),
                                  fontFamily: 'Poppins',
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 16.h),

                    // ── Month navigator (global widgets) ──
                    Row(
                      children: [
                        Expanded(
                          child: AppMonthSelector(
                            month: _currentMonth,
                            year: _currentYear,
                            onPrev: _prevMonth,
                            onNext: _nextMonth,
                          ),
                        ),
                        SizedBox(width: 10.w),
                        AppCalendarPickerButton(
                          currentMonth: _currentMonth,
                          currentYear: _currentYear,
                          onSelected: (month, year) {
                            setState(() {
                              _currentMonth = month;
                              _currentYear = year;
                            });
                          },
                        ),
                      ],
                    ),
                    SizedBox(height: 16.h),

                    // Stats cards
                    Row(
                      children: [
                        Expanded(
                          child: _buildStatCard(
                            '$_totalBaru',
                            t.riwayatHafalanSantri.totalHafalanBaru,
                            colors,
                          ),
                        ),
                        SizedBox(width: 12.w),
                        Expanded(
                          child: _buildStatCard(
                            '$_totalMurajaah',
                            t.riwayatHafalanSantri.totalMurajaah,
                            colors,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16.h),

                    // Filter + Buka Mutaba'ah
                    Row(
                      children: [
                        SizedBox(
                          width: 150.w,
                          child: CustomDropdown<String>(
                            items: _filterOptions,
                            initialItem: _selectedFilterLabel,
                            onChanged: (value) {
                              if (value != null) {
                                setState(() => _selectedFilterLabel = value);
                              }
                            },
                            decoration: CustomDropdownDecoration(
                              closedFillColor: colors.surface,
                              closedBorder: Border.all(
                                color: colors.border,
                                width: 1,
                              ),
                              closedBorderRadius: BorderRadius.circular(10.r),
                              expandedFillColor: colors.surface,
                              expandedBorder: Border.all(
                                color: colors.border,
                                width: 1,
                              ),
                              expandedBorderRadius: BorderRadius.circular(10.r),
                              headerStyle: TextStyle(
                                fontSize: 13.sp,
                                fontWeight: FontWeight.w600,
                                color: colors.textPrimary,
                                fontFamily: 'Poppins',
                              ),
                              listItemStyle: TextStyle(
                                fontSize: 13.sp,
                                fontWeight: FontWeight.w500,
                                color: colors.textPrimary,
                                fontFamily: 'Poppins',
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 10.w),
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              context.router.push(
                                MutabaahSantriRoute(
                                  name: widget.name,
                                  nis: widget.nis,
                                ),
                              );
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(vertical: 10.h),
                              decoration: BoxDecoration(
                                color: colors.primary,
                                borderRadius: BorderRadius.circular(10.r),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.menu_book,
                                    size: 16.sp,
                                    color: colors.textOnButton,
                                  ),
                                  SizedBox(width: 6.w),
                                  Text(
                                    t.riwayatHafalanSantri.bukaMutabaah,
                                    style: TextStyle(
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.w700,
                                      color: colors.textOnButton,
                                      fontFamily: 'Poppins',
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16.h),

                    // Records list
                    ...filtered.asMap().entries.map(
                      (e) => _buildRecordCard(e.value, e.key, colors),
                    ),
                    SizedBox(height: 16.h),

                    // Lihat Progress button
                    CustomOutlinedButton(
                      width: double.infinity,
                      height: 48.h,
                      onPressed: () {
                        context.router.push(
                          ProgressHafalanPerJuzRoute(
                            name: widget.name,
                            nis: widget.nis,
                          ),
                        );
                      },
                      icon: Icons.menu_book,
                      label: t.riwayatHafalanSantri.lihatProgress,
                    ),
                    SizedBox(height: 10.h),

                    // Download Laporan button
                    CustomOutlinedButton(
                      width: double.infinity,
                      height: 48.h,
                      onPressed: () {
                        // TODO: Download report
                      },
                      icon: Icons.download,
                      label: t.riwayatHafalanSantri.downloadLaporan,
                    ),
                    SizedBox(height: 24.h),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String value, String label, AppColorSet colors) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 12.w),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: colors.border, width: 1),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(
              fontSize: 28.sp,
              fontWeight: FontWeight.w800,
              color: colors.primary,
              fontFamily: 'Poppins',
            ),
          ),
          SizedBox(height: 2.h),
          Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.w500,
              color: colors.textSecondary,
              fontFamily: 'Poppins',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecordCard(
    Map<String, dynamic> record,
    int index,
    AppColorSet colors,
  ) {
    final dayStr = record['day'].toString().padLeft(2, '0');
    final dayName = _getDayName(record['day']);
    final isBaru = record['type'] == 'baru';
    final isShowingDelete = _activeDeleteIndex == index;

    return GestureDetector(
      onLongPress: () {
        setState(() {
          _activeDeleteIndex = isShowingDelete ? null : index;
        });
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 10.h),
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: BorderRadius.circular(14.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            // Day info
            Column(
              children: [
                Text(
                  dayName,
                  style: TextStyle(
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w500,
                    color: colors.textSecondary,
                    fontFamily: 'Poppins',
                  ),
                ),
                Text(
                  dayStr,
                  style: TextStyle(
                    fontSize: 22.sp,
                    fontWeight: FontWeight.w800,
                    color: colors.textPrimary,
                    fontFamily: 'Poppins',
                  ),
                ),
              ],
            ),
            SizedBox(width: 16.w),

            // Surah info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    isBaru
                        ? t.riwayatHafalanSantri.hafalanBaru
                        : t.riwayatHafalanSantri.murajaah,
                    style: TextStyle(
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w500,
                      color: colors.textSecondary,
                      fontFamily: 'Poppins',
                    ),
                  ),
                  Text(
                    record['surah'],
                    style: TextStyle(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w700,
                      color: colors.textPrimary,
                      fontFamily: 'Poppins',
                    ),
                  ),
                  Text(
                    record['ayat'],
                    style: TextStyle(
                      fontSize: 11.sp,
                      color: colors.textSecondary,
                      fontFamily: 'Poppins',
                    ),
                  ),
                ],
              ),
            ),

            // Score & delete
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '${record['score']}',
                  style: TextStyle(
                    fontSize: 22.sp,
                    fontWeight: FontWeight.w800,
                    color: colors.textPrimary,
                    fontFamily: 'Poppins',
                  ),
                ),
                if (isShowingDelete) ...[
                  SizedBox(width: 12.w),
                  GestureDetector(
                    onTap: () async {
                      final confirmed = await ConfirmDeleteDialog.show(context);
                      if (confirmed && context.mounted) {
                        setState(() {
                          _records.remove(record);
                          _activeDeleteIndex = null;
                        });
                      }
                    },
                    child: Container(
                      padding: EdgeInsets.all(8.w),
                      decoration: BoxDecoration(
                        color: colors.red.withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.delete_outline,
                        size: 20.sp,
                        color: colors.red,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}
