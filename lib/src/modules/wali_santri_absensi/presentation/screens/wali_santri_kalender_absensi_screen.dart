import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_halaqoh/gen/i18n/translations.g.dart';
import 'package:my_halaqoh/src/core/service_locator/service_locator.dart';
import 'package:my_halaqoh/src/core/theme/app_colors.dart';
import 'package:my_halaqoh/src/core/widget/widgets.dart';
import 'package:my_halaqoh/src/modules/auth/presentation/cubits/auth_cubit.dart';
import 'package:my_halaqoh/src/modules/auth/presentation/cubits/auth_state.dart';
import 'package:my_halaqoh/src/core/helpers/active_session_helper.dart';
import 'package:my_halaqoh/src/modules/guru_absensi/domain/models/absensi_model.dart';
import 'package:my_halaqoh/src/modules/guru_absensi/presentation/cubits/absensi_cubit.dart';
import 'package:my_halaqoh/src/modules/guru_absensi/presentation/cubits/absensi_state.dart';
import 'package:my_halaqoh/src/modules/master_data/domain/models/halaqoh_model.dart';
import 'package:my_halaqoh/src/modules/master_data/domain/models/santri_model.dart';
import 'package:my_halaqoh/src/modules/master_data/presentation/cubits/halaqoh_cubit.dart';
import 'package:my_halaqoh/src/modules/master_data/presentation/cubits/halaqoh_state.dart';
import 'package:my_halaqoh/src/modules/master_data/presentation/cubits/santri_cubit.dart';
import 'package:my_halaqoh/src/modules/master_data/presentation/cubits/santri_state.dart';

/// Kalender Absensi Lengkap — full month calendar with session dots
@RoutePage()
class WaliSantriKalenderAbsensiScreen extends StatefulWidget {
  final String name;
  final String nis;
  final String programType;

  const WaliSantriKalenderAbsensiScreen({
    super.key,
    @PathParam('name') required this.name,
    @PathParam('nis') required this.nis,
    @PathParam('programType') this.programType = 'reguler',
  });

  @override
  State<WaliSantriKalenderAbsensiScreen> createState() =>
      _WaliSantriKalenderAbsensiScreenState();
}

class _WaliSantriKalenderAbsensiScreenState
    extends State<WaliSantriKalenderAbsensiScreen> {
  int _currentMonth = DateTime.now().month;
  int _currentYear = DateTime.now().year;

  late AbsensiCubit _absensiCubit;
  String? _watchedHalaqohId;

  List<String> get _sessionKeys {
    if (widget.programType == 'takhassus') {
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

  @override
  void dispose() {
    _absensiCubit.close();
    super.dispose();
  }

  void _loadData() {
    if (!mounted) return;
    final linkedDocId = ActiveSessionHelper.getActiveLinkedDocId(context) ?? '';
    final halaqohState = context.read<HalaqohCubit>().state;

    HalaqohModel? myHalaqoh;
    halaqohState.maybeWhen(
      loaded: (list) {
        try {
          myHalaqoh = list.firstWhere(
            (h) => h.santriIds.contains(linkedDocId),
          );
        } catch (_) {}
      },
      orElse: () {},
    );

    if (myHalaqoh != null && _watchedHalaqohId != myHalaqoh!.id) {
      _watchedHalaqohId = myHalaqoh!.id;
      // watchByHalaqohFromRemote: stream dari Firestore langsung.
      // Wali santri berada di device berbeda dari guru — Hive lokal tidak
      // diupdate oleh guru, sehingga harus stream dari Firestore agar realtime.
      _absensiCubit.watchByHalaqohFromRemote(myHalaqoh!.id);
    }
  }

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

    final linkedDocId = ActiveSessionHelper.getActiveLinkedDocId(context) ?? '';
    final halaqohState = context.watch<HalaqohCubit>().state;
    final santriState = context.watch<SantriCubit>().state;

    SantriModel? mySantri;
    santriState.maybeWhen(
      loaded: (list) {
        try {
          mySantri = list.firstWhere((s) => s.id == linkedDocId);
        } catch (_) {
          try {
            mySantri = list.firstWhere((s) => s.nis == widget.nis);
          } catch (_) {}
        }
      },
      orElse: () {},
    );

    final displayName = mySantri?.nama ?? widget.name;
    final displayNis = mySantri?.nis ?? widget.nis;

    HalaqohModel? myHalaqoh;
    halaqohState.maybeWhen(
      loaded: (list) {
        try {
          myHalaqoh =
              list.firstWhere((h) => h.santriIds.contains(linkedDocId));
        } catch (_) {}
      },
      orElse: () {},
    );

    final halaqohLabel = myHalaqoh?.nama ?? '-';

    return MultiBlocListener(
      listeners: [
        BlocListener<AuthCubit, AuthState>(
          listener: (context, state) => _loadData(),
        ),
        BlocListener<HalaqohCubit, HalaqohState>(
          listener: (context, state) => _loadData(),
        ),
      ],
      child: BlocProvider.value(
        value: _absensiCubit,
        child: BlocBuilder<AbsensiCubit, AbsensiState>(
          builder: (context, absensiState) {
          List<AbsensiModel> allRecords = [];
          absensiState.maybeWhen(
            loaded: (data) => allRecords = data,
            orElse: () {},
          );

          final attendanceData = _buildAttendanceData(allRecords);

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
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 16.h),

                  // Santri Profile Context Header
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    child: SantriContextHeader(
                      name: displayName,
                      nis: displayNis,
                      subtitle: halaqohLabel != '-' ? halaqohLabel : null,
                      profilePictureUrl: mySantri?.profilePicture,
                    ),
                  ),
                  SizedBox(height: 22.h),

                  // Month navigator
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
                  ),
                  SizedBox(height: 20.h),

                  // Calendar grid
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24.w),
                    child: Column(
                      children: [
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
                        ..._buildCalendarRows(
                          daysInMonth,
                          firstWeekday,
                          colors,
                          attendanceData,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 24.h),

                  // ── Keterangan Card ──
                  AttendanceLegendCard(
                    programType: widget.programType,
                    showBelumAbsen: true,
                    margin: EdgeInsets.symmetric(horizontal: 20.w),
                  ),
                  SizedBox(height: 24.h),
                ],
              ),
            ),
          );
        },
      ),
    ),
  );
}

  List<Widget> _buildCalendarRows(
    int daysInMonth,
    int firstWeekday,
    AppColorSet colors,
    Map<int, Map<String, String>> attendanceData,
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
          // FIX: always pass data (empty map if no attendance for that day)
          final data = attendanceData[day] ?? <String, String>{};
          cells.add(
            Expanded(
              child: _buildCalendarCell(day, colors, data: data),
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

  /// FIX: removed `hasData`/`isFuture` logic — every day renders dots.
  /// Dot color is `colors.border` when no session data (same as guru kalender screen).
  Widget _buildCalendarCell(
    int day,
    AppColorSet colors, {
    required Map<String, String> data,
  }) {
    final keys = _sessionKeys;

    return Container(
      height: widget.programType == 'takhassus' ? 58.h : 52.h,
      margin: EdgeInsets.all(2.w),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(
          color: colors.border.withValues(alpha: 0.5),
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
              color: colors.textPrimary,
              fontFamily: 'Poppins',
            ),
          ),
          SizedBox(height: 2.h),
          if (widget.programType == 'takhassus')
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
                _buildDot(_statusColor(data[keys[0]], colors)),
                SizedBox(width: 3.w),
                _buildDot(_statusColor(data[keys[1]], colors)),
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
}