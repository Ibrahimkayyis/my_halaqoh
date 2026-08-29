import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_halaqoh/gen/i18n/translations.g.dart';
import 'package:my_halaqoh/src/core/service_locator/service_locator.dart';
import 'package:my_halaqoh/src/core/theme/app_colors.dart';
import 'package:my_halaqoh/src/core/widget/widgets.dart';
import 'package:my_halaqoh/src/core/router/app_router.dart';
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
import 'package:my_halaqoh/src/modules/guru_laporan/presentation/widgets/laporan_konfigurasi_sheet.dart';

/// Riwayat Absensi screen — individual student attendance history
@RoutePage()
class RiwayatAbsensiScreen extends StatefulWidget {
  final String name;
  final String nis;

  const RiwayatAbsensiScreen({
    super.key,
    @PathParam('name') required this.name,
    @PathParam('nis') required this.nis,
  });

  @override
  State<RiwayatAbsensiScreen> createState() => _RiwayatAbsensiScreenState();
}

class _RiwayatAbsensiScreenState extends State<RiwayatAbsensiScreen> {
  int _currentMonth = DateTime.now().month;
  int _currentYear = DateTime.now().year;

  List<String> get _dayNames => t.calendar.daysAbbrSundayFirst;

  late AbsensiCubit _absensiCubit;

  // Resolved from the Halaqoh's program field in _loadData(). Defaults to
  // 'reguler' until the Halaqoh is loaded.
  String _effectiveProgramType = 'reguler';

  List<String> get _sessionKeys {
    if (_effectiveProgramType == 'takhassus') {
      return ['shubuh', 'dhuha', 'siang', 'ashar', 'maghrib'];
    }
    return ['shubuh', 'maghrib'];
  }

  List<String> get _sessionLabels {
    if (_effectiveProgramType == 'takhassus') {
      return ['P', 'D', 'S', 'A', 'M'];
    }
    return ['P', 'M'];
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

      // Find this student's entry in the record
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

  Map<String, int> _computeStats(Map<int, Map<String, String>> attendanceData) {
    int hadir = 0, sakit = 0, izin = 0, alfa = 0;
    for (final data in attendanceData.values) {
      for (final status in data.values) {
        switch (status) {
          case 'H':
            hadir++;
            break;
          case 'S':
            sakit++;
            break;
          case 'I':
            izin++;
            break;
          case 'A':
            alfa++;
            break;
        }
      }
    }
    return {
      'hadir': hadir,
      'sakit': sakit,
      'izin': izin,
      'alfa': alfa,
    };
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

    // Look up real santri data by NIS
    final santriState = context.watch<SantriCubit>().state;
    SantriModel? santri;
    santriState.maybeWhen(
      loaded: (list) {
        try {
          santri = list.firstWhere((s) => s.nis == widget.nis);
        } catch (_) {}
      },
      orElse: () {},
    );

    return BlocProvider.value(
      value: _absensiCubit,
      child: BlocBuilder<AbsensiCubit, AbsensiState>(
        builder: (context, absensiState) {
          List<AbsensiModel> allRecords = [];
          String? errorMsg;
          absensiState.maybeWhen(
            loaded: (data) => allRecords = data,
            error: (msg) => errorMsg = msg,
            orElse: () {},
          );

          if (errorMsg != null) {
            return Scaffold(
              appBar: AppBar(title: Text(t.riwayatAbsensi.title)),
              body: Center(
                child: Text(
                  t.riwayatAbsensi.error(message: errorMsg!),
                  style: TextStyle(color: Colors.red),
                ),
              ),
            );
          }

          final attendanceData = _buildAttendanceData(allRecords);
          final stats = _computeStats(attendanceData);

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
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 16.h),

                  // ── Profile Context Header ──
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    child: SantriContextHeader(
                      name: santri?.nama ?? widget.name,
                      nis: santri?.nis ?? widget.nis,
                      subtitle: santri != null && santri!.kelas.isNotEmpty
                          ? 'Kelas ${santri!.kelas}${santri!.program}'
                          : null,
                      profilePictureUrl: santri?.profilePicture,
                    ),
                  ),
                  SizedBox(height: 22.h),

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
                  SizedBox(height: 16.h),

                  // ── Summary stats ──
                  AttendanceSummaryCard(
                    stats: stats,
                    margin: EdgeInsets.symmetric(horizontal: 20.w),
                  ),
                  SizedBox(height: 20.h),

                  // ── Day cards ──
                  SizedBox(
                    height: _effectiveProgramType == 'takhassus'
                        ? 350.h
                        : 200.h,
                    child: Builder(
                      builder: (context) {
                        final totalDays = DateUtils.getDaysInMonth(
                          _currentYear,
                          _currentMonth,
                        );
                        final daysList = List.generate(
                          totalDays,
                          (index) => index + 1,
                        );

                        return ListView.builder(
                          scrollDirection: Axis.horizontal,
                          padding: EdgeInsets.symmetric(horizontal: 24.w),
                          itemCount: daysList.length,
                          itemBuilder: (context, index) {
                            final day = daysList[index];
                            final data =
                                attendanceData[day] ?? <String, String>{};
                            return _buildDayCard(
                              day,
                              _getDayName(day),
                              data,
                              colors,
                            );
                          },
                        );
                      },
                    ),
                  ),
                  SizedBox(height: 8.h),

                  // ── Swipe hint ──
                  Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 24.w),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.chevron_left,
                            size: 16.sp,
                            color: colors.textSecondary.withValues(alpha: 0.5),
                          ),
                          Flexible(
                            child: Text(
                              t.riwayatAbsensi.geserHint,
                              textAlign: TextAlign.center,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 12.sp,
                                color: colors.textSecondary.withValues(
                                  alpha: 0.5,
                                ),
                                fontFamily: 'Poppins',
                              ),
                            ),
                          ),
                          Icon(
                            Icons.chevron_right,
                            size: 16.sp,
                            color: colors.textSecondary.withValues(alpha: 0.5),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 16.h),

                  // ── Action buttons (Kalender & Download) ──
                  AttendanceActionRow(
                    margin: EdgeInsets.symmetric(horizontal: 20.w),
                    onViewCalendar: () {
                      context.router.push(
                        KalenderAbsensiRoute(
                          name: widget.name,
                          nis: widget.nis,
                        ),
                      );
                    },
                    onDownloadReport: () {
                      // Resolve the teacher's halaqoh from the global cubit
                      HalaqohModel? myHalaqoh;
                      final linkedDocId =
                          ActiveSessionHelper.getActiveLinkedDocId(context) ??
                          '';
                      context.read<HalaqohCubit>().state.maybeWhen(
                        loaded: (list) {
                          try {
                            myHalaqoh = list.firstWhere(
                              (h) => h.guruId == linkedDocId,
                            );
                          } catch (_) {}
                        },
                        orElse: () {},
                      );

                      LaporanKonfigurasiSheet.show(
                        context,
                        records: allRecords,
                        santriName: widget.name,
                        santriNis: widget.nis,
                        programType: _effectiveProgramType,
                        halaqoh: myHalaqoh,
                        initialMonth: _currentMonth,
                        initialYear: _currentYear,
                      );
                    },
                  ),
                  SizedBox(height: 16.h),

                  // ── Keterangan Card ──
                  AttendanceLegendCard(
                    programType: _effectiveProgramType,
                    margin: EdgeInsets.symmetric(horizontal: 20.w),
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

  Widget _buildDayCard(
    int day,
    String dayName,
    Map<String, String> data,
    AppColorSet colors,
  ) {
    final keys = _sessionKeys;
    final labels = _sessionLabels;

    return Container(
      width: _effectiveProgramType == 'takhassus' ? 80.w : 72.w,
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
                _buildStatusBadge(data[keys[i]] ?? '-', colors),
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
      case 'H':
        bgColor = colors.primary;
        label = 'H';
        break;
      case 'S':
        bgColor = colors.yellow;
        label = 'S';
        break;
      case 'I':
        bgColor = colors.blue;
        label = 'I';
        break;
      case 'A':
        bgColor = colors.red;
        label = 'A';
        break;
      default:
        bgColor = colors.border;
        label = '-';
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
}

