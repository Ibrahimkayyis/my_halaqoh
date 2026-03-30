import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_halaqoh/gen/i18n/translations.g.dart';
import 'package:my_halaqoh/src/core/theme/app_colors.dart';
import 'package:my_halaqoh/src/core/widget/widgets.dart';

/// Mutaba'ah Santri â€” daily memorization log split into Hafalan Baru & Murajaah tables
@RoutePage()
class WaliSantriMutabaahScreen extends StatefulWidget {
  final String name;
  final String nis;

  const WaliSantriMutabaahScreen({
    super.key,
    required this.name,
    required this.nis,
  });

  @override
  State<WaliSantriMutabaahScreen> createState() => _WaliSantriMutabaahScreenState();
}

class _WaliSantriMutabaahScreenState extends State<WaliSantriMutabaahScreen> {
  int _currentMonth = 11; // November
  int _currentYear = 2025;



  // Dummy hafalan baru records
  final List<Map<String, dynamic>> _hafalanBaruRecords = [
    {
      'dayOfWeek': 'Sen',
      'date': '01/11',
      'surah': 'Al-Mulk',
      'ayat': '1-10',
      'nilai': 95,
    },
    {
      'dayOfWeek': 'Rab',
      'date': '03/11',
      'surah': 'Al-Mulk',
      'ayat': '11-20',
      'nilai': 90,
    },
    {
      'dayOfWeek': 'Jum',
      'date': '05/11',
      'surah': 'Al-Mulk',
      'ayat': '21-30',
      'nilai': 65,
    },
    {
      'dayOfWeek': 'Sen',
      'date': '08/11',
      'surah': 'Al-Qalam',
      'ayat': '1-15',
      'nilai': 88,
    },
    {
      'dayOfWeek': 'Rab',
      'date': '10/11',
      'surah': 'Al-Qalam',
      'ayat': '16-30',
      'nilai': 92,
    },
    {
      'dayOfWeek': 'Jum',
      'date': '12/11',
      'surah': 'Al-Haqqah',
      'ayat': '1-12',
      'nilai': 78,
    },
    {
      'dayOfWeek': 'Sen',
      'date': '15/11',
      'surah': 'Al-Haqqah',
      'ayat': '13-25',
      'nilai': 85,
    },
    {
      'dayOfWeek': 'Rab',
      'date': '17/11',
      'surah': "Al-Ma'arij",
      'ayat': '1-10',
      'nilai': 90,
    },
    {
      'dayOfWeek': 'Jum',
      'date': '19/11',
      'surah': 'Nuh',
      'ayat': '1-14',
      'nilai': 87,
    },
    {
      'dayOfWeek': 'Sen',
      'date': '22/11',
      'surah': 'Nuh',
      'ayat': '15-28',
      'nilai': 93,
    },
  ];

  // Dummy murajaah records
  final List<Map<String, dynamic>> _murajaahRecords = [
    {
      'dayOfWeek': 'Sel',
      'date': '02/11',
      'surah': 'An-Naba',
      'ayat': '1-40',
      'nilai': 80,
    },
    {
      'dayOfWeek': 'Kam',
      'date': '04/11',
      'surah': 'Abasa',
      'ayat': '1-42',
      'nilai': 92,
    },
    {
      'dayOfWeek': 'Sab',
      'date': '06/11',
      'surah': 'At-Takwir',
      'ayat': '1-29',
      'nilai': 98,
    },
    {
      'dayOfWeek': 'Sel',
      'date': '09/11',
      'surah': 'Al-Mulk',
      'ayat': '1-30',
      'nilai': 94,
    },
    {
      'dayOfWeek': 'Kam',
      'date': '11/11',
      'surah': 'An-Naba',
      'ayat': '1-40',
      'nilai': 88,
    },
    {
      'dayOfWeek': 'Sab',
      'date': '13/11',
      'surah': 'Al-Qalam',
      'ayat': '1-30',
      'nilai': 91,
    },
    {
      'dayOfWeek': 'Sel',
      'date': '16/11',
      'surah': 'Al-Haqqah',
      'ayat': '1-12',
      'nilai': 95,
    },
    {
      'dayOfWeek': 'Kam',
      'date': '18/11',
      'surah': "Al-Ma'arij",
      'ayat': '1-10',
      'nilai': 86,
    },
  ];

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

  /// Score badge color
  Color _scoreColor(int nilai) {
    if (nilai >= 85) return const Color(0xFF4CAF50); // green
    if (nilai >= 70) return const Color(0xFFFFC107); // amber
    return const Color(0xFFFF7043); // orange-red
  }

  Color _scoreTextColor(int nilai) {
    if (nilai >= 85) return const Color(0xFF1B5E20);
    if (nilai >= 70) return const Color(0xFF795548);
    return const Color(0xFFBF360C);
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);

    return Scaffold(
      backgroundColor: colors.background,
      body: SafeArea(
        child: Column(
          children: [
            // AppBar
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
                    t.mutabaahSantri.title,
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

            // Content
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Month navigator
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
                        SizedBox(width: 8.w),
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
                    SizedBox(height: 20.h),

                    // â”€â”€ Hafalan Baru section â”€â”€
                    _buildSectionHeader(t.mutabaahSantri.hafalanBaru, colors),
                    SizedBox(height: 10.h),
                    _buildDataTable(_hafalanBaruRecords, colors),
                    SizedBox(height: 28.h),

                    // â”€â”€ Murajaah section â”€â”€
                    _buildSectionHeader(t.mutabaahSantri.murajaah, colors),
                    SizedBox(height: 10.h),
                    _buildDataTable(_murajaahRecords, colors),
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

  /// Section header with green left accent bar
  Widget _buildSectionHeader(String label, AppColorSet colors) {
    return Row(
      children: [
        Container(
          width: 4.w,
          height: 22.h,
          decoration: BoxDecoration(
            color: colors.primary,
            borderRadius: BorderRadius.circular(2.r),
          ),
        ),
        SizedBox(width: 8.w),
        Text(
          label,
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w700,
            color: colors.textPrimary,
            fontFamily: 'Poppins',
          ),
        ),
      ],
    );
  }

  /// Data table matching the mockup layout
  Widget _buildDataTable(
    List<Map<String, dynamic>> records,
    AppColorSet colors,
  ) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: colors.border, width: 1),
      ),
      child: Column(
        children: [
          // Header row
          Container(
            padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(color: colors.border, width: 1),
              ),
            ),
            child: Row(
              children: [
                _headerCell(t.mutabaahSantri.hari, 50.w, colors),
                _headerCell(t.mutabaahSantri.tgl, 50.w, colors),
                Expanded(
                  child: _headerCell(t.mutabaahSantri.surat, null, colors),
                ),
                _headerCell(t.mutabaahSantri.ayat, 55.w, colors),
                _headerCell(
                  t.mutabaahSantri.nilai,
                  45.w,
                  colors,
                  align: TextAlign.center,
                ),
              ],
            ),
          ),

          // Data rows
          ...records.asMap().entries.map((entry) {
            final record = entry.value;
            final isLast = entry.key == records.length - 1;

            return Container(
              padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
              decoration: BoxDecoration(
                border: isLast
                    ? null
                    : Border(
                        bottom: BorderSide(
                          color: colors.border.withValues(alpha: 0.5),
                          width: 0.5,
                        ),
                      ),
              ),
              child: Row(
                children: [
                  // HARI
                  SizedBox(
                    width: 50.w,
                    child: Text(
                      record['dayOfWeek'],
                      style: TextStyle(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w700,
                        color: colors.textPrimary,
                        fontFamily: 'Poppins',
                      ),
                    ),
                  ),
                  // TGL
                  SizedBox(
                    width: 50.w,
                    child: Text(
                      record['date'],
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w400,
                        color: colors.textSecondary,
                        fontFamily: 'Poppins',
                      ),
                    ),
                  ),
                  // SURAT
                  Expanded(
                    child: Text(
                      record['surah'],
                      style: TextStyle(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w500,
                        color: colors.textPrimary,
                        fontFamily: 'Poppins',
                      ),
                    ),
                  ),
                  // AYAT
                  SizedBox(
                    width: 55.w,
                    child: Text(
                      record['ayat'],
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w400,
                        color: colors.textSecondary,
                        fontFamily: 'Poppins',
                      ),
                    ),
                  ),
                  // NILAI badge
                  SizedBox(
                    width: 45.w,
                    child: Center(
                      child: Container(
                        width: 36.w,
                        height: 36.w,
                        decoration: BoxDecoration(
                          color: _scoreColor(
                            record['nilai'],
                          ).withValues(alpha: 0.15),
                          shape: BoxShape.circle,
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          '${record['nilai']}',
                          style: TextStyle(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w700,
                            color: _scoreTextColor(record['nilai']),
                            fontFamily: 'Poppins',
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _headerCell(
    String label,
    double? width,
    AppColorSet colors, {
    TextAlign align = TextAlign.left,
  }) {
    final text = Text(
      label,
      textAlign: align,
      style: TextStyle(
        fontSize: 11.sp,
        fontWeight: FontWeight.w600,
        color: colors.textSecondary,
        fontFamily: 'Poppins',
        letterSpacing: 0.3,
      ),
    );

    if (width != null) {
      return SizedBox(width: width, child: text);
    }
    return text;
  }
}

