import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:my_halaqoh/gen/i18n/translations.g.dart';
import 'package:my_halaqoh/src/core/service_locator/service_locator.dart';
import 'package:my_halaqoh/src/core/theme/app_colors.dart';
import 'package:my_halaqoh/src/core/widget/widgets.dart';
import 'package:my_halaqoh/src/modules/guru_hafalan/domain/models/hafalan_santri_model.dart';
import 'package:my_halaqoh/src/modules/guru_hafalan/presentation/cubits/riwayat_hafalan_cubit.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Re-use the same grouping logic as RiwayatHafalanSantriScreen
// ─────────────────────────────────────────────────────────────────────────────
class _SubmissionGroup {
  final DateTime tanggalSetoran;
  final String jenis;
  final int nilaiKelancaran;
  final int nilaiTajwid;
  final List<HafalanSantriModel> records;

  _SubmissionGroup({
    required this.tanggalSetoran,
    required this.jenis,
    required this.nilaiKelancaran,
    required this.nilaiTajwid,
    required this.records,
  });

  int get avgScore => ((nilaiKelancaran + nilaiTajwid) / 2).round();

  /// Returns a display string for the surah range.
  String get surahDisplay {
    if (records.length == 1) return records.first.surahName;
    final sorted = List<HafalanSantriModel>.from(records)
      ..sort((a, b) => a.surahId.compareTo(b.surahId));
    return '${sorted.first.surahName} — ${sorted.last.surahName}';
  }

  /// Returns an ayat range string
  String get ayatDisplay {
    if (records.length == 1) {
      final r = records.first;
      return '${r.ayatMulai}-${r.ayatSelesai}';
    }
    return t.mutabaahSantri.suratCount(count: records.length);
  }

  /// Detailed per-surah lines
  List<String> get detailLines {
    final sorted = List<HafalanSantriModel>.from(records)
      ..sort((a, b) => a.surahId.compareTo(b.surahId));
    return sorted
        .map((r) => '${r.surahName} (${r.ayatMulai}-${r.ayatSelesai})')
        .toList();
  }
}

List<_SubmissionGroup> _groupIntoSubmissions(List<HafalanSantriModel> records) {
  final Map<String, List<HafalanSantriModel>> grouped = {};
  for (final record in records) {
    final key =
        '${record.tanggalSetoran.toIso8601String()}_${record.jenis}_${record.nilaiKelancaran}_${record.nilaiTajwid}';
    grouped.putIfAbsent(key, () => []).add(record);
  }
  final groups = grouped.entries.map((entry) {
    final list = entry.value;
    return _SubmissionGroup(
      tanggalSetoran: list.first.tanggalSetoran,
      jenis: list.first.jenis,
      nilaiKelancaran: list.first.nilaiKelancaran,
      nilaiTajwid: list.first.nilaiTajwid,
      records: list,
    );
  }).toList();
  // Sort newest first so page 1 shows the most recent submissions
  groups.sort((a, b) => b.tanggalSetoran.compareTo(a.tanggalSetoran));
  return groups;
}

/// Mutaba'ah Santri — daily memorization log split into Hafalan Baru & Murajaah tables
@RoutePage()
class MutabaahSantriScreen extends StatefulWidget implements AutoRouteWrapper {
  final String santriId;
  final String name;
  final String nis;

  const MutabaahSantriScreen({
    super.key,
    required this.santriId,
    required this.name,
    required this.nis,
  });

  @override
  Widget wrappedRoute(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<RiwayatHafalanCubit>(),
      child: this,
    );
  }

  @override
  State<MutabaahSantriScreen> createState() => _MutabaahSantriScreenState();
}

class _MutabaahSantriScreenState extends State<MutabaahSantriScreen> {
  late int _currentMonth;
  late int _currentYear;

  static const int _itemsPerPage = 5;

  List<String> get _dayNames => t.mutabaahSantri.dayNames;

  // Track which groups are expanded (by section + index)
  final Set<String> _expandedKeys = {};

  // Pagination state per section
  int _ziyadahPage = 0;
  int _murajaahPage = 0;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _currentMonth = now.month;
    _currentYear = now.year;
    _loadData();
  }

  void _loadData() {
    _ziyadahPage = 0;
    _murajaahPage = 0;
    _expandedKeys.clear();
    context.read<RiwayatHafalanCubit>().watchRiwayat(
          widget.santriId,
          _currentMonth,
          _currentYear,
        );
  }

  void _prevMonth() {
    setState(() {
      _currentMonth--;
      if (_currentMonth < 1) {
        _currentMonth = 12;
        _currentYear--;
      }
    });
    _loadData();
  }

  void _nextMonth() {
    setState(() {
      _currentMonth++;
      if (_currentMonth > 12) {
        _currentMonth = 1;
        _currentYear++;
      }
    });
    _loadData();
  }

  Color _scoreColor(int nilai) {
    if (nilai >= 85) return const Color(0xFF4CAF50);
    if (nilai >= 70) return const Color(0xFFFFC107);
    return const Color(0xFFFF7043);
  }

  Color _scoreTextColor(int nilai) {
    if (nilai >= 85) return const Color(0xFF1B5E20);
    if (nilai >= 70) return const Color(0xFF795548);
    return const Color(0xFFBF360C);
  }

  String _getDayName(DateTime date) {
    return _dayNames[date.weekday % 7];
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);

    return Scaffold(
      backgroundColor: colors.background,
      body: SafeArea(
        child: Column(
          children: [
            // ── AppBar ──
            Padding(
              padding: EdgeInsets.only(left: 8.w, top: 8.h, right: 24.w),
              child: Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_back, color: colors.textPrimary),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  SizedBox(width: 4.w),
                  Text(
                    t.mutabaahSantri.title,
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w700,
                      color: colors.textPrimary,
                      fontFamily: 'Poppins',
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 8.h),

            // ── Content ──
            Expanded(
              child: BlocBuilder<RiwayatHafalanCubit, RiwayatHafalanState>(
                builder: (context, state) {
                  return state.when(
                    initial: () => const SizedBox.shrink(),
                    loading: () => const Center(child: CircularProgressIndicator()),
                    error: (msg) => Center(
                      child: Text(
                        msg,
                        style: TextStyle(
                          color: colors.red,
                          fontFamily: 'Poppins',
                          fontSize: 14.sp,
                        ),
                      ),
                    ),
                    loaded: (allRecords) {
                      final hafalanBaru = allRecords
                          .where((r) => r.jenis == 'Ziyadah')
                          .toList();
                      final murajaah = allRecords
                          .where((r) => r.jenis == 'Murajaah')
                          .toList();

                      final hafalanBaruGroups = _groupIntoSubmissions(hafalanBaru);
                      final murajaahGroups = _groupIntoSubmissions(murajaah);

                      return SingleChildScrollView(
                        padding: EdgeInsets.symmetric(horizontal: 24.w),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // ── Month navigator ──
                            Row(
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
                                    _loadData();
                                  },
                                ),
                              ],
                            ),
                            SizedBox(height: 20.h),

                            // ── Hafalan Baru section ──
                            _buildSectionHeader(
                              t.mutabaahSantri.hafalanBaru,
                              colors,
                              count: hafalanBaruGroups.length,
                            ),
                            SizedBox(height: 10.h),
                            if (hafalanBaruGroups.isEmpty)
                              _buildEmptyState(t.mutabaahSantri.belumAdaHafalanBaru, colors)
                            else
                              _buildPaginatedTable(
                                allGroups: hafalanBaruGroups,
                                sectionKey: 'ziyadah',
                                currentPage: _ziyadahPage,
                                onPageChanged: (p) => setState(() => _ziyadahPage = p),
                                colors: colors,
                              ),
                            SizedBox(height: 28.h),

                            // ── Murajaah section ──
                            _buildSectionHeader(
                              t.mutabaahSantri.murajaah,
                              colors,
                              count: murajaahGroups.length,
                            ),
                            SizedBox(height: 10.h),
                            if (murajaahGroups.isEmpty)
                              _buildEmptyState(t.mutabaahSantri.belumAdaMurajaah, colors)
                            else
                              _buildPaginatedTable(
                                allGroups: murajaahGroups,
                                sectionKey: 'murajaah',
                                currentPage: _murajaahPage,
                                onPageChanged: (p) => setState(() => _murajaahPage = p),
                                colors: colors,
                              ),
                            SizedBox(height: 24.h),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(String message, AppColorSet colors) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 24.h),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: colors.border, width: 1),
      ),
      child: Center(
        child: Text(
          message,
          style: TextStyle(
            fontSize: 13.sp,
            color: colors.textSecondary,
            fontFamily: 'Poppins',
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String label, AppColorSet colors, {int? count}) {
    return Row(
      children: [
        Container(
          width: 4.w,
          height: 22.h,
          decoration: BoxDecoration(
            color: colors.primary,
            borderRadius: BorderRadius.circular(2.r),
          ),
        ),
        SizedBox(width: 8.w),
        Text(
          label,
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w700,
            color: colors.textPrimary,
            fontFamily: 'Poppins',
          ),
        ),
        if (count != null && count > 0) ...[
          SizedBox(width: 8.w),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
            decoration: BoxDecoration(
              color: colors.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Text(
              '$count',
              style: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.w600,
                color: colors.primary,
                fontFamily: 'Poppins',
              ),
            ),
          ),
        ],
      ],
    );
  }

  /// Wraps the grouped table with pagination controls.
  Widget _buildPaginatedTable({
    required List<_SubmissionGroup> allGroups,
    required String sectionKey,
    required int currentPage,
    required ValueChanged<int> onPageChanged,
    required AppColorSet colors,
  }) {
    final totalPages = (allGroups.length / _itemsPerPage).ceil();
    // Clamp currentPage in case data shrinks
    final safePage = currentPage.clamp(0, totalPages - 1);
    if (safePage != currentPage) {
      WidgetsBinding.instance.addPostFrameCallback((_) => onPageChanged(safePage));
    }

    final start = safePage * _itemsPerPage;
    final end = (start + _itemsPerPage).clamp(0, allGroups.length);
    final pageGroups = allGroups.sublist(start, end);

    return Column(
      children: [
        _buildGroupedTable(pageGroups, '${sectionKey}_p$safePage', colors),
        if (totalPages > 1) ...[
          SizedBox(height: 10.h),
          _buildPaginationBar(
            currentPage: safePage,
            totalPages: totalPages,
            onPageChanged: onPageChanged,
            colors: colors,
          ),
        ],
      ],
    );
  }

  /// Compact pagination bar with prev/next arrows and page numbers.
  Widget _buildPaginationBar({
    required int currentPage,
    required int totalPages,
    required ValueChanged<int> onPageChanged,
    required AppColorSet colors,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Previous button
        _buildPageArrow(
          icon: Icons.chevron_left,
          enabled: currentPage > 0,
          onTap: () => onPageChanged(currentPage - 1),
          colors: colors,
        ),
        SizedBox(width: 4.w),

        // Page numbers (show max 5 pages at a time)
        ..._buildPageNumbers(currentPage, totalPages, onPageChanged, colors),

        SizedBox(width: 4.w),
        // Next button
        _buildPageArrow(
          icon: Icons.chevron_right,
          enabled: currentPage < totalPages - 1,
          onTap: () => onPageChanged(currentPage + 1),
          colors: colors,
        ),
      ],
    );
  }

  List<Widget> _buildPageNumbers(
    int currentPage,
    int totalPages,
    ValueChanged<int> onPageChanged,
    AppColorSet colors,
  ) {
    // Determine visible page range (max 5 pages)
    const maxVisible = 5;
    int startPage = currentPage - (maxVisible ~/ 2);
    if (startPage < 0) startPage = 0;
    int endPage = startPage + maxVisible;
    if (endPage > totalPages) {
      endPage = totalPages;
      startPage = (endPage - maxVisible).clamp(0, totalPages);
    }

    return List.generate(endPage - startPage, (i) {
      final page = startPage + i;
      final isActive = page == currentPage;
      return GestureDetector(
        onTap: isActive ? null : () => onPageChanged(page),
        child: Container(
          width: 32.w,
          height: 32.w,
          margin: EdgeInsets.symmetric(horizontal: 2.w),
          decoration: BoxDecoration(
            color: isActive ? colors.primary : colors.surface,
            borderRadius: BorderRadius.circular(8.r),
            border: isActive
                ? null
                : Border.all(color: colors.border, width: 1),
          ),
          alignment: Alignment.center,
          child: Text(
            '${page + 1}',
            style: TextStyle(
              fontSize: 12.sp,
              fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
              color: isActive ? Colors.white : colors.textSecondary,
              fontFamily: 'Poppins',
            ),
          ),
        ),
      );
    });
  }

  Widget _buildPageArrow({
    required IconData icon,
    required bool enabled,
    required VoidCallback onTap,
    required AppColorSet colors,
  }) {
    return GestureDetector(
      onTap: enabled ? onTap : null,
      child: Container(
        width: 32.w,
        height: 32.w,
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: BorderRadius.circular(8.r),
          border: Border.all(color: colors.border, width: 1),
        ),
        alignment: Alignment.center,
        child: Icon(
          icon,
          size: 18.sp,
          color: enabled
              ? colors.textPrimary
              : colors.textSecondary.withValues(alpha: 0.3),
        ),
      ),
    );
  }

  Widget _buildGroupedTable(
    List<_SubmissionGroup> groups,
    String sectionKey,
    AppColorSet colors,
  ) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: colors.border, width: 1),
      ),
      child: Column(
        children: [
          // Header row
          Container(
            padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: colors.border, width: 1)),
            ),
            child: Row(
              children: [
                _headerCell(t.mutabaahSantri.hari, 50.w, colors),
                _headerCell(t.mutabaahSantri.tgl, 50.w, colors),
                Expanded(child: _headerCell(t.mutabaahSantri.surat, null, colors)),
                _headerCell(t.mutabaahSantri.ayat, 55.w, colors),
                _headerCell(t.mutabaahSantri.nilai, 45.w, colors,
                    align: TextAlign.center),
              ],
            ),
          ),

          // Data rows (grouped)
          ...groups.asMap().entries.map((entry) {
            final group = entry.value;
            final idx = entry.key;
            final isLast = idx == groups.length - 1;
            final expandKey = '${sectionKey}_$idx';
            final isExpanded = _expandedKeys.contains(expandKey);
            final hasMultiple = group.records.length > 1;
            final dateStr = DateFormat('dd/MM').format(group.tanggalSetoran);

            return Column(
              children: [
                // Main row
                GestureDetector(
                  onTap: hasMultiple
                      ? () {
                          setState(() {
                            if (isExpanded) {
                              _expandedKeys.remove(expandKey);
                            } else {
                              _expandedKeys.add(expandKey);
                            }
                          });
                        }
                      : null,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
                    decoration: BoxDecoration(
                      color: isExpanded
                          ? colors.primary.withValues(alpha: 0.03)
                          : null,
                      border: (isLast && !isExpanded)
                          ? null
                          : Border(
                              bottom: BorderSide(
                                color: colors.border.withValues(alpha: 0.5),
                                width: 0.5,
                              ),
                            ),
                    ),
                    child: Row(
                      children: [
                        SizedBox(
                          width: 50.w,
                          child: Text(
                            _getDayName(group.tanggalSetoran),
                            style: TextStyle(
                              fontSize: 13.sp,
                              fontWeight: FontWeight.w700,
                              color: colors.textPrimary,
                              fontFamily: 'Poppins',
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 50.w,
                          child: Text(
                            dateStr,
                            style: TextStyle(
                              fontSize: 12.sp,
                              color: colors.textSecondary,
                              fontFamily: 'Poppins',
                            ),
                          ),
                        ),
                        Expanded(
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  group.surahDisplay,
                                  style: TextStyle(
                                    fontSize: 13.sp,
                                    fontWeight: FontWeight.w500,
                                    color: colors.textPrimary,
                                    fontFamily: 'Poppins',
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              if (hasMultiple) ...[
                                SizedBox(width: 2.w),
                                AnimatedRotation(
                                  turns: isExpanded ? 0.5 : 0,
                                  duration: const Duration(milliseconds: 200),
                                  child: Icon(
                                    Icons.expand_more,
                                    size: 16.sp,
                                    color: colors.textSecondary,
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                        SizedBox(
                          width: 55.w,
                          child: Text(
                            group.ayatDisplay,
                            style: TextStyle(
                              fontSize: 12.sp,
                              color: colors.textSecondary,
                              fontFamily: 'Poppins',
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 45.w,
                          child: Center(
                            child: Container(
                              width: 36.w,
                              height: 36.w,
                              decoration: BoxDecoration(
                                color: _scoreColor(group.avgScore)
                                    .withValues(alpha: 0.15),
                                shape: BoxShape.circle,
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                '${group.avgScore}',
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w700,
                                  color: _scoreTextColor(group.avgScore),
                                  fontFamily: 'Poppins',
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Expanded detail rows
                if (isExpanded && hasMultiple)
                  ..._buildExpandedRows(group, isLast, colors),
              ],
            );
          }),
        ],
      ),
    );
  }

  List<Widget> _buildExpandedRows(
    _SubmissionGroup group,
    bool isLastGroup,
    AppColorSet colors,
  ) {
    final sorted = List<HafalanSantriModel>.from(group.records)
      ..sort((a, b) => a.surahId.compareTo(b.surahId));

    return sorted.asMap().entries.map((entry) {
      final record = entry.value;
      final isLast = entry.key == sorted.length - 1;

      return Container(
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: colors.primary.withValues(alpha: 0.02),
          border: (isLast && isLastGroup)
              ? null
              : Border(
                  bottom: BorderSide(
                    color: colors.border.withValues(alpha: 0.3),
                    width: 0.5,
                  ),
                ),
        ),
        child: Row(
          children: [
            SizedBox(width: 50.w), // day column placeholder
            SizedBox(width: 50.w), // date column placeholder
            Expanded(
              child: Row(
                children: [
                  Container(
                    width: 5.w,
                    height: 5.w,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: colors.primary.withValues(alpha: 0.5),
                    ),
                  ),
                  SizedBox(width: 6.w),
                  Expanded(
                    child: Text(
                      record.surahName,
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: colors.textSecondary,
                        fontFamily: 'Poppins',
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              width: 55.w,
              child: Text(
                '${record.ayatMulai}-${record.ayatSelesai}',
                style: TextStyle(
                  fontSize: 11.sp,
                  color: colors.textSecondary.withValues(alpha: 0.8),
                  fontFamily: 'Poppins',
                ),
              ),
            ),
            SizedBox(width: 45.w), // score column placeholder (same score)
          ],
        ),
      );
    }).toList();
  }

  Widget _headerCell(
    String label,
    double? width,
    AppColorSet colors, {
    TextAlign align = TextAlign.left,
  }) {
    final text = Text(
      label,
      textAlign: align,
      style: TextStyle(
        fontSize: 11.sp,
        fontWeight: FontWeight.w600,
        color: colors.textSecondary,
        fontFamily: 'Poppins',
        letterSpacing: 0.3,
      ),
    );
    if (width != null) return SizedBox(width: width, child: text);
    return text;
  }
}