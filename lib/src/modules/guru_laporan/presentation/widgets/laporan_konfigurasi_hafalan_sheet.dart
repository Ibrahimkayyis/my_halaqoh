import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:my_halaqoh/src/core/service_locator/service_locator.dart';
import 'package:my_halaqoh/src/core/theme/app_colors.dart';

import 'package:my_halaqoh/src/modules/master_data/domain/models/halaqoh_model.dart';

import '../../domain/models/laporan_absensi_config.dart';
import '../../domain/models/laporan_hafalan_config.dart';
import '../cubits/laporan_hafalan_cubit.dart';
import '../cubits/laporan_hafalan_state.dart';

/// Modal bottom sheet for configuring and generating a Hafalan PDF report.
/// Mirrors [LaporanKonfigurasiSheet] UX patterns exactly.
class LaporanKonfigurasiHafalanSheet extends StatefulWidget {
  final String santriName;
  final String santriId;
  final String santriNis;
  final HalaqohModel? halaqoh;
  final int initialMonth;
  final int initialYear;

  const LaporanKonfigurasiHafalanSheet({
    super.key,
    required this.santriName,
    required this.santriId,
    required this.santriNis,
    required this.halaqoh,
    required this.initialMonth,
    required this.initialYear,
  });

  static void show(
    BuildContext context, {
    required String santriName,
    required String santriId,
    required String santriNis,
    required HalaqohModel? halaqoh,
    required int initialMonth,
    required int initialYear,
  }) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      useSafeArea: true,
      builder: (_) => BlocProvider(
        create: (_) => sl<LaporanHafalanCubit>(),
        child: LaporanKonfigurasiHafalanSheet(
          santriName: santriName,
          santriId: santriId,
          santriNis: santriNis,
          halaqoh: halaqoh,
          initialMonth: initialMonth,
          initialYear: initialYear,
        ),
      ),
    );
  }

  @override
  State<LaporanKonfigurasiHafalanSheet> createState() =>
      _LaporanKonfigurasiHafalanSheetState();
}

class _LaporanKonfigurasiHafalanSheetState extends State<LaporanKonfigurasiHafalanSheet>
    with SingleTickerProviderStateMixin {
  ReportRange _range = ReportRange.monthly;

  // ── Monthly ───────────────────────────────────────────────────────────────
  late int _month;
  late int _year;

  // ── Weekly ────────────────────────────────────────────────────────────────
  late int _weekMonth;
  late int _weekYear;
  late DateTime _weekStart;
  late DateTime _weekEnd;

  // ── Custom ────────────────────────────────────────────────────────────────
  DateTime? _customStart;
  DateTime? _customEnd;

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

  // ── Computed dates ────────────────────────────────────────────────────────
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

  // ── Config ────────────────────────────────────────────────────────────────
  LaporanHafalanConfig get _config => LaporanHafalanConfig(
    santriName: widget.santriName,
    santriId: widget.santriId,
    santriNis: widget.santriNis,
    halaqohName: widget.halaqoh?.nama ?? '-',
    guruNama: widget.halaqoh?.guruNama ?? '-',
    range: _range,
    startDate: _startDate,
    endDate: _endDate,
  );

  String get _filename {
    final slug = widget.santriName.replaceAll(' ', '_');
    return 'Laporan_Hafalan_${slug}_${DateFormat('yyyyMMdd').format(DateTime.now())}.pdf';
  }

  // ── Helpers ───────────────────────────────────────────────────────────────
  static const _monthNames = [
    'Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun',
    'Jul', 'Agu', 'Sep', 'Okt', 'Nov', 'Des',
  ];
  static const _monthNamesFull = [
    'Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni',
    'Juli', 'Agustus', 'September', 'Oktober', 'November', 'Desember',
  ];

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
      locale: const Locale('id', 'ID'),
      helpText: isStart ? 'Pilih Tanggal Awal' : 'Pilih Tanggal Akhir',
      confirmText: 'Pilih',
      cancelText: 'Batal',
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

  // ── Build ─────────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);

    return BlocConsumer<LaporanHafalanCubit, LaporanHafalanState>(
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
        Text(
          'Unduh Laporan Hafalan',
          style: TextStyle(
            fontSize: 17.sp,
            fontWeight: FontWeight.w700,
            color: colors.textPrimary,
            fontFamily: 'Poppins',
          ),
        ),
        SizedBox(height: 4.h),
        Text(
          'Pilih periode & konfigurasi laporan PDF santri.',
          style: TextStyle(
            fontSize: 12.sp,
            color: colors.textSecondary,
            fontFamily: 'Poppins',
          ),
        ),
        SizedBox(height: 16.h),

        _StudentChip(
          name: widget.santriName,
          nis: widget.santriNis,
          colors: colors,
        ),
        SizedBox(height: 20.h),

        _SectionLabel(label: 'Rentang Waktu', colors: colors),
        SizedBox(height: 8.h),
        Row(
          children: [
            _RangeCard(
              icon: Icons.view_week_rounded,
              label: 'Mingguan',
              selected: _range == ReportRange.weekly,
              colors: colors,
              onTap: () => _switchRange(ReportRange.weekly),
            ),
            SizedBox(width: 8.w),
            _RangeCard(
              icon: Icons.calendar_month_rounded,
              label: 'Bulanan',
              selected: _range == ReportRange.monthly,
              colors: colors,
              onTap: () => _switchRange(ReportRange.monthly),
            ),
            SizedBox(width: 8.w),
            _RangeCard(
              icon: Icons.tune_rounded,
              label: 'Kustom',
              selected: _range == ReportRange.semester,
              colors: colors,
              onTap: () => _switchRange(ReportRange.semester),
            ),
          ],
        ),
        SizedBox(height: 18.h),

        FadeTransition(opacity: _fadeAnim, child: _buildDateSelector(colors)),
        SizedBox(height: 16.h),

        if (_isCustomValid) ...[
          _PreviewBar(startDate: _startDate, endDate: _endDate, colors: colors),
          SizedBox(height: 18.h),
        ],

        SizedBox(
          width: double.infinity,
          height: 52.h,
          child: ElevatedButton(
            onPressed: isGenerating || !_isCustomValid
                ? null
                : () => context.read<LaporanHafalanCubit>().generatePdf(_config),
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
                        'Membuat laporan...',
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
                        'Buat Laporan PDF',
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

  // ── Date selector switcher ─────────────────────────────────────────────────
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

  // ── Weekly: week strip ────────────────────────────────────────────────────
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
                if (_weekMonth < 1) {
                  _weekMonth = 12;
                  _weekYear--;
                }
              }),
            ),
            Expanded(
              child: Text(
                '${_monthNamesFull[_weekMonth - 1]} $_weekYear',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w600,
                  color: colors.textPrimary,
                  fontFamily: 'Poppins',
                ),
              ),
            ),
            _IconNavButton(
              icon: Icons.chevron_right,
              colors: colors,
              onTap: () => setState(() {
                _weekMonth++;
                if (_weekMonth > 12) {
                  _weekMonth = 1;
                  _weekYear++;
                }
              }),
            ),
          ],
        ),
        SizedBox(height: 10.h),
        ...weeks.map((mon) {
          final sun = mon.add(const Duration(days: 6));
          final isSelected = mon == _weekStart;
          return _WeekChip(
            weekStart: mon,
            weekEnd: sun,
            isSelected: isSelected,
            colors: colors,
            onTap: () => setState(() {
              _weekStart = mon;
              _weekEnd = sun;
            }),
          );
        }),
      ],
    );
  }

  // ── Monthly: 3-column month grid ──────────────────────────────────────────
  Widget _buildMonthlySelector(AppColorSet colors) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            _IconNavButton(
              icon: Icons.chevron_left,
              colors: colors,
              onTap: () => setState(() => _year--),
            ),
            Expanded(
              child: Text(
                '$_year',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w700,
                  color: colors.textPrimary,
                  fontFamily: 'Poppins',
                ),
              ),
            ),
            _IconNavButton(
              icon: Icons.chevron_right,
              colors: colors,
              onTap: () => setState(() => _year++),
            ),
          ],
        ),
        SizedBox(height: 10.h),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            mainAxisSpacing: 8.h,
            crossAxisSpacing: 8.w,
            childAspectRatio: 2.2,
          ),
          itemCount: 12,
          itemBuilder: (_, i) {
            final selected = (i + 1) == _month;
            return _MonthChip(
              label: _monthNames[i],
              selected: selected,
              colors: colors,
              onTap: () => setState(() => _month = i + 1),
            );
          },
        ),
      ],
    );
  }

  // ── Custom: two date pickers ──────────────────────────────────────────────
  Widget _buildCustomSelector(AppColorSet colors) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionLabel(label: 'Pilih Rentang Tanggal', colors: colors),
        SizedBox(height: 10.h),
        Row(
          children: [
            Expanded(
              child: _DatePickerField(
                label: 'Tanggal Awal',
                date: _customStart,
                icon: Icons.event_available_rounded,
                colors: colors,
                onTap: () => _pickDate(true),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.w),
              child: Icon(
                Icons.arrow_forward_rounded,
                size: 18.sp,
                color: colors.textSecondary,
              ),
            ),
            Expanded(
              child: _DatePickerField(
                label: 'Tanggal Akhir',
                date: _customEnd,
                icon: Icons.event_rounded,
                colors: colors,
                onTap: () => _pickDate(false),
              ),
            ),
          ],
        ),
        if (_customStart != null && _customEnd != null) ...[
          SizedBox(height: 10.h),
          _DurationBadge(
            days: _customEnd!.difference(_customStart!).inDays + 1,
            colors: colors,
          ),
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
        Text(
          'Laporan Siap!',
          style: TextStyle(
            fontSize: 17.sp,
            fontWeight: FontWeight.w700,
            color: colors.textPrimary,
            fontFamily: 'Poppins',
          ),
        ),
        SizedBox(height: 4.h),
        Text(
          'PDF berhasil dibuat. Pratinjau atau bagikan sekarang.',
          style: TextStyle(
            fontSize: 12.sp,
            color: colors.textSecondary,
            fontFamily: 'Poppins',
          ),
        ),
        SizedBox(height: 16.h),

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
                  Icons.picture_as_pdf_rounded,
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
                      'Laporan Hafalan',
                      style: TextStyle(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w600,
                        color: colors.textPrimary,
                        fontFamily: 'Poppins',
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      widget.santriName,
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

        Row(
          children: [
            Expanded(
              child: _ActionButton(
                icon: Icons.visibility_outlined,
                label: 'Pratinjau',
                isPrimary: false,
                colors: colors,
                onTap: () => context.read<LaporanHafalanCubit>().previewPdf(
                  pdfBytes as dynamic,
                  _filename,
                ),
              ),
            ),
            SizedBox(width: 10.w),
            Expanded(
              child: _ActionButton(
                icon: Icons.share_rounded,
                label: 'Bagikan',
                isPrimary: true,
                colors: colors,
                onTap: () => context.read<LaporanHafalanCubit>().sharePdf(
                  pdfBytes as dynamic,
                  _filename,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 10.h),

        Center(
          child: TextButton.icon(
            onPressed: () => context.read<LaporanHafalanCubit>().reset(),
            icon: Icon(
              Icons.refresh_rounded,
              size: 16.sp,
              color: colors.textSecondary,
            ),
            label: Text(
              'Buat laporan baru',
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

class _SectionLabel extends StatelessWidget {
  final String label;
  final AppColorSet colors;
  const _SectionLabel({required this.label, required this.colors});

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: TextStyle(
        fontSize: 12.sp,
        fontWeight: FontWeight.w600,
        color: colors.textSecondary,
        fontFamily: 'Poppins',
        letterSpacing: 0.3,
      ),
    );
  }
}

class _StudentChip extends StatelessWidget {
  final String name;
  final String nis;
  final AppColorSet colors;
  const _StudentChip({
    required this.name,
    required this.nis,
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
              Icons.person_rounded,
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
                  name,
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w600,
                    color: colors.textPrimary,
                    fontFamily: 'Poppins',
                  ),
                ),
                SizedBox(height: 1.h),
                Text(
                  'NIS: $nis',
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

class _RangeCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool selected;
  final AppColorSet colors;
  final VoidCallback onTap;
  const _RangeCard({
    required this.icon,
    required this.label,
    required this.selected,
    required this.colors,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: EdgeInsets.symmetric(vertical: 12.h),
          decoration: BoxDecoration(
            color: selected ? colors.primary : colors.surface,
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(
              color: selected ? colors.primary : colors.border,
              width: selected ? 1.5 : 1,
            ),
            boxShadow: selected
                ? [
                    BoxShadow(
                      color: colors.primary.withValues(alpha: 0.25),
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ]
                : [],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: 22.sp,
                color: selected ? colors.textOnButton : colors.textSecondary,
              ),
              SizedBox(height: 5.h),
              Text(
                label,
                style: TextStyle(
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w600,
                  color: selected ? colors.textOnButton : colors.textSecondary,
                  fontFamily: 'Poppins',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _WeekChip extends StatelessWidget {
  final DateTime weekStart;
  final DateTime weekEnd;
  final bool isSelected;
  final AppColorSet colors;
  final VoidCallback onTap;
  const _WeekChip({
    required this.weekStart,
    required this.weekEnd,
    required this.isSelected,
    required this.colors,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final fmt = DateFormat('dd MMM', 'id');
    final label = '${fmt.format(weekStart)} – ${fmt.format(weekEnd)}';
    final weekNum =
        ((weekStart.difference(DateTime(weekStart.year, 1, 1)).inDays) / 7)
            .floor() + 1;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        margin: EdgeInsets.only(bottom: 7.h),
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 11.h),
        decoration: BoxDecoration(
          color: isSelected
              ? colors.primary.withValues(alpha: 0.08)
              : colors.surface,
          borderRadius: BorderRadius.circular(10.r),
          border: Border.all(
            color: isSelected ? colors.primary : colors.border,
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 32.w,
              height: 32.w,
              decoration: BoxDecoration(
                color: isSelected ? colors.primary : colors.border,
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Center(
                child: Text(
                  'W$weekNum',
                  style: TextStyle(
                    fontSize: 9.sp,
                    fontWeight: FontWeight.w700,
                    color: isSelected
                        ? colors.textOnButton
                        : colors.textSecondary,
                    fontFamily: 'Poppins',
                  ),
                ),
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 13.sp,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                  color: isSelected ? colors.primary : colors.textPrimary,
                  fontFamily: 'Poppins',
                ),
              ),
            ),
            if (isSelected)
              Icon(
                Icons.check_circle_rounded,
                color: colors.primary,
                size: 18.sp,
              ),
          ],
        ),
      ),
    );
  }
}

class _MonthChip extends StatelessWidget {
  final String label;
  final bool selected;
  final AppColorSet colors;
  final VoidCallback onTap;
  const _MonthChip({
    required this.label,
    required this.selected,
    required this.colors,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        decoration: BoxDecoration(
          color: selected ? colors.primary : colors.surface,
          borderRadius: BorderRadius.circular(8.r),
          border: Border.all(color: selected ? colors.primary : colors.border),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              fontSize: 11.sp,
              fontWeight: selected ? FontWeight.w700 : FontWeight.w400,
              color: selected ? colors.textOnButton : colors.textPrimary,
              fontFamily: 'Poppins',
            ),
          ),
        ),
      ),
    );
  }
}

class _DatePickerField extends StatelessWidget {
  final String label;
  final DateTime? date;
  final IconData icon;
  final AppColorSet colors;
  final VoidCallback onTap;
  const _DatePickerField({
    required this.label,
    required this.date,
    required this.icon,
    required this.colors,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final hasDate = date != null;
    final text = hasDate
        ? DateFormat('dd MMM yyyy', 'id').format(date!)
        : 'Pilih tanggal';

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
        decoration: BoxDecoration(
          color: hasDate
              ? colors.primary.withValues(alpha: 0.05)
              : colors.surface,
          borderRadius: BorderRadius.circular(10.r),
          border: Border.all(
            color: hasDate ? colors.primary : colors.border,
            width: hasDate ? 1.5 : 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  icon,
                  size: 14.sp,
                  color: hasDate ? colors.primary : colors.textSecondary,
                ),
                SizedBox(width: 4.w),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 9.sp,
                    color: colors.textSecondary,
                    fontFamily: 'Poppins',
                  ),
                ),
              ],
            ),
            SizedBox(height: 4.h),
            Text(
              text,
              style: TextStyle(
                fontSize: 11.sp,
                fontWeight: hasDate ? FontWeight.w600 : FontWeight.w400,
                color: hasDate ? colors.textPrimary : colors.textSecondary,
                fontFamily: 'Poppins',
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DurationBadge extends StatelessWidget {
  final int days;
  final AppColorSet colors;
  const _DurationBadge({required this.days, required this.colors});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
      decoration: BoxDecoration(
        color: colors.primary.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.info_outline_rounded, size: 13.sp, color: colors.primary),
          SizedBox(width: 5.w),
          Text(
            'Total $days hari dipilih',
            style: TextStyle(
              fontSize: 11.sp,
              color: colors.primary,
              fontWeight: FontWeight.w500,
              fontFamily: 'Poppins',
            ),
          ),
        ],
      ),
    );
  }
}

class _PreviewBar extends StatelessWidget {
  final DateTime startDate;
  final DateTime endDate;
  final AppColorSet colors;
  const _PreviewBar({
    required this.startDate,
    required this.endDate,
    required this.colors,
  });

  @override
  Widget build(BuildContext context) {
    final fmt = DateFormat('dd MMM yyyy', 'id');
    final days = endDate.difference(startDate).inDays + 1;
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 11.h),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: colors.border),
      ),
      child: Row(
        children: [
          Icon(Icons.date_range_rounded, size: 18.sp, color: colors.primary),
          SizedBox(width: 10.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Periode Laporan',
                  style: TextStyle(
                    fontSize: 9.sp,
                    color: colors.textSecondary,
                    fontFamily: 'Poppins',
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  '${fmt.format(startDate)} – ${fmt.format(endDate)}',
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w600,
                    color: colors.textPrimary,
                    fontFamily: 'Poppins',
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
            decoration: BoxDecoration(
              color: colors.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(6.r),
            ),
            child: Text(
              '$days hr',
              style: TextStyle(
                fontSize: 10.sp,
                fontWeight: FontWeight.w700,
                color: colors.primary,
                fontFamily: 'Poppins',
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _IconNavButton extends StatelessWidget {
  final IconData icon;
  final AppColorSet colors;
  final VoidCallback onTap;
  const _IconNavButton({
    required this.icon,
    required this.colors,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 34.w,
        height: 34.w,
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: BorderRadius.circular(8.r),
          border: Border.all(color: colors.border),
        ),
        child: Icon(icon, size: 20.sp, color: colors.textPrimary),
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isPrimary;
  final AppColorSet colors;
  final VoidCallback onTap;
  const _ActionButton({
    required this.icon,
    required this.label,
    required this.isPrimary,
    required this.colors,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50.h,
      child: isPrimary
          ? ElevatedButton.icon(
              onPressed: onTap,
              icon: Icon(icon, size: 18.sp),
              label: Text(
                label,
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: colors.primary,
                foregroundColor: colors.textOnButton,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
                elevation: 0,
              ),
            )
          : OutlinedButton.icon(
              onPressed: onTap,
              icon: Icon(icon, size: 18.sp, color: colors.primary),
              label: Text(
                label,
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 13.sp,
                  color: colors.primary,
                ),
              ),
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: colors.primary),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
              ),
            ),
    );
  }
}
