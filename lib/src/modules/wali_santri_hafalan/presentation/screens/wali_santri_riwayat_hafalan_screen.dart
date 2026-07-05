import 'package:animated_custom_dropdown/custom_dropdown.dart';
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
            body: SafeArea(
              child: Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      padding: EdgeInsets.symmetric(horizontal: 24.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Green gradient profile card
                          Container(
                            width: double.infinity,
                            padding: EdgeInsets.all(18.w),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  colors.primary,
                                  colors.primary.withValues(alpha: 0.8),
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
                                  width: 50.w,
                                  height: 50.w,
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        displayName,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          fontSize: 18.sp,
                                          fontWeight: FontWeight.w700,
                                          color: Colors.white,
                                          fontFamily: 'Poppins',
                                        ),
                                      ),
                                      SizedBox(height: 2.h),
                                      Text(
                                        t.riwayatHafalanSantri.nisLabel(nis: displayNis),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          fontSize: 12.sp,
                                          fontWeight: FontWeight.w400,
                                          color: Colors.white.withValues(
                                            alpha: 0.85,
                                          ),
                                          fontFamily: 'Poppins',
                                        ),
                                      ),
                                      Text(
                                        myHalaqoh != null
                                            ? t.riwayatHafalanSantri
                                                  .halaqohKelas(
                                                    halaqoh: myHalaqoh!.nama,
                                                    kelas: myHalaqoh!.kelas,
                                                  )
                                            : t.waliSantriDashboard.notRegisteredHalaqoh,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          fontSize: 12.sp,
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
                          SizedBox(height: 16.h),

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
                                        _selectedFilterIndex = idx;
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
                                    expandedBorderRadius: BorderRadius.circular(
                                      10.r,
                                    ),
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

                              // Buka Mutaba'ah button
                              Expanded(
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (_) =>
                                            WaliSantriMutabaahScreen(
                                              name: widget.name,
                                              nis: widget.nis,
                                            ),
                                      ),
                                    );
                                  },
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                      vertical: 10.h,
                                    ),
                                    decoration: BoxDecoration(
                                      color: colors.primary,
                                      borderRadius: BorderRadius.circular(10.r),
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
                          SizedBox(height: 16.h),

                          // Lihat Progress button
                          SizedBox(
                            width: double.infinity,
                            height: 48.h,
                            child: CustomOutlinedButton(
                              width: double.infinity,
                              height: 48.h,
                              onPressed: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (_) =>
                                        WaliSantriProgressPerJuzScreen(
                                          name: widget.name,
                                          nis: widget.nis,
                                        ),
                                  ),
                                );
                              },
                              icon: Icons.menu_book,
                              label: t.riwayatHafalanSantri.lihatProgress,
                            ),
                          ),
                          SizedBox(height: 10.h),
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

  // Merender card yang sudah tergabung berdasarkan _SubmissionGroup
  Widget _buildGroupCard(
    _SubmissionGroup group,
    int index,
    AppColorSet colors,
  ) {
    final dayStr = group.tanggalSetoran.day.toString().padLeft(2, '0');
    final dayName = _getDayName(group.tanggalSetoran);
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
                            isBaru
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
                                t.riwayatHafalanSantri.suratCount(count: group.records.length),
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
                          fontWeight: FontWeight.w400,
                          color: colors.textSecondary,
                          fontFamily: 'Poppins',
                        ),
                      ),
                    ],
                  ),
                ),

                // Avg score & expand icon (sama dengan guru screen)
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
                  ],
                ),
              ],
            ),

            // ── Expanded detail ──
            if (isExpanded && hasMultiple) ...[
              SizedBox(height: 8.h),
              Divider(color: colors.border.withValues(alpha: 0.5), height: 1),
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
