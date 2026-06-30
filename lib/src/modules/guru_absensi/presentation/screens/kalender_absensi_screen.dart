import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_halaqoh/gen/i18n/translations.g.dart';
import 'package:my_halaqoh/src/core/service_locator/service_locator.dart';
import 'package:my_halaqoh/src/core/theme/app_colors.dart';
import 'package:my_halaqoh/src/core/widget/widgets.dart';
import 'package:my_halaqoh/src/core/helpers/active_session_helper.dart';
import 'package:my_halaqoh/src/modules/guru_absensi/domain/models/absensi_model.dart';
import 'package:my_halaqoh/src/modules/guru_absensi/presentation/cubits/absensi_cubit.dart';
import 'package:my_halaqoh/src/modules/guru_absensi/presentation/cubits/absensi_state.dart';
import 'package:my_halaqoh/src/modules/master_data/domain/models/halaqoh_model.dart';
import 'package:my_halaqoh/src/modules/master_data/presentation/cubits/halaqoh_cubit.dart';
import 'package:my_halaqoh/src/modules/master_data/presentation/cubits/halaqoh_state.dart';

/// Kalender Absensi Lengkap — full month calendar with session dots
@RoutePage()
class KalenderAbsensiScreen extends StatefulWidget {
  final String name;
  final String nis;

  const KalenderAbsensiScreen({
    super.key,
    @PathParam('name') required this.name,
    @PathParam('nis') required this.nis,
  });

  @override
  State<KalenderAbsensiScreen> createState() => _KalenderAbsensiScreenState();
}

class _KalenderAbsensiScreenState extends State<KalenderAbsensiScreen> {
  int _currentMonth = DateTime.now().month;
  int _currentYear = DateTime.now().year;

  late AbsensiCubit _absensiCubit;

  // Resolved from the Halaqoh's program field in _loadData().
  String _effectiveProgramType = 'reguler';

  List<String> get _sessionKeys {
    if (_effectiveProgramType == 'takhassus') {
      return ['shubuh', 'dhuha', 'siang', 'ashar', 'maghrib'];
    }
    return ['shubuh', 'maghrib'];
  }

  List<String> get _sessionLabels {
    if (_effectiveProgramType == 'takhassus') {
      return t.kalenderAbsensi.sessionsTakhassus;
    }
    return t.kalenderAbsensi.sessionsReguler;
  }

  @override
  void initState() {
    super.initState();
    _absensiCubit = sl<AbsensiCubit>();
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadData());
  }

  void _loadData() {
    final linkedDocId = ActiveSessionHelper.getActiveLinkedDocId(context) ?? '';
    final halaqohState = context.read<HalaqohCubit>().state;

    HalaqohModel? myHalaqoh;
    halaqohState.maybeWhen(
      loaded: (list) {
        try {
          myHalaqoh = list.firstWhere((h) => h.guruId == linkedDocId);
        } catch (_) {}
      },
      orElse: () {},
    );

    if (myHalaqoh != null) {
      _absensiCubit.watchByHalaqoh(myHalaqoh!.id);
      // Resolve and cache the effective program type from the Halaqoh.
      final derived = myHalaqoh!.program == 'T' ? 'takhassus' : 'reguler';
      if (derived != _effectiveProgramType) {
        setState(() => _effectiveProgramType = derived);
      }
    }
  }

  @override
  void dispose() {
    _absensiCubit.close();
    super.dispose();
  }

  /// Build attendance data from real AbsensiModel records for this student + month
  Map<int, Map<String, String>> _buildAttendanceData(
    List<AbsensiModel> allRecords,
  ) {
    final data = <int, Map<String, String>>{};
    final keys = _sessionKeys;

    for (final record in allRecords) {
      if (record.tanggal.month != _currentMonth ||
          record.tanggal.year != _currentYear) {
        continue;
      }
      if (!keys.contains(record.sesi)) continue;

      final day = record.tanggal.day;
      final entry = record.records.where((r) => r.nis == widget.nis);
      if (entry.isEmpty) continue;

      final status = entry.first.status;
      final statusCode = _statusToCode(status);

      data.putIfAbsent(day, () => {});
      data[day]![record.sesi] = statusCode;
    }

    return data;
  }

  String _statusToCode(String status) {
    switch (status) {
      case 'hadir':
        return 'H';
      case 'sakit':
        return 'S';
      case 'izin':
        return 'I';
      case 'alfa':
        return 'A';
      default:
        return '-';
    }
  }

  int _daysInMonth(int year, int month) => DateTime(year, month + 1, 0).day;

  int _firstWeekdayOfMonth(int year, int month) =>
      DateTime(year, month, 1).weekday % 7;

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

    return BlocProvider.value(
      value: _absensiCubit,
      child: BlocBuilder<AbsensiCubit, AbsensiState>(
        builder: (context, absensiState) {
          List<AbsensiModel> allRecords = [];
          absensiState.maybeWhen(
            loaded: (data) => allRecords = data,
            orElse: () {},
          );

          final attendanceData = _buildAttendanceData(allRecords);
          final daysInMonth = _daysInMonth(_currentYear, _currentMonth);
          final firstWeekday = _firstWeekdayOfMonth(
            _currentYear,
            _currentMonth,
          );
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
                          Expanded(
                            child: Column(
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
                                  t.kalenderAbsensi.nisLabel(nis: widget.nis),
                                  style: TextStyle(
                                    fontSize: 13.sp,
                                    color: Colors.white.withValues(alpha: 0.85),
                                    fontFamily: 'Poppins',
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 20.h),

                  // ── Month navigator ──
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
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20.h),

                  // ── Calendar grid ──
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
                        ..._buildCalendarRows(
                          daysInMonth,
                          firstWeekday,
                          attendanceData,
                          colors,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 24.h),

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
                              _buildLegendDot(
                                colors.yellow,
                                t.kalenderAbsensi.sakit,
                                colors,
                              ),
                            ],
                          ),
                          SizedBox(height: 10.h),
                          Row(
                            children: [
                              _buildLegendDot(
                                colors.blue,
                                t.kalenderAbsensi.izin,
                                colors,
                              ),
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
                          if (_effectiveProgramType == 'takhassus')
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
        },
      ),
    );
  }

  List<Widget> _buildCalendarRows(
    int daysInMonth,
    int firstWeekday,
    Map<int, Map<String, String>> attendanceData,
    AppColorSet colors,
  ) {
    final rows = <Widget>[];
    int dayCounter = 1;
    final totalCells = firstWeekday + daysInMonth;
    final totalRows = (totalCells / 7).ceil();

    for (int row = 0; row < totalRows; row++) {
      final cells = <Widget>[];
      for (int col = 0; col < 7; col++) {
        final cellIndex = row * 7 + col;
        if (cellIndex < firstWeekday || dayCounter > daysInMonth) {
          cells.add(const Expanded(child: SizedBox()));
        } else {
          final day = dayCounter;
          final data = attendanceData[day];
          final hasData = data != null && data.isNotEmpty;
          cells.add(
            Expanded(
              child: _buildCalendarCell(day, hasData, colors, data: data),
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
    bool hasData,
    AppColorSet colors, {
    Map<String, String>? data,
  }) {
    final isFuture = !hasData;
    final keys = _sessionKeys;
    final safeData = data ?? <String, String>{};

    return Container(
      height: _effectiveProgramType == 'takhassus' ? 58.h : 52.h,
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
              fontSize: _effectiveProgramType == 'takhassus' ? 11.sp : 13.sp,
              fontWeight: FontWeight.w600,
              color: isFuture
                  ? colors.textSecondary.withValues(alpha: 0.6)
                  : colors.textPrimary,
              fontFamily: 'Poppins',
            ),
          ),
          SizedBox(height: 2.h),
          if (_effectiveProgramType == 'takhassus')
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildDot(_statusColor(safeData[keys[0]], colors)),
                    SizedBox(width: 2.w),
                    _buildDot(_statusColor(safeData[keys[1]], colors)),
                    SizedBox(width: 2.w),
                    _buildDot(_statusColor(safeData[keys[2]], colors)),
                  ],
                ),
                SizedBox(height: 2.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildDot(_statusColor(safeData[keys[3]], colors)),
                    SizedBox(width: 2.w),
                    _buildDot(_statusColor(safeData[keys[4]], colors)),
                  ],
                ),
              ],
            )
          else
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildDot(_statusColor(safeData[keys[0]], colors)),
                SizedBox(width: 3.w),
                _buildDot(_statusColor(safeData[keys[1]], colors)),
              ],
            ),
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
            color: colors.textSecondary,
            fontFamily: 'Poppins',
          ),
        ),
      ],
    );
  }
}
