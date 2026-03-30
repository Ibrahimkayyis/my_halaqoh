import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_halaqoh/gen/i18n/translations.g.dart';
import 'package:my_halaqoh/src/core/theme/app_colors.dart';
import 'package:my_halaqoh/src/core/widget/widgets.dart';
import 'package:my_halaqoh/src/core/router/app_router.dart';

/// Riwayat Absensi screen — individual student attendance history
@RoutePage()
class RiwayatAbsensiScreen extends StatefulWidget {
  final String name;
  final String nis;
  final String programType;

  const RiwayatAbsensiScreen({
    super.key,
    @PathParam('name') required this.name,
    @PathParam('nis') required this.nis,
    @PathParam('programType') this.programType = 'reguler',
  });

  @override
  State<RiwayatAbsensiScreen> createState() => _RiwayatAbsensiScreenState();
}

class _RiwayatAbsensiScreenState extends State<RiwayatAbsensiScreen> {
  int _currentMonth = 11;
  int _currentYear = 2025;

  final List<String> _dayNames = [
    'AHA', 'SEN', 'SEL', 'RAB', 'KAM', 'JUM', 'SAB',
  ];

  List<String> get _sessionKeys {
    if (widget.programType == 'takhassus') {
      return ['shubuh', 'dhuha1', 'dhuha2', 'ashar', 'maghrib'];
    }
    return ['pagi', 'mlm'];
  }

  List<String> get _sessionLabels {
    if (widget.programType == 'takhassus') {
      return ['P', 'D1', 'D2', 'S', 'M'];
    }
    return ['P', 'M'];
  }

  late Map<int, Map<String, String>> _attendanceData;

  @override
  void initState() {
    super.initState();
    _generateDummyData();
  }

  void _generateDummyData() {
    _attendanceData = {};
    final keys = _sessionKeys;
    final statuses = ['H', 'S', 'I', 'A'];
    for (int d = 1; d <= 30; d++) {
      _attendanceData[d] = {};
      for (final key in keys) {
        final hash = (d * 7 + key.hashCode) % 20;
        if (hash < 2) {
          _attendanceData[d]![key] = statuses[hash + 1];
        } else if (hash == 3 && d % 5 == 0) {
          _attendanceData[d]![key] = 'A';
        } else {
          _attendanceData[d]![key] = 'H';
        }
      }
    }
  }

  Map<String, int> get _stats {
    int hadir = 0, sakit = 0, izin = 0, alfa = 0;
    for (final data in _attendanceData.values) {
      for (final status in data.values) {
        switch (status) {
          case 'H': hadir++; break;
          case 'S': sakit++; break;
          case 'I': izin++; break;
          case 'A': alfa++; break;
        }
      }
    }
    return {'hadir': hadir, 'sakit': sakit, 'izin': izin, 'alfa': alfa};
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

  String _getDayName(int day) {
    final date = DateTime(_currentYear, _currentMonth, day);
    return _dayNames[date.weekday % 7];
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final stats = _stats;

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
          t.riwayatAbsensi.title,
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

            // ── Profile card ──
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
                      width: 48.w,
                      height: 48.w,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withValues(alpha: 0.2),
                      ),
                      child: Icon(Icons.person, size: 26.sp, color: Colors.white),
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
                          'NIS: ${widget.nis}',
                          style: TextStyle(
                            fontSize: 13.sp,
                            color: Colors.white.withValues(alpha: 0.85),
                            fontFamily: 'Poppins',
                          ),
                        ),
                        SizedBox(height: 1.h),
                        Text(
                          t.riwayatAbsensi.halaqohKelas(halaqoh: 'A', kelas: '7'),
                          style: TextStyle(
                            fontSize: 13.sp,
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

            // ── Month navigator (global widgets) ──
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: Row(
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
                        _generateDummyData();
                      });
                    },
                  ),
                ],
              ),
            ),
            SizedBox(height: 16.h),

            // ── Summary stats ──
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: Row(
                children: [
                  _buildStat('${stats['hadir']}', t.riwayatAbsensi.hadir, colors.primary, colors),
                  SizedBox(width: 10.w),
                  _buildStat('${stats['sakit']}', t.riwayatAbsensi.sakit, colors.yellow, colors),
                  SizedBox(width: 10.w),
                  _buildStat('${stats['izin']}', t.riwayatAbsensi.izin, colors.blue, colors),
                  SizedBox(width: 10.w),
                  _buildStat('${stats['alfa']}', t.riwayatAbsensi.alfa, colors.red, colors),
                ],
              ),
            ),
            SizedBox(height: 20.h),

            // ── Day cards ──
            SizedBox(
              height: widget.programType == 'takhassus' ? 280.h : 180.h,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                itemCount: _attendanceData.length,
                itemBuilder: (context, index) {
                  final day = index + 1;
                  final data = _attendanceData[day]!;
                  return _buildDayCard(day, _getDayName(day), data, colors);
                },
              ),
            ),
            SizedBox(height: 8.h),

            // ── Swipe hint ──
            Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.chevron_left, size: 16.sp,
                      color: colors.textSecondary.withValues(alpha: 0.5)),
                  Text(
                    t.riwayatAbsensi.geserHint,
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: colors.textSecondary.withValues(alpha: 0.5),
                      fontFamily: 'Poppins',
                    ),
                  ),
                  Icon(Icons.chevron_right, size: 16.sp,
                      color: colors.textSecondary.withValues(alpha: 0.5)),
                ],
              ),
            ),
            SizedBox(height: 16.h),

            // ── Lihat Kalender button ──
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: GestureDetector(
                onTap: () {
                  context.router.push(
                    KalenderAbsensiRoute(
                      name: widget.name,
                      nis: widget.nis,
                      programType: widget.programType,
                    ),
                  );
                },
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(vertical: 14.h),
                  decoration: BoxDecoration(
                    color: colors.surface,
                    borderRadius: BorderRadius.circular(14.r),
                    border: Border.all(color: colors.primary, width: 1.5),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        t.riwayatAbsensi.lihatKalender,
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w700,
                          color: colors.primary,
                          fontFamily: 'Poppins',
                          letterSpacing: 0.3,
                        ),
                      ),
                      SizedBox(width: 8.w),
                      Icon(Icons.calendar_month, size: 20.sp, color: colors.primary),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: 16.h),

            // ── Keterangan card ──
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
                      t.riwayatAbsensi.keterangan,
                      style: TextStyle(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w700,
                        color: colors.textPrimary,
                        fontFamily: 'Poppins',
                      ),
                    ),
                    SizedBox(height: 12.h),
                    Row(
                      children: [
                        _buildLegendItem(colors.primary, t.riwayatAbsensi.hadirLabel, colors),
                        SizedBox(width: 40.w),
                        _buildLegendItem(colors.yellow, t.riwayatAbsensi.sakitLabel, colors),
                      ],
                    ),
                    SizedBox(height: 8.h),
                    Row(
                      children: [
                        _buildLegendItem(colors.red, t.riwayatAbsensi.alphaLabel, colors),
                        SizedBox(width: 40.w),
                        _buildLegendItem(colors.blue, t.riwayatAbsensi.izinLabel, colors),
                      ],
                    ),
                    SizedBox(height: 14.h),
                    Divider(color: colors.border.withValues(alpha: 0.5), height: 1),
                    SizedBox(height: 14.h),
                    Text(
                      'Keterangan Sesi',
                      style: TextStyle(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w600,
                        color: colors.textPrimary,
                        fontFamily: 'Poppins',
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Wrap(
                      spacing: 16.w,
                      runSpacing: 6.h,
                      children: widget.programType == 'takhassus'
                          ? [
                              _buildSessionLabel('P', 'Pagi (Shubuh)', colors),
                              _buildSessionLabel('D1', 'Dhuha 1', colors),
                              _buildSessionLabel('D2', 'Dhuha 2', colors),
                              _buildSessionLabel('S', 'Sore (Ashar)', colors),
                              _buildSessionLabel('M', 'Malam (Maghrib)', colors),
                            ]
                          : [
                              _buildSessionLabel('P', 'Pagi (Shubuh)', colors),
                              _buildSessionLabel('M', 'Malam (Maghrib)', colors),
                            ],
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 16.h),

            // ── Download button ──
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: PrimaryButton(
                width: double.infinity,
                height: 52.h,
                onPressed: () {
                  // TODO: download report
                },
                icon: Icons.download,
                label: t.riwayatAbsensi.downloadLaporan,
              ),
            ),
            SizedBox(height: 24.h),
          ],
        ),
      ),
    );
  }

  Widget _buildStat(String value, String label, Color color, AppColorSet colors) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 12.h),
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: BorderRadius.circular(12.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            Text(
              value,
              style: TextStyle(
                fontSize: 22.sp,
                fontWeight: FontWeight.w700,
                color: color,
                fontFamily: 'Poppins',
              ),
            ),
            SizedBox(height: 2.h),
            Text(
              label,
              style: TextStyle(
                fontSize: 10.sp,
                fontWeight: FontWeight.w600,
                color: colors.textSecondary,
                fontFamily: 'Poppins',
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDayCard(int day, String dayName, Map<String, String> data, AppColorSet colors) {
    final keys = _sessionKeys;
    final labels = _sessionLabels;

    return Container(
      width: widget.programType == 'takhassus' ? 80.w : 72.w,
      margin: EdgeInsets.only(right: 10.w),
      padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 6.w),
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
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
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
          SizedBox(height: 2.h),
          Text(
            day.toString().padLeft(2, '0'),
            style: TextStyle(
              fontSize: 24.sp,
              fontWeight: FontWeight.w700,
              color: colors.textPrimary,
              fontFamily: 'Poppins',
            ),
          ),
          SizedBox(height: 8.h),
          ...List.generate(keys.length, (i) {
            return Column(
              children: [
                Text(
                  labels[i],
                  style: TextStyle(
                    fontSize: 9.sp,
                    fontWeight: FontWeight.w500,
                    color: colors.textSecondary,
                    fontFamily: 'Poppins',
                  ),
                ),
                SizedBox(height: 2.h),
                _buildStatusBadge(data[keys[i]] ?? 'H', colors),
                if (i < keys.length - 1) SizedBox(height: 4.h),
              ],
            );
          }),
        ],
      ),
    );
  }

  Widget _buildStatusBadge(String status, AppColorSet colors) {
    Color bgColor;
    String label;
    switch (status) {
      case 'H': bgColor = colors.primary; label = 'H'; break;
      case 'S': bgColor = colors.yellow;  label = 'S'; break;
      case 'I': bgColor = colors.blue;    label = 'I'; break;
      case 'A': bgColor = colors.red;     label = 'A'; break;
      default:  bgColor = colors.border;  label = '-';
    }
    return Container(
      width: 28.w,
      height: 28.w,
      decoration: BoxDecoration(shape: BoxShape.circle, color: bgColor),
      child: Center(
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12.sp,
            fontWeight: FontWeight.w700,
            color: Colors.white,
            fontFamily: 'Poppins',
          ),
        ),
      ),
    );
  }

  Widget _buildLegendItem(Color color, String label, AppColorSet colors) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 24.w,
          height: 24.w,
          decoration: BoxDecoration(shape: BoxShape.circle, color: color),
          child: Center(
            child: Text(
              label[0],
              style: TextStyle(
                fontSize: 11.sp,
                fontWeight: FontWeight.w700,
                color: Colors.white,
                fontFamily: 'Poppins',
              ),
            ),
          ),
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

  Widget _buildSessionLabel(String code, String name, AppColorSet colors) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
          decoration: BoxDecoration(
            color: colors.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(4.r),
          ),
          child: Text(
            code,
            style: TextStyle(
              fontSize: 11.sp,
              fontWeight: FontWeight.w700,
              color: colors.primary,
              fontFamily: 'Poppins',
            ),
          ),
        ),
        SizedBox(width: 4.w),
        Text(
          name,
          style: TextStyle(
            fontSize: 11.sp,
            fontWeight: FontWeight.w500,
            color: colors.textSecondary,
            fontFamily: 'Poppins',
          ),
        ),
      ],
    );
  }
}