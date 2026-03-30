import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:my_halaqoh/gen/i18n/translations.g.dart';
import 'package:my_halaqoh/src/core/theme/app_colors.dart';
import 'package:my_halaqoh/src/core/widget/widgets.dart';

/// Surah data model
class _SurahData {
  final int number;
  final String name;
  final int juz;
  final String type;
  final int ayatCount;

  const _SurahData({
    required this.number,
    required this.name,
    required this.juz,
    required this.type,
    required this.ayatCount,
  });
}

/// Selected surah state
class _SelectedSurah {
  final _SurahData surah;
  bool semuaAyat = false;
  final TextEditingController ayatAwalController;
  final TextEditingController ayatAkhirController;

  _SelectedSurah({required this.surah})
    : ayatAwalController = TextEditingController(text: '1'),
      ayatAkhirController = TextEditingController(
        text: surah.ayatCount.toString(),
      );

  void dispose() {
    ayatAwalController.dispose();
    ayatAkhirController.dispose();
  }
}

/// Input Hafalan form screen — Ziyadah/Murajaah tabs, surah picker, ayat fields, scoring
@RoutePage()
class InputHafalanScreen extends StatefulWidget {
  final String name;
  final String nis;

  const InputHafalanScreen({super.key, required this.name, required this.nis});

  @override
  State<InputHafalanScreen> createState() => _InputHafalanScreenState();
}

class _InputHafalanScreenState extends State<InputHafalanScreen>
    with SingleTickerProviderStateMixin {
  // ── Tab controller (replaces _selectedTab string) ─────────────────────────
  late TabController _tabController;

  DateTime _tanggalSetoran = DateTime.now();

  final _juzController = TextEditingController();
  final _kelancaranController = TextEditingController(text: '0');
  final _tajwidController = TextEditingController(text: '0');

  final List<_SelectedSurah> _selectedSurahs = [];

  // Dummy surah data
  final List<_SurahData> _surahList = const [
    _SurahData(
      number: 1,
      name: 'Al-Fatihah',
      juz: 1,
      type: 'Makkiyah',
      ayatCount: 7,
    ),
    _SurahData(
      number: 2,
      name: 'Al-Baqarah',
      juz: 1,
      type: 'Madaniyah',
      ayatCount: 286,
    ),
    _SurahData(
      number: 3,
      name: 'Ali Imran',
      juz: 3,
      type: 'Madaniyah',
      ayatCount: 200,
    ),
    _SurahData(
      number: 36,
      name: 'Yasin',
      juz: 22,
      type: 'Makkiyah',
      ayatCount: 83,
    ),
    _SurahData(
      number: 67,
      name: 'Al-Mulk',
      juz: 29,
      type: 'Makkiyah',
      ayatCount: 30,
    ),
    _SurahData(
      number: 78,
      name: "An-Naba'",
      juz: 30,
      type: 'Makkiyah',
      ayatCount: 40,
    ),
    _SurahData(
      number: 79,
      name: "An-Nazi'at",
      juz: 30,
      type: 'Makkiyah',
      ayatCount: 46,
    ),
    _SurahData(
      number: 80,
      name: "'Abasa",
      juz: 30,
      type: 'Makkiyah',
      ayatCount: 42,
    ),
    _SurahData(
      number: 81,
      name: 'At-Takwir',
      juz: 30,
      type: 'Makkiyah',
      ayatCount: 29,
    ),
    _SurahData(
      number: 82,
      name: 'Al-Infitar',
      juz: 30,
      type: 'Makkiyah',
      ayatCount: 19,
    ),
    _SurahData(
      number: 83,
      name: 'Al-Mutaffifin',
      juz: 30,
      type: 'Makkiyah',
      ayatCount: 36,
    ),
    _SurahData(
      number: 84,
      name: 'Al-Insyiqaq',
      juz: 30,
      type: 'Makkiyah',
      ayatCount: 25,
    ),
    _SurahData(
      number: 85,
      name: 'Al-Buruj',
      juz: 30,
      type: 'Makkiyah',
      ayatCount: 22,
    ),
    _SurahData(
      number: 86,
      name: 'At-Tariq',
      juz: 30,
      type: 'Makkiyah',
      ayatCount: 17,
    ),
    _SurahData(
      number: 87,
      name: "Al-A'la",
      juz: 30,
      type: 'Makkiyah',
      ayatCount: 19,
    ),
    _SurahData(
      number: 88,
      name: 'Al-Gasyiyah',
      juz: 30,
      type: 'Makkiyah',
      ayatCount: 26,
    ),
    _SurahData(
      number: 89,
      name: 'Al-Fajr',
      juz: 30,
      type: 'Makkiyah',
      ayatCount: 30,
    ),
    _SurahData(
      number: 90,
      name: 'Al-Balad',
      juz: 30,
      type: 'Makkiyah',
      ayatCount: 20,
    ),
    _SurahData(
      number: 91,
      name: 'Asy-Syams',
      juz: 30,
      type: 'Makkiyah',
      ayatCount: 15,
    ),
    _SurahData(
      number: 92,
      name: 'Al-Lail',
      juz: 30,
      type: 'Makkiyah',
      ayatCount: 21,
    ),
    _SurahData(
      number: 93,
      name: 'Ad-Duha',
      juz: 30,
      type: 'Makkiyah',
      ayatCount: 11,
    ),
    _SurahData(
      number: 94,
      name: 'Asy-Syarh',
      juz: 30,
      type: 'Makkiyah',
      ayatCount: 8,
    ),
    _SurahData(
      number: 95,
      name: 'At-Tin',
      juz: 30,
      type: 'Makkiyah',
      ayatCount: 8,
    ),
    _SurahData(
      number: 96,
      name: 'Al-Alaq',
      juz: 30,
      type: 'Makkiyah',
      ayatCount: 19,
    ),
    _SurahData(
      number: 97,
      name: 'Al-Qadr',
      juz: 30,
      type: 'Makkiyah',
      ayatCount: 5,
    ),
    _SurahData(
      number: 98,
      name: 'Al-Bayyinah',
      juz: 30,
      type: 'Madaniyah',
      ayatCount: 8,
    ),
    _SurahData(
      number: 99,
      name: 'Az-Zalzalah',
      juz: 30,
      type: 'Madaniyah',
      ayatCount: 8,
    ),
    _SurahData(
      number: 100,
      name: 'Al-Adiyat',
      juz: 30,
      type: 'Makkiyah',
      ayatCount: 11,
    ),
    _SurahData(
      number: 101,
      name: "Al-Qari'ah",
      juz: 30,
      type: 'Makkiyah',
      ayatCount: 11,
    ),
    _SurahData(
      number: 102,
      name: 'At-Takasur',
      juz: 30,
      type: 'Makkiyah',
      ayatCount: 8,
    ),
    _SurahData(
      number: 103,
      name: 'Al-Asr',
      juz: 30,
      type: 'Makkiyah',
      ayatCount: 3,
    ),
    _SurahData(
      number: 104,
      name: 'Al-Humazah',
      juz: 30,
      type: 'Makkiyah',
      ayatCount: 9,
    ),
    _SurahData(
      number: 105,
      name: 'Al-Fil',
      juz: 30,
      type: 'Makkiyah',
      ayatCount: 5,
    ),
    _SurahData(
      number: 106,
      name: 'Quraisy',
      juz: 30,
      type: 'Makkiyah',
      ayatCount: 4,
    ),
    _SurahData(
      number: 107,
      name: "Al-Ma'un",
      juz: 30,
      type: 'Makkiyah',
      ayatCount: 7,
    ),
    _SurahData(
      number: 108,
      name: 'Al-Kausar',
      juz: 30,
      type: 'Makkiyah',
      ayatCount: 3,
    ),
    _SurahData(
      number: 109,
      name: 'Al-Kafirun',
      juz: 30,
      type: 'Makkiyah',
      ayatCount: 6,
    ),
    _SurahData(
      number: 110,
      name: 'An-Nasr',
      juz: 30,
      type: 'Madaniyah',
      ayatCount: 3,
    ),
    _SurahData(
      number: 111,
      name: 'Al-Lahab',
      juz: 30,
      type: 'Makkiyah',
      ayatCount: 5,
    ),
    _SurahData(
      number: 112,
      name: 'Al-Ikhlas',
      juz: 30,
      type: 'Makkiyah',
      ayatCount: 4,
    ),
    _SurahData(
      number: 113,
      name: 'Al-Falaq',
      juz: 30,
      type: 'Madaniyah',
      ayatCount: 5,
    ),
    _SurahData(
      number: 114,
      name: 'An-Nas',
      juz: 30,
      type: 'Madaniyah',
      ayatCount: 6,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _juzController.dispose();
    _kelancaranController.dispose();
    _tajwidController.dispose();
    for (final s in _selectedSurahs) {
      s.dispose();
    }
    super.dispose();
  }

  // ── Helpers ───────────────────────────────────────────────────────────────
  String get _selectedTab => _tabController.index == 0 ? 'ziyadah' : 'murajaah';

  void _showSurahBottomSheet() {
    final colors = AppColors.of(context);
    final searchController = TextEditingController();
    String searchQuery = '';
    final tempSelected = <int>{..._selectedSurahs.map((s) => s.surah.number)};

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (ctx, setSheetState) {
            final filtered = _surahList.where((s) {
              if (searchQuery.isEmpty) return true;
              return s.name.toLowerCase().contains(searchQuery.toLowerCase()) ||
                  s.number.toString().contains(searchQuery);
            }).toList();

            final totalCount = tempSelected.length;

            return Container(
              height: MediaQuery.of(context).size.height * 0.75,
              decoration: BoxDecoration(
                color: colors.surface,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
              ),
              child: Column(
                children: [
                  SizedBox(height: 20.h),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24.w),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Pilih Daftar Surat',
                                style: TextStyle(
                                  fontSize: 18.sp,
                                  fontWeight: FontWeight.w700,
                                  color: colors.textPrimary,
                                  fontFamily: 'Poppins',
                                ),
                              ),
                              SizedBox(height: 2.h),
                              Text(
                                'Pilih satu atau lebih surat',
                                style: TextStyle(
                                  fontSize: 13.sp,
                                  color: colors.textSecondary,
                                  fontFamily: 'Poppins',
                                ),
                              ),
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: () => Navigator.pop(ctx),
                          child: Icon(
                            Icons.close,
                            size: 22.sp,
                            color: colors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 16.h),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24.w),
                    child: Container(
                      decoration: BoxDecoration(
                        color: colors.background,
                        borderRadius: BorderRadius.circular(12.r),
                        border: Border.all(color: colors.border, width: 1),
                      ),
                      child: TextField(
                        controller: searchController,
                        onChanged: (v) => setSheetState(() => searchQuery = v),
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontFamily: 'Poppins',
                          color: colors.textPrimary,
                        ),
                        decoration: InputDecoration(
                          hintText: 'Cari nama surat...',
                          hintStyle: TextStyle(
                            fontSize: 14.sp,
                            fontFamily: 'Poppins',
                            color: colors.textSecondary.withValues(alpha: 0.5),
                          ),
                          prefixIcon: Icon(
                            Icons.search,
                            color: colors.textSecondary,
                            size: 20.sp,
                          ),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 16.w,
                            vertical: 12.h,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Expanded(
                    child: ListView.builder(
                      padding: EdgeInsets.symmetric(horizontal: 24.w),
                      itemCount: filtered.length,
                      itemBuilder: (_, idx) {
                        final surah = filtered[idx];
                        final isSelected = tempSelected.contains(surah.number);
                        return InkWell(
                          onTap: () {
                            setSheetState(() {
                              if (isSelected) {
                                tempSelected.remove(surah.number);
                              } else {
                                tempSelected.add(surah.number);
                              }
                            });
                          },
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical: 14.h),
                            child: Row(
                              children: [
                                Container(
                                  width: 36.w,
                                  height: 36.w,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: colors.primary.withValues(
                                      alpha: 0.08,
                                    ),
                                  ),
                                  alignment: Alignment.center,
                                  child: Text(
                                    surah.number.toString(),
                                    style: TextStyle(
                                      fontSize: 13.sp,
                                      fontWeight: FontWeight.w600,
                                      color: colors.primary,
                                      fontFamily: 'Poppins',
                                    ),
                                  ),
                                ),
                                SizedBox(width: 14.w),
                                Expanded(
                                  child: Text(
                                    surah.name,
                                    style: TextStyle(
                                      fontSize: 15.sp,
                                      fontWeight: FontWeight.w500,
                                      color: colors.textPrimary,
                                      fontFamily: 'Poppins',
                                    ),
                                  ),
                                ),
                                Icon(
                                  isSelected
                                      ? Icons.check_circle
                                      : Icons.radio_button_unchecked,
                                  size: 24.sp,
                                  color: isSelected
                                      ? colors.primary
                                      : colors.border,
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(24.w, 12.h, 24.w, 24.h),
                    child: PrimaryButton(
                      width: double.infinity,
                      height: 50.h,
                      onPressed: totalCount > 0
                          ? () {
                              _selectedSurahs.removeWhere((sel) {
                                if (!tempSelected.contains(sel.surah.number)) {
                                  sel.dispose();
                                  return true;
                                }
                                return false;
                              });
                              for (final num in tempSelected) {
                                if (!_selectedSurahs.any(
                                  (s) => s.surah.number == num,
                                )) {
                                  final surah = _surahList.firstWhere(
                                    (s) => s.number == num,
                                  );
                                  _selectedSurahs.add(
                                    _SelectedSurah(surah: surah),
                                  );
                                }
                              }
                              setState(() {});
                              Navigator.pop(ctx);
                            }
                          : null,
                      label: totalCount > 0
                          ? 'KONFIRMASI PILIHAN  ($totalCount)'
                          : 'KONFIRMASI PILIHAN',
                      borderRadius: 14.r,
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Future<void> _selectTanggalSetoran(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _tanggalSetoran,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: AppColors.of(context).primary,
              onPrimary: Colors.white,
              onSurface: AppColors.of(context).textPrimary,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _tanggalSetoran) {
      setState(() => _tanggalSetoran = picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        backgroundColor: colors.background,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: colors.textPrimary),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Input Hafalan',
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.w700,
            color: colors.textPrimary,
            fontFamily: 'Poppins',
          ),
        ),
        centerTitle: false,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 8.h),

                  // ── Profile card ──
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(16.w),
                    decoration: BoxDecoration(
                      color: colors.surface,
                      borderRadius: BorderRadius.circular(14.r),
                      border: Border.all(
                        color: colors.border.withValues(alpha: 0.5),
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 48.w,
                          height: 48.w,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: colors.primary.withValues(alpha: 0.1),
                          ),
                          child: Icon(
                            Icons.person,
                            size: 26.sp,
                            color: colors.primary,
                          ),
                        ),
                        SizedBox(width: 14.w),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.name,
                              style: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w700,
                                color: colors.textPrimary,
                                fontFamily: 'Poppins',
                              ),
                            ),
                            SizedBox(height: 2.h),
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 8.w,
                                vertical: 2.h,
                              ),
                              decoration: BoxDecoration(
                                color: colors.background,
                                borderRadius: BorderRadius.circular(6.r),
                              ),
                              child: Text(
                                'NIS: ${widget.nis}',
                                style: TextStyle(
                                  fontSize: 11.sp,
                                  fontWeight: FontWeight.w500,
                                  color: colors.textSecondary,
                                  fontFamily: 'Poppins',
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 18.h),

                  // ── Ziyadah / Murajaah tab selector ──
                  AppTabSelector(
                    controller: _tabController,
                    tabs: [
                      t.inputHafalanForm.ziyadah,
                      t.inputHafalanForm.murajaah,
                    ],
                    horizontalPadding: 0,
                  ),
                  SizedBox(height: 24.h),

                  Row(
                    children: [
                      Icon(Icons.menu_book, size: 20.sp, color: colors.primary),
                      SizedBox(width: 8.w),
                      Text(
                        t.inputHafalanForm.formulirHafalan,
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w700,
                          color: colors.textPrimary,
                          fontFamily: 'Poppins',
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 14.h),

                  // ── Tanggal Setoran Picker ──
                  GestureDetector(
                    onTap: () => _selectTanggalSetoran(context),
                    child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(
                        horizontal: 16.w,
                        vertical: 14.h,
                      ),
                      decoration: BoxDecoration(
                        color: colors.surface,
                        borderRadius: BorderRadius.circular(12.r),
                        border: Border.all(color: colors.border, width: 1),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Tanggal Setoran',
                                  style: TextStyle(
                                    fontSize: 11.sp,
                                    fontWeight: FontWeight.w500,
                                    color: colors.textSecondary,
                                    fontFamily: 'Poppins',
                                  ),
                                ),
                                SizedBox(height: 2.h),
                                Text(
                                  DateFormat(
                                    'EEEE, d MMMM yyyy',
                                    'id',
                                  ).format(_tanggalSetoran),
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w600,
                                    color: colors.textPrimary,
                                    fontFamily: 'Poppins',
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Icon(
                            Icons.calendar_month,
                            size: 22.sp,
                            color: colors.primary,
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 12.h),

                  // ── Pilih Daftar Surat button ──
                  GestureDetector(
                    onTap: _showSurahBottomSheet,
                    child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(
                        horizontal: 16.w,
                        vertical: 14.h,
                      ),
                      decoration: BoxDecoration(
                        color: colors.surface,
                        borderRadius: BorderRadius.circular(12.r),
                        border: Border.all(color: colors.border, width: 1),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Tambah Surat',
                                  style: TextStyle(
                                    fontSize: 11.sp,
                                    fontWeight: FontWeight.w500,
                                    color: colors.textSecondary,
                                    fontFamily: 'Poppins',
                                  ),
                                ),
                                SizedBox(height: 2.h),
                                Text(
                                  'Pilih Daftar Surat',
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w600,
                                    color: colors.textPrimary,
                                    fontFamily: 'Poppins',
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Icon(
                            Icons.add_circle_outline,
                            size: 22.sp,
                            color: colors.primary,
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 12.h),

                  // ── Selected surah cards ──
                  ...List.generate(_selectedSurahs.length, (index) {
                    return _buildSurahCard(
                      index,
                      _selectedSurahs[index],
                      colors,
                    );
                  }),

                  // ── Juz ──
                  _buildTextField(
                    t.inputHafalanForm.juz,
                    _juzController,
                    colors,
                    keyboardType: TextInputType.number,
                  ),
                  SizedBox(height: 24.h),

                  // ── Penilaian header ──
                  Row(
                    children: [
                      Icon(
                        Icons.star_outline,
                        size: 20.sp,
                        color: colors.primary,
                      ),
                      SizedBox(width: 8.w),
                      Text(
                        t.inputHafalanForm.penilaian,
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w700,
                          color: colors.textPrimary,
                          fontFamily: 'Poppins',
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 14.h),

                  // ── Kelancaran ──
                  _buildScoringField(
                    'Kelancaran',
                    'Skala 1-100',
                    Icons.speed,
                    _kelancaranController,
                    colors,
                  ),
                  SizedBox(height: 12.h),

                  // ── Tajwid ──
                  _buildScoringField(
                    'Tajwid',
                    'Skala 1-100',
                    Icons.record_voice_over_outlined,
                    _tajwidController,
                    colors,
                  ),
                  SizedBox(height: 32.h),
                ],
              ),
            ),
          ),

          // ── Bottom buttons ──
          Container(
            padding: EdgeInsets.fromLTRB(24.w, 12.h, 24.w, 24.h),
            decoration: BoxDecoration(
              color: colors.surface,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                PrimaryButton(
                  width: double.infinity,
                  height: 50.h,
                  onPressed: () async {
                    final confirmed = await ConfirmSaveDialog.show(context);
                    if (confirmed && context.mounted) {
                      final dummyData = {
                        'day': DateTime.now().day,
                        'type': _selectedTab,
                        'surah': _selectedSurahs.isNotEmpty
                            ? _selectedSurahs.first.surah.name
                            : 'Surat Baru',
                        'ayat': _selectedSurahs.isNotEmpty
                            ? 'Ayat ${_selectedSurahs.first.ayatAwalController.text} - ${_selectedSurahs.first.ayatAkhirController.text}'
                            : 'Ayat 1-10',
                        'score': int.tryParse(_kelancaranController.text) ?? 80,
                      };
                      Navigator.of(context).pop(dummyData);
                    }
                  },
                  label: t.inputHafalanForm.simpan,
                  borderRadius: 14.r,
                ),
                SizedBox(height: 10.h),
                CustomOutlinedButton(
                  width: double.infinity,
                  height: 50.h,
                  onPressed: () => Navigator.of(context).pop(),
                  label: t.inputHafalanForm.batal,
                  borderRadius: 14.r,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── Surah card ─────────────────────────────────────────────────────────────
  Widget _buildSurahCard(int index, _SelectedSurah sel, AppColorSet colors) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(
          color: colors.border.withValues(alpha: 0.5),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 28.w,
                height: 28.w,
                decoration: BoxDecoration(
                  color: colors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                alignment: Alignment.center,
                child: Text(
                  (index + 1).toString().padLeft(2, '0'),
                  style: TextStyle(
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w700,
                    color: colors.primary,
                    fontFamily: 'Poppins',
                  ),
                ),
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      sel.surah.name,
                      style: TextStyle(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w700,
                        color: colors.textPrimary,
                        fontFamily: 'Poppins',
                      ),
                    ),
                    Text(
                      'Juz ${sel.surah.juz} • ${sel.surah.type}',
                      style: TextStyle(
                        fontSize: 11.sp,
                        color: colors.textSecondary,
                        fontFamily: 'Poppins',
                      ),
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedSurahs[index].dispose();
                    _selectedSurahs.removeAt(index);
                  });
                },
                child: Icon(
                  Icons.delete_outline,
                  size: 20.sp,
                  color: colors.textSecondary,
                ),
              ),
            ],
          ),
          SizedBox(height: 10.h),
          GestureDetector(
            onTap: () {
              setState(() {
                sel.semuaAyat = !sel.semuaAyat;
                if (sel.semuaAyat) {
                  sel.ayatAwalController.text = '1';
                  sel.ayatAkhirController.text = sel.surah.ayatCount.toString();
                }
              });
            },
            child: Row(
              children: [
                Icon(
                  sel.semuaAyat
                      ? Icons.check_circle
                      : Icons.radio_button_unchecked,
                  size: 20.sp,
                  color: sel.semuaAyat ? colors.primary : colors.textSecondary,
                ),
                SizedBox(width: 6.w),
                Text(
                  'Semua Ayat',
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w500,
                    color: colors.textPrimary,
                    fontFamily: 'Poppins',
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 10.h),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      t.inputHafalanForm.ayatAwal.toUpperCase(),
                      style: TextStyle(
                        fontSize: 10.sp,
                        fontWeight: FontWeight.w600,
                        color: colors.textSecondary,
                        letterSpacing: 0.5,
                        fontFamily: 'Poppins',
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Container(
                      decoration: BoxDecoration(
                        color: colors.background,
                        borderRadius: BorderRadius.circular(10.r),
                        border: Border.all(color: colors.border, width: 1),
                      ),
                      child: TextField(
                        controller: sel.ayatAwalController,
                        readOnly: sel.semuaAyat,
                        keyboardType: TextInputType.number,
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontFamily: 'Poppins',
                          color: colors.textPrimary,
                        ),
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 12.w,
                            vertical: 10.h,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      t.inputHafalanForm.ayatAkhir.toUpperCase(),
                      style: TextStyle(
                        fontSize: 10.sp,
                        fontWeight: FontWeight.w600,
                        color: colors.textSecondary,
                        letterSpacing: 0.5,
                        fontFamily: 'Poppins',
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Container(
                      decoration: BoxDecoration(
                        color: colors.background,
                        borderRadius: BorderRadius.circular(10.r),
                        border: Border.all(color: colors.border, width: 1),
                      ),
                      child: TextField(
                        controller: sel.ayatAkhirController,
                        readOnly: sel.semuaAyat,
                        keyboardType: TextInputType.number,
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontFamily: 'Poppins',
                          color: colors.textPrimary,
                        ),
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 12.w,
                            vertical: 10.h,
                          ),
                        ),
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

  // ── Scoring field ──────────────────────────────────────────────────────────
  Widget _buildScoringField(
    String label,
    String scaleLabel,
    IconData icon,
    TextEditingController controller,
    AppColorSet colors,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                color: colors.textPrimary,
                fontFamily: 'Poppins',
              ),
            ),
            Text(
              scaleLabel,
              style: TextStyle(
                fontSize: 11.sp,
                color: colors.textSecondary,
                fontFamily: 'Poppins',
              ),
            ),
          ],
        ),
        SizedBox(height: 6.h),
        Container(
          decoration: BoxDecoration(
            color: colors.surface,
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(color: colors.border, width: 1),
          ),
          child: TextField(
            controller: controller,
            keyboardType: TextInputType.number,
            style: TextStyle(
              fontSize: 14.sp,
              fontFamily: 'Poppins',
              color: colors.textPrimary,
            ),
            decoration: InputDecoration(
              prefixIcon: Icon(icon, size: 20.sp, color: colors.textSecondary),
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(
                horizontal: 16.w,
                vertical: 14.h,
              ),
            ),
          ),
        ),
      ],
    );
  }

  // ── Simple text field ──────────────────────────────────────────────────────
  Widget _buildTextField(
    String hint,
    TextEditingController controller,
    AppColorSet colors, {
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: colors.border, width: 1),
      ),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        style: TextStyle(
          fontSize: 14.sp,
          fontFamily: 'Poppins',
          color: colors.textPrimary,
        ),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(
            fontSize: 14.sp,
            fontFamily: 'Poppins',
            color: colors.textSecondary.withValues(alpha: 0.5),
          ),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(
            horizontal: 16.w,
            vertical: 14.h,
          ),
        ),
      ),
    );
  }
}
