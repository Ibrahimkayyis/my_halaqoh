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
import 'package:my_halaqoh/src/modules/auth/presentation/cubits/auth_cubit.dart';
import 'package:my_halaqoh/src/modules/auth/presentation/cubits/auth_state.dart';
import 'package:my_halaqoh/src/modules/master_data/presentation/cubits/halaqoh_cubit.dart';
import 'package:my_halaqoh/src/modules/master_data/presentation/cubits/halaqoh_state.dart';
import 'package:my_halaqoh/src/modules/master_data/presentation/cubits/santri_cubit.dart';
import 'package:my_halaqoh/src/modules/master_data/presentation/cubits/santri_state.dart';
import 'package:my_halaqoh/src/modules/master_data/domain/models/santri_model.dart';
import 'package:my_halaqoh/src/modules/master_data/domain/models/halaqoh_model.dart';
import 'package:my_halaqoh/src/modules/wali_santri_hafalan/domain/models/wali_santri_hafalan_model.dart';
import 'package:my_halaqoh/src/modules/wali_santri_hafalan/presentation/cubits/wali_santri_riwayat_hafalan_cubit.dart';

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

  final List<String> _dayNames = [
    'SEN',
    'SEL',
    'RAB',
    'KAM',
    'JUM',
    'SAB',
    'AHA',
  ];

  final List<String> _filterOptions = [
    'Semua Tipe',
    'Hafalan Baru',
    "Muraja'ah",
  ];
  String _selectedFilterLabel = 'Semua Tipe';

  String get _filterKey {
    if (_selectedFilterLabel == 'Hafalan Baru') return 'Ziyadah';
    if (_selectedFilterLabel == "Muraja'ah") return 'Murajaah';
    return 'semua';
  }

  String _getDayName(int day) {
    final date = DateTime(_currentYear, _currentMonth, day);
    return _dayNames[date.weekday - 1];
  }

  void _prevMonth() {
    setState(() {
      _currentMonth--;
      if (_currentMonth < 1) {
        _currentMonth = 12;
        _currentYear--;
      }
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
    final authState = context.read<AuthCubit>().state;
    String linkedDocId = '';
    authState.maybeWhen(
      authenticated: (userMeta) {
        linkedDocId = userMeta.linkedDocId;
      },
      orElse: () {},
    );
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

          final authState = context.watch<AuthCubit>().state;
          final halaqohState = context.watch<HalaqohCubit>().state;
          final santriState = context.watch<SantriCubit>().state;
          final riwayatState = context
              .watch<WaliSantriRiwayatHafalanCubit>()
              .state;

          String linkedDocId = '';
          authState.maybeWhen(
            authenticated: (userMeta) {
              linkedDocId = userMeta.linkedDocId;
            },
            orElse: () {},
          );

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

          final totalBaru = allRecords
              .where((r) => r.jenis == 'Ziyadah')
              .length;
          final totalMurajaah = allRecords
              .where((r) => r.jenis == 'Murajaah')
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
                                  ),
                                  child: Icon(
                                    Icons.person,
                                    size: 26.sp,
                                    color: Colors.white,
                                  ),
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
                                        'NIS: $displayNis',
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
                                            : 'Belum Terdaftar Halaqoh',
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
                                  });
                                  _fetchData();
                                },
                              ),
                            ],
                          ),
                          SizedBox(height: 16.h),

                          // Stats cards
                          Row(
                            children: [
                              Expanded(
                                child: _buildStatCard(
                                  '$totalBaru',
                                  t.riwayatHafalanSantri.totalHafalanBaru,
                                  colors,
                                ),
                              ),
                              SizedBox(width: 12.w),
                              Expanded(
                                child: _buildStatCard(
                                  '$totalMurajaah',
                                  t.riwayatHafalanSantri.totalMurajaah,
                                  colors,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 16.h),

                          // Filter + Buka Mutaba'ah
                          Row(
                            children: [
                              SizedBox(
                                width: 150.w,
                                child: CustomDropdown<String>(
                                  items: _filterOptions,
                                  initialItem: _selectedFilterLabel,
                                  onChanged: (value) {
                                    if (value != null) {
                                      setState(
                                        () => _selectedFilterLabel = value,
                                      );
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
                          else if (filteredRecords.isEmpty)
                            Center(
                              child: Padding(
                                padding: EdgeInsets.symmetric(vertical: 20.h),
                                child: Text(
                                  'Tidak ada hafalan untuk filter ini',
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    fontFamily: 'Poppins',
                                    color: colors.textSecondary,
                                  ),
                                ),
                              ),
                            )
                          else
                            ...filteredRecords.map(
                              (record) => _buildRecordCard(record, colors),
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

  Widget _buildStatCard(String value, String label, AppColorSet colors) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 12.w),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: colors.border, width: 1),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(
              fontSize: 28.sp,
              fontWeight: FontWeight.w800,
              color: colors.primary,
              fontFamily: 'Poppins',
            ),
          ),
          SizedBox(height: 2.h),
          Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.w500,
              color: colors.textSecondary,
              fontFamily: 'Poppins',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecordCard(WaliSantriHafalanModel record, AppColorSet colors) {
    final dayStr = record.tanggalSetoran.day.toString().padLeft(2, '0');
    final dayName = _getDayName(record.tanggalSetoran.day);
    final isBaru = record.jenis == 'Ziyadah';

    return Container(
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
      child: Row(
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
                Text(
                  record.surahName,
                  style: TextStyle(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w700,
                    color: colors.textPrimary,
                    fontFamily: 'Poppins',
                  ),
                ),
                Text(
                  'Ayat ${record.ayatMulai} - ${record.ayatSelesai}',
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

          // Score
          Text(
            '${record.nilaiKelancaran}',
            style: TextStyle(
              fontSize: 22.sp,
              fontWeight: FontWeight.w800,
              color: colors.textPrimary,
              fontFamily: 'Poppins',
            ),
          ),
        ],
      ),
    );
  }
}
