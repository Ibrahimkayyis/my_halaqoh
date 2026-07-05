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
      case 'hadir_barcode':
        return 'H';
      case 'hadir_manual':
        return 'HT';
      case 'terlambat':
        return 'T';
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
                      padding: EdgeInsets.all(20.w),
                      decoration: BoxDecoration(
                        color: colors.surface,
                        borderRadius: BorderRadius.circular(16.r),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.04),
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
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w700,
                              color: colors.textPrimary,
                              fontFamily: 'Poppins',
                            ),
                          ),
                          SizedBox(height: 16.h),
                          // Symmetrical status legend rows
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(
                                child: _buildLegendItem(
                                  colors.primary,
                                  t.detailAbsensiHariIni.hadirBarcode,
                                  colors,
                                  customCode: 'H',
                                ),
                              ),
                              SizedBox(width: 16.w),
                              Expanded(
                                child: _buildLegendItem(
                                  colors.green,
                                  t.detailAbsensiHariIni.hadirManual,
                                  colors,
                                  customCode: 'HT',
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 16.h),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(
                                child: _buildLegendItem(
                                  const Color(0xFFF3722C),
                                  t.detailAbsensiHariIni.terlambat,
                                  colors,
                                  customCode: 'T',
                                ),
                              ),
                              SizedBox(width: 16.w),
                              Expanded(
                                child: _buildLegendItem(
                                  colors.yellow,
                                  t.kalenderAbsensi.sakit,
                                  colors,
                                  customCode: 'S',
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 16.h),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(
                                child: _buildLegendItem(
                                  colors.blue,
                                  t.kalenderAbsensi.izin,
                                  colors,
                                  customCode: 'I',
                                ),
                              ),
                              SizedBox(width: 16.w),
                              Expanded(
                                child: _buildLegendItem(
                                  colors.red,
                                  t.kalenderAbsensi.alfaLabel,
                                  colors,
                                  customCode: 'A',
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 16.h),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(
                                child: _buildLegendItem(
                                  colors.border,
                                  t.kalenderAbsensi.belumAbsen,
                                  colors,
                                  customCode: '-',
                                  isDashedBorder: true,
                                ),
                              ),
                              SizedBox(width: 16.w),
                              const Expanded(
                                child: SizedBox(),
                              ),
                            ],
                          ),
                          SizedBox(height: 24.h),
                          Text(
                            t.riwayatAbsensi.sessionKeterangan,
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w700,
                              color: colors.textPrimary,
                              fontFamily: 'Poppins',
                            ),
                          ),
                          SizedBox(height: 16.h),
                          // Session legend forced to 1 single horizontal row with horizontal scrolling to prevent overflow
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: _effectiveProgramType == 'takhassus'
                                  ? t.kalenderAbsensi.sessionsTakhassus.map((label) {
                                      final parts = label.split('. ');
                                      final code = parts[0];
                                      final name = parts.length > 1 ? parts[1] : '';
                                      return Padding(
                                        padding: EdgeInsets.only(right: 20.w),
                                        child: _buildSessionLabel(code, name, colors),
                                      );
                                    }).toList()
                                  : [
                                      _buildSessionLabel(
                                        'P',
                                        t.kalenderAbsensi.pagiKiri,
                                        colors,
                                      ),
                                      SizedBox(width: 24.w),
                                      _buildSessionLabel(
                                        'M',
                                        t.kalenderAbsensi.malamKanan,
                                        colors,
                                      ),
                                    ],
                            ),
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
      case 'HT':
        return colors.green;
      case 'T':
        return const Color(0xFFF3722C);
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

  Widget _buildLegendItem(
    Color color,
    String label,
    AppColorSet colors, {
    String? customCode,
    bool isDashedBorder = false,
  }) {
    final displayCode = customCode ?? label[0];
    return Row(
      children: [
        Container(
          width: 28.w,
          height: 28.w,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isDashedBorder ? Colors.transparent : color,
            border: isDashedBorder
                ? Border.all(color: color, width: 1.5, style: BorderStyle.solid)
                : null,
          ),
          child: Center(
            child: Text(
              displayCode,
              style: TextStyle(
                fontSize: displayCode.length > 1 ? 10.sp : 12.sp,
                fontWeight: FontWeight.w700,
                color: isDashedBorder ? colors.textSecondary : Colors.white,
                fontFamily: 'Poppins',
              ),
            ),
          ),
        ),
        SizedBox(width: 10.w),
        Expanded(
          child: Text(
            label,
            style: TextStyle(
              fontSize: 12.5.sp,
              fontWeight: FontWeight.w500,
              color: colors.textPrimary,
              fontFamily: 'Poppins',
              height: 1.2,
            ),
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
          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
          decoration: BoxDecoration(
            color: colors.border.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(6.r),
          ),
          child: Text(
            code,
            style: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.w700,
              color: colors.primary,
              fontFamily: 'Poppins',
            ),
          ),
        ),
        SizedBox(width: 6.w),
        Text(
          name,
          style: TextStyle(
            fontSize: 12.sp,
            fontWeight: FontWeight.w500,
            color: colors.textPrimary,
            fontFamily: 'Poppins',
          ),
        ),
      ],
    );
  }
}
