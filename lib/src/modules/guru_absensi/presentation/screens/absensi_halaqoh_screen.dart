import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_halaqoh/gen/i18n/translations.g.dart';
import 'package:my_halaqoh/src/core/theme/app_colors.dart';
import 'package:my_halaqoh/src/core/widget/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_halaqoh/src/core/service_locator/service_locator.dart';
import 'package:my_halaqoh/src/core/helpers/active_session_helper.dart';
import 'package:my_halaqoh/src/modules/master_data/presentation/cubits/halaqoh_cubit.dart';
import 'package:my_halaqoh/src/modules/master_data/presentation/cubits/halaqoh_state.dart';
import 'package:my_halaqoh/src/modules/master_data/presentation/cubits/santri_cubit.dart';
import 'package:my_halaqoh/src/modules/guru_absensi/presentation/cubits/absensi_cubit.dart';
import 'package:my_halaqoh/src/modules/guru_absensi/presentation/cubits/absensi_state.dart';
import 'package:my_halaqoh/src/modules/master_data/domain/models/halaqoh_model.dart';
import 'package:my_halaqoh/src/modules/master_data/domain/models/santri_model.dart';
import 'package:my_halaqoh/src/modules/guru_absensi/domain/models/absensi_model.dart';
import 'package:my_halaqoh/src/modules/master_data/presentation/cubits/santri_state.dart';
import 'package:my_halaqoh/src/modules/guru_laporan/presentation/widgets/laporan_konfigurasi_halaqoh_sheet.dart';

/// Absensi Halaqoh — split-panel attendance grid.
/// Names stick on the left, dates+sessions scroll horizontally.
/// Derives program type at runtime from HalaqohModel.program.
@RoutePage()
class AbsensiHalaqohScreen extends StatefulWidget {
  const AbsensiHalaqohScreen({super.key});

  @override
  State<AbsensiHalaqohScreen> createState() => _AbsensiHalaqohScreenState();
}

class _AbsensiHalaqohScreenState extends State<AbsensiHalaqohScreen> {
  // Default to current month & year
  late int _currentMonth;
  late int _currentYear;

  List<String> get _dayAbbr => t.calendar.daysAbbr;

  // Session keys and abbreviations are computed from the resolved programType
  // (see _effectiveProgramType() in build). These static helpers accept the
  // derived string so the getters can remain pure.
  static List<String> _sessionKeysFor(String programType) {
    if (programType == 'takhassus') {
      return ['shubuh', 'dhuha', 'siang', 'ashar', 'maghrib'];
    }
    return ['shubuh', 'maghrib'];
  }

  static List<String> _sessionAbbrFor(String programType) {
    if (programType == 'takhassus') {
      return ['P', 'D', 'S', 'A', 'M'];
    }
    return ['P', 'M'];
  }

  final ScrollController _namesVerticalCtrl = ScrollController();

  late AbsensiCubit _absensiCubit;

  @override
  void initState() {
    super.initState();
    // Initialize to current month/year
    final now = DateTime.now();
    _currentMonth = now.month;
    _currentYear = now.year;

    _absensiCubit = sl<AbsensiCubit>();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadData();
    });
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
    }
  }

  @override
  void dispose() {
    _namesVerticalCtrl.dispose();
    _absensiCubit.close();
    super.dispose();
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

  String _getDayAbbr(int day) {
    final date = DateTime(_currentYear, _currentMonth, day);
    return _dayAbbr[date.weekday - 1];
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
    final daysInMonth = _daysInMonth(_currentYear, _currentMonth);

    final linkedDocId = ActiveSessionHelper.getActiveLinkedDocId(context) ?? '';
    final halaqohState = context.watch<HalaqohCubit>().state;
    final santriState = context.watch<SantriCubit>().state;

    HalaqohModel? myHalaqoh;
    halaqohState.maybeWhen(
      loaded: (list) {
        try {
          myHalaqoh = list.firstWhere((h) => h.guruId == linkedDocId);
        } catch (_) {}
      },
      orElse: () {},
    );

    // Derive the effective program type from the Halaqoh, not from a route arg.
    // Must be computed AFTER myHalaqoh is resolved above.
    final effectiveProgramType =
        myHalaqoh?.program == 'T' ? 'takhassus' : 'reguler';
    final sessions = _sessionAbbrFor(effectiveProgramType);
    final keys = _sessionKeysFor(effectiveProgramType);
    final sessionCount = sessions.length;
    final colWidth = 36.0.w;
    final nameColWidth = 130.0.w;
    // Base row height — rows may grow taller if name wraps
    final double baseRowHeight = 44.0.h;
    final headerHeight = 52.h;

    List<SantriModel> mySantriList = [];
    if (myHalaqoh != null) {
      santriState.maybeWhen(
        loaded: (sList) {
          mySantriList = sList
              .where((s) => myHalaqoh!.santriIds.contains(s.id))
              .toList();
        },
        orElse: () {},
      );
    }

    return BlocProvider.value(
      value: _absensiCubit,
      child: BlocBuilder<AbsensiCubit, AbsensiState>(
        builder: (context, absensiState) {
          List<AbsensiModel> allRecords = [];
          absensiState.maybeWhen(
            loaded: (data) => allRecords = data,
            orElse: () {},
          );

          final Map<String, Map<int, Map<String, String>>> realData = {};

          for (final record in allRecords) {
            if (record.tanggal.month != _currentMonth ||
                record.tanggal.year != _currentYear) {
              continue;
            }
            if (!keys.contains(record.sesi)) continue;

            final day = record.tanggal.day;
            for (final entry in record.records) {
              final nis = entry.nis;
              final status = _statusToCode(entry.status);

              realData.putIfAbsent(nis, () => {});
              realData[nis]!.putIfAbsent(day, () => {});
              realData[nis]![day]![record.sesi] = status;
            }
          }

          return Scaffold(
            backgroundColor: colors.background,
            floatingActionButtonLocation: ExpandableFabMenu.location,
            floatingActionButton: ExpandableFabMenu(
              items: [
                ExpandableFabItem(
                  icon: Icons.info_outline,
                  label: 'Lihat Keterangan',
                  onTap: () {
                    _showKeteranganDialog(
                      context,
                      colors,
                      effectiveProgramType,
                    );
                  },
                ),
                ExpandableFabItem(
                  icon: Icons.download_rounded,
                  label: t.absensiHalaqoh.downloadLaporan,
                  onTap: () {
                    LaporanKonfigurasiHalaqohSheet.show(
                      context,
                      records: allRecords,
                      santriList: mySantriList,
                      halaqohName: myHalaqoh?.nama ?? '-',
                      kelas: myHalaqoh?.kelas ?? '-',
                      programType: effectiveProgramType,
                      guruNama: myHalaqoh?.guruNama ?? '-',
                      initialMonth: _currentMonth,
                      initialYear: _currentYear,
                    );
                  },
                ),
              ],
            ),
            body: SafeArea(
              child: Column(
                children: [
                  // ── Top bar: back + month selector + calendar picker ──
                  Padding(
                    padding: EdgeInsets.fromLTRB(8.w, 8.h, 20.w, 8.h),
                    child: Row(
                      children: [
                        IconButton(
                          icon: Icon(Icons.arrow_back, color: colors.textPrimary),
                          onPressed: () => Navigator.of(context).pop(),
                        ),
                        SizedBox(width: 4.w),
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

                  // ── Horizontal scroll hint banner ──
                  Container(
                    width: double.infinity,
                    margin: EdgeInsets.fromLTRB(20.w, 0, 20.w, 8.h),
                    padding: EdgeInsets.symmetric(
                      horizontal: 12.w,
                      vertical: 8.h,
                    ),
                    decoration: BoxDecoration(
                      color: colors.primary.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(8.r),
                      border: Border.all(
                        color: colors.primary.withValues(alpha: 0.25),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.swipe, size: 18.sp, color: colors.primary),
                        SizedBox(width: 8.w),
                        Expanded(
                          child: Text(
                            t.absensiHalaqoh.swipeHint,
                            style: TextStyle(
                              fontSize: 11.sp,
                              color: colors.primary,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // ── Table ──
                  Expanded(
                    child: _SyncedTable(
                      santriList: mySantriList,
                      daysInMonth: daysInMonth,
                      sessions: sessions,
                      sessionKeys: keys,
                      sessionCount: sessionCount,
                      colWidth: colWidth,
                      nameColWidth: nameColWidth,
                      baseRowHeight: baseRowHeight,
                      headerHeight: headerHeight,
                      colors: colors,
                      realData: realData,
                      verticalCtrl: _namesVerticalCtrl,
                      getDayAbbr: _getDayAbbr,
                      buildDot: _buildDot,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  List<Widget> _buildSessionLegend(AppColorSet colors, String effectiveProgramType) {
    final labels = <Map<String, String>>[];
    if (effectiveProgramType == 'takhassus') {
      labels.addAll([
        {'code': t.riwayatAbsensi.abbrTakhassus[0], 'label': t.detailAbsensiHariIni.sessions.pagi},
        {'code': t.riwayatAbsensi.abbrTakhassus[1], 'label': t.detailAbsensiHariIni.sessions.dhuha},
        {'code': t.riwayatAbsensi.abbrTakhassus[2], 'label': t.detailAbsensiHariIni.sessions.siang},
        {'code': t.riwayatAbsensi.abbrTakhassus[3], 'label': t.detailAbsensiHariIni.sessions.ashar},
        {'code': t.riwayatAbsensi.abbrTakhassus[4], 'label': t.detailAbsensiHariIni.sessions.malam},
      ]);
    } else {
      labels.addAll([
        {'code': t.riwayatAbsensi.abbrReguler[0], 'label': t.detailAbsensiHariIni.sessions.pagi},
        {'code': t.riwayatAbsensi.abbrReguler[1], 'label': t.detailAbsensiHariIni.sessions.malam},
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
              color: colors.textPrimary,
              fontFamily: 'Poppins',
            ),
          ),
        ],
      );
    }).toList();
  }

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

  Widget _legendDot(Color color, String label, AppColorSet colors) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12.w,
          height: 12.w,
          decoration: BoxDecoration(shape: BoxShape.circle, color: color),
        ),
        SizedBox(width: 10.w),
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

  void _showKeteranganDialog(BuildContext context, AppColorSet colors, String effectiveProgramType) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: colors.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24.r),
          ),
          insetPadding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 40.h),
          child: Padding(
            padding: EdgeInsets.all(20.w),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.pop(context),
                      color: colors.textSecondary,
                    ),
                  ],
                ),
                SizedBox(height: 16.h),
                Flexible(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Card 1: STATUS ABSENSI
                        Container(
                          width: double.infinity,
                          padding: EdgeInsets.all(16.w),
                          decoration: BoxDecoration(
                            color: colors.background,
                            borderRadius: BorderRadius.circular(12.r),
                            border: Border.all(
                              color: colors.border.withValues(alpha: 0.8),
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'STATUS ABSENSI',
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w700,
                                  color: colors.textSecondary,
                                  fontFamily: 'Poppins',
                                  letterSpacing: 0.5,
                                ),
                              ),
                              SizedBox(height: 14.h),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _legendDot(colors.primary, t.detailAbsensiHariIni.hadir, colors),
                                  SizedBox(height: 12.h),
                                  _legendDot(colors.yellow, t.absensiHalaqoh.sakit, colors),
                                  SizedBox(height: 12.h),
                                  _legendDot(colors.blue, t.absensiHalaqoh.izin, colors),
                                  SizedBox(height: 12.h),
                                  _legendDot(colors.red, t.absensiHalaqoh.alfa, colors),
                                  SizedBox(height: 12.h),
                                  _legendDot(colors.border, t.detailAbsensiHariIni.belumAbsen, colors),
                                ],
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 16.h),
                        // Card 2: SESI
                        Container(
                          width: double.infinity,
                          padding: EdgeInsets.all(16.w),
                          decoration: BoxDecoration(
                            color: colors.background,
                            borderRadius: BorderRadius.circular(12.r),
                            border: Border.all(
                              color: colors.border.withValues(alpha: 0.8),
                            ),
                          ),
                          child: Column(
                            children: [
                              Text(
                                'SESI',
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w700,
                                  color: colors.textSecondary,
                                  fontFamily: 'Poppins',
                                  letterSpacing: 0.5,
                                ),
                              ),
                              SizedBox(height: 14.h),
                              Wrap(
                                spacing: 16.w,
                                runSpacing: 8.h,
                                alignment: WrapAlignment.center,
                                children: _buildSessionLegend(colors, effectiveProgramType),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

/// Frozen-column attendance table.
///
/// Architecture (the only correct approach for variable-height rows):
///
///  • ONE [ScrollController] for vertical   → attached to ONE [SingleChildScrollView].
///  • ONE [ScrollController] for horizontal → attached to the header ONLY.
///  • A [ValueNotifier<double>] is driven by the horizontal controller offset.
///  • Every data row contains the name cell AND the grid cells as siblings
///    inside an [IntrinsicHeight] [Row].  The grid cells are wrapped in a
///    [ClipRect] + [OverflowBox] + [Transform.translate] driven by the
///    [ValueNotifier] — so they appear to scroll horizontally without
///    attaching a second [ScrollController].
///
///  Result:
///  - Perfect per-row vertical alignment (IntrinsicHeight, same Row).
///  - No multiple-controller assertion errors.
///  - No listener-based sync for vertical (no drift possible).
///  - Every row (including the last) is always rendered.
class _SyncedTable extends StatefulWidget {
  final List<SantriModel> santriList;
  final int daysInMonth;
  final List<String> sessions;
  final List<String> sessionKeys;
  final int sessionCount;
  final double colWidth;
  final double nameColWidth;
  final double baseRowHeight;
  final double headerHeight;
  final AppColorSet colors;
  final Map<String, Map<int, Map<String, String>>> realData;
  final ScrollController verticalCtrl;
  final String Function(int day) getDayAbbr;
  final Widget Function(String status, AppColorSet colors) buildDot;

  const _SyncedTable({
    required this.santriList,
    required this.daysInMonth,
    required this.sessions,
    required this.sessionKeys,
    required this.sessionCount,
    required this.colWidth,
    required this.nameColWidth,
    required this.baseRowHeight,
    required this.headerHeight,
    required this.colors,
    required this.realData,
    required this.verticalCtrl,
    required this.getDayAbbr,
    required this.buildDot,
  });

  @override
  State<_SyncedTable> createState() => _SyncedTableState();
}

class _SyncedTableState extends State<_SyncedTable> {
  /// Drives the horizontal position of every grid row via Transform.translate.
  final ValueNotifier<double> _horizOffset = ValueNotifier(0.0);

  /// The single horizontal ScrollController — attached ONLY to the header.
  late final ScrollController _headerHorizCtrl;

  @override
  void initState() {
    super.initState();
    _headerHorizCtrl = ScrollController();
    _headerHorizCtrl.addListener(() {
      _horizOffset.value = _headerHorizCtrl.offset;
    });
  }

  @override
  void dispose() {
    _headerHorizCtrl.dispose();
    _horizOffset.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final gridTotalWidth =
        widget.daysInMonth * widget.sessionCount * widget.colWidth;

    return Column(
      children: [
        // ── Sticky header ──
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // "Santri" label — pinned left
            Container(
              width: widget.nameColWidth,
              height: widget.headerHeight,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: widget.colors.border, width: 1.5),
                  right: BorderSide(color: widget.colors.border, width: 1.5),
                ),
              ),
              child: Text(
                t.absensiHalaqoh.santri,
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w600,
                  color: widget.colors.textSecondary,
                  fontFamily: 'Poppins',
                ),
              ),
            ),

            // Date + session headers — the ONLY horizontal ScrollView.
            // Its controller drives _horizOffset via the listener above.
            Expanded(
              child: SingleChildScrollView(
                controller: _headerHorizCtrl,
                scrollDirection: Axis.horizontal,
                physics: const ClampingScrollPhysics(),
                child: SizedBox(
                  width: gridTotalWidth,
                  height: widget.headerHeight,
                  child: Row(
                    children: List.generate(widget.daysInMonth, (dayIdx) {
                      final day = dayIdx + 1;
                      final dayStr = day.toString().padLeft(2, '0');
                      final dayAbbr = widget.getDayAbbr(day);
                      final groupWidth = widget.sessionCount * widget.colWidth;

                      return Container(
                        width: groupWidth,
                        height: widget.headerHeight,
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              color: widget.colors.border,
                              width: 1.5,
                            ),
                            right: BorderSide(
                              color: widget.colors.border,
                              width: 1.5,
                            ),
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              '$dayStr $dayAbbr',
                              style: TextStyle(
                                fontSize: 10.sp,
                                fontWeight: FontWeight.w600,
                                color: widget.colors.textPrimary,
                                fontFamily: 'Poppins',
                              ),
                            ),
                            Row(
                              children: widget.sessions.map((s) {
                                return Expanded(
                                  child: Center(
                                    child: Text(
                                      s,
                                      style: TextStyle(
                                        fontSize: 9.sp,
                                        fontWeight: FontWeight.w600,
                                        color: widget.colors.textSecondary,
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
              ),
            ),
          ],
        ),

        // ── Body rows — ONE vertical SingleChildScrollView ──
        //
        // Each row is IntrinsicHeight so name cell and grid cells share
        // the exact same height automatically.
        // The grid cells are not in a ScrollView — instead they are
        // translated horizontally by _horizOffset using Transform.translate
        // inside a ClipRect, so there is no second horizontal controller.
        Expanded(
          child: ScrollConfiguration(
            behavior: ScrollConfiguration.of(
              context,
            ).copyWith(scrollbars: false),
            child: SingleChildScrollView(
              controller: widget.verticalCtrl,
              child: Column(
                children: [
                  ...List.generate(widget.santriList.length, (i) {
                  final santri = widget.santriList[i];
                  final nis = santri.nis;
                  final isEvenRow = i.isEven;
                  final rowBg = isEvenRow
                      ? widget.colors.surface
                      : widget.colors.background;

                  return IntrinsicHeight(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // ── Pinned name cell ──
                        Container(
                          width: widget.nameColWidth,
                          constraints: BoxConstraints(
                            minHeight: widget.baseRowHeight,
                          ),
                          padding: EdgeInsets.symmetric(
                            horizontal: 10.w,
                            vertical: 8.h,
                          ),
                          decoration: BoxDecoration(
                            color: rowBg,
                            border: Border(
                              bottom: BorderSide(
                                color: widget.colors.border,
                                width: 1,
                              ),
                              right: BorderSide(
                                color: widget.colors.border,
                                width: 1.5,
                              ),
                            ),
                          ),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              santri.nama,
                              style: TextStyle(
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w500,
                                color: widget.colors.textPrimary,
                                fontFamily: 'Poppins',
                                height: 1.4,
                              ),
                            ),
                          ),
                        ),

                        // ── Grid cells — translated, not scrolled ──
                        Expanded(
                          child: ClipRect(
                            child: Container(
                              decoration: BoxDecoration(
                                color: rowBg,
                                border: Border(
                                  bottom: BorderSide(
                                    color: widget.colors.border,
                                    width: 1,
                                  ),
                                ),
                              ),
                              child: ValueListenableBuilder<double>(
                                valueListenable: _horizOffset,
                                builder: (_, offset, _) {
                                  return OverflowBox(
                                    minWidth: gridTotalWidth,
                                    maxWidth: gridTotalWidth,
                                    alignment: Alignment.centerLeft,
                                    child: Transform.translate(
                                      offset: Offset(-offset, 0),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.stretch,
                                        children: List.generate(
                                          widget.daysInMonth,
                                          (dayIdx) {
                                            final day = dayIdx + 1;
                                            return Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.stretch,
                                              children: List.generate(
                                                widget.sessionCount,
                                                (sIdx) {
                                                  final sessionKey =
                                                      widget.sessionKeys[sIdx];
                                                  final status =
                                                      widget
                                                          .realData[nis]?[day]?[sessionKey] ??
                                                      '-';
                                                  final isLastSession =
                                                      sIdx ==
                                                      widget.sessionCount - 1;

                                                  return Container(
                                                    width: widget.colWidth,
                                                    decoration: BoxDecoration(
                                                      border: Border(
                                                        right: isLastSession
                                                            ? BorderSide(
                                                                color: widget
                                                                    .colors
                                                                    .border,
                                                                width: 1.5,
                                                              )
                                                            : BorderSide(
                                                                color: widget
                                                                    .colors
                                                                    .border
                                                                    .withValues(
                                                                      alpha:
                                                                          0.25,
                                                                    ),
                                                                width: 0.5,
                                                              ),
                                                      ),
                                                    ),
                                                    child: Center(
                                                      child: widget.buildDot(
                                                        status,
                                                        widget.colors,
                                                      ),
                                                    ),
                                                  );
                                                },
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }),
                SizedBox(height: 80.h),
              ],
            ),
            ),
          ),
        ),
      ],
    );
  }
}
