import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_halaqoh/gen/i18n/translations.g.dart';
import 'package:my_halaqoh/src/core/theme/app_colors.dart';

/// Progress Hafalan Per Surat — shows surah-level progress for a specific juz
@RoutePage()
class ProgressHafalanPerSuratScreen extends StatelessWidget {
  final String name;
  final String nis;
  final int juzNumber;

  const ProgressHafalanPerSuratScreen({
    super.key,
    required this.name,
    required this.nis,
    required this.juzNumber,
  });

  // Complete mapping of surahs per juz (juz 1-30)
  static final Map<int, List<Map<String, dynamic>>> _juzSurahMap = {
    1: [
      {'name': 'Al-Fatihah', 'totalAyat': 7, 'memorized': 7},
      {'name': 'Al-Baqarah', 'totalAyat': 141, 'memorized': 100},
    ],
    2: [
      {'name': 'Al-Baqarah', 'totalAyat': 145, 'memorized': 80},
    ],
    3: [
      {'name': 'Al-Baqarah', 'totalAyat': 0, 'memorized': 0},
      {'name': 'Ali Imran', 'totalAyat': 91, 'memorized': 45},
    ],
    4: [
      {'name': 'Ali Imran', 'totalAyat': 109, 'memorized': 30},
      {'name': 'An-Nisa', 'totalAyat': 23, 'memorized': 0},
    ],
    5: [
      {'name': 'An-Nisa', 'totalAyat': 124, 'memorized': 0},
      {'name': 'Al-Maidah', 'totalAyat': 22, 'memorized': 0},
    ],
    6: [
      {'name': 'Al-Maidah', 'totalAyat': 98, 'memorized': 0},
      {'name': "Al-An'am", 'totalAyat': 110, 'memorized': 0},
    ],
    7: [
      {'name': "Al-An'am", 'totalAyat': 55, 'memorized': 0},
      {'name': "Al-A'raf", 'totalAyat': 87, 'memorized': 0},
    ],
    8: [
      {'name': "Al-A'raf", 'totalAyat': 119, 'memorized': 0},
    ],
    9: [
      {'name': "Al-A'raf", 'totalAyat': 0, 'memorized': 0},
      {'name': 'Al-Anfal', 'totalAyat': 75, 'memorized': 0},
    ],
    10: [
      {'name': 'Al-Anfal', 'totalAyat': 0, 'memorized': 0},
      {'name': 'At-Taubah', 'totalAyat': 93, 'memorized': 0},
    ],
    11: [
      {'name': 'At-Taubah', 'totalAyat': 36, 'memorized': 0},
      {'name': 'Yunus', 'totalAyat': 109, 'memorized': 0},
      {'name': 'Hud', 'totalAyat': 5, 'memorized': 0},
    ],
    12: [
      {'name': 'Hud', 'totalAyat': 118, 'memorized': 0},
      {'name': 'Yusuf', 'totalAyat': 52, 'memorized': 0},
    ],
    13: [
      {'name': 'Yusuf', 'totalAyat': 59, 'memorized': 0},
      {'name': "Ar-Ra'd", 'totalAyat': 43, 'memorized': 0},
      {'name': 'Ibrahim', 'totalAyat': 52, 'memorized': 0},
    ],
    14: [
      {'name': 'Al-Hijr', 'totalAyat': 99, 'memorized': 0},
      {'name': 'An-Nahl', 'totalAyat': 128, 'memorized': 0},
    ],
    15: [
      {'name': 'Al-Isra', 'totalAyat': 111, 'memorized': 0},
      {'name': 'Al-Kahf', 'totalAyat': 74, 'memorized': 0},
    ],
    16: [
      {'name': 'Al-Kahf', 'totalAyat': 36, 'memorized': 0},
      {'name': 'Maryam', 'totalAyat': 98, 'memorized': 0},
      {'name': 'Taha', 'totalAyat': 135, 'memorized': 0},
    ],
    17: [
      {'name': 'Al-Anbiya', 'totalAyat': 112, 'memorized': 0},
      {'name': 'Al-Hajj', 'totalAyat': 78, 'memorized': 0},
    ],
    18: [
      {'name': "Al-Mu'minun", 'totalAyat': 118, 'memorized': 0},
      {'name': 'An-Nur', 'totalAyat': 64, 'memorized': 0},
      {'name': 'Al-Furqan', 'totalAyat': 20, 'memorized': 0},
    ],
    19: [
      {'name': 'Al-Furqan', 'totalAyat': 57, 'memorized': 0},
      {'name': "Asy-Syu'ara", 'totalAyat': 227, 'memorized': 0},
      {'name': 'An-Naml', 'totalAyat': 55, 'memorized': 0},
    ],
    20: [
      {'name': 'An-Naml', 'totalAyat': 38, 'memorized': 0},
      {'name': 'Al-Qasas', 'totalAyat': 88, 'memorized': 0},
      {'name': 'Al-Ankabut', 'totalAyat': 45, 'memorized': 0},
    ],
    21: [
      {'name': 'Al-Ankabut', 'totalAyat': 24, 'memorized': 0},
      {'name': 'Ar-Rum', 'totalAyat': 60, 'memorized': 0},
      {'name': 'Luqman', 'totalAyat': 34, 'memorized': 0},
      {'name': 'As-Sajdah', 'totalAyat': 30, 'memorized': 0},
      {'name': 'Al-Ahzab', 'totalAyat': 30, 'memorized': 0},
    ],
    22: [
      {'name': 'Al-Ahzab', 'totalAyat': 43, 'memorized': 0},
      {'name': 'Saba', 'totalAyat': 54, 'memorized': 0},
      {'name': 'Fatir', 'totalAyat': 45, 'memorized': 0},
      {'name': 'Yasin', 'totalAyat': 83, 'memorized': 0},
    ],
    23: [
      {'name': 'Yasin', 'totalAyat': 0, 'memorized': 0},
      {'name': 'As-Saffat', 'totalAyat': 182, 'memorized': 0},
      {'name': 'Sad', 'totalAyat': 88, 'memorized': 0},
      {'name': 'Az-Zumar', 'totalAyat': 31, 'memorized': 0},
    ],
    24: [
      {'name': 'Az-Zumar', 'totalAyat': 44, 'memorized': 0},
      {'name': 'Ghafir', 'totalAyat': 85, 'memorized': 0},
      {'name': 'Fussilat', 'totalAyat': 46, 'memorized': 0},
    ],
    25: [
      {'name': 'Fussilat', 'totalAyat': 8, 'memorized': 0},
      {'name': 'Asy-Syura', 'totalAyat': 53, 'memorized': 0},
      {'name': 'Az-Zukhruf', 'totalAyat': 89, 'memorized': 0},
      {'name': 'Ad-Dukhan', 'totalAyat': 59, 'memorized': 0},
      {'name': 'Al-Jasiyah', 'totalAyat': 37, 'memorized': 0},
    ],
    26: [
      {'name': 'Al-Ahqaf', 'totalAyat': 35, 'memorized': 0},
      {'name': 'Muhammad', 'totalAyat': 38, 'memorized': 0},
      {'name': 'Al-Fath', 'totalAyat': 29, 'memorized': 0},
      {'name': 'Al-Hujurat', 'totalAyat': 18, 'memorized': 0},
      {'name': 'Qaf', 'totalAyat': 45, 'memorized': 0},
      {'name': 'Az-Zariyat', 'totalAyat': 60, 'memorized': 0},
    ],
    27: [
      {'name': 'At-Tur', 'totalAyat': 49, 'memorized': 0},
      {'name': 'An-Najm', 'totalAyat': 62, 'memorized': 0},
      {'name': 'Al-Qamar', 'totalAyat': 55, 'memorized': 0},
      {'name': 'Ar-Rahman', 'totalAyat': 78, 'memorized': 0},
      {'name': "Al-Waqi'ah", 'totalAyat': 96, 'memorized': 0},
      {'name': 'Al-Hadid', 'totalAyat': 29, 'memorized': 0},
    ],
    28: [
      {'name': 'Al-Mujadalah', 'totalAyat': 22, 'memorized': 0},
      {'name': 'Al-Hasyr', 'totalAyat': 24, 'memorized': 0},
      {'name': 'Al-Mumtahanah', 'totalAyat': 13, 'memorized': 0},
      {'name': 'As-Saff', 'totalAyat': 14, 'memorized': 0},
      {'name': "Al-Jumu'ah", 'totalAyat': 11, 'memorized': 0},
      {'name': 'Al-Munafiqun', 'totalAyat': 11, 'memorized': 0},
      {'name': 'At-Tagabun', 'totalAyat': 18, 'memorized': 0},
      {'name': 'At-Talaq', 'totalAyat': 12, 'memorized': 0},
      {'name': 'At-Tahrim', 'totalAyat': 12, 'memorized': 0},
    ],
    29: [
      {'name': 'Al-Mulk', 'totalAyat': 30, 'memorized': 30},
      {'name': 'Al-Qalam', 'totalAyat': 52, 'memorized': 52},
      {'name': 'Al-Haqqah', 'totalAyat': 52, 'memorized': 30},
      {'name': "Al-Ma'arij", 'totalAyat': 44, 'memorized': 20},
      {'name': 'Nuh', 'totalAyat': 28, 'memorized': 28},
      {'name': 'Al-Jinn', 'totalAyat': 28, 'memorized': 0},
      {'name': 'Al-Muzzammil', 'totalAyat': 20, 'memorized': 0},
      {'name': 'Al-Muddassir', 'totalAyat': 56, 'memorized': 0},
      {'name': 'Al-Qiyamah', 'totalAyat': 40, 'memorized': 0},
      {'name': 'Al-Insan', 'totalAyat': 31, 'memorized': 0},
      {'name': 'Al-Mursalat', 'totalAyat': 50, 'memorized': 0},
    ],
    30: [
      {'name': 'An-Naba', 'totalAyat': 40, 'memorized': 40},
      {'name': "An-Nazi'at", 'totalAyat': 46, 'memorized': 25},
      {'name': 'Abasa', 'totalAyat': 42, 'memorized': 0},
      {'name': 'At-Takwir', 'totalAyat': 29, 'memorized': 0},
      {'name': 'Al-Infitar', 'totalAyat': 19, 'memorized': 19},
      {'name': 'Al-Mutaffifin', 'totalAyat': 36, 'memorized': 36},
      {'name': 'Al-Insyiqaq', 'totalAyat': 25, 'memorized': 25},
      {'name': 'Al-Buruj', 'totalAyat': 22, 'memorized': 22},
      {'name': 'At-Tariq', 'totalAyat': 17, 'memorized': 17},
      {'name': "Al-A'la", 'totalAyat': 19, 'memorized': 19},
      {'name': 'Al-Gasyiyah', 'totalAyat': 26, 'memorized': 0},
      {'name': 'Al-Fajr', 'totalAyat': 30, 'memorized': 0},
      {'name': 'Al-Balad', 'totalAyat': 20, 'memorized': 0},
      {'name': 'Asy-Syams', 'totalAyat': 15, 'memorized': 0},
      {'name': 'Al-Lail', 'totalAyat': 21, 'memorized': 0},
      {'name': 'Ad-Duha', 'totalAyat': 11, 'memorized': 0},
      {'name': 'Asy-Syarh', 'totalAyat': 8, 'memorized': 0},
      {'name': 'At-Tin', 'totalAyat': 8, 'memorized': 0},
      {'name': 'Al-Alaq', 'totalAyat': 19, 'memorized': 0},
      {'name': 'Al-Qadr', 'totalAyat': 5, 'memorized': 0},
      {'name': 'Al-Bayyinah', 'totalAyat': 8, 'memorized': 0},
      {'name': 'Az-Zalzalah', 'totalAyat': 8, 'memorized': 0},
      {'name': 'Al-Adiyat', 'totalAyat': 11, 'memorized': 0},
      {'name': "Al-Qari'ah", 'totalAyat': 11, 'memorized': 0},
      {'name': 'At-Takasur', 'totalAyat': 8, 'memorized': 0},
      {'name': 'Al-Asr', 'totalAyat': 3, 'memorized': 0},
      {'name': 'Al-Humazah', 'totalAyat': 9, 'memorized': 0},
      {'name': 'Al-Fil', 'totalAyat': 5, 'memorized': 0},
      {'name': 'Quraisy', 'totalAyat': 4, 'memorized': 0},
      {'name': "Al-Ma'un", 'totalAyat': 7, 'memorized': 0},
      {'name': 'Al-Kausar', 'totalAyat': 3, 'memorized': 0},
      {'name': 'Al-Kafirun', 'totalAyat': 6, 'memorized': 0},
      {'name': 'An-Nasr', 'totalAyat': 3, 'memorized': 0},
      {'name': 'Al-Lahab', 'totalAyat': 5, 'memorized': 0},
      {'name': 'Al-Ikhlas', 'totalAyat': 4, 'memorized': 0},
      {'name': 'Al-Falaq', 'totalAyat': 5, 'memorized': 0},
      {'name': 'An-Nas', 'totalAyat': 6, 'memorized': 0},
    ],
  };

  List<Map<String, dynamic>> get _surahs => _juzSurahMap[juzNumber] ?? [];

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final surahs = _surahs;

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
                    'Juz $juzNumber',
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

            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Green gradient profile card
                    _buildProfileCard(colors),
                    SizedBox(height: 20.h),

                    // Progress Per Surat header
                    Text(
                      t.progressHafalanPerSurat.title,
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w700,
                        color: colors.textPrimary,
                        fontFamily: 'Poppins',
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      t.progressHafalanPerSurat.detailJuz(juz: '$juzNumber'),
                      style: TextStyle(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w400,
                        color: colors.textSecondary,
                        fontFamily: 'Poppins',
                      ),
                    ),
                    SizedBox(height: 14.h),

                    // Surah cards
                    ...surahs.map((surah) => _buildSurahCard(surah, colors)),
                    SizedBox(height: 24.h),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

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
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                  fontFamily: 'Poppins',
                ),
              ),
              SizedBox(height: 2.h),
              Text(
                'NIS: $nis',
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w400,
                  color: Colors.white.withValues(alpha: 0.85),
                  fontFamily: 'Poppins',
                ),
              ),
              Text(
                t.riwayatHafalanSantri.halaqohKelas(halaqoh: 'A', kelas: '7'),
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w400,
                  color: Colors.white.withValues(alpha: 0.85),
                  fontFamily: 'Poppins',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSurahCard(Map<String, dynamic> surah, AppColorSet colors) {
    final surahName = surah['name'] as String;
    final totalAyat = surah['totalAyat'] as int;
    final memorized = surah['memorized'] as int;
    final percent = totalAyat > 0 ? (memorized / totalAyat * 100).round() : 0;
    final progress = totalAyat > 0 ? memorized / totalAyat : 0.0;

    String statusLabel;
    Color statusColor;
    if (percent == 100) {
      statusLabel = t.progressHafalanPerSurat.selesai;
      statusColor = colors.primary;
    } else if (percent > 0) {
      statusLabel = t.progressHafalanPerSurat.dalamProses;
      statusColor = colors.primary;
    } else {
      statusLabel = t.progressHafalanPerSurat.belumDimulai;
      statusColor = colors.textSecondary;
    }

    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(14.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Surah name + percent
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    surahName,
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w700,
                      color: colors.textPrimary,
                      fontFamily: 'Poppins',
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    '$totalAyat Ayat',
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w400,
                      color: colors.textSecondary,
                      fontFamily: 'Poppins',
                    ),
                  ),
                ],
              ),
              Text(
                '$percent%',
                style: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w800,
                  color: colors.primary,
                  fontFamily: 'Poppins',
                ),
              ),
            ],
          ),
          SizedBox(height: 10.h),

          // Progress bar
          ClipRRect(
            borderRadius: BorderRadius.circular(4.r),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 6.h,
              backgroundColor: colors.border,
              valueColor: AlwaysStoppedAnimation<Color>(colors.primary),
            ),
          ),
          SizedBox(height: 8.h),

          // Ayat count + status label
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                t.progressHafalanPerSurat.ayatDari(
                  memorized: '$memorized',
                  total: '$totalAyat',
                ),
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w400,
                  color: colors.textSecondary,
                  fontFamily: 'Poppins',
                ),
              ),
              Text(
                statusLabel,
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w600,
                  color: statusColor,
                  fontFamily: 'Poppins',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
