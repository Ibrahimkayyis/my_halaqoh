import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_halaqoh/gen/i18n/translations.g.dart';
import 'package:my_halaqoh/src/core/router/app_router.dart';
import 'package:my_halaqoh/src/core/service_locator/service_locator.dart';
import 'package:my_halaqoh/src/core/theme/app_colors.dart';
import 'package:my_halaqoh/src/core/widget/widgets.dart';
import 'package:my_halaqoh/src/modules/guru_hafalan/domain/models/hafalan_santri_model.dart';
import 'package:my_halaqoh/src/modules/guru_hafalan/presentation/cubits/riwayat_hafalan_cubit.dart';
import 'package:my_halaqoh/src/modules/master_data/domain/models/halaqoh_model.dart';
import 'package:my_halaqoh/src/modules/master_data/presentation/cubits/halaqoh_cubit.dart';
import 'package:my_halaqoh/src/modules/master_data/presentation/cubits/halaqoh_state.dart';
import 'package:my_halaqoh/src/core/helpers/active_session_helper.dart';
import 'package:my_halaqoh/src/modules/guru_laporan/presentation/widgets/laporan_konfigurasi_hafalan_sheet.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Helper class: groups multiple HafalanSantriModel records that belong to the
// same submission (same date + type + scores) into one logical unit.
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
  /// Single surah: "Al-Mulk (Ayat 1-30)"
  /// Multiple surahs: "Al-Mulk — An-Nas"
  String get surahDisplay {
    if (records.length == 1) {
      return records.first.surahName;
    }
    // Sort by surahId to show range correctly
    final sorted = List<HafalanSantriModel>.from(records)
      ..sort((a, b) => a.surahId.compareTo(b.surahId));
    return '${sorted.first.surahName} — ${sorted.last.surahName}';
  }

  /// Returns a subtitle with ayat details
  String get ayatDisplay {
    if (records.length == 1) {
      final r = records.first;
      return t.riwayatHafalanSantri.ayatRange(start: r.ayatMulai, end: r.ayatSelesai);
    }
    return t.riwayatHafalanSantri.suratCount(count: records.length);
  }

  /// Returns detailed per-surah lines for expanded view
  List<String> get detailLines {
    final sorted = List<HafalanSantriModel>.from(records)
      ..sort((a, b) => a.surahId.compareTo(b.surahId));
    return sorted
        .map((r) => '${r.surahName} (${r.ayatMulai}-${r.ayatSelesai})')
        .toList();
  }
}

/// Groups a flat list of records into submission groups.
/// Records are considered part of the same submission if they share
/// the same tanggalSetoran, jenis, nilaiKelancaran, and nilaiTajwid.
List<_SubmissionGroup> _groupIntoSubmissions(List<HafalanSantriModel> records) {
  final Map<String, List<HafalanSantriModel>> grouped = {};

  for (final record in records) {
    // Build a composite key from shared submission attributes
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

  // Sort by date descending (newest first)
  groups.sort((a, b) => b.tanggalSetoran.compareTo(a.tanggalSetoran));
  return groups;
}

/// Riwayat Hafalan Santri — individual student memorization history
@RoutePage()
class RiwayatHafalanSantriScreen extends StatefulWidget
    implements AutoRouteWrapper {
  final String santriId;
  final String name;
  final String nis;

  const RiwayatHafalanSantriScreen({
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
  State<RiwayatHafalanSantriScreen> createState() =>
      _RiwayatHafalanSantriScreenState();
}

class _RiwayatHafalanSantriScreenState
    extends State<RiwayatHafalanSantriScreen> {
  late int _currentMonth;
  late int _currentYear;

  List<String> get _dayNames => t.mutabaahSantri.dayNames;

  int? _activeDeleteIndex;
  int? _expandedIndex;

  List<String> get _filterOptions => [
    t.riwayatHafalanSantri.filterSemuaTipe,
    t.riwayatHafalanSantri.filterHafalanBaru,
    t.riwayatHafalanSantri.filterMurajaah,
  ];
  int _selectedFilterIndex = 0;

  String get _filterKey {
    if (_selectedFilterIndex == 1) return 'Ziyadah';
    if (_selectedFilterIndex == 2) return 'Murajaah';
    return 'semua';
  }

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _currentMonth = now.month;
    _currentYear = now.year;
    _loadData();
  }

  void _loadData() {
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

  String _getDayName(DateTime date) {
    return _dayNames[date.weekday % 7];
  }

  /// Filter the loaded data based on filter selection
  List<HafalanSantriModel> _applyFilter(List<HafalanSantriModel> data) {
    if (_filterKey == 'semua') return data;
    return data.where((r) => r.jenis == _filterKey).toList();
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
                    t.riwayatHafalanSantri.title,
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
                    loading: () =>
                        const Center(child: CircularProgressIndicator()),
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
                      final filtered = _applyFilter(allRecords);
                      final groups = _groupIntoSubmissions(filtered);

                      // Count submissions (groups), not individual records
                      final allGroups = _groupIntoSubmissions(allRecords);
                      final totalBaru = allGroups
                          .where((g) => g.jenis == 'Ziyadah')
                          .length;
                      final totalMurajaah = allGroups
                          .where((g) => g.jenis == 'Murajaah')
                          .length;

                      return SingleChildScrollView(
                        padding: EdgeInsets.symmetric(horizontal: 24.w),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Profile card
                            _buildProfileCard(colors),
                            SizedBox(height: 16.h),

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
                            SizedBox(height: 16.h),

                            // Stats cards — IntrinsicHeight memastikan kedua card
                            // sama tingginya meski label berbeda panjang.
                             _buildCombinedStatCard(
                               totalBaru,
                               totalMurajaah,
                               colors,
                             ),
                            SizedBox(height: 16.h),

                            // Filter + Buka Mutaba'ah
                            Row(
                              children: [
                                Flexible(
                                  child: CustomDropdown<String>(
                                    items: _filterOptions,
                                    initialItem: _filterOptions[_selectedFilterIndex],
                                    onChanged: (value) {
                                      if (value != null) {
                                        final idx = _filterOptions.indexOf(value);
                                        setState(() {
                                          _selectedFilterIndex = idx >= 0 ? idx : 0;
                                          _expandedIndex = null;
                                        });
                                      }
                                    },
                                    decoration: CustomDropdownDecoration(
                                      closedFillColor: colors.surface,
                                      closedBorder: Border.all(
                                        color: colors.border,
                                        width: 1,
                                      ),
                                      closedBorderRadius: BorderRadius.circular(
                                        10.r,
                                      ),
                                      expandedFillColor: colors.surface,
                                      expandedBorder: Border.all(
                                        color: colors.border,
                                        width: 1,
                                      ),
                                      expandedBorderRadius:
                                          BorderRadius.circular(10.r),
                                      headerStyle: TextStyle(
                                        fontSize: 13.sp,
                                        fontWeight: FontWeight.w600,
                                        color: colors.textPrimary,
                                        fontFamily: 'Poppins',
                                      ),
                                      listItemStyle: TextStyle(
                                        fontSize: 13.sp,
                                        fontWeight: FontWeight.w500,
                                        color: colors.textPrimary,
                                        fontFamily: 'Poppins',
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(width: 10.w),
                                Expanded(
                                  child: GestureDetector(
                                    onTap: () {
                                      context.router.push(
                                        MutabaahSantriRoute(
                                          santriId: widget.santriId,
                                          name: widget.name,
                                          nis: widget.nis,
                                        ),
                                      );
                                    },
                                    child: Container(
                                      padding: EdgeInsets.symmetric(
                                        vertical: 10.h,
                                      ),
                                      decoration: BoxDecoration(
                                        color: colors.primary,
                                        borderRadius: BorderRadius.circular(
                                          10.r,
                                        ),
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.menu_book,
                                            size: 16.sp,
                                            color: colors.textOnButton,
                                          ),
                                          SizedBox(width: 6.w),
                                          Text(
                                            t.riwayatHafalanSantri.bukaMutabaah,
                                            style: TextStyle(
                                              fontSize: 12.sp,
                                              fontWeight: FontWeight.w700,
                                              color: colors.textOnButton,
                                              fontFamily: 'Poppins',
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 16.h),

                            // Records list (grouped by submission)
                            if (groups.isEmpty)
                              Padding(
                                padding: EdgeInsets.symmetric(vertical: 40.h),
                                child: Center(
                                  child: Text(
                                    t.riwayatHafalanSantri.belumAdaDataBulanIni,
                                    style: TextStyle(
                                      fontSize: 14.sp,
                                      color: colors.textSecondary,
                                      fontFamily: 'Poppins',
                                    ),
                                  ),
                                ),
                              )
                            else
                              ...groups.asMap().entries.map(
                                (e) => _buildGroupCard(e.value, e.key, colors),
                              ),
                            SizedBox(height: 16.h),

                            // Lihat Progress button
                            CustomOutlinedButton(
                              width: double.infinity,
                              height: 48.h,
                              onPressed: () {
                                context.router.push(
                                  ProgressHafalanPerJuzRoute(
                                    santriId: widget.santriId,
                                    name: widget.name,
                                    nis: widget.nis,
                                  ),
                                );
                              },
                              icon: Icons.menu_book,
                              label: t.riwayatHafalanSantri.lihatProgress,
                            ),
                            SizedBox(height: 10.h),

                            // Download Laporan button
                            CustomOutlinedButton(
                              width: double.infinity,
                              height: 48.h,
                              onPressed: () {
                                HalaqohModel? myHalaqoh;
                                final linkedDocId = ActiveSessionHelper.getActiveLinkedDocId(context) ?? '';
                                context.read<HalaqohCubit>().state.maybeWhen(
                                  loaded: (list) {
                                    try { myHalaqoh = list.firstWhere((h) => h.guruId == linkedDocId); } catch (_) {}
                                  },
                                  orElse: () {},
                                );
                                LaporanKonfigurasiHafalanSheet.show(
                                  context,
                                  santriId:     widget.santriId,
                                  santriName:   widget.name,
                                  santriNis:    widget.nis,
                                  halaqoh:      myHalaqoh,
                                  initialMonth: _currentMonth,
                                  initialYear:  _currentYear,
                                );
                              },
                              icon: Icons.download,
                              label: t.riwayatHafalanSantri.downloadLaporan,
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

  // ── Profile Card ──
  Widget _buildProfileCard(AppColorSet colors) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(18.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [colors.primary, colors.primary.withValues(alpha: 0.8)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Row(
        children: [
          Container(
            width: 50.w,
            height: 50.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withValues(alpha: 0.2),
            ),
            child: Icon(Icons.person, size: 26.sp, color: Colors.white),
          ),
          SizedBox(width: 14.w),
          // FIX: Expanded prevents overflow when name is long
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.name,
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                    fontFamily: 'Poppins',
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  t.riwayatHafalanSantri.nisLabel(nis: widget.nis),
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: Colors.white.withValues(alpha: 0.85),
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

  Widget _buildCombinedStatCard(
    int totalBaru,
    int totalMurajaah,
    AppColorSet colors,
  ) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 16.w),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: colors.border.withValues(alpha: 0.5),
          width: 1,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header Chip
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: 16.w,
              vertical: 6.h,
            ),
            decoration: BoxDecoration(
              color: colors.primary.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(20.r),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.analytics_outlined,
                  size: 16.sp,
                  color: colors.primary,
                ),
                SizedBox(width: 6.w),
                Text(
                  t.riwayatHafalanSantri.totalTatapMuka,
                  style: TextStyle(
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w700,
                    color: colors.primary,
                    fontFamily: 'Poppins',
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 20.h),
          // Stats Row
          Row(
            children: [
              // Hafalan Baru
              Expanded(
                child: Column(
                  children: [
                    Text(
                      '$totalBaru',
                      style: TextStyle(
                        fontSize: 28.sp,
                        fontWeight: FontWeight.w800,
                        color: colors.primary,
                        fontFamily: 'Poppins',
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      t.riwayatHafalanSantri.hafalanBaru,
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w500,
                        color: colors.textSecondary,
                        fontFamily: 'Poppins',
                      ),
                    ),
                  ],
                ),
              ),
              // Divider
              Container(
                height: 36.h,
                width: 1,
                color: colors.border.withValues(alpha: 0.5),
              ),
              // Muraja'ah
              Expanded(
                child: Column(
                  children: [
                    Text(
                      '$totalMurajaah',
                      style: TextStyle(
                        fontSize: 28.sp,
                        fontWeight: FontWeight.w800,
                        color: const Color(0xFFF3722C), // Orange
                        fontFamily: 'Poppins',
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      t.riwayatHafalanSantri.murajaah,
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w500,
                        color: colors.textSecondary,
                        fontFamily: 'Poppins',
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildGroupCard(
    _SubmissionGroup group,
    int index,
    AppColorSet colors,
  ) {
    final dayStr = group.tanggalSetoran.day.toString().padLeft(2, '0');
    final dayName = _getDayName(group.tanggalSetoran);
    final isZiyadah = group.jenis == 'Ziyadah';
    final isShowingDelete = _activeDeleteIndex == index;
    final isExpanded = _expandedIndex == index;
    final hasMultiple = group.records.length > 1;

    return GestureDetector(
      onTap: hasMultiple
          ? () {
              setState(() {
                _expandedIndex = isExpanded ? null : index;
              });
            }
          : null,
      onLongPress: () {
        setState(() {
          _activeDeleteIndex = isShowingDelete ? null : index;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: EdgeInsets.only(bottom: 10.h),
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
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
          children: [
            Row(
              children: [
                // Day info
                Column(
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
                    Text(
                      dayStr,
                      style: TextStyle(
                        fontSize: 22.sp,
                        fontWeight: FontWeight.w800,
                        color: colors.textPrimary,
                        fontFamily: 'Poppins',
                      ),
                    ),
                  ],
                ),
                SizedBox(width: 16.w),

                // Surah info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            isZiyadah
                                ? t.riwayatHafalanSantri.hafalanBaru
                                : t.riwayatHafalanSantri.murajaah,
                            style: TextStyle(
                              fontSize: 10.sp,
                              fontWeight: FontWeight.w500,
                              color: colors.textSecondary,
                              fontFamily: 'Poppins',
                            ),
                          ),
                          if (hasMultiple) ...[
                            SizedBox(width: 6.w),
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 6.w,
                                vertical: 1.h,
                              ),
                              decoration: BoxDecoration(
                                color: colors.primary.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(4.r),
                              ),
                              child: Text(
                                '${group.records.length} surat',
                                style: TextStyle(
                                  fontSize: 9.sp,
                                  fontWeight: FontWeight.w600,
                                  color: colors.primary,
                                  fontFamily: 'Poppins',
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                      Text(
                        group.surahDisplay,
                        style: TextStyle(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w700,
                          color: colors.textPrimary,
                          fontFamily: 'Poppins',
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        group.ayatDisplay,
                        style: TextStyle(
                          fontSize: 11.sp,
                          color: colors.textSecondary,
                          fontFamily: 'Poppins',
                        ),
                      ),
                    ],
                  ),
                ),

                // Score, expand icon & delete
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '${group.avgScore}',
                      style: TextStyle(
                        fontSize: 22.sp,
                        fontWeight: FontWeight.w800,
                        color: colors.textPrimary,
                        fontFamily: 'Poppins',
                      ),
                    ),
                    if (hasMultiple) ...[
                      SizedBox(width: 4.w),
                      AnimatedRotation(
                        turns: isExpanded ? 0.5 : 0,
                        duration: const Duration(milliseconds: 200),
                        child: Icon(
                          Icons.expand_more,
                          size: 20.sp,
                          color: colors.textSecondary,
                        ),
                      ),
                    ],
                    if (isShowingDelete) ...[
                      SizedBox(width: 12.w),
                      GestureDetector(
                        onTap: () async {
                          final confirmed = await ConfirmDeleteDialog.show(context);
                          if (confirmed && mounted) {
                            setState(() {
                              _activeDeleteIndex = null;
                            });
                            
                            final messenger = ScaffoldMessenger.of(context);
                            final appColors = AppColors.of(context);
                            final cubit = context.read<RiwayatHafalanCubit>();

                            final success = await cubit.deleteSubmissionGroup(group.records);

                            if (mounted) {
                              messenger.showSnackBar(
                                SnackBar(
                                  content: Text(
                                    success
                                        ? t.riwayatHafalanSantri.deleteSuccess
                                        : t.riwayatHafalanSantri.deleteFailed,
                                    style: const TextStyle(fontFamily: 'Poppins'),
                                  ),
                                  backgroundColor: success
                                      ? appColors.primary
                                      : appColors.error,
                                ),
                              );
                            }
                          }
                        },
                        child: Container(
                          padding: EdgeInsets.all(8.w),
                          decoration: BoxDecoration(
                            color: colors.red.withValues(alpha: 0.1),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.delete_outline,
                            size: 20.sp,
                            color: colors.red,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),

            // ── Expanded detail: show each surah in the group ──
            if (isExpanded && hasMultiple) ...[
              SizedBox(height: 8.h),
              Divider(
                color: colors.border.withValues(alpha: 0.5),
                height: 1,
              ),
              SizedBox(height: 8.h),
              ...group.detailLines.map(
                (line) => Padding(
                  padding: EdgeInsets.only(left: 38.w, bottom: 4.h),
                  child: Row(
                    children: [
                      Container(
                        width: 5.w,
                        height: 5.w,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: colors.primary.withValues(alpha: 0.6),
                        ),
                      ),
                      SizedBox(width: 8.w),
                      Expanded(
                        child: Text(
                          line,
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
              ),
            ],
          ],
        ),
      ),
    );
  }
}
