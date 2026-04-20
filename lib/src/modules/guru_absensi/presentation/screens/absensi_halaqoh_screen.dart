import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_halaqoh/gen/i18n/translations.g.dart';
import 'package:my_halaqoh/src/core/theme/app_colors.dart';
import 'package:my_halaqoh/src/core/widget/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_halaqoh/src/core/service_locator/service_locator.dart';
import 'package:my_halaqoh/src/modules/auth/presentation/cubits/auth_cubit.dart';
import 'package:my_halaqoh/src/modules/auth/presentation/cubits/auth_state.dart';
import 'package:my_halaqoh/src/modules/master_data/presentation/cubits/halaqoh_cubit.dart';
import 'package:my_halaqoh/src/modules/master_data/presentation/cubits/halaqoh_state.dart';
import 'package:my_halaqoh/src/modules/master_data/presentation/cubits/santri_cubit.dart';
import 'package:my_halaqoh/src/modules/guru_absensi/presentation/cubits/absensi_cubit.dart';
import 'package:my_halaqoh/src/modules/guru_absensi/presentation/cubits/absensi_state.dart';
import 'package:my_halaqoh/src/modules/master_data/domain/models/halaqoh_model.dart';
import 'package:my_halaqoh/src/modules/master_data/domain/models/santri_model.dart';
import 'package:my_halaqoh/src/modules/guru_absensi/domain/models/absensi_model.dart';
import 'package:my_halaqoh/src/modules/master_data/presentation/cubits/santri_state.dart';

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
  // Default to current month & year
  late int _currentMonth;
  late int _currentYear;

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

  List<String> get _sessionKeys {
    if (widget.programType == 'takhassus') {
      return ['shubuh', 'dhuha', 'siang', 'ashar', 'maghrib'];
    }
    return ['shubuh', 'maghrib'];
  }

  List<String> get _sessionAbbr {
    if (widget.programType == 'takhassus') {
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
    final authState = context.read<AuthCubit>().state;
    final halaqohState = context.read<HalaqohCubit>().state;

    String linkedDocId = '';
    authState.maybeWhen(
      authenticated: (userMeta) => linkedDocId = userMeta.linkedDocId,
      orElse: () {},
    );

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
    final sessions = _sessionAbbr;
    final keys = _sessionKeys;
    final sessionCount = sessions.length;
    final colWidth = 36.0.w;
    final nameColWidth = 130.0.w;
    // Base row height — rows may grow taller if name wraps
    final double baseRowHeight = 44.0.h;
    final headerHeight = 52.h;

    final authState = context.watch<AuthCubit>().state;
    final halaqohState = context.watch<HalaqohCubit>().state;
    final santriState = context.watch<SantriCubit>().state;

    String linkedDocId = '';
    authState.maybeWhen(
      authenticated: (userMeta) => linkedDocId = userMeta.linkedDocId,
      orElse: () {},
    );

    HalaqohModel? myHalaqoh;
    halaqohState.maybeWhen(
      loaded: (list) {
        try {
          myHalaqoh = list.firstWhere((h) => h.guruId == linkedDocId);
        } catch (_) {}
      },
      orElse: () {},
    );

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
            body: SafeArea(
              child: Column(
                children: [
                  // ── Top bar: back + month selector + calendar picker ──
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 8.h,
                    ),
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () => Navigator.of(context).pop(),
                          child: Container(
                            width: 40.w,
                            height: 40.w,
                            decoration: BoxDecoration(
                              color: colors.surface,
                              borderRadius: BorderRadius.circular(12.r),
                              border: Border.all(
                                color: colors.border,
                                width: 1,
                              ),
                            ),
                            child: Icon(
                              Icons.arrow_back,
                              size: 20.sp,
                              color: colors.textPrimary,
                            ),
                          ),
                        ),
                        SizedBox(width: 10.w),
                        Expanded(
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 12.w,
                              vertical: 8.h,
                            ),
                            decoration: BoxDecoration(
                              color: colors.surface,
                              borderRadius: BorderRadius.circular(12.r),
                              border: Border.all(
                                color: colors.border,
                                width: 1,
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                GestureDetector(
                                  onTap: _prevMonth,
                                  child: Icon(
                                    Icons.chevron_left,
                                    color: colors.primary,
                                    size: 24.sp,
                                  ),
                                ),
                                Text(
                                  '${_monthNames[_currentMonth - 1]} $_currentYear',
                                  style: TextStyle(
                                    fontSize: 15.sp,
                                    fontWeight: FontWeight.w700,
                                    color: colors.textPrimary,
                                    fontFamily: 'Poppins',
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
                              ],
                            ),
                          ),
                        ),
                        SizedBox(width: 10.w),
                        GestureDetector(
                          onTap: () => _selectMonthYear(context, colors),
                          child: Container(
                            width: 40.w,
                            height: 40.w,
                            decoration: BoxDecoration(
                              color: colors.surface,
                              borderRadius: BorderRadius.circular(12.r),
                              border: Border.all(
                                color: colors.border,
                                width: 1,
                              ),
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

                  // ── Horizontal scroll hint banner (Selalu Tampil) ──
                  Container(
                    width: double.infinity,
                    margin: EdgeInsets.fromLTRB(16.w, 0, 16.w, 6.h),
                    padding: EdgeInsets.symmetric(
                      horizontal: 12.w,
                      vertical: 8.h,
                    ),
                    decoration: BoxDecoration(
                      color: colors.primary.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(10.r),
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
                            'Geser baris tanggal ke kiri/kanan untuk melihat data per hari',
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
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _legendDot(
                              colors.primary,
                              t.absensiHalaqoh.hadir,
                              colors,
                            ),
                            SizedBox(width: 16.w),
                            _legendDot(
                              colors.yellow,
                              t.absensiHalaqoh.sakit,
                              colors,
                            ),
                            SizedBox(width: 16.w),
                            _legendDot(
                              colors.blue,
                              t.absensiHalaqoh.izin,
                              colors,
                            ),
                            SizedBox(width: 16.w),
                            _legendDot(
                              colors.red,
                              t.absensiHalaqoh.alfa,
                              colors,
                            ),
                          ],
                        ),
                        SizedBox(height: 10.h),
                        Wrap(
                          spacing: 12.w,
                          runSpacing: 6.h,
                          alignment: WrapAlignment.center,
                          children: _buildSessionLegend(colors),
                        ),
                        SizedBox(height: 14.h),
                        PrimaryButton(
                          width: double.infinity,
                          onPressed: () {
                            // TODO: download attendance report
                          },
                          icon: Icons.download,
                          label: t.absensiHalaqoh.downloadLaporan,
                          borderRadius: 24.r,
                        ),
                        SizedBox(height: 4.h),
                      ],
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

  List<Widget> _buildSessionLegend(AppColorSet colors) {
    final labels = <Map<String, String>>[];
    if (widget.programType == 'takhassus') {
      labels.addAll([
        {'code': 'P', 'label': 'Pagi'},
        {'code': 'D', 'label': 'Dhuha'},
        {'code': 'S', 'label': 'Siang'},
        {'code': 'A', 'label': 'Ashar'},
        {'code': 'M', 'label': 'Malam'},
      ]);
    } else {
      labels.addAll([
        {'code': 'P', 'label': 'Pagi'},
        {'code': 'M', 'label': 'Malam'},
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
          width: 10.w,
          height: 10.w,
          decoration: BoxDecoration(shape: BoxShape.circle, color: color),
        ),
        SizedBox(width: 4.w),
        Text(
          label,
          style: TextStyle(
            fontSize: 11.sp,
            color: colors.textPrimary,
            fontFamily: 'Poppins',
          ),
        ),
      ],
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
                'Santri',
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
                children: List.generate(widget.santriList.length, (i) {
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
                                builder: (_, offset, __) {
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
              ),
            ),
          ),
        ),
      ],
    );
  }
}
