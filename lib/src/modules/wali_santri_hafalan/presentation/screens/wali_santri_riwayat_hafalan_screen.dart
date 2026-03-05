import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_halaqoh/gen/i18n/translations.g.dart';
import 'package:my_halaqoh/src/core/theme/app_colors.dart';
import 'package:my_halaqoh/src/modules/wali_santri_hafalan/presentation/screens/wali_santri_mutabaah_screen.dart';
import 'package:my_halaqoh/src/modules/wali_santri_hafalan/presentation/screens/wali_santri_progress_per_juz_screen.dart';

/// Riwayat Hafalan Santri â€” individual student memorization history
@RoutePage()
class WaliSantriRiwayatHafalanScreen extends StatefulWidget {
  final String name;
  final String nis;

  const WaliSantriRiwayatHafalanScreen({
    super.key,
    required this.name,
    required this.nis,
  });

  @override
  State<WaliSantriRiwayatHafalanScreen> createState() =>
      _WaliSantriRiwayatHafalanScreenState();
}

class _WaliSantriRiwayatHafalanScreenState
    extends State<WaliSantriRiwayatHafalanScreen> {
  int _currentMonth = 11; // November
  int _currentYear = 2025;

  final List<String> _monthNames = [
    'Januari',
    'Februari',
    'Maret',
    'April',
    'Mei',
    'Juni',
    'Juli',
    'Agustus',
    'September',
    'Oktober',
    'November',
    'Desember',
  ];

  final List<String> _dayNames = [
    'AHA',
    'SEN',
    'SEL',
    'RAB',
    'KAM',
    'JUM',
    'SAB',
  ];

  // Dummy hafalan records
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
      'surah': 'Al - Ma\'arij',
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
      'surah': 'Al - Ma\'arij',
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

  // Filter options: display label -> filter key
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
    if (_filterKey == 'semua') return _records;
    return _records.where((r) => r['type'] == _filterKey).toList();
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
            // Content
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Green gradient profile card
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
                                  fontWeight: FontWeight.w400,
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
                                  fontWeight: FontWeight.w400,
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

                    // Month navigator
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 16.w,
                        vertical: 10.h,
                      ),
                      decoration: BoxDecoration(
                        color: colors.surface,
                        borderRadius: BorderRadius.circular(24.r),
                        border: Border.all(color: colors.border, width: 1),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                            onTap: _prevMonth,
                            child: Icon(
                              Icons.chevron_left,
                              color: colors.primary,
                              size: 24.sp,
                            ),
                          ),
                          Text(
                            '${_monthNames[_currentMonth - 1]} $_currentYear',
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w700,
                              color: colors.textPrimary,
                              fontFamily: 'Poppins',
                            ),
                          ),
                          GestureDetector(
                            onTap: _nextMonth,
                            child: Icon(
                              Icons.chevron_right,
                              color: colors.primary,
                              size: 24.sp,
                            ),
                          ),
                        ],
                      ),
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
                        // Filter dropdown (animated_custom_dropdown)
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

                        // Buka Mutaba'ah button
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => WaliSantriMutabaahScreen(
                                    name: widget.name,
                                    nis: widget.nis,
                                  ),
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
                    ...filtered.map(
                      (record) => _buildRecordCard(record, colors),
                    ),
                    SizedBox(height: 16.h),

                    // Lihat Progress button
                    SizedBox(
                      width: double.infinity,
                      height: 48.h,
                      child: OutlinedButton.icon(
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => WaliSantriProgressPerJuzScreen(
                                name: widget.name,
                                nis: widget.nis,
                              ),
                            ),
                          );
                        },
                        icon: Icon(Icons.menu_book, size: 18.sp),
                        label: Text(
                          t.riwayatHafalanSantri.lihatProgress,
                          style: TextStyle(
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w700,
                            fontFamily: 'Poppins',
                          ),
                        ),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: colors.primary,
                          side: BorderSide(color: colors.primary, width: 1.5),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14.r),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 10.h),
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

  Widget _buildRecordCard(Map<String, dynamic> record, AppColorSet colors) {
    final dayStr = record['day'].toString().padLeft(2, '0');
    final dayName = _getDayName(record['day']);
    final isBaru = record['type'] == 'baru';

    return Container(
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
                    fontWeight: FontWeight.w400,
                    color: colors.textSecondary,
                    fontFamily: 'Poppins',
                  ),
                ),
              ],
            ),
          ),

          // Score
          Text(
            '${record['score']}',
            style: TextStyle(
              fontSize: 22.sp,
              fontWeight: FontWeight.w800,
              color: colors.textPrimary,
              fontFamily: 'Poppins',
            ),
          ),
        ],
      ),
    );
  }
}
