import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_halaqoh/gen/i18n/translations.g.dart';
import 'package:my_halaqoh/src/core/theme/app_colors.dart';

/// Absensi Halaqoh — split-panel attendance grid.
/// Names stick on the left, dates+sessions scroll horizontally.
/// [programType]: 'reguler' (2 sessions) or 'takhassus' (5 sessions)
@RoutePage()
class AbsensiHalaqohScreen extends StatefulWidget {
  final String programType;

  const AbsensiHalaqohScreen({
    super.key,
    @PathParam('programType') this.programType = 'reguler',
  });

  @override
  State<AbsensiHalaqohScreen> createState() => _AbsensiHalaqohScreenState();
}

class _AbsensiHalaqohScreenState extends State<AbsensiHalaqohScreen> {
  int _currentMonth = 1;
  int _currentYear = 2026;

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

  final List<String> _dayAbbr = [
    'SEN',
    'SEL',
    'RAB',
    'KAM',
    'JUM',
    'SAB',
    'AHA',
  ];

  // Santri names
  final List<String> _santriNames = [
    'Ach. Fikrie',
    'Ahmad Khairul',
    'Ghatfhan M.',
    'Ghulam A.',
    'Haikal Mustafa',
    'M. Syahril',
    'M. Ali Candra',
    'Robi Haisy',
  ];

  /// Session labels based on program type
  List<String> get _sessions {
    if (widget.programType == 'takhassus') {
      return ['P', 'D1', 'D2', 'S', 'M'];
    }
    return ['P', 'M'];
  }

  // Linked vertical scroll controllers
  final ScrollController _namesVerticalCtrl = ScrollController();
  final ScrollController _gridVerticalCtrl = ScrollController();

  // Horizontal scroll for date grid
  final ScrollController _gridHorizontalCtrl = ScrollController();

  // Data: santriIndex -> {day -> {session -> status}}
  late Map<int, Map<int, Map<String, String>>> _data;

  @override
  void initState() {
    super.initState();
    _generateDummyData();

    // Link vertical scrolls
    _namesVerticalCtrl.addListener(() {
      if (_gridVerticalCtrl.hasClients &&
          _gridVerticalCtrl.offset != _namesVerticalCtrl.offset) {
        _gridVerticalCtrl.jumpTo(_namesVerticalCtrl.offset);
      }
    });
    _gridVerticalCtrl.addListener(() {
      if (_namesVerticalCtrl.hasClients &&
          _namesVerticalCtrl.offset != _gridVerticalCtrl.offset) {
        _namesVerticalCtrl.jumpTo(_gridVerticalCtrl.offset);
      }
    });
  }

  @override
  void dispose() {
    _namesVerticalCtrl.dispose();
    _gridVerticalCtrl.dispose();
    _gridHorizontalCtrl.dispose();
    super.dispose();
  }

  void _generateDummyData() {
    _data = {};
    final sessions = _sessions;
    final daysInMonth = _daysInMonth(_currentYear, _currentMonth);
    final statuses = ['H', 'S', 'I', 'A'];

    for (int s = 0; s < _santriNames.length; s++) {
      _data[s] = {};
      for (int d = 1; d <= daysInMonth; d++) {
        _data[s]![d] = {};
        for (final session in sessions) {
          // Mostly hadir, some variety
          String status = 'H';
          final hash = (s * 31 + d * 7 + session.hashCode) % 20;
          if (hash < 2) {
            status = statuses[hash + 1]; // S or I
          } else if (hash == 3 && s % 3 == 0) {
            status = 'A';
          }
          _data[s]![d]![session] = status;
        }
      }
    }
  }

  int _daysInMonth(int year, int month) => DateTime(year, month + 1, 0).day;

  String _getDayAbbr(int day) {
    final date = DateTime(_currentYear, _currentMonth, day);
    return _dayAbbr[date.weekday - 1]; // weekday: 1=Mon
  }

  void _prevMonth() {
    setState(() {
      _currentMonth--;
      if (_currentMonth < 1) {
        _currentMonth = 12;
        _currentYear--;
      }
      _generateDummyData();
    });
  }

  void _nextMonth() {
    setState(() {
      _currentMonth++;
      if (_currentMonth > 12) {
        _currentMonth = 1;
        _currentYear++;
      }
      _generateDummyData();
    });
  }

  Future<void> _selectMonthYear(
    BuildContext context,
    AppColorSet colors,
  ) async {
    int pickerYear = _currentYear;

    await showDialog<void>(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (ctx, setDialogState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.r),
              ),
              contentPadding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 16.h),
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: () => setDialogState(() => pickerYear--),
                    icon: Icon(
                      Icons.chevron_left,
                      color: colors.primary,
                      size: 24.sp,
                    ),
                  ),
                  Text(
                    '$pickerYear',
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w700,
                      fontFamily: 'Poppins',
                      color: colors.textPrimary,
                    ),
                  ),
                  IconButton(
                    onPressed: () => setDialogState(() => pickerYear++),
                    icon: Icon(
                      Icons.chevron_right,
                      color: colors.primary,
                      size: 24.sp,
                    ),
                  ),
                ],
              ),
              content: SizedBox(
                width: double.maxFinite,
                child: GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    mainAxisSpacing: 8,
                    crossAxisSpacing: 8,
                    childAspectRatio: 2.2,
                  ),
                  itemCount: 12,
                  itemBuilder: (_, idx) {
                    final m = idx + 1;
                    final isSelected =
                        m == _currentMonth && pickerYear == _currentYear;
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          _currentMonth = m;
                          _currentYear = pickerYear;
                          _generateDummyData();
                        });
                        Navigator.pop(ctx);
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 150),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? colors.primary
                              : colors.primary.withValues(alpha: 0.06),
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          _monthNames[idx].substring(0, 3),
                          style: TextStyle(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'Poppins',
                            color: isSelected
                                ? Colors.white
                                : colors.textPrimary,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final daysInMonth = _daysInMonth(_currentYear, _currentMonth);
    final sessions = _sessions;
    final sessionCount = sessions.length;
    final colWidth = 36.0.w;
    final nameColWidth = 130.0.w;
    final rowHeight = 40.0.h;
    final headerHeight = 52.h;

    return Scaffold(
      backgroundColor: colors.background,
      body: SafeArea(
        child: Column(
          children: [
            // ── Month navigator ──
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                decoration: BoxDecoration(
                  color: colors.surface,
                  borderRadius: BorderRadius.circular(24.r),
                  border: Border.all(color: colors.border, width: 1),
                ),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: _prevMonth,
                      child: Icon(
                        Icons.chevron_left,
                        color: colors.primary,
                        size: 24.sp,
                      ),
                    ),
                    Expanded(
                      child: Center(
                        child: Text(
                          '${_monthNames[_currentMonth - 1]} $_currentYear',
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w700,
                            color: colors.textPrimary,
                            fontFamily: 'Poppins',
                          ),
                        ),
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
                    SizedBox(width: 8.w),
                    GestureDetector(
                      onTap: () => _selectMonthYear(context, colors),
                      child: Container(
                        width: 36.w,
                        height: 36.w,
                        decoration: BoxDecoration(
                          border: Border.all(color: colors.border, width: 1),
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                        child: Icon(
                          Icons.calendar_month,
                          size: 20.sp,
                          color: colors.primary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // ── Table ──
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Left: fixed SANTRI column ──
                  SizedBox(
                    width: nameColWidth,
                    child: Column(
                      children: [
                        // Header cell
                        Container(
                          height: headerHeight,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                color: colors.border,
                                width: 0.5,
                              ),
                              right: BorderSide(
                                color: colors.border,
                                width: 0.5,
                              ),
                            ),
                          ),
                          child: Text(
                            t.absensiHalaqoh.santri,
                            style: TextStyle(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w600,
                              color: colors.textSecondary,
                              fontFamily: 'Poppins',
                            ),
                          ),
                        ),
                        // Name rows
                        Expanded(
                          child: ListView.builder(
                            controller: _namesVerticalCtrl,
                            itemCount: _santriNames.length,
                            itemBuilder: (context, index) {
                              return Container(
                                height: rowHeight,
                                padding: EdgeInsets.only(left: 16.w),
                                alignment: Alignment.centerLeft,
                                decoration: BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(
                                      color: colors.border.withValues(
                                        alpha: 0.3,
                                      ),
                                      width: 0.5,
                                    ),
                                    right: BorderSide(
                                      color: colors.border,
                                      width: 0.5,
                                    ),
                                  ),
                                ),
                                child: Text(
                                  _santriNames[index],
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.w500,
                                    color: colors.textPrimary,
                                    fontFamily: 'Poppins',
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),

                  // ── Right: scrollable date grid ──
                  Expanded(
                    child: SingleChildScrollView(
                      controller: _gridHorizontalCtrl,
                      scrollDirection: Axis.horizontal,
                      child: SizedBox(
                        width: daysInMonth * sessionCount * colWidth,
                        child: Column(
                          children: [
                            // Date headers
                            SizedBox(
                              height: headerHeight,
                              child: Row(
                                children: List.generate(daysInMonth, (dayIdx) {
                                  final day = dayIdx + 1;
                                  final dayStr = day.toString().padLeft(2, '0');
                                  final dayAbbr = _getDayAbbr(day);
                                  final groupWidth = sessionCount * colWidth;

                                  return Container(
                                    width: groupWidth,
                                    decoration: BoxDecoration(
                                      border: Border(
                                        bottom: BorderSide(
                                          color: colors.border,
                                          width: 0.5,
                                        ),
                                        right: BorderSide(
                                          color: colors.border.withValues(
                                            alpha: 0.2,
                                          ),
                                          width: 0.5,
                                        ),
                                      ),
                                    ),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        // Date label: "01 SEN"
                                        Text(
                                          '$dayStr $dayAbbr',
                                          style: TextStyle(
                                            fontSize: 10.sp,
                                            fontWeight: FontWeight.w600,
                                            color: colors.textPrimary,
                                            fontFamily: 'Poppins',
                                          ),
                                        ),
                                        // Session labels row
                                        Row(
                                          children: sessions.map((s) {
                                            return Expanded(
                                              child: Center(
                                                child: Text(
                                                  s,
                                                  style: TextStyle(
                                                    fontSize: 9.sp,
                                                    fontWeight: FontWeight.w600,
                                                    color: colors.textSecondary,
                                                    fontFamily: 'Poppins',
                                                  ),
                                                ),
                                              ),
                                            );
                                          }).toList(),
                                        ),
                                      ],
                                    ),
                                  );
                                }),
                              ),
                            ),

                            // Data grid
                            Expanded(
                              child: ListView.builder(
                                controller: _gridVerticalCtrl,
                                itemCount: _santriNames.length,
                                itemBuilder: (context, santriIdx) {
                                  return SizedBox(
                                    height: rowHeight,
                                    child: Row(
                                      children: List.generate(daysInMonth, (
                                        dayIdx,
                                      ) {
                                        final day = dayIdx + 1;
                                        return Row(
                                          children: sessions.map((session) {
                                            final status =
                                                _data[santriIdx]?[day]?[session] ??
                                                'H';
                                            return Container(
                                              width: colWidth,
                                              height: rowHeight,
                                              decoration: BoxDecoration(
                                                border: Border(
                                                  bottom: BorderSide(
                                                    color: colors.border
                                                        .withValues(alpha: 0.3),
                                                    width: 0.5,
                                                  ),
                                                ),
                                              ),
                                              child: Center(
                                                child: _buildDot(
                                                  status,
                                                  colors,
                                                ),
                                              ),
                                            );
                                          }).toList(),
                                        );
                                      }),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // ── Footer: legend + download ──
            Container(
              padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 8.h),
              decoration: BoxDecoration(
                color: colors.surface,
                border: Border(
                  top: BorderSide(color: colors.border, width: 0.5),
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Status legend
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _legendDot(
                        colors.primary,
                        t.absensiHalaqoh.hadir,
                        colors,
                      ),
                      SizedBox(width: 16.w),
                      _legendDot(colors.yellow, t.absensiHalaqoh.sakit, colors),
                      SizedBox(width: 16.w),
                      _legendDot(colors.blue, t.absensiHalaqoh.izin, colors),
                      SizedBox(width: 16.w),
                      _legendDot(colors.red, t.absensiHalaqoh.alfa, colors),
                    ],
                  ),
                  SizedBox(height: 10.h),

                  // Session label legend
                  Wrap(
                    spacing: 12.w,
                    runSpacing: 6.h,
                    alignment: WrapAlignment.center,
                    children: _buildSessionLegend(colors),
                  ),
                  SizedBox(height: 14.h),

                  // Download button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        // TODO: download attendance report
                      },
                      icon: Icon(Icons.download, size: 18.sp),
                      label: Text(
                        t.absensiHalaqoh.downloadLaporan,
                        style: TextStyle(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w700,
                          fontFamily: 'Poppins',
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: colors.primary,
                        foregroundColor: colors.textOnButton,
                        padding: EdgeInsets.symmetric(vertical: 14.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24.r),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 4.h),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Session legend items ──
  List<Widget> _buildSessionLegend(AppColorSet colors) {
    final labels = <Map<String, String>>[];

    if (widget.programType == 'takhassus') {
      labels.addAll([
        {'code': 'P', 'label': t.absensiHalaqoh.pagi},
        {'code': 'D1', 'label': t.absensiHalaqoh.dhuha1},
        {'code': 'D2', 'label': t.absensiHalaqoh.dhuha2},
        {'code': 'S', 'label': t.absensiHalaqoh.sore},
        {'code': 'M', 'label': t.absensiHalaqoh.malam},
      ]);
    } else {
      labels.addAll([
        {'code': 'P', 'label': t.absensiHalaqoh.pagi},
        {'code': 'M', 'label': t.absensiHalaqoh.malam},
      ]);
    }

    return labels.map((item) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 22.w,
            height: 22.w,
            decoration: BoxDecoration(
              border: Border.all(color: colors.border, width: 1),
              borderRadius: BorderRadius.circular(6.r),
            ),
            child: Center(
              child: Text(
                item['code']!,
                style: TextStyle(
                  fontSize: 9.sp,
                  fontWeight: FontWeight.w700,
                  color: colors.primary,
                  fontFamily: 'Poppins',
                ),
              ),
            ),
          ),
          SizedBox(width: 4.w),
          Text(
            item['label']!,
            style: TextStyle(
              fontSize: 11.sp,
              fontWeight: FontWeight.w400,
              color: colors.textPrimary,
              fontFamily: 'Poppins',
            ),
          ),
        ],
      );
    }).toList();
  }

  // ── Status dot ──
  Widget _buildDot(String status, AppColorSet colors) {
    Color dotColor;
    switch (status) {
      case 'H':
        dotColor = colors.primary;
        break;
      case 'S':
        dotColor = colors.yellow;
        break;
      case 'A':
        dotColor = colors.red;
        break;
      case 'I':
        dotColor = colors.blue;
        break;
      default:
        dotColor = colors.border;
    }
    return Container(
      width: 12.w,
      height: 12.w,
      decoration: BoxDecoration(shape: BoxShape.circle, color: dotColor),
    );
  }

  // ── Legend dot + label ──
  Widget _legendDot(Color color, String label, AppColorSet colors) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 10.w,
          height: 10.w,
          decoration: BoxDecoration(shape: BoxShape.circle, color: color),
        ),
        SizedBox(width: 4.w),
        Text(
          label,
          style: TextStyle(
            fontSize: 11.sp,
            fontWeight: FontWeight.w400,
            color: colors.textPrimary,
            fontFamily: 'Poppins',
          ),
        ),
      ],
    );
  }
}
