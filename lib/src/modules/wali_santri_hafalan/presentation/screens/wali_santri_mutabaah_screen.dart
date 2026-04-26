import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_halaqoh/gen/i18n/translations.g.dart';
import 'package:my_halaqoh/src/core/theme/app_colors.dart';
import 'package:my_halaqoh/src/core/widget/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_halaqoh/src/modules/auth/presentation/cubits/auth_cubit.dart';
import 'package:my_halaqoh/src/modules/auth/presentation/cubits/auth_state.dart';
import 'package:my_halaqoh/src/modules/wali_santri_hafalan/domain/models/wali_santri_hafalan_model.dart';
import 'package:my_halaqoh/src/modules/wali_santri_hafalan/presentation/cubits/wali_santri_riwayat_hafalan_cubit.dart';

/// Mutaba'ah Santri â€” daily memorization log split into Hafalan Baru & Murajaah tables
@RoutePage()
class WaliSantriMutabaahScreen extends StatefulWidget {
  final String name;
  final String nis;

  const WaliSantriMutabaahScreen({
    super.key,
    required this.name,
    required this.nis,
  });

  @override
  State<WaliSantriMutabaahScreen> createState() =>
      _WaliSantriMutabaahScreenState();
}

class _WaliSantriMutabaahScreenState extends State<WaliSantriMutabaahScreen> {
  int _currentMonth = DateTime.now().month;
  int _currentYear = DateTime.now().year;

  final List<String> _dayNames = [
    'Sen',
    'Sel',
    'Rab',
    'Kam',
    'Jum',
    'Sab',
    'Aha',
  ];

  String _getDayName(int day) {
    final date = DateTime(_currentYear, _currentMonth, day);
    // DateTime.weekday returns 1 for Monday to 7 for Sunday
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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchData();
    });
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
      context.read<WaliSantriRiwayatHafalanCubit>().watchRiwayat(
        linkedDocId,
        _currentMonth,
        _currentYear,
      );
    }
  }

  /// Score badge color
  Color _scoreColor(int nilai) {
    if (nilai >= 85) return const Color(0xFF4CAF50); // green
    if (nilai >= 70) return const Color(0xFFFFC107); // amber
    return const Color(0xFFFF7043); // orange-red
  }

  Color _scoreTextColor(int nilai) {
    if (nilai >= 85) return const Color(0xFF1B5E20);
    if (nilai >= 70) return const Color(0xFF795548);
    return const Color(0xFFBF360C);
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final riwayatState = context.watch<WaliSantriRiwayatHafalanCubit>().state;

    List<WaliSantriHafalanModel> hafalanBaruRecords = [];
    List<WaliSantriHafalanModel> murajaahRecords = [];
    bool isLoading = false;

    riwayatState.maybeWhen(
      loading: () => isLoading = true,
      loaded: (records) {
        hafalanBaruRecords = records
            .where((r) => r.jenis == 'Ziyadah')
            .toList();
        murajaahRecords = records.where((r) => r.jenis == 'Murajaah').toList();
      },
      orElse: () {},
    );

    return Scaffold(
      backgroundColor: colors.background,
      body: SafeArea(
        child: Column(
          children: [
            // AppBar
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

            // Content
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
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
                          },
                        ),
                      ],
                    ),
                    SizedBox(height: 20.h),

                    if (isLoading)
                      const Center(child: CircularProgressIndicator())
                    else ...[
                      // ── Hafalan Baru section ──
                      _buildSectionHeader(t.mutabaahSantri.hafalanBaru, colors),
                      SizedBox(height: 10.h),
                      if (hafalanBaruRecords.isEmpty)
                        Text(
                          'Tidak ada hafalan baru bulan ini',
                          style: TextStyle(
                            color: colors.textSecondary,
                            fontFamily: 'Poppins',
                            fontSize: 13.sp,
                          ),
                        )
                      else
                        _buildDataTable(hafalanBaruRecords, colors),
                      SizedBox(height: 28.h),

                      // ── Murajaah section ──
                      _buildSectionHeader(t.mutabaahSantri.murajaah, colors),
                      SizedBox(height: 10.h),
                      if (murajaahRecords.isEmpty)
                        Text(
                          'Tidak ada murajaah bulan ini',
                          style: TextStyle(
                            color: colors.textSecondary,
                            fontFamily: 'Poppins',
                            fontSize: 13.sp,
                          ),
                        )
                      else
                        _buildDataTable(murajaahRecords, colors),
                      SizedBox(height: 24.h),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Section header with green left accent bar
  Widget _buildSectionHeader(String label, AppColorSet colors) {
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
      ],
    );
  }

  /// Data table matching the mockup layout
  Widget _buildDataTable(
    List<WaliSantriHafalanModel> records,
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
              border: Border(
                bottom: BorderSide(color: colors.border, width: 1),
              ),
            ),
            child: Row(
              children: [
                _headerCell(t.mutabaahSantri.hari, 50.w, colors),
                _headerCell(t.mutabaahSantri.tgl, 50.w, colors),
                Expanded(
                  child: _headerCell(t.mutabaahSantri.surat, null, colors),
                ),
                _headerCell(t.mutabaahSantri.ayat, 55.w, colors),
                _headerCell(
                  t.mutabaahSantri.nilai,
                  45.w,
                  colors,
                  align: TextAlign.center,
                ),
              ],
            ),
          ),

          // Data rows
          ...records.asMap().entries.map((entry) {
            final record = entry.value;
            final isLast = entry.key == records.length - 1;

            return Container(
              padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
              decoration: BoxDecoration(
                border: isLast
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
                  // HARI
                  SizedBox(
                    width: 50.w,
                    child: Text(
                      _getDayName(record.tanggalSetoran.day),
                      style: TextStyle(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w700,
                        color: colors.textPrimary,
                        fontFamily: 'Poppins',
                      ),
                    ),
                  ),
                  // TGL
                  SizedBox(
                    width: 50.w,
                    child: Text(
                      '${record.tanggalSetoran.day.toString().padLeft(2, '0')}/${record.tanggalSetoran.month.toString().padLeft(2, '0')}',
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w400,
                        color: colors.textSecondary,
                        fontFamily: 'Poppins',
                      ),
                    ),
                  ),
                  // SURAT
                  Expanded(
                    child: Text(
                      record.surahName,
                      style: TextStyle(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w500,
                        color: colors.textPrimary,
                        fontFamily: 'Poppins',
                      ),
                    ),
                  ),
                  // AYAT
                  SizedBox(
                    width: 55.w,
                    child: Text(
                      '${record.ayatMulai}-${record.ayatSelesai}',
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w400,
                        color: colors.textSecondary,
                        fontFamily: 'Poppins',
                      ),
                    ),
                  ),
                  // NILAI badge (Using nilaiKelancaran as the primary score)
                  SizedBox(
                    width: 45.w,
                    child: Center(
                      child: Container(
                        width: 36.w,
                        height: 36.w,
                        decoration: BoxDecoration(
                          color: _scoreColor(
                            record.nilaiKelancaran,
                          ).withValues(alpha: 0.15),
                          shape: BoxShape.circle,
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          '${record.nilaiKelancaran}',
                          style: TextStyle(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w700,
                            color: _scoreTextColor(record.nilaiKelancaran),
                            fontFamily: 'Poppins',
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
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

    if (width != null) {
      return SizedBox(width: width, child: text);
    }
    return text;
  }
}
