import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_halaqoh/gen/i18n/translations.g.dart';
import 'package:my_halaqoh/src/core/theme/app_colors.dart';
import 'package:my_halaqoh/src/core/widget/widgets.dart';
import 'package:my_halaqoh/src/modules/wali_santri_hafalan/presentation/screens/wali_santri_mutabaah_screen.dart';
import 'package:my_halaqoh/src/modules/wali_santri_hafalan/presentation/screens/wali_santri_progress_per_juz_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_halaqoh/src/core/service_locator/service_locator.dart';
import 'package:my_halaqoh/src/core/helpers/active_session_helper.dart';
import 'package:my_halaqoh/src/modules/master_data/presentation/cubits/halaqoh_cubit.dart';
import 'package:my_halaqoh/src/modules/master_data/presentation/cubits/halaqoh_state.dart';
import 'package:my_halaqoh/src/modules/master_data/presentation/cubits/santri_cubit.dart';
import 'package:my_halaqoh/src/modules/master_data/presentation/cubits/santri_state.dart';
import 'package:my_halaqoh/src/modules/master_data/domain/models/santri_model.dart';
import 'package:my_halaqoh/src/modules/master_data/domain/models/halaqoh_model.dart';
import 'package:my_halaqoh/src/modules/wali_santri_hafalan/domain/models/wali_santri_hafalan_model.dart';
import 'package:my_halaqoh/src/modules/wali_santri_hafalan/presentation/cubits/wali_santri_riwayat_hafalan_cubit.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Helper class: Menggabungkan beberapa record hafalan ke dalam satu group
// berdasarkan tanggal, jenis, dan nilai.
// ─────────────────────────────────────────────────────────────────────────────
class _SubmissionGroup {
  final DateTime tanggalSetoran;
  final String jenis;
  final int nilaiKelancaran;
  final int nilaiTajwid;
  final List<WaliSantriHafalanModel> records;

  _SubmissionGroup({
    required this.tanggalSetoran,
    required this.jenis,
    required this.nilaiKelancaran,
    required this.nilaiTajwid,
    required this.records,
  });

  /// Rata-rata nilai kelancaran dan tajwid, sama persis dengan guru screen.
  int get avgScore => ((nilaiKelancaran + nilaiTajwid) / 2).round();

  /// Range surah — sort by surahId sebelum ambil first/last.
  String get surahDisplay {
    if (records.length == 1) {
      return records.first.surahName;
    }
    final sorted = List<WaliSantriHafalanModel>.from(records)
      ..sort((a, b) => a.surahId.compareTo(b.surahId));
    return '${sorted.first.surahName} — ${sorted.last.surahName}';
  }

  String get ayatDisplay {
    if (records.length == 1) {
      final r = records.first;
      return t.riwayatHafalanSantri.ayatRange(start: '${r.ayatMulai}', end: '${r.ayatSelesai}');
    }
    return t.riwayatHafalanSantri.suratCount(count: records.length);
  }

  /// Detail per-surah — sorted by surahId.
  List<String> get detailLines {
    final sorted = List<WaliSantriHafalanModel>.from(records)
      ..sort((a, b) => a.surahId.compareTo(b.surahId));
    return sorted
        .map((r) => '${r.surahName} (${r.ayatMulai}-${r.ayatSelesai})')
        .toList();
  }
}

/// Groups a flat list of records into submission groups.
/// Records belong to the same submission when they share
/// tanggalSetoran, jenis, nilaiKelancaran, AND nilaiTajwid —
/// identik dengan logika di guru riwayat_hafalan_santri_screen.
List<_SubmissionGroup> _groupIntoSubmissions(
  List<WaliSantriHafalanModel> records,
) {
  final Map<String, List<WaliSantriHafalanModel>> grouped = {};

  for (final record in records) {
    // Kunci mencakup nilaiTajwid agar sesi dengan kelancaran sama
    // tapi tajwid berbeda tidak tergabung secara keliru.
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

  // Sort terbaru di atas (sama dengan guru screen)
  groups.sort((a, b) => b.tanggalSetoran.compareTo(a.tanggalSetoran));
  return groups;
}

@RoutePage()
class WaliSantriRiwayatHafalanScreen extends StatefulWidget {
  final String name;
  final String nis;

  const WaliSantriRiwayatHafalanScreen({
    super.key,
    required this.name,
    required this.nis,
  });

  @override
  State<WaliSantriRiwayatHafalanScreen> createState() =>
      _WaliSantriRiwayatHafalanScreenState();
}

class _WaliSantriRiwayatHafalanScreenState
    extends State<WaliSantriRiwayatHafalanScreen> {
  late final WaliSantriRiwayatHafalanCubit _riwayatCubit;

  int _currentMonth = DateTime.now().month;
  int _currentYear = DateTime.now().year;

  // State untuk melacak card mana yang sedang di-expand
  int? _expandedIndex;

  List<String> get _dayNames => t.mutabaahSantri.dayNames;

  List<String> get _filterOptions => [
        t.riwayatHafalanSantri.filterSemuaTipe,
        t.riwayatHafalanSantri.filterHafalanBaru,
        t.riwayatHafalanSantri.filterMurajaah,
      ];
  int _selectedFilterIndex = 0;
  bool _isStatsExpanded = false;

  String get _filterKey {
    if (_selectedFilterIndex == 1) return 'Ziyadah';
    if (_selectedFilterIndex == 2) return 'Murajaah';
    return 'semua';
  }

  String _getDayName(DateTime date) {
    return _dayNames[date.weekday % 7];
  }

  void _prevMonth() {
    setState(() {
      _currentMonth--;
      if (_currentMonth < 1) {
        _currentMonth = 12;
        _currentYear--;
      }
      _expandedIndex = null; // Tutup expand jika ganti bulan
    });
    _fetchData();
  }

  void _nextMonth() {
    setState(() {
      _currentMonth++;
      if (_currentMonth > 12) {
        _currentMonth = 1;
        _currentYear++;
      }
      _expandedIndex = null; // Tutup expand jika ganti bulan
    });
    _fetchData();
  }

  @override
  void initState() {
    super.initState();
    _riwayatCubit = sl<WaliSantriRiwayatHafalanCubit>();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchData();
    });
  }

  @override
  void dispose() {
    _riwayatCubit.close();
    super.dispose();
  }

  void _fetchData() {
    final linkedDocId = ActiveSessionHelper.getActiveLinkedDocId(context) ?? '';
    if (linkedDocId.isNotEmpty) {
      _riwayatCubit.watchRiwayat(linkedDocId, _currentMonth, _currentYear);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _riwayatCubit,
      child: Builder(
        builder: (context) {
          final colors = AppColors.of(context);

          final halaqohState = context.watch<HalaqohCubit>().state;
          final santriState = context.watch<SantriCubit>().state;
          final riwayatState = context
              .watch<WaliSantriRiwayatHafalanCubit>()
              .state;

          final linkedDocId = ActiveSessionHelper.getActiveLinkedDocId(context) ?? '';

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
                myHalaqoh = list.firstWhere(
                  (h) => h.santriIds.contains(linkedDocId),
                );
              } catch (_) {}
            },
            orElse: () {},
          );

          List<WaliSantriHafalanModel> allRecords = [];
          riwayatState.maybeWhen(
            loaded: (records) {
              allRecords = records;
            },
            orElse: () {},
          );

          List<WaliSantriHafalanModel> filteredRecords = [];
          if (_filterKey == 'semua') {
            filteredRecords = allRecords;
          } else {
            filteredRecords = allRecords
                .where((r) => r.jenis == _filterKey)
                .toList();
          }

          // Gunakan logika grouping di sini
          final groups = _groupIntoSubmissions(filteredRecords);
          final allGroups = _groupIntoSubmissions(allRecords);

          final totalBaru = allGroups.where((g) => g.jenis == 'Ziyadah').length;
          final totalMurajaah = allGroups
              .where((g) => g.jenis == 'Murajaah')
              .length;

          return Scaffold(
            backgroundColor: colors.background,
            floatingActionButtonLocation: ExpandableFabMenu.location,
            floatingActionButton: ExpandableFabMenu(
              margin: EdgeInsets.only(bottom: 92.h, right: 8.w),
              items: [
                ExpandableFabItem(
                  icon: Icons.analytics_outlined,
                  label: 'Lihat Progress',
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => WaliSantriProgressPerJuzScreen(
                          name: widget.name,
                          nis: widget.nis,
                        ),
                      ),
                    );
                  },
                ),
                ExpandableFabItem(
                  icon: Icons.menu_book_outlined,
                  label: 'Buka Mutaba\'ah',
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => WaliSantriMutabaahScreen(
                          name: widget.name,
                          nis: widget.nis,
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
            body: SafeArea(
              child: Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      padding: EdgeInsets.symmetric(horizontal: 20.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 16.h),

                          // Santri Profile Context Header
                          SantriContextHeader(
                            name: displayName,
                            nis: displayNis,
                            subtitle: myHalaqoh != null
                                ? t.riwayatHafalanSantri.halaqohKelas(
                                    halaqoh: myHalaqoh!.nama,
                                    kelas: myHalaqoh!.kelas,
                                  )
                                : t.waliSantriDashboard.notRegisteredHalaqoh,
                            profilePictureUrl: mySantri?.profilePicture,
                          ),
                          SizedBox(height: 22.h),

                          // Month navigator
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
                              SizedBox(width: 8.w),
                              AppCalendarPickerButton(
                                currentMonth: _currentMonth,
                                currentYear: _currentYear,
                                onSelected: (month, year) {
                                  setState(() {
                                    _currentMonth = month;
                                    _currentYear = year;
                                    _expandedIndex = null;
                                  });
                                  _fetchData();
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
                          SizedBox(height: 20.h),

                          // ── Section Header: Setoran Terbaru ──
                          Row(
                            children: [
                              Container(
                                width: 3.5.w,
                                height: 16.h,
                                decoration: BoxDecoration(
                                  color: colors.primary,
                                  borderRadius: BorderRadius.circular(2.r),
                                ),
                              ),
                              SizedBox(width: 8.w),
                              Text(
                                'Setoran Terbaru',
                                style: TextStyle(
                                  fontSize: 15.sp,
                                  fontWeight: FontWeight.w700,
                                  color: colors.textPrimary,
                                  fontFamily: 'Poppins',
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 12.h),

                          // ── Filter Segmented Chips ──
                          Row(
                            children: [
                              _buildFilterChip(
                                0,
                                _filterOptions[0],
                                colors,
                              ),
                              SizedBox(width: 8.w),
                              _buildFilterChip(
                                1,
                                _filterOptions[1],
                                colors,
                              ),
                              SizedBox(width: 8.w),
                              _buildFilterChip(
                                2,
                                _filterOptions[2],
                                colors,
                              ),
                            ],
                          ),
                          SizedBox(height: 14.h),

                          // Records list
                          if (riwayatState.maybeWhen(
                            loading: () => true,
                            orElse: () => false,
                          ))
                            const Center(child: CircularProgressIndicator())
                          else if (groups.isEmpty)
                            Center(
                              child: Padding(
                                padding: EdgeInsets.symmetric(vertical: 20.h),
                                child: Text(
                                  t.riwayatHafalanSantri.tidakAdaHafalanFilter,
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    fontFamily: 'Poppins',
                                    color: colors.textSecondary,
                                  ),
                                ),
                              ),
                            )
                          else
                            ...groups.asMap().entries.map(
                              (e) => _buildGroupCard(e.value, e.key, colors),
                            ),
                          SizedBox(height: 160.h),
                        ],
                      ),
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

  Widget _buildFilterChip(int index, String label, AppColorSet colors) {
    final isSelected = _selectedFilterIndex == index;
    return Expanded(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            setState(() {
              _selectedFilterIndex = index;
              _expandedIndex = null;
            });
          },
          borderRadius: BorderRadius.circular(8.r),
          child: Container(
            height: 34.h,
            decoration: BoxDecoration(
              color: isSelected
                  ? colors.primary.withValues(alpha: 0.1)
                  : colors.surface,
              borderRadius: BorderRadius.circular(8.r),
              border: Border.all(
                color: isSelected
                    ? colors.primary
                    : colors.border.withValues(alpha: 0.7),
                width: isSelected ? 1.2 : 0.8,
              ),
            ),
            child: Center(
              child: Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 11.5.sp,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                  color: isSelected ? colors.primary : colors.textSecondary,
                  fontFamily: 'Poppins',
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCombinedStatCard(
    int totalBaru,
    int totalMurajaah,
    AppColorSet colors,
  ) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _isStatsExpanded = !_isStatsExpanded;
        });
      },
      child: AnimatedSize(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        child: Container(
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
              if (!_isStatsExpanded) ...[
                // Collapsed View (Single Total)
                Text(
                  '${totalBaru + totalMurajaah}',
                  style: TextStyle(
                    fontSize: 28.sp,
                    fontWeight: FontWeight.w800,
                    color: colors.primary,
                    fontFamily: 'Poppins',
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  t.riwayatHafalanSantri.tatapMukaLabel,
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w500,
                    color: colors.textSecondary,
                    fontFamily: 'Poppins',
                  ),
                ),
                SizedBox(height: 12.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      t.riwayatHafalanSantri.tapForDetails,
                      style: TextStyle(
                        fontSize: 10.sp,
                        fontWeight: FontWeight.w500,
                        color: colors.textSecondary.withValues(alpha: 0.7),
                        fontFamily: 'Poppins',
                      ),
                    ),
                    SizedBox(width: 2.w),
                    Icon(
                      Icons.keyboard_arrow_down_rounded,
                      size: 14.sp,
                      color: colors.textSecondary.withValues(alpha: 0.7),
                    ),
                  ],
                ),
              ] else ...[
                // Expanded View (Breakdown)
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
                SizedBox(height: 16.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      t.riwayatHafalanSantri.tapToClose,
                      style: TextStyle(
                        fontSize: 10.sp,
                        fontWeight: FontWeight.w500,
                        color: colors.textSecondary.withValues(alpha: 0.7),
                        fontFamily: 'Poppins',
                      ),
                    ),
                    SizedBox(width: 2.w),
                    Icon(
                      Icons.keyboard_arrow_up_rounded,
                      size: 14.sp,
                      color: colors.textSecondary.withValues(alpha: 0.7),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  // Merender card yang sudah tergabung berdasarkan _SubmissionGroup
  // Merender card yang sudah tergabung berdasarkan _SubmissionGroup
  Widget _buildGroupCard(
    _SubmissionGroup group,
    int index,
    AppColorSet colors,
  ) {
    const monthAbbr = [
      'Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun',
      'Jul', 'Agu', 'Sep', 'Okt', 'Nov', 'Des',
    ];
    final textTheme = Theme.of(context).textTheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final dayName = _getDayName(group.tanggalSetoran);
    final formattedDate = '$dayName, ${group.tanggalSetoran.day} ${monthAbbr[group.tanggalSetoran.month - 1]}';
    final isBaru = group.jenis == 'Ziyadah';
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
      child: AnimatedSize(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        child: Container(
          margin: EdgeInsets.only(bottom: 8.h),
          padding: EdgeInsets.symmetric(
            horizontal: 16.w,
            vertical: 14.h,
          ),
          decoration: BoxDecoration(
            color: colors.surface,
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(
              color: isDark
                  ? colors.border
                  : colors.border.withValues(alpha: 0.6),
              width: 0.8,
            ),
            boxShadow: isDark
                ? []
                : [
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
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Surah info & tags
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Row 1: Type label (Hafalan Baru / Muraja'ah) + Multiple surah chip + Date
                        Row(
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 6.w,
                                vertical: 2.h,
                              ),
                              decoration: BoxDecoration(
                                color: colors.primary.withValues(alpha: 0.08),
                                borderRadius: BorderRadius.circular(4.r),
                              ),
                              child: Text(
                                isBaru
                                    ? t.riwayatHafalanSantri.hafalanBaru
                                    : t.riwayatHafalanSantri.murajaah,
                                style: textTheme.labelSmall?.copyWith(
                                      fontSize: 9.5.sp,
                                      fontWeight: FontWeight.w600,
                                      color: colors.primary,
                                    ) ??
                                    TextStyle(
                                      fontSize: 9.5.sp,
                                      fontWeight: FontWeight.w600,
                                      color: colors.primary,
                                      fontFamily: 'Poppins',
                                    ),
                              ),
                            ),
                            if (hasMultiple) ...[
                              SizedBox(width: 6.w),
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 6.w,
                                  vertical: 2.h,
                                ),
                                decoration: BoxDecoration(
                                  color: colors.primary.withValues(alpha: 0.08),
                                  borderRadius: BorderRadius.circular(4.r),
                                ),
                                child: Text(
                                  t.riwayatHafalanSantri.suratCount(count: group.records.length),
                                  style: textTheme.labelSmall?.copyWith(
                                        fontSize: 9.5.sp,
                                        fontWeight: FontWeight.w600,
                                        color: colors.primary,
                                      ) ??
                                      TextStyle(
                                        fontSize: 9.5.sp,
                                        fontWeight: FontWeight.w600,
                                        color: colors.primary,
                                        fontFamily: 'Poppins',
                                      ),
                                ),
                              ),
                            ],
                            SizedBox(width: 8.w),
                            Text(
                              formattedDate,
                              style: textTheme.labelSmall?.copyWith(
                                    fontSize: 10.5.sp,
                                    fontWeight: FontWeight.w500,
                                    color: colors.textSecondary,
                                  ) ??
                                  TextStyle(
                                    fontSize: 10.5.sp,
                                    fontWeight: FontWeight.w500,
                                    color: colors.textSecondary,
                                    fontFamily: 'Poppins',
                                  ),
                            ),
                          ],
                        ),
                        SizedBox(height: 4.h),

                        // Row 2: Surah Name (Prominent bold text)
                        Text(
                          group.surahDisplay,
                          style: textTheme.titleMedium?.copyWith(
                                fontSize: 15.sp,
                                fontWeight: FontWeight.w700,
                                color: colors.textPrimary,
                                height: 1.25,
                              ) ??
                              TextStyle(
                                fontSize: 15.sp,
                                fontWeight: FontWeight.w700,
                                color: colors.textPrimary,
                                fontFamily: 'Poppins',
                                height: 1.25,
                              ),
                          softWrap: true,
                        ),
                        SizedBox(height: 3.h),

                        // Row 3: Ayat details
                        Text(
                          group.ayatDisplay,
                          style: textTheme.bodySmall?.copyWith(
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w400,
                                color: colors.textSecondary,
                              ) ??
                              TextStyle(
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w400,
                                color: colors.textSecondary,
                                fontFamily: 'Poppins',
                              ),
                          softWrap: true,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 12.w),

                  // Numeric Score Pill
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 10.w,
                      vertical: 4.h,
                    ),
                    decoration: BoxDecoration(
                      color: colors.surface,
                      borderRadius: BorderRadius.circular(8.r),
                      border: Border.all(
                        color: colors.border,
                        width: 1,
                      ),
                    ),
                    child: Text(
                      '${group.avgScore}',
                      style: textTheme.titleSmall?.copyWith(
                            fontSize: 13.5.sp,
                            fontWeight: FontWeight.w700,
                            color: colors.textPrimary,
                          ) ??
                          TextStyle(
                            fontSize: 13.5.sp,
                            fontWeight: FontWeight.w700,
                            color: colors.textPrimary,
                            fontFamily: 'Poppins',
                          ),
                    ),
                  ),

                  // Expand icon if has multiple surahs
                  if (hasMultiple) ...[
                    SizedBox(width: 4.w),
                    AnimatedRotation(
                      turns: isExpanded ? 0.5 : 0,
                      duration: const Duration(milliseconds: 200),
                      child: Icon(
                        Icons.keyboard_arrow_down_rounded,
                        size: 20.sp,
                        color: colors.textSecondary,
                      ),
                    ),
                  ],
                ],
              ),

              // ── Expanded detail: show each surah in the group ──
              if (isExpanded && hasMultiple) ...[
                SizedBox(height: 10.h),
                Divider(
                  color: colors.border.withValues(alpha: 0.6),
                  height: 1,
                ),
                SizedBox(height: 8.h),
                ...group.detailLines.map(
                  (line) => Padding(
                    padding: EdgeInsets.symmetric(vertical: 2.5.h, horizontal: 2.w),
                    child: Row(
                      children: [
                        Container(
                          width: 4.5.w,
                          height: 4.5.w,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: colors.primary.withValues(alpha: 0.7),
                          ),
                        ),
                        SizedBox(width: 8.w),
                        Expanded(
                          child: Text(
                            line,
                            style: textTheme.bodySmall?.copyWith(
                                  fontSize: 11.5.sp,
                                  color: colors.textSecondary,
                                ) ??
                                TextStyle(
                                  fontSize: 11.5.sp,
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
      ),
    );
  }
}
