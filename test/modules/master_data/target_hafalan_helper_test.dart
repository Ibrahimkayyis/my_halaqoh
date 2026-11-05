import 'dart:convert';
import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_halaqoh/src/core/quran/quran_data.dart';
import 'package:my_halaqoh/src/core/quran/quran_service.dart';
import 'package:my_halaqoh/src/modules/master_data/domain/helpers/target_hafalan_helper.dart';
import 'package:my_halaqoh/src/modules/master_data/domain/models/target_hafalan_model.dart';

void _initQuranServiceWithRealData() {
  final file = File('assets/data/quran.json');
  final jsonMap = jsonDecode(file.readAsStringSync()) as Map<String, dynamic>;
  final quranData = QuranData.fromJson(jsonMap);
  QuranService.instance.injectForTest(quranData);
}

void main() {
  setUpAll(() {
    _initQuranServiceWithRealData();
  });

  group('TargetHafalanHelper — Decimal Formatting', () {
    test('formatDecimalMax2 handles whole numbers cleanly', () {
      expect(TargetHafalanHelper.formatDecimalMax2(0.0), '0');
      expect(TargetHafalanHelper.formatDecimalMax2(1.0), '1');
      expect(TargetHafalanHelper.formatDecimalMax2(2.0), '2');
      expect(TargetHafalanHelper.formatDecimalMax2(8.0), '8');
      expect(TargetHafalanHelper.formatDecimalMax2(100.0), '100');
    });

    test('formatDecimalMax2 truncates to 2 decimal places without unwanted rounding', () {
      // 1.46 should remain 1.46 (not rounded up to 1.5)
      expect(TargetHafalanHelper.formatDecimalMax2(1.46), '1.46');
      expect(TargetHafalanHelper.formatDecimalMax2(1.464), '1.46');
      expect(TargetHafalanHelper.formatDecimalMax2(1.469), '1.46');
      expect(TargetHafalanHelper.formatDecimalMax2(1.5), '1.5');
      expect(TargetHafalanHelper.formatDecimalMax2(1.50), '1.5');
      expect(TargetHafalanHelper.formatDecimalMax2(1.92), '1.92');
      expect(TargetHafalanHelper.formatDecimalMax2(7.64), '7.64');
      expect(TargetHafalanHelper.formatDecimalMax2(92.48), '92.48');
    });

    test('formatJuz and formatPercent delegate correctly', () {
      expect(TargetHafalanHelper.formatJuz(2.0), '2');
      expect(TargetHafalanHelper.formatJuz(1.46), '1.46');
      expect(TargetHafalanHelper.formatPercent(100.0), '100');
      expect(TargetHafalanHelper.formatPercent(95.5), '95.5');
      expect(TargetHafalanHelper.formatPercent(92.48), '92.48');
    });
  });

  group('TargetHafalanHelper — Multi-Juz Progress Calculation', () {
    test('Juz 26 & 27 setoran 100% yields exactly 2.00 Juz (not 1.92)', () {
      // Target model for Class 8 Takhassus Semester 1 (Targets: Juz 27 UTS, Juz 26 UAS)
      final targetModel = TargetHafalanModel(
        id: '8_Takhassus',
        kelas: '8',
        program: 'Takhassus',
        semesterAktif: 1,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      // Santri has completed 100% of Juz 26 and 100% of Juz 27
      final setoranSegments = <Map<String, int>>[];

      final juz26 = QuranService.instance.getJuzByNumber(26)!;
      for (final seg in juz26.surahs) {
        setoranSegments.add({
          'surah_id': seg.surahId,
          'ayat_start': seg.ayatStart,
          'ayat_end': seg.ayatEnd,
        });
      }

      final juz27 = QuranService.instance.getJuzByNumber(27)!;
      for (final seg in juz27.surahs) {
        setoranSegments.add({
          'surah_id': seg.surahId,
          'ayat_start': seg.ayatStart,
          'ayat_end': seg.ayatEnd,
        });
      }

      final progressData = QuranService.instance.calculateProgress(setoranSegments);

      final completedDouble = TargetHafalanHelper.getCompletedJuzCountDouble(
        targetModel: targetModel,
        kelas: '8',
        programCode: 'T',
        progressData: progressData,
      );

      // With Az-Zariyat (Surah 51) correctly mapped to Juz 27, completed must be 2.00
      expect(completedDouble, closeTo(2.0, 0.0001));
      expect(TargetHafalanHelper.formatJuz(completedDouble), '2');
    });

    test('Juz 30 down to 23 (8 Juz) setoran 100% yields exactly 8.00 Juz (not 7.64)', () {
      // Target model for Class 9 Takhassus Semester 1 (Targets: Juz 30, 29, 28, 27, 26, 25, 24, 23)
      final targetModel = TargetHafalanModel(
        id: '9_Takhassus',
        kelas: '9',
        program: 'Takhassus',
        semesterAktif: 1,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      final setoranSegments = <Map<String, int>>[];
      for (int j = 23; j <= 30; j++) {
        final juz = QuranService.instance.getJuzByNumber(j)!;
        for (final seg in juz.surahs) {
          setoranSegments.add({
            'surah_id': seg.surahId,
            'ayat_start': seg.ayatStart,
            'ayat_end': seg.ayatEnd,
          });
        }
      }

      final progressData = QuranService.instance.calculateProgress(setoranSegments);

      final completedDouble = TargetHafalanHelper.getCompletedJuzCountDouble(
        targetModel: targetModel,
        kelas: '9',
        programCode: 'T',
        progressData: progressData,
      );

      // Previously 7.64 due to Az-Zariyat, Fussilat, and Az-Zumar being wiped.
      // Now it must be exactly 8.00!
      expect(completedDouble, closeTo(8.0, 0.0001));
      expect(TargetHafalanHelper.formatJuz(completedDouble), '8');
    });

    test('Reguler Class 9 Sem 1 UTS: Al-Baqarah (142-202) in Juz 2 is correctly counted', () {
      // Setor Al-Baqarah 142–202 (61 ayat in Juz 2)
      final setoranSegments = [
        {'surah_id': 2, 'ayat_start': 142, 'ayat_end': 202},
      ];

      final progressData = QuranService.instance.calculateProgress(setoranSegments);

      // Get target ranges for Class 9 Reguler Sem 1 UTS
      final fraction = TargetHafalanHelper.getCompletedFractionForRanges(
        [const TargetAyatRange(surahId: 2, ayatStart: 142, ayatEnd: 202)],
        progressData,
      );

      // Previously matched to Juz 1 and gave 0. Now must be 1.0 (100%)
      expect(fraction, closeTo(1.0, 0.0001));
    });

    test('Universal check: All 19 multi-juz surahs calculate 100% when their respective segments are memorized', () {
      final multiJuzSurahs = QuranService.instance.getAllSurahs().where((s) => s.isMultiJuz).toList();
      expect(multiJuzSurahs.length, 19);

      for (final surah in multiJuzSurahs) {
        for (final mapping in surah.juzMappings) {
          final range = TargetAyatRange(
            surahId: surah.id,
            ayatStart: mapping.ayatStart,
            ayatEnd: mapping.ayatEnd,
          );

          final setoran = [
            {
              'surah_id': surah.id,
              'ayat_start': mapping.ayatStart,
              'ayat_end': mapping.ayatEnd,
            }
          ];

          final progressData = QuranService.instance.calculateProgress(setoran);
          final fraction = TargetHafalanHelper.getCompletedFractionForRanges([range], progressData);

          expect(
            fraction,
            closeTo(1.0, 0.0001),
            reason: 'Surah ${surah.name} in Juz ${mapping.juz} (ayat ${mapping.ayatStart}-${mapping.ayatEnd}) should be 100%',
          );
        }
      }
    });
  });
}
