import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:logger/logger.dart';

import 'hafalan_progress.dart';
import 'juz_model.dart';
import 'juz_segment_model.dart';
import 'quran_data.dart';
import 'surah_model.dart';

/// Service for loading and querying Quran data from assets/data/quran.json.
///
/// Singleton — use [QuranService.instance].
/// Must call [initialize()] once before using any query methods,
/// typically in [main()] after Firebase and Hive init.
class QuranService {
  QuranService._();
  static final QuranService instance = QuranService._();

  final _log = Logger();

  QuranData? _data;
  bool _initialized = false;

  // O(1) lookup maps
  final Map<int, SurahModel> _surahById   = {};
  final Map<int, JuzModel>   _juzByNumber = {};

  // ── Init ──────────────────────────────────────────────────────────────────

  Future<void> initialize() async {
    if (_initialized) return;
    try {
      final raw  = await rootBundle.loadString('assets/data/quran.json');
      final json = jsonDecode(raw) as Map<String, dynamic>;
      _data = QuranData.fromJson(json);

      for (final s in _data!.surahs) {
        _surahById[s.id] = s;
      }
      for (final j in _data!.juz) {
        _juzByNumber[j.number] = j;
      }

      _initialized = true;
      _log.i('QuranService initialized: '
          '${_data!.surahs.length} surahs, '
          '${_data!.juz.length} juz');
    } catch (e, st) {
      _log.e('QuranService.initialize failed', error: e, stackTrace: st);
    }
  }

  void _assertInitialized() {
    assert(_initialized,
        'QuranService not initialized. Call initialize() first.');
  }

  // ── Surah queries ─────────────────────────────────────────────────────────

  List<SurahModel> getAllSurahs() {
    _assertInitialized();
    return List.unmodifiable(_data!.surahs);
  }

  SurahModel? getSurahById(int id) {
    _assertInitialized();
    return _surahById[id];
  }

  /// All surahs that appear (at least partially) in a given juz.
  List<SurahModel> getSurahsByJuz(int juzNumber) {
    _assertInitialized();
    return _data!.surahs
        .where((s) => s.juzNumbers.contains(juzNumber))
        .toList();
  }

  // ── Juz queries ───────────────────────────────────────────────────────────

  List<JuzModel> getAllJuz() {
    _assertInitialized();
    return List.unmodifiable(_data!.juz);
  }

  JuzModel? getJuzByNumber(int number) {
    _assertInitialized();
    return _juzByNumber[number];
  }

  int getTotalAyatInJuz(int juzNumber) {
    _assertInitialized();
    return _juzByNumber[juzNumber]?.totalAyat ?? 0;
  }

  int getTotalAyatForJuzList(List<int> juzNumbers) {
    _assertInitialized();
    return juzNumbers.fold(0, (sum, n) => sum + getTotalAyatInJuz(n));
  }

  // ── Validation ────────────────────────────────────────────────────────────

  bool isValidAyatRange({
    required int surahId,
    required int ayatStart,
    required int ayatEnd,
  }) {
    _assertInitialized();
    final surah = _surahById[surahId];
    if (surah == null) return false;
    return ayatStart >= 1 &&
        ayatEnd <= surah.ayatCount &&
        ayatStart <= ayatEnd;
  }

  // ── Progress calculation ──────────────────────────────────────────────────

  /// Calculates hafalan progress per juz for a santri.
  ///
  /// [memorizedSegments]: list of memorized ranges, each with keys:
  /// - surah_id  (int)
  /// - ayat_start (int)
  /// - ayat_end   (int)
  OverallHafalanProgress calculateProgress(
    List<Map<String, int>> memorizedSegments,
  ) {
    _assertInitialized();

    // Group memorized ranges by surah_id
    final Map<int, List<_AyatRange>> bySurah = {};
    for (final seg in memorizedSegments) {
      final sid = seg['surah_id']!;
      bySurah.putIfAbsent(sid, () => []).add(
        _AyatRange(seg['ayat_start']!, seg['ayat_end']!),
      );
    }

    final juzProgressList = <JuzProgress>[];

    for (final juz in _data!.juz) {
      final surahProgressList = <SurahProgress>[];
      int juzMemorized = 0;

      for (final juzSeg in juz.surahs) {
        final surah = _surahById[juzSeg.surahId];
        if (surah == null) continue;

        final surahSegInJuz = surah.segmentForJuz(juz.number);
        if (surahSegInJuz == null) continue;

        final ranges   = bySurah[surah.id] ?? [];
        final memorized = _countMemorizedInRange(
          ranges:     ranges,
          rangeStart: surahSegInJuz.ayatStart,
          rangeEnd:   surahSegInJuz.ayatEnd,
        );

        juzMemorized += memorized;
        surahProgressList.add(SurahProgress(
          surahId:       surah.id,
          surahName:     surah.name,
          totalAyat:     surahSegInJuz.ayatEnd - surahSegInJuz.ayatStart + 1,
          memorizedAyat: memorized,
        ));
      }

      juzProgressList.add(JuzProgress(
        juzNumber:         juz.number,
        totalAyat:         juz.totalAyat,
        memorizedAyat:     juzMemorized,
        surahProgressList: surahProgressList,
      ));
    }

    final totalMemorized = juzProgressList.fold<int>(
      0,
      (sum, j) => sum + j.memorizedAyat,
    );

    return OverallHafalanProgress(
      totalAyatQuran:  _data!.surahs.fold(0, (s, x) => s + x.ayatCount),
      totalMemorized:  totalMemorized,
      juzProgressList: juzProgressList,
    );
  }

  int _countMemorizedInRange({
    required List<_AyatRange> ranges,
    required int rangeStart,
    required int rangeEnd,
  }) {
    if (ranges.isEmpty) return 0;
    final memorized = <int>{};
    for (final r in ranges) {
      final s = r.start.clamp(rangeStart, rangeEnd);
      final e = r.end.clamp(rangeStart, rangeEnd);
      if (s > e) continue;
      for (int a = s; a <= e; a++) {
        memorized.add(a);
      }
    }
    return memorized.length;
  }

  /// Returns all segments for a list of target juz numbers.
  List<JuzSegmentModel> getSegmentsForJuzList(List<int> juzNumbers) {
    _assertInitialized();
    return juzNumbers
        .expand((n) => _juzByNumber[n]?.surahs ?? <JuzSegmentModel>[])
        .toList();
  }
}

class _AyatRange {
  final int start;
  final int end;
  const _AyatRange(this.start, this.end);
}