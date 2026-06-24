import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:my_halaqoh/gen/i18n/translations.g.dart';
import 'package:my_halaqoh/src/core/service_locator/service_locator.dart';
import 'package:my_halaqoh/src/core/theme/app_colors.dart';
import 'package:my_halaqoh/src/modules/guru_absensi/domain/models/absensi_model.dart';
import 'package:my_halaqoh/src/modules/master_data/domain/models/santri_model.dart';

import '../../domain/models/laporan_absensi_config.dart';
import '../../domain/models/laporan_absensi_halaqoh_config.dart';
import '../cubits/laporan_absensi_halaqoh_cubit.dart';
import '../cubits/laporan_absensi_halaqoh_state.dart';

class LaporanKonfigurasiHalaqohSheet extends StatefulWidget {
  final List<AbsensiModel> records;
  final List<SantriModel> santriList;
  final String halaqohName;
  final String kelas;
  final String programType;
  final String guruNama;
  final int initialMonth;
  final int initialYear;

  const LaporanKonfigurasiHalaqohSheet({
    super.key,
    required this.records,
    required this.santriList,
    required this.halaqohName,
    required this.kelas,
    required this.programType,
    required this.guruNama,
    required this.initialMonth,
    required this.initialYear,
  });

  static void show(
    BuildContext context, {
    required List<AbsensiModel> records,
    required List<SantriModel> santriList,
    required String halaqohName,
    required String kelas,
    required String programType,
    required String guruNama,
    required int initialMonth,
    required int initialYear,
  }) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      useSafeArea: true,
      builder: (_) => BlocProvider(
        create: (_) => sl<LaporanAbsensiHalaqohCubit>(),
        child: LaporanKonfigurasiHalaqohSheet(
          records: records,
          santriList: santriList,
          halaqohName: halaqohName,
          kelas: kelas,
          programType: programType,
          guruNama: guruNama,
          initialMonth: initialMonth,
          initialYear: initialYear,
        ),
      ),
    );
  }

  @override
  State<LaporanKonfigurasiHalaqohSheet> createState() =>
      _LaporanKonfigurasiHalaqohSheetState();
}

class _LaporanKonfigurasiHalaqohSheetState
    extends State<LaporanKonfigurasiHalaqohSheet>
    with SingleTickerProviderStateMixin {
  // ── Range ──────────────────────────────────────────────────────────────────
  ReportRange _range = ReportRange.monthly;

  // ── Monthly ───────────────────────────────────────────────────────────────
  late int _month;
  late int _year;

  // ── Weekly ────────────────────────────────────────────────────────────────
  late int _weekMonth;
  late int _weekYear;
  late DateTime _weekStart;
  late DateTime _weekEnd;

  // ── Semester (custom) ─────────────────────────────────────────────────────
  DateTime? _customStart;
  DateTime? _customEnd;

  // ── Animation ─────────────────────────────────────────────────────────────
  late AnimationController _animCtrl;
  late Animation<double> _fadeAnim;

  @override
  void initState() {
    super.initState();
    _month = widget.initialMonth;
    _year = widget.initialYear;
    _weekMonth = widget.initialMonth;
    _weekYear = widget.initialYear;
    _initWeekToMonday(DateTime(_year, _month, 1));

    _animCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 220),
    );
    _fadeAnim = CurvedAnimation(parent: _animCtrl, curve: Curves.easeOut);
    _animCtrl.forward();
  }

  void _initWeekToMonday(DateTime ref) {
    final mon = ref.subtract(Duration(days: ref.weekday - 1));
    _weekStart = DateTime(mon.year, mon.month, mon.day);
    _weekEnd = _weekStart.add(const Duration(days: 6));
  }

  @override
  void dispose() {
    _animCtrl.dispose();
    super.dispose();
  }

  // ── Computed dates ─────────────────────────────────────────────────────────
  DateTime get _startDate {
    switch (_range) {
      case ReportRange.weekly:
        return _weekStart;
      case ReportRange.monthly:
        return DateTime(_year, _month, 1);
      case ReportRange.semester:
        return _customStart ?? DateTime(_year, 1, 1);
    }
  }

  DateTime get _endDate {
    switch (_range) {
      case ReportRange.weekly:
        return _weekEnd;
      case ReportRange.monthly:
        return DateTime(_year, _month + 1, 0);
      case ReportRange.semester:
        return _customEnd ?? DateTime(_year, 12, 31);
    }
  }

  bool get _isCustomValid =>
      _range != ReportRange.semester ||
      (_customStart != null && _customEnd != null);

  LaporanAbsensiHalaqohConfig get _config => LaporanAbsensiHalaqohConfig(
    halaqohName: widget.halaqohName,
    guruNama: widget.guruNama,
    programType: widget.programType,
    range: _range,
    startDate: _startDate,
    endDate: _endDate,
  );

  String get _filename {
    final slug = widget.halaqohName.replaceAll(' ', '_');
    return 'Rekap_Absensi_${slug}_${DateFormat('yyyyMMdd').format(DateTime.now())}.pdf';
  }

  // ── Helpers ────────────────────────────────────────────────────────────────

  void _switchRange(ReportRange r) {
    setState(() => _range = r);
    _animCtrl..reset()..forward();
  }

  List<DateTime> _weeksInMonth(int year, int month) {
    final firstDay = DateTime(year, month, 1);
    final lastDay = DateTime(year, month + 1, 0);
    var mon = firstDay.subtract(Duration(days: firstDay.weekday - 1));
    final weeks = <DateTime>[];
    while (!mon.isAfter(lastDay)) {
      weeks.add(mon);
      mon = mon.add(const Duration(days: 7));
    }
    return weeks;
  }

  Future<void> _pickDate(bool isStart) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: isStart
          ? (_customStart ?? DateTime(_year, _month, 1))
          : (_customEnd ?? DateTime(_year, _month + 1, 0)),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030, 12, 31),
      locale: Locale(t.$meta.locale.languageCode),
      helpText: isStart ? t.laporanConfig.chooseStartDate : t.laporanConfig.chooseEndDate,
      confirmText: t.laporanConfig.btnSelect,
      cancelText: t.laporanConfig.btnCancel,
    );
    if (picked == null) return;
    setState(() {
      if (isStart) {
        _customStart = picked;
        if (_customEnd != null && _customEnd!.isBefore(picked)) {
          _customEnd = picked.add(const Duration(days: 6));
        }
      } else {
        _customEnd = picked;
        if (_customStart != null && _customStart!.isAfter(picked)) {
          _customStart = picked.subtract(const Duration(days: 6));
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);

    return BlocConsumer<LaporanAbsensiHalaqohCubit, LaporanAbsensiHalaqohState>(
      listener: (context, state) {
        state.maybeWhen(
          error: (msg) => ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(msg, style: const TextStyle(fontFamily: 'Poppins')),
              backgroundColor: colors.red,
              behavior: SnackBarBehavior.floating,
            ),
          ),
          orElse: () {},
        );
      },
      builder: (context, state) {
        final isGenerating = state.maybeWhen(
          generating: () => true,
          orElse: () => false,
        );
        final pdfBytes = state.maybeWhen(
          generated: (b) => b,
          orElse: () => null,
        );

        return Container(
          decoration: BoxDecoration(
            color: colors.background,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // ── Drag handle ───────────────────────────────────────────
              Padding(
                padding: EdgeInsets.only(top: 12.h, bottom: 4.h),
                child: Container(
                  width: 36.w,
                  height: 4.h,
                  decoration: BoxDecoration(
                    color: colors.border,
                    borderRadius: BorderRadius.circular(2.r),
                  ),
                ),
              ),

              // ── Scrollable body ───────────────────────────────────────
              Flexible(
                child: SingleChildScrollView(
                  padding: EdgeInsets.fromLTRB(20.w, 8.h, 20.w, 32.h),
                  child: pdfBytes != null
                      ? _buildSuccessState(context, pdfBytes, colors)
                      : _buildConfigState(context, isGenerating, colors),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // ── Config state ──────────────────────────────────────────────────────────
  Widget _buildConfigState(
    BuildContext context,
    bool isGenerating,
    AppColorSet colors,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title
        Text(
          t.laporanConfig.titleHalaqoh,
          style: TextStyle(
            fontSize: 17.sp,
            fontWeight: FontWeight.w700,
            color: colors.textPrimary,
            fontFamily: 'Poppins',
          ),
        ),
        SizedBox(height: 4.h),
        Text(
          t.laporanConfig.subtitleHalaqoh,
          style: TextStyle(
            fontSize: 12.sp,
            color: colors.textSecondary,
            fontFamily: 'Poppins',
          ),
        ),
        SizedBox(height: 16.h),

        // ── Halaqoh Info Chip ─────────────────────────────────────────────
        _HalaqohChip(
          halaqohName: widget.halaqohName,
          guruNama: widget.guruNama,
          colors: colors,
        ),
        SizedBox(height: 20.h),

        // ── Range type cards ─────────────────────────────────────────
        _SectionLabel(label: t.laporanConfig.timeRange, colors: colors),
        SizedBox(height: 8.h),

        Row(
          children: [
            _RangeCard(
              icon: Icons.view_week_rounded,
              label: t.laporanConfig.weekly,
              selected: _range == ReportRange.weekly,
              colors: colors,
              onTap: () => _switchRange(ReportRange.weekly),
            ),
            SizedBox(width: 8.w),
            _RangeCard(
              icon: Icons.calendar_month_rounded,
              label: t.laporanConfig.monthly,
              selected: _range == ReportRange.monthly,
              colors: colors,
              onTap: () => _switchRange(ReportRange.monthly),
            ),
            SizedBox(width: 8.w),
            _RangeCard(
              icon: Icons.tune_rounded,
              label: t.laporanConfig.custom,
              selected: _range == ReportRange.semester,
              colors: colors,
              onTap: () => _switchRange(ReportRange.semester),
            ),
          ],
        ),
        SizedBox(height: 18.h),

        // ── Date selector (animated) ─────────────────────────────────
        FadeTransition(opacity: _fadeAnim, child: _buildDateSelector(colors)),
        SizedBox(height: 16.h),

        // ── Preview bar ──────────────────────────────────────────────
        if (_isCustomValid) ...[
          _PreviewBar(startDate: _startDate, endDate: _endDate, colors: colors),
          SizedBox(height: 18.h),
        ],

        // ── Generate button ──────────────────────────────────────────
        SizedBox(
          width: double.infinity,
          height: 52.h,
          child: ElevatedButton(
            onPressed: isGenerating || !_isCustomValid
                ? null
                : () => context.read<LaporanAbsensiHalaqohCubit>().generatePdf(
                    _config,
                    widget.records,
                    widget.santriList,
                  ),
            style: ElevatedButton.styleFrom(
              backgroundColor: colors.primary,
              foregroundColor: colors.textOnButton,
              disabledBackgroundColor: colors.border,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14.r),
              ),
              elevation: 0,
            ),
            child: isGenerating
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 18.w,
                        height: 18.w,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.5,
                          color: colors.textOnButton,
                        ),
                      ),
                      SizedBox(width: 10.w),
                      Text(
                        t.laporanConfig.generatingReport,
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.picture_as_pdf_rounded, size: 20.sp),
                      SizedBox(width: 8.w),
                      Text(
                        t.laporanConfig.btnGenerateRecapPdf,
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ],
    );
  }

  Widget _buildDateSelector(AppColorSet colors) {
    switch (_range) {
      case ReportRange.weekly:
        return _buildWeeklySelector(colors);
      case ReportRange.monthly:
        return _buildMonthlySelector(colors);
      case ReportRange.semester:
        return _buildCustomSelector(colors);
    }
  }

  Widget _buildWeeklySelector(AppColorSet colors) {
    final weeks = _weeksInMonth(_weekYear, _weekMonth);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            _IconNavButton(
              icon: Icons.chevron_left,
              colors: colors,
              onTap: () => setState(() {
                _weekMonth--;
                if (_weekMonth < 1) { _weekMonth = 12; _weekYear--; }
              }),
            ),
            Expanded(
              child: Text(
                '${t.calendar.months[_weekMonth - 1]} $_weekYear',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w600, color: colors.textPrimary, fontFamily: 'Poppins'),
              ),
            ),
            _IconNavButton(
              icon: Icons.chevron_right,
              colors: colors,
              onTap: () => setState(() {
                _weekMonth++;
                if (_weekMonth > 12) { _weekMonth = 1; _weekYear++; }
              }),
            ),
          ],
        ),
        SizedBox(height: 10.h),
        ...weeks.map((mon) {
          final sun = mon.add(const Duration(days: 6));
          final isSelected = mon == _weekStart;
          return _WeekChip(
            weekStart: mon, weekEnd: sun, isSelected: isSelected, colors: colors,
            onTap: () => setState(() { _weekStart = mon; _weekEnd = sun; }),
          );
        }),
      ],
    );
  }

  Widget _buildMonthlySelector(AppColorSet colors) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            _IconNavButton(icon: Icons.chevron_left, colors: colors, onTap: () => setState(() => _year--)),
            Expanded(
              child: Text('$_year', textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w700, color: colors.textPrimary, fontFamily: 'Poppins')),
            ),
            _IconNavButton(icon: Icons.chevron_right, colors: colors, onTap: () => setState(() => _year++)),
          ],
        ),
        SizedBox(height: 10.h),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4, mainAxisSpacing: 8.h, crossAxisSpacing: 8.w, childAspectRatio: 2.2,
          ),
          itemCount: 12,
          itemBuilder: (_, i) => _MonthChip(
            label: t.calendar.months[i].substring(0, 3),
            selected: (i + 1) == _month,
            colors: colors,
            onTap: () => setState(() => _month = i + 1),
          ),
        ),
      ],
    );
  }

  Widget _buildCustomSelector(AppColorSet colors) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionLabel(label: t.laporanConfig.selectDateRange, colors: colors),
        SizedBox(height: 10.h),
        Row(
          children: [
            Expanded(child: _DatePickerField(label: t.laporanConfig.startDate, date: _customStart, icon: Icons.event_available_rounded, colors: colors, onTap: () => _pickDate(true))),
            Padding(padding: EdgeInsets.symmetric(horizontal: 8.w), child: Icon(Icons.arrow_forward_rounded, size: 18.sp, color: colors.textSecondary)),
            Expanded(child: _DatePickerField(label: t.laporanConfig.endDate, date: _customEnd, icon: Icons.event_rounded, colors: colors, onTap: () => _pickDate(false))),
          ],
        ),
        if (_customStart != null && _customEnd != null) ...[
          SizedBox(height: 10.h),
          _DurationBadge(days: _customEnd!.difference(_customStart!).inDays + 1, colors: colors),
        ],
      ],
    );
  }

  // ── Success state ─────────────────────────────────────────────────────────
  Widget _buildSuccessState(
    BuildContext context,
    List<int> pdfBytes,
    AppColorSet colors,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header
        Text(
          t.laporanConfig.readyRecapTitle,
          style: TextStyle(
            fontSize: 17.sp,
            fontWeight: FontWeight.w700,
            color: colors.textPrimary,
            fontFamily: 'Poppins',
          ),
        ),
        SizedBox(height: 4.h),
        Text(
          t.laporanConfig.readySubtitle,
          style: TextStyle(
            fontSize: 12.sp,
            color: colors.textSecondary,
            fontFamily: 'Poppins',
          ),
        ),
        SizedBox(height: 16.h),

        // Success card
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            color: colors.primary.withValues(alpha: 0.07),
            borderRadius: BorderRadius.circular(14.r),
            border: Border.all(
              color: colors.primary.withValues(alpha: 0.25),
              width: 1.5,
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 44.w,
                height: 44.w,
                decoration: BoxDecoration(
                  color: colors.primary.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Icon(
                  Icons.groups_rounded,
                  color: colors.primary,
                  size: 22.sp,
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      t.laporanConfig.recapAttendance,
                      style: TextStyle(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w600,
                        color: colors.textPrimary,
                        fontFamily: 'Poppins',
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      widget.halaqohName,
                      style: TextStyle(
                        fontSize: 11.sp,
                        color: colors.textSecondary,
                        fontFamily: 'Poppins',
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: colors.primary,
                  borderRadius: BorderRadius.circular(6.r),
                ),
                child: Text(
                  'PDF',
                  style: TextStyle(
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w700,
                    color: colors.textOnButton,
                    fontFamily: 'Poppins',
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 16.h),

        // Action buttons
        Row(
          children: [
            Expanded(
              child: _ActionButton(
                icon: Icons.visibility_outlined,
                label: t.laporanConfig.btnPreview,
                isPrimary: false,
                colors: colors,
                onTap: () => context.read<LaporanAbsensiHalaqohCubit>().previewPdf(
                  pdfBytes as dynamic, _filename,
                ),
              ),
            ),
            SizedBox(width: 10.w),
            Expanded(
              child: _ActionButton(
                icon: Icons.share_rounded,
                label: t.laporanConfig.btnShare,
                isPrimary: true,
                colors: colors,
                onTap: () => context.read<LaporanAbsensiHalaqohCubit>().sharePdf(
                  pdfBytes as dynamic, _filename,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 10.h),

        Center(
          child: TextButton.icon(
            onPressed: () => context.read<LaporanAbsensiHalaqohCubit>().reset(),
            icon: Icon(
              Icons.refresh_rounded,
              size: 16.sp,
              color: colors.textSecondary,
            ),
            label: Text(
              t.laporanConfig.btnCreateNewRecap,
              style: TextStyle(
                fontSize: 12.sp,
                color: colors.textSecondary,
                fontFamily: 'Poppins',
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// Sub-widgets
// ═══════════════════════════════════════════════════════════════════════════

class _HalaqohChip extends StatelessWidget {
  final String halaqohName;
  final String guruNama;
  final AppColorSet colors;
  const _HalaqohChip({
    required this.halaqohName,
    required this.guruNama,
    required this.colors,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: colors.border),
      ),
      child: Row(
        children: [
          Container(
            width: 38.w,
            height: 38.w,
            decoration: BoxDecoration(
              color: colors.primary.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.group_rounded,
              color: colors.primary,
              size: 20.sp,
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  halaqohName,
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w600,
                    color: colors.textPrimary,
                    fontFamily: 'Poppins',
                  ),
                ),
                SizedBox(height: 1.h),
                Text(
                  'Musyrif: $guruNama',
                  style: TextStyle(
                    fontSize: 11.sp,
                    color: colors.textSecondary,
                    fontFamily: 'Poppins',
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Sub-widgets — reused from LaporanKonfigurasiSheet pattern

class _SectionLabel extends StatelessWidget {
  final String label;
  final AppColorSet colors;
  const _SectionLabel({required this.label, required this.colors});
  @override
  Widget build(BuildContext context) => Text(
    label,
    style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w600,
        color: colors.textSecondary, fontFamily: 'Poppins', letterSpacing: 0.3),
  );
}

class _RangeCard extends StatelessWidget {
  final IconData icon; final String label; final bool selected;
  final AppColorSet colors; final VoidCallback onTap;
  const _RangeCard({required this.icon, required this.label,
      required this.selected, required this.colors, required this.onTap});
  @override
  Widget build(BuildContext context) => Expanded(
    child: GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(vertical: 12.h),
        decoration: BoxDecoration(
          color: selected ? colors.primary : colors.surface,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: selected ? colors.primary : colors.border, width: selected ? 1.5 : 1),
          boxShadow: selected ? [BoxShadow(color: colors.primary.withValues(alpha: 0.25), blurRadius: 8, offset: const Offset(0, 3))] : [],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 22.sp, color: selected ? colors.textOnButton : colors.textSecondary),
            SizedBox(height: 5.h),
            Text(label, style: TextStyle(fontSize: 11.sp, fontWeight: FontWeight.w600,
                color: selected ? colors.textOnButton : colors.textSecondary, fontFamily: 'Poppins')),
          ],
        ),
      ),
    ),
  );
}

class _WeekChip extends StatelessWidget {
  final DateTime weekStart, weekEnd; final bool isSelected;
  final AppColorSet colors; final VoidCallback onTap;
  const _WeekChip({required this.weekStart, required this.weekEnd,
      required this.isSelected, required this.colors, required this.onTap});
  @override
  Widget build(BuildContext context) {
    final fmt = DateFormat('dd MMM', t.$meta.locale.languageCode);
    final label = '${fmt.format(weekStart)} – ${fmt.format(weekEnd)}';
    final weekNum = ((weekStart.difference(DateTime(weekStart.year, 1, 1)).inDays) / 7).floor() + 1;
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        margin: EdgeInsets.only(bottom: 7.h),
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 11.h),
        decoration: BoxDecoration(
          color: isSelected ? colors.primary.withValues(alpha: 0.08) : colors.surface,
          borderRadius: BorderRadius.circular(10.r),
          border: Border.all(color: isSelected ? colors.primary : colors.border, width: isSelected ? 1.5 : 1),
        ),
        child: Row(
          children: [
            Container(
              width: 32.w, height: 32.w,
              decoration: BoxDecoration(color: isSelected ? colors.primary : colors.border, borderRadius: BorderRadius.circular(8.r)),
              child: Center(child: Text('W$weekNum', style: TextStyle(fontSize: 9.sp, fontWeight: FontWeight.w700,
                  color: isSelected ? colors.textOnButton : colors.textSecondary, fontFamily: 'Poppins'))),
            ),
            SizedBox(width: 12.w),
            Expanded(child: Text(label, style: TextStyle(fontSize: 13.sp,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                color: isSelected ? colors.primary : colors.textPrimary, fontFamily: 'Poppins'))),
            if (isSelected) Icon(Icons.check_circle_rounded, color: colors.primary, size: 18.sp),
          ],
        ),
      ),
    );
  }
}

class _MonthChip extends StatelessWidget {
  final String label; final bool selected; final AppColorSet colors; final VoidCallback onTap;
  const _MonthChip({required this.label, required this.selected, required this.colors, required this.onTap});
  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    child: AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      decoration: BoxDecoration(
        color: selected ? colors.primary : colors.surface,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: selected ? colors.primary : colors.border),
      ),
      child: Center(child: Text(label, style: TextStyle(fontSize: 11.sp,
          fontWeight: selected ? FontWeight.w700 : FontWeight.w400,
          color: selected ? colors.textOnButton : colors.textPrimary, fontFamily: 'Poppins'))),
    ),
  );
}

class _DatePickerField extends StatelessWidget {
  final String label; final DateTime? date; final IconData icon;
  final AppColorSet colors; final VoidCallback onTap;
  const _DatePickerField({required this.label, required this.date,
      required this.icon, required this.colors, required this.onTap});
  @override
  Widget build(BuildContext context) {
    final hasDate = date != null;
    final text = hasDate ? DateFormat('dd MMM yyyy', t.$meta.locale.languageCode).format(date!) : t.laporanConfig.selectDateHint;
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
        decoration: BoxDecoration(
          color: hasDate ? colors.primary.withValues(alpha: 0.05) : colors.surface,
          borderRadius: BorderRadius.circular(10.r),
          border: Border.all(color: hasDate ? colors.primary : colors.border, width: hasDate ? 1.5 : 1),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(children: [
              Icon(icon, size: 14.sp, color: hasDate ? colors.primary : colors.textSecondary),
              SizedBox(width: 4.w),
              Text(label, style: TextStyle(fontSize: 9.sp, color: colors.textSecondary, fontFamily: 'Poppins')),
            ]),
            SizedBox(height: 4.h),
            Text(text, style: TextStyle(fontSize: 11.sp,
                fontWeight: hasDate ? FontWeight.w600 : FontWeight.w400,
                color: hasDate ? colors.textPrimary : colors.textSecondary, fontFamily: 'Poppins')),
          ],
        ),
      ),
    );
  }
}

class _DurationBadge extends StatelessWidget {
  final int days; final AppColorSet colors;
  const _DurationBadge({required this.days, required this.colors});
  @override
  Widget build(BuildContext context) => Container(
    padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
    decoration: BoxDecoration(color: colors.primary.withValues(alpha: 0.08), borderRadius: BorderRadius.circular(20.r)),
    child: Row(mainAxisSize: MainAxisSize.min, children: [
      Icon(Icons.info_outline_rounded, size: 13.sp, color: colors.primary),
      SizedBox(width: 5.w),
      Text(t.laporanConfig.totalDaysSelected(days: days), style: TextStyle(fontSize: 11.sp, color: colors.primary, fontWeight: FontWeight.w500, fontFamily: 'Poppins')),
    ]),
  );
}

class _PreviewBar extends StatelessWidget {
  final DateTime startDate, endDate; final AppColorSet colors;
  const _PreviewBar({required this.startDate, required this.endDate, required this.colors});
  @override
  Widget build(BuildContext context) {
    final fmt = DateFormat('dd MMM yyyy', t.$meta.locale.languageCode);
    final days = endDate.difference(startDate).inDays + 1;
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 11.h),
      decoration: BoxDecoration(color: colors.surface, borderRadius: BorderRadius.circular(10.r), border: Border.all(color: colors.border)),
      child: Row(children: [
        Icon(Icons.date_range_rounded, size: 18.sp, color: colors.primary),
        SizedBox(width: 10.w),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(t.laporanConfig.reportPeriod, style: TextStyle(fontSize: 9.sp, color: colors.textSecondary, fontFamily: 'Poppins')),
          SizedBox(height: 2.h),
          Text('${fmt.format(startDate)} – ${fmt.format(endDate)}',
              style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w600, color: colors.textPrimary, fontFamily: 'Poppins')),
        ])),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
          decoration: BoxDecoration(color: colors.primary.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(6.r)),
          child: Text(t.laporanConfig.daysShort(days: days), style: TextStyle(fontSize: 10.sp, fontWeight: FontWeight.w700, color: colors.primary, fontFamily: 'Poppins')),
        ),
      ]),
    );
  }
}

class _IconNavButton extends StatelessWidget {
  final IconData icon; final AppColorSet colors; final VoidCallback onTap;
  const _IconNavButton({required this.icon, required this.colors, required this.onTap});
  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    child: Container(
      width: 34.w, height: 34.w,
      decoration: BoxDecoration(color: colors.surface, borderRadius: BorderRadius.circular(8.r), border: Border.all(color: colors.border)),
      child: Icon(icon, size: 20.sp, color: colors.textPrimary),
    ),
  );
}

class _ActionButton extends StatelessWidget {
  final IconData icon; final String label; final bool isPrimary;
  final AppColorSet colors; final VoidCallback onTap;
  const _ActionButton({required this.icon, required this.label,
      required this.isPrimary, required this.colors, required this.onTap});
  @override
  Widget build(BuildContext context) => SizedBox(
    height: 50.h,
    child: isPrimary
        ? ElevatedButton.icon(
            onPressed: onTap,
            icon: Icon(icon, size: 18.sp),
            label: Text(label, style: TextStyle(fontFamily: 'Poppins', fontSize: 13.sp, fontWeight: FontWeight.w600)),
            style: ElevatedButton.styleFrom(backgroundColor: colors.primary, foregroundColor: colors.textOnButton,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)), elevation: 0),
          )
        : OutlinedButton.icon(
            onPressed: onTap,
            icon: Icon(icon, size: 18.sp, color: colors.primary),
            label: Text(label, style: TextStyle(fontFamily: 'Poppins', fontSize: 13.sp, color: colors.primary)),
            style: OutlinedButton.styleFrom(
                side: BorderSide(color: colors.primary),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r))),
          ),
  );
}
