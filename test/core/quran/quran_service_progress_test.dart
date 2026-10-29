import 'package:flutter_test/flutter_test.dart';
import 'package:my_halaqoh/src/core/quran/hafalan_progress.dart';
import 'package:my_halaqoh/src/core/quran/juz_model.dart';
import 'package:my_halaqoh/src/core/quran/juz_segment_model.dart';
import 'package:my_halaqoh/src/core/quran/quran_data.dart';
import 'package:my_halaqoh/src/core/quran/quran_service.dart';
import 'package:my_halaqoh/src/core/quran/surah_model.dart';

/// Helper: inject minimal QuranData into [QuranService] for testing.
///
/// Mirrors the structure of [quran.json] but uses a very small dataset so
/// tests run without loading assets.
///
/// Dataset used:
///   Surah 1 — Al-Fatihah: 7 ayat, entirely in Juz 1
///   Surah 2 — Al-Baqarah: 286 ayat, spans Juz 1 (1–141), Juz 2 (142–252), Juz 3 (253–286)
///   Surah 3 — Ali Imran : 200 ayat, spans Juz 3 (1–92),  Juz 4 (93–200)
void _injectTestData() {
  final testData = QuranData(
    surahs: [
      SurahModel(
        id: 1,
        name: 'Al-Fatihah',
        nameAr: 'الفاتحة',
        ayatCount: 7,
        juzStart: 1,
        juzMappings: [
          const JuzSegmentModel(juz: 1, ayatStart: 1, ayatEnd: 7),
        ],
      ),
      SurahModel(
        id: 2,
        name: 'Al-Baqarah',
        nameAr: 'البقرة',
        ayatCount: 286,
        juzStart: 1,
        juzMappings: [
          const JuzSegmentModel(juz: 1, ayatStart: 1, ayatEnd: 141),
          const JuzSegmentModel(juz: 2, ayatStart: 142, ayatEnd: 252),
          const JuzSegmentModel(juz: 3, ayatStart: 253, ayatEnd: 286),
        ],
      ),
      SurahModel(
        id: 3,
        name: 'Ali Imran',
        nameAr: 'آل عمران',
        ayatCount: 200,
        juzStart: 3,
        juzMappings: [
          const JuzSegmentModel(juz: 3, ayatStart: 1, ayatEnd: 92),
          const JuzSegmentModel(juz: 4, ayatStart: 93, ayatEnd: 200),
        ],
      ),
    ],
    juz: [
      JuzModel(
        number: 1,
        totalAyat: 148, // 7 (Al-Fatihah) + 141 (Al-Baqarah 1–141)
        surahs: [
          const JuzSegmentModel(surahId: 1, ayatStart: 1, ayatEnd: 7),
          const JuzSegmentModel(surahId: 2, ayatStart: 1, ayatEnd: 141),
        ],
      ),
      JuzModel(
        number: 2,
        totalAyat: 111, // Al-Baqarah 142–252
        surahs: [
          const JuzSegmentModel(surahId: 2, ayatStart: 142, ayatEnd: 252),
        ],
      ),
      JuzModel(
        number: 3,
        totalAyat: 126, // Al-Baqarah 253–286 (34) + Ali Imran 1–92 (92)
        surahs: [
          const JuzSegmentModel(surahId: 2, ayatStart: 253, ayatEnd: 286),
          const JuzSegmentModel(surahId: 3, ayatStart: 1, ayatEnd: 92),
        ],
      ),
      JuzModel(
        number: 4,
        totalAyat: 108, // Ali Imran 93–200
        surahs: [
          const JuzSegmentModel(surahId: 3, ayatStart: 93, ayatEnd: 200),
        ],
      ),
    ],
  );

  QuranService.instance.injectForTest(testData);
}

void main() {
  setUpAll(_injectTestData);

  // ---------------------------------------------------------------------------
  // Helper
  // ---------------------------------------------------------------------------

  OverallHafalanProgress calc(List<Map<String, int>> segments) =>
      QuranService.instance.calculateProgress(segments);

  JuzProgress juzOf(OverallHafalanProgress p, int juzNumber) =>
      p.juzProgressList.firstWhere((j) => j.juzNumber == juzNumber);

  // ---------------------------------------------------------------------------
  // Core regression: the clamp() phantom-ayat bug
  // ---------------------------------------------------------------------------

  group('calculateProgress — regression: no phantom ayat in non-overlapping juz', () {
    /// THE REPORTED BUG: setoran Al-Baqarah ayat 1–50 (entirely in Juz 1)
    /// should NOT add any ayat to Juz 2 or Juz 3.
    test('Al-Baqarah 1–50: only Juz 1 gains progress, Juz 2 and Juz 3 stay at 0', () {
      final p = calc([
        {'surah_id': 2, 'ayat_start': 1, 'ayat_end': 50},
      ]);

      // Juz 1: Al-Baqarah 1–50 are all within the Juz-1 segment (1–141) → 50 ayat
      expect(juzOf(p, 1).memorizedAyat, equals(50),
          reason: 'Juz 1 should count all 50 memorised ayat of Al-Baqarah');

      // Juz 2: Al-Baqarah starts at ayat 142 in Juz 2 — no overlap with 1–50 → 0 ayat
      expect(juzOf(p, 2).memorizedAyat, equals(0),
          reason: 'Juz 2 must NOT gain phantom ayat when range is entirely in Juz 1');

      // Juz 3: Al-Baqarah starts at ayat 253 in Juz 3 — no overlap with 1–50 → 0 ayat
      expect(juzOf(p, 3).memorizedAyat, equals(0),
          reason: 'Juz 3 must NOT gain phantom ayat when range is entirely in Juz 1');
    });

    /// Edge: setoran from the very end of Juz 1 boundary (ayat 141), just inside
    test('Al-Baqarah ayat 141 (boundary of Juz 1): only Juz 1 gets 1 ayat', () {
      final p = calc([
        {'surah_id': 2, 'ayat_start': 141, 'ayat_end': 141},
      ]);

      expect(juzOf(p, 1).memorizedAyat, equals(1));
      expect(juzOf(p, 2).memorizedAyat, equals(0));
      expect(juzOf(p, 3).memorizedAyat, equals(0));
    });

    /// Edge: setoran crosses the Juz 1–2 boundary (ayat 135–150)
    test('Al-Baqarah 135–150: Juz 1 gets 7 ayat (135–141), Juz 2 gets 9 ayat (142–150)', () {
      final p = calc([
        {'surah_id': 2, 'ayat_start': 135, 'ayat_end': 150},
      ]);

      expect(juzOf(p, 1).memorizedAyat, equals(7),  // 141-135+1 = 7
          reason: 'Juz 1 segment: ayat 135–141 = 7 ayat');
      expect(juzOf(p, 2).memorizedAyat, equals(9),  // 150-142+1 = 9
          reason: 'Juz 2 segment: ayat 142–150 = 9 ayat');
      expect(juzOf(p, 3).memorizedAyat, equals(0));
    });

    /// Complete surah entirely in one juz: Al-Fatihah (all 7 ayat, Juz 1 only)
    test('Al-Fatihah complete: Juz 1 gets 7 ayat, others stay 0', () {
      final p = calc([
        {'surah_id': 1, 'ayat_start': 1, 'ayat_end': 7},
      ]);

      expect(juzOf(p, 1).memorizedAyat, equals(7));
      expect(juzOf(p, 2).memorizedAyat, equals(0));
      expect(juzOf(p, 3).memorizedAyat, equals(0));
      expect(juzOf(p, 4).memorizedAyat, equals(0));
    });

    /// Setoran entirely within Juz 2 portion of Al-Baqarah (ayat 200–220)
    test('Al-Baqarah 200–220 (entirely in Juz 2): only Juz 2 progresses', () {
      final p = calc([
        {'surah_id': 2, 'ayat_start': 200, 'ayat_end': 220},
      ]);

      expect(juzOf(p, 1).memorizedAyat, equals(0));
      expect(juzOf(p, 2).memorizedAyat, equals(21)); // 220-200+1 = 21
      expect(juzOf(p, 3).memorizedAyat, equals(0));
    });

    /// Setoran that crosses Juz 2–3 boundary (Al-Baqarah 245–260)
    test('Al-Baqarah 245–260: Juz 2 gets 8 ayat (245–252), Juz 3 gets 8 ayat (253–260)', () {
      final p = calc([
        {'surah_id': 2, 'ayat_start': 245, 'ayat_end': 260},
      ]);

      expect(juzOf(p, 1).memorizedAyat, equals(0));
      expect(juzOf(p, 2).memorizedAyat, equals(8));  // 252-245+1 = 8
      expect(juzOf(p, 3).memorizedAyat, equals(8));  // 260-253+1 = 8
      expect(juzOf(p, 4).memorizedAyat, equals(0));
    });
  });

  // ---------------------------------------------------------------------------
  // Overlap merging — duplicate / overlapping segments
  // ---------------------------------------------------------------------------

  group('calculateProgress — overlapping segment deduplication', () {
    test('two overlapping ranges for same surah do not double-count', () {
      // Al-Baqarah ayat 1–100 AND ayat 50–141 — overlap is 50–100
      final p = calc([
        {'surah_id': 2, 'ayat_start': 1, 'ayat_end': 100},
        {'surah_id': 2, 'ayat_start': 50, 'ayat_end': 141},
      ]);

      // Total unique ayat in Juz 1 = 1–141 = 141 (all of them)
      expect(juzOf(p, 1).memorizedAyat, equals(141));
      expect(juzOf(p, 2).memorizedAyat, equals(0));
    });

    test('identical duplicate segment is counted only once', () {
      final p = calc([
        {'surah_id': 2, 'ayat_start': 1, 'ayat_end': 50},
        {'surah_id': 2, 'ayat_start': 1, 'ayat_end': 50},
      ]);

      expect(juzOf(p, 1).memorizedAyat, equals(50));
      expect(juzOf(p, 2).memorizedAyat, equals(0));
      expect(juzOf(p, 3).memorizedAyat, equals(0));
    });
  });

  // ---------------------------------------------------------------------------
  // Complete juz
  // ---------------------------------------------------------------------------

  group('calculateProgress — complete juz detection', () {
    test('memorising all of Juz 2 marks Juz 2 as complete', () {
      // Al-Baqarah 142–252 = all of Juz 2
      final p = calc([
        {'surah_id': 2, 'ayat_start': 142, 'ayat_end': 252},
      ]);

      expect(juzOf(p, 2).isComplete, isTrue);
      expect(juzOf(p, 2).memorizedAyat, equals(111));
      expect(p.completedJuz, equals(1));
    });

    test('partial memorisation does not mark juz as complete', () {
      final p = calc([
        {'surah_id': 2, 'ayat_start': 142, 'ayat_end': 200},
      ]);

      expect(juzOf(p, 2).isComplete, isFalse);
      expect(p.completedJuz, equals(0));
    });
  });

  // ---------------------------------------------------------------------------
  // Empty / edge cases
  // ---------------------------------------------------------------------------

  group('calculateProgress — empty and edge cases', () {
    test('empty segments returns all zeros', () {
      final p = calc([]);

      expect(p.totalMemorized, equals(0));
      expect(p.completedJuz, equals(0));
      for (final j in p.juzProgressList) {
        expect(j.memorizedAyat, equals(0));
      }
    });

    test('totalMemorized equals sum of all juz memorizedAyat', () {
      final p = calc([
        {'surah_id': 1, 'ayat_start': 1, 'ayat_end': 7},    // 7 ayat in Juz 1
        {'surah_id': 2, 'ayat_start': 142, 'ayat_end': 252}, // 111 ayat in Juz 2
      ]);

      final sumFromJuz =
          p.juzProgressList.fold<int>(0, (sum, j) => sum + j.memorizedAyat);
      expect(p.totalMemorized, equals(sumFromJuz));
      expect(p.totalMemorized, equals(118)); // 7 + 111
    });
  });
}
