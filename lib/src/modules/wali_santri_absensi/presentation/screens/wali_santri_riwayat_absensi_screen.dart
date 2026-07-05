import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_halaqoh/gen/i18n/translations.g.dart';
import 'package:my_halaqoh/src/core/router/app_router.dart';
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

/// Riwayat Absensi screen — individual student attendance history
@RoutePage()
class WaliSantriRiwayatAbsensiScreen extends StatefulWidget {
  final String name;
  final String nis;
  final String programType;

  const WaliSantriRiwayatAbsensiScreen({
    super.key,
    @PathParam('name') required this.name,
    @PathParam('nis') required this.nis,
    @PathParam('programType') this.programType = 'reguler',
  });

  @override
  State<WaliSantriRiwayatAbsensiScreen> createState() =>
      _WaliSantriRiwayatAbsensiScreenState();
}

class _WaliSantriRiwayatAbsensiScreenState
    extends State<WaliSantriRiwayatAbsensiScreen> {
  int _currentMonth = DateTime.now().month;
  int _currentYear = DateTime.now().year;

  List<String> get _dayNames => [
    t.kalenderAbsensi.aha,
    t.kalenderAbsensi.sen,
    t.kalenderAbsensi.sel,
    t.kalenderAbsensi.rab,
    t.kalenderAbsensi.kam,
    t.kalenderAbsensi.jum,
    t.kalenderAbsensi.sab,
  ];

  late AbsensiCubit _absensiCubit;
  String? _watchedHalaqohId;

  List<String> get _sessionKeys {
    if (widget.programType == 'takhassus') {
      return ['shubuh', 'dhuha', 'siang', 'ashar', 'maghrib'];
    }
    return ['shubuh', 'maghrib'];
  }

  List<String> get _sessionLabels {
    if (widget.programType == 'takhassus') {
      return t.riwayatAbsensi.abbrTakhassus;
    }
    return t.riwayatAbsensi.abbrReguler;
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
          myHalaqoh = list.firstWhere((h) => h.santriIds.contains(linkedDocId));
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

  Map<String, int> _computeStats(Map<int, Map<String, String>> attendanceData) {
    int hadirBarcode = 0,
        hadirManual = 0,
        terlambat = 0,
        sakit = 0,
        izin = 0,
        alfa = 0;
    for (final data in attendanceData.values) {
      for (final status in data.values) {
        switch (status) {
          case 'H':
            hadirBarcode++;
            break;
          case 'HT':
            hadirManual++;
            break;
          case 'T':
            terlambat++;
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
      'hadir_barcode': hadirBarcode,
      'hadir_manual': hadirManual,
      'terlambat': terlambat,
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

    final linkedDocId = ActiveSessionHelper.getActiveLinkedDocId(context) ?? '';
    final santriState = context.watch<SantriCubit>().state;
    final halaqohState = context.watch<HalaqohCubit>().state;

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
          myHalaqoh = list.firstWhere((h) => h.santriIds.contains(linkedDocId));
        } catch (_) {}
      },
      orElse: () {},
    );

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
            final stats = _computeStats(attendanceData);

            // FIX: always show all days in month, empty map if no data
            final totalDays = DateUtils.getDaysInMonth(
              _currentYear,
              _currentMonth,
            );
            final allDays = List.generate(totalDays, (i) => i + 1);

            return Scaffold(
              backgroundColor: colors.background,
              body: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 40.h),

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
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              width: 48.w,
                              height: 48.w,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white.withValues(alpha: 0.2),
                                image: mySantri?.profilePicture != null
                                    ? DecorationImage(
                                        image: NetworkImage(
                                          mySantri!.profilePicture!,
                                        ),
                                        fit: BoxFit.cover,
                                      )
                                    : null,
                              ),
                              child: mySantri?.profilePicture == null
                                  ? Icon(
                                      Icons.person,
                                      size: 26.sp,
                                      color: Colors.white,
                                    )
                                  : null,
                            ),
                            SizedBox(width: 14.w),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    displayName,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontSize: 17.sp,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.white,
                                      fontFamily: 'Poppins',
                                    ),
                                  ),
                                  SizedBox(height: 2.h),
                                  Text(
                                    t.riwayatAbsensi.nisLabel(nis: displayNis),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontSize: 13.sp,
                                      fontWeight: FontWeight.w400,
                                      color: Colors.white.withValues(
                                        alpha: 0.85,
                                      ),
                                      fontFamily: 'Poppins',
                                    ),
                                  ),
                                  SizedBox(height: 1.h),
                                  Text(
                                    myHalaqoh != null
                                        ? t.riwayatAbsensi.halaqohKelas(
                                            halaqoh: myHalaqoh!.nama,
                                            kelas: myHalaqoh!.kelas,
                                          )
                                        : t
                                              .riwayatAbsensi
                                              .belumTerdaftarHalaqoh,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontSize: 13.sp,
                                      fontWeight: FontWeight.w400,
                                      color: Colors.white.withValues(
                                        alpha: 0.85,
                                      ),
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
                    SizedBox(height: 16.h),

                    // Summary stats
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 24.w),
                      child: Container(
                        width: double.infinity,
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
                            Padding(
                              padding: EdgeInsets.fromLTRB(
                                20.w,
                                16.h,
                                20.w,
                                12.h,
                              ),
                              child: Text(
                                t.riwayatAbsensi.ringkasanKehadiran,
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w700,
                                  color: colors.textPrimary,
                                  fontFamily: 'Poppins',
                                ),
                              ),
                            ),
                            // Row 1
                            SizedBox(
                              height: 92.h,
                              child: Row(
                                children: [
                                  _buildStat(
                                    '${stats['hadir_barcode']}',
                                    t.detailAbsensiHariIni.hadirBarcode,
                                    colors.primary,
                                    colors,
                                  ),
                                  _buildShortDivider(colors),
                                  _buildStat(
                                    '${stats['hadir_manual']}',
                                    t.detailAbsensiHariIni.hadirManual,
                                    colors.green,
                                    colors,
                                  ),
                                  _buildShortDivider(colors),
                                  _buildStat(
                                    '${stats['terlambat']}',
                                    t.detailAbsensiHariIni.terlambat,
                                    const Color(0xFFF3722C),
                                    colors,
                                  ),
                                ],
                              ),
                            ),
                            // Row 2
                            SizedBox(
                              height: 84.h,
                              child: Row(
                                children: [
                                  _buildStat(
                                    '${stats['sakit']}',
                                    t.riwayatAbsensi.sakit,
                                    colors.yellow,
                                    colors,
                                  ),
                                  _buildShortDivider(colors),
                                  _buildStat(
                                    '${stats['izin']}',
                                    t.riwayatAbsensi.izin,
                                    colors.blue,
                                    colors,
                                  ),
                                  _buildShortDivider(colors),
                                  _buildStat(
                                    '${stats['alfa']}',
                                    t.riwayatAbsensi.alfa,
                                    colors.red,
                                    colors,
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 4.h),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 20.h),

                    // Day cards — ALL days in month, empty data shown as '-'
                    SizedBox(
                      height: widget.programType == 'takhassus' ? 315.h : 180.h,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        padding: EdgeInsets.symmetric(horizontal: 24.w),
                        itemCount: allDays.length,
                        itemBuilder: (context, index) {
                          final day = allDays[index];
                          // If no data for this day, pass empty map
                          final data =
                              attendanceData[day] ?? <String, String>{};
                          return _buildDayCard(
                            day,
                            _getDayName(day),
                            data,
                            colors,
                          );
                        },
                      ),
                    ),
                    SizedBox(height: 8.h),

                    // Swipe hint
                    Center(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 24.w),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.chevron_left,
                              size: 16.sp,
                              color: colors.textSecondary.withValues(
                                alpha: 0.5,
                              ),
                            ),
                            Flexible(
                              child: Text(
                                t.riwayatAbsensi.geserHint,
                                textAlign: TextAlign.center,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w400,
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
                              color: colors.textSecondary.withValues(
                                alpha: 0.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 16.h),

                    // Lihat Kalender button
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 24.w),
                      child: GestureDetector(
                        onTap: () {
                          context.router.push(
                            WaliSantriKalenderAbsensiRoute(
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
                            border: Border.all(
                              color: colors.primary,
                              width: 1.5,
                            ),
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
                              Icon(
                                Icons.calendar_month,
                                size: 20.sp,
                                color: colors.primary,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 16.h),

                    // Keterangan card
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
                              t.riwayatAbsensi.keterangan,
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
                                    t.riwayatAbsensi.sakitLabel,
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
                                    t.riwayatAbsensi.izinLabel,
                                    colors,
                                    customCode: 'I',
                                  ),
                                ),
                                SizedBox(width: 16.w),
                                Expanded(
                                  child: _buildLegendItem(
                                    colors.red,
                                    t.riwayatAbsensi.alphaLabel,
                                    colors,
                                    customCode: 'A',
                                  ),
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
                                children: widget.programType == 'takhassus'
                                    ? [
                                        _buildSessionLabel(
                                          _sessionLabels[0],
                                          t.riwayatAbsensi.sessionPagiShubuh,
                                          colors,
                                        ),
                                        SizedBox(width: 20.w),
                                        _buildSessionLabel(
                                          _sessionLabels[1],
                                          t.riwayatAbsensi.sessionDhuha,
                                          colors,
                                        ),
                                        SizedBox(width: 20.w),
                                        _buildSessionLabel(
                                          _sessionLabels[2],
                                          t.riwayatAbsensi.sessionSiang,
                                          colors,
                                        ),
                                        SizedBox(width: 20.w),
                                        _buildSessionLabel(
                                          _sessionLabels[3],
                                          t.riwayatAbsensi.sessionSoreAshar,
                                          colors,
                                        ),
                                        SizedBox(width: 20.w),
                                        _buildSessionLabel(
                                          _sessionLabels[4],
                                          t.riwayatAbsensi.sessionMalamMaghrib,
                                          colors,
                                        ),
                                      ]
                                    : [
                                        _buildSessionLabel(
                                          _sessionLabels[0],
                                          t.riwayatAbsensi.sessionPagiShubuh,
                                          colors,
                                        ),
                                        SizedBox(width: 24.w),
                                        _buildSessionLabel(
                                          _sessionLabels[1],
                                          t.riwayatAbsensi.sessionMalamMaghrib,
                                          colors,
                                        ),
                                      ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 100.h),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildStat(
    String value,
    String label,
    Color color,
    AppColorSet colors,
  ) {
    return Expanded(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 4.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              value,
              style: TextStyle(
                fontSize: 26.sp,
                fontWeight: FontWeight.w700,
                color: color,
                fontFamily: 'Poppins',
              ),
            ),
            SizedBox(height: 4.h),
            Flexible(
              child: Text(
                label.toUpperCase(),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 9.sp,
                  fontWeight: FontWeight.w600,
                  color: colors.textSecondary,
                  fontFamily: 'Poppins',
                  letterSpacing: 0.3,
                  height: 1.2,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// A short centered vertical line that does NOT span the full cell height —
  /// gives a lighter, more elegant look than a full VerticalDivider.
  Widget _buildShortDivider(AppColorSet colors) {
    return Center(
      child: Container(
        width: 1,
        height: 40.h,
        color: colors.border.withValues(alpha: 0.5),
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
          // Show all session badges; '-' if no data for that session
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
      case 'T':
        bgColor = const Color(0xFFF3722C);
        label = 'T';
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

  Widget _buildLegendItem(
    Color color,
    String label,
    AppColorSet colors, {
    String? customCode,
  }) {
    final displayCode = customCode ?? label[0];
    return Row(
      children: [
        Container(
          width: 28.w,
          height: 28.w,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color,
          ),
          child: Center(
            child: Text(
              displayCode,
              style: TextStyle(
                fontSize: displayCode.length > 1 ? 10.sp : 12.sp,
                fontWeight: FontWeight.w700,
                color: Colors.white,
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
