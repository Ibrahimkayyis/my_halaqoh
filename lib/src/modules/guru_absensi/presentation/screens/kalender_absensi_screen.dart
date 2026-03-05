import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_halaqoh/gen/i18n/translations.g.dart';
import 'package:my_halaqoh/src/core/theme/app_colors.dart';

/// Kalender Absensi Lengkap — full month calendar with pagi/malam dots
@RoutePage()
class KalenderAbsensiScreen extends StatefulWidget {
  final String name;
  final String nis;
  final String programType;

  const KalenderAbsensiScreen({
    super.key,
    @PathParam('name') required this.name,
    @PathParam('nis') required this.nis,
    @PathParam('programType') this.programType = 'reguler',
  });

  @override
  State<KalenderAbsensiScreen> createState() => _KalenderAbsensiScreenState();
}

class _KalenderAbsensiScreenState extends State<KalenderAbsensiScreen> {
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

  /// Session keys based on program type
  List<String> get _sessionKeys {
    if (widget.programType == 'takhassus') {
      return ['shubuh', 'dhuha1', 'dhuha2', 'ashar', 'maghrib'];
    }
    return ['pagi', 'mlm'];
  }

  /// Session labels for legend
  List<String> get _sessionLabels {
    if (widget.programType == 'takhassus') {
      return [
        'P = Pagi',
        'D1 = Dhuha 1',
        'D2 = Dhuha 2',
        'S = Sore',
        'M = Malam',
      ];
    }
    return ['Pagi (Kiri)', 'Malam (Kanan)'];
  }

  // Dummy data generated based on program type
  late Map<int, Map<String, String>> _attendanceData;

  @override
  void initState() {
    super.initState();
    _generateDummyData();
  }

  void _generateDummyData() {
    _attendanceData = {};
    final keys = _sessionKeys;
    final statuses = ['H', 'S', 'A'];
    final daysInMonth = _daysInMonth(_currentYear, _currentMonth);
    for (int d = 1; d <= daysInMonth; d++) {
      // Only generate data for some days (simulating partial month)
      if (d > 16) continue;
      _attendanceData[d] = {};
      for (final key in keys) {
        final hash = (d * 7 + key.hashCode) % 15;
        if (hash < 1) {
          _attendanceData[d]![key] = 'S';
        } else if (hash == 2 && d % 4 == 0) {
          _attendanceData[d]![key] = 'A';
        } else {
          _attendanceData[d]![key] = 'H';
        }
      }
    }
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

  int _daysInMonth(int year, int month) {
    return DateTime(year, month + 1, 0).day;
  }

  int _firstWeekdayOfMonth(int year, int month) {
    return DateTime(year, month, 1).weekday % 7; // 0=Sunday
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final daysInMonth = _daysInMonth(_currentYear, _currentMonth);
    final firstWeekday = _firstWeekdayOfMonth(_currentYear, _currentMonth);
    final dayHeaders = [
      t.kalenderAbsensi.aha,
      t.kalenderAbsensi.sen,
      t.kalenderAbsensi.sel,
      t.kalenderAbsensi.rab,
      t.kalenderAbsensi.kam,
      t.kalenderAbsensi.jum,
      t.kalenderAbsensi.sab,
    ];

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        backgroundColor: colors.background,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: colors.textPrimary),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          t.kalenderAbsensi.title,
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.w700,
            color: colors.textPrimary,
            fontFamily: 'Poppins',
          ),
        ),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 8.h),

            // Profile card
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.all(18.w),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      colors.primary,
                      colors.primary.withValues(alpha: 0.85),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16.r),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 44.w,
                      height: 44.w,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withValues(alpha: 0.2),
                      ),
                      child: Icon(
                        Icons.person,
                        size: 24.sp,
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
                            fontSize: 17.sp,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                            fontFamily: 'Poppins',
                          ),
                        ),
                        SizedBox(height: 2.h),
                        Text(
                          t.kalenderAbsensi.nisHalaqoh(
                            nis: widget.nis,
                            halaqoh: 'A',
                          ),
                          style: TextStyle(
                            fontSize: 13.sp,
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
            ),
            SizedBox(height: 20.h),

            // Month navigator
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: _prevMonth,
                    child: Container(
                      width: 36.w,
                      height: 36.w,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: colors.primary.withValues(alpha: 0.1),
                      ),
                      child: Icon(
                        Icons.chevron_left,
                        color: colors.primary,
                        size: 22.sp,
                      ),
                    ),
                  ),
                  Text(
                    '${_monthNames[_currentMonth - 1]} $_currentYear',
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w700,
                      color: colors.textPrimary,
                      fontFamily: 'Poppins',
                    ),
                  ),
                  GestureDetector(
                    onTap: _nextMonth,
                    child: Container(
                      width: 36.w,
                      height: 36.w,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: colors.primary.withValues(alpha: 0.1),
                      ),
                      child: Icon(
                        Icons.chevron_right,
                        color: colors.primary,
                        size: 22.sp,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20.h),

            // Calendar grid
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: Column(
                children: [
                  // Day headers
                  Row(
                    children: dayHeaders
                        .map(
                          (d) => Expanded(
                            child: Center(
                              child: Text(
                                d,
                                style: TextStyle(
                                  fontSize: 11.sp,
                                  fontWeight: FontWeight.w600,
                                  color: colors.textSecondary,
                                  fontFamily: 'Poppins',
                                ),
                              ),
                            ),
                          ),
                        )
                        .toList(),
                  ),
                  SizedBox(height: 10.h),

                  // Calendar rows
                  ..._buildCalendarRows(daysInMonth, firstWeekday, colors),
                ],
              ),
            ),
            SizedBox(height: 24.h),

            // Keterangan card
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.all(18.w),
                decoration: BoxDecoration(
                  color: colors.surface,
                  borderRadius: BorderRadius.circular(14.r),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.03),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      t.kalenderAbsensi.keterangan,
                      style: TextStyle(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w700,
                        color: colors.textPrimary,
                        fontFamily: 'Poppins',
                      ),
                    ),
                    SizedBox(height: 14.h),
                    Row(
                      children: [
                        _buildLegendDot(
                          colors.primary,
                          t.kalenderAbsensi.hadirLabel,
                          colors,
                        ),
                        SizedBox(width: 30.w),
                        _buildLegendDot(colors.yellow, 'Sakit', colors),
                      ],
                    ),
                    SizedBox(height: 10.h),
                    Row(
                      children: [
                        _buildLegendDot(colors.blue, 'Izin', colors),
                        SizedBox(width: 30.w),
                        _buildLegendDot(
                          colors.red,
                          t.kalenderAbsensi.alfaLabel,
                          colors,
                        ),
                      ],
                    ),
                    SizedBox(height: 10.h),
                    Row(
                      children: [
                        _buildLegendDot(
                          colors.border,
                          t.kalenderAbsensi.belumAbsen,
                          colors,
                        ),
                      ],
                    ),
                    SizedBox(height: 14.h),
                    Divider(
                      color: colors.border.withValues(alpha: 0.5),
                      height: 1,
                    ),
                    SizedBox(height: 14.h),
                    // Session position legend
                    if (widget.programType == 'takhassus')
                      Wrap(
                        spacing: 12.w,
                        runSpacing: 6.h,
                        children: _sessionLabels.map((label) {
                          return Text(
                            label,
                            style: TextStyle(
                              fontSize: 11.sp,
                              fontWeight: FontWeight.w500,
                              color: colors.textSecondary,
                              fontFamily: 'Poppins',
                            ),
                          );
                        }).toList(),
                      )
                    else
                      Row(
                        children: [
                          _buildSessionLegend(
                            '●',
                            t.kalenderAbsensi.pagiKiri,
                            colors,
                          ),
                          SizedBox(width: 24.w),
                          _buildSessionLegend(
                            '●',
                            t.kalenderAbsensi.malamKanan,
                            colors,
                          ),
                        ],
                      ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 24.h),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildCalendarRows(
    int daysInMonth,
    int firstWeekday,
    AppColorSet colors,
  ) {
    final rows = <Widget>[];
    int dayCounter = 1;

    // Total cells needed
    final totalCells = firstWeekday + daysInMonth;
    final totalRows = (totalCells / 7).ceil();

    for (int row = 0; row < totalRows; row++) {
      final cells = <Widget>[];
      for (int col = 0; col < 7; col++) {
        final cellIndex = row * 7 + col;
        if (cellIndex < firstWeekday || dayCounter > daysInMonth) {
          // Empty cell
          cells.add(const Expanded(child: SizedBox()));
        } else {
          final day = dayCounter;
          final data = _attendanceData[day];
          final isPresent = data != null;

          cells.add(
            Expanded(
              child: _buildCalendarCell(
                day,
                data?[_sessionKeys.first],
                data?[_sessionKeys.last],
                isPresent,
                colors,
                data: data,
              ),
            ),
          );
          dayCounter++;
        }
      }
      rows.add(
        Padding(
          padding: EdgeInsets.only(bottom: 6.h),
          child: Row(children: cells),
        ),
      );
    }
    return rows;
  }

  Widget _buildCalendarCell(
    int day,
    String? pagiStatus,
    String? mlmStatus,
    bool hasData,
    AppColorSet colors, {
    Map<String, String>? data,
  }) {
    final isFuture = !hasData;
    final keys = _sessionKeys;

    return Container(
      height: widget.programType == 'takhassus' ? 58.h : 52.h,
      margin: EdgeInsets.all(2.w),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(
          color: isFuture
              ? colors.border.withValues(alpha: 0.3)
              : colors.border.withValues(alpha: 0.5),
          width: 1,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            day.toString(),
            style: TextStyle(
              fontSize: widget.programType == 'takhassus' ? 11.sp : 13.sp,
              fontWeight: FontWeight.w600,
              color: isFuture
                  ? colors.textSecondary.withValues(alpha: 0.4)
                  : colors.textPrimary,
              fontFamily: 'Poppins',
            ),
          ),
          if (hasData && data != null) ...[
            SizedBox(height: 2.h),
            if (widget.programType == 'takhassus')
              // 5 dots: row of 3 + row of 2
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildDot(_statusColor(data[keys[0]], colors)),
                      SizedBox(width: 2.w),
                      _buildDot(_statusColor(data[keys[1]], colors)),
                      SizedBox(width: 2.w),
                      _buildDot(_statusColor(data[keys[2]], colors)),
                    ],
                  ),
                  SizedBox(height: 2.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildDot(_statusColor(data[keys[3]], colors)),
                      SizedBox(width: 2.w),
                      _buildDot(_statusColor(data[keys[4]], colors)),
                    ],
                  ),
                ],
              )
            else
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildDot(_statusColor(pagiStatus, colors)),
                  SizedBox(width: 3.w),
                  _buildDot(_statusColor(mlmStatus, colors)),
                ],
              ),
          ] else if (hasData) ...[
            SizedBox(height: 3.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildDot(_statusColor(pagiStatus, colors)),
                SizedBox(width: 3.w),
                _buildDot(_statusColor(mlmStatus, colors)),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Color _statusColor(String? status, AppColorSet colors) {
    switch (status) {
      case 'H':
        return colors.primary;
      case 'S':
        return colors.yellow;
      case 'I':
        return colors.blue;
      case 'A':
        return colors.red;
      default:
        return colors.border;
    }
  }

  Widget _buildDot(Color color) {
    return Container(
      width: 8.w,
      height: 8.w,
      decoration: BoxDecoration(shape: BoxShape.circle, color: color),
    );
  }

  Widget _buildLegendDot(Color color, String label, AppColorSet colors) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12.w,
          height: 12.w,
          decoration: BoxDecoration(shape: BoxShape.circle, color: color),
        ),
        SizedBox(width: 8.w),
        Text(
          label,
          style: TextStyle(
            fontSize: 13.sp,
            fontWeight: FontWeight.w500,
            color: colors.textPrimary,
            fontFamily: 'Poppins',
          ),
        ),
      ],
    );
  }

  Widget _buildSessionLegend(String icon, String label, AppColorSet colors) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          icon,
          style: TextStyle(fontSize: 8.sp, color: colors.border),
        ),
        SizedBox(width: 4.w),
        Icon(
          label.contains('Pagi') || label.contains('Morning')
              ? Icons.wb_sunny_outlined
              : Icons.nights_stay_outlined,
          size: 14.sp,
          color: colors.textSecondary,
        ),
        SizedBox(width: 4.w),
        Text(
          label,
          style: TextStyle(
            fontSize: 12.sp,
            fontWeight: FontWeight.w400,
            color: colors.textSecondary,
            fontFamily: 'Poppins',
          ),
        ),
      ],
    );
  }
}
