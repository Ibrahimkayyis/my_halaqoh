/// Represents calculated hafalan progress for a single surah.
class SurahProgress {
  final int surahId;
  final String surahName;
  final int totalAyat;
  final int memorizedAyat;
  final Set<int> memorizedAyats;

  const SurahProgress({
    required this.surahId,
    required this.surahName,
    required this.totalAyat,
    required this.memorizedAyat,
    this.memorizedAyats = const {},
  });

  double get percentage =>
      totalAyat == 0 ? 0 : memorizedAyat / totalAyat;

  bool get isComplete => memorizedAyat >= totalAyat;

  /// Returns exact count of memorized ayat within [rangeStart]..[rangeEnd].
  /// Uses [memorizedAyats] when populated; falls back to sequential estimate
  /// from [segmentStart] only for legacy/mock instances without [memorizedAyats].
  int countMemorizedInSubRange(
    int rangeStart,
    int rangeEnd, {
    required int segmentStart,
  }) {
    if (memorizedAyat <= 0 || rangeStart > rangeEnd) return 0;
    if (memorizedAyats.isNotEmpty) {
      int count = 0;
      for (final ayat in memorizedAyats) {
        if (ayat >= rangeStart && ayat <= rangeEnd) {
          count++;
        }
      }
      return count;
    }
    final memorizedLimit = segmentStart + memorizedAyat - 1;
    final actualStart = rangeStart > segmentStart ? rangeStart : segmentStart;
    final actualEnd = rangeEnd < memorizedLimit ? rangeEnd : memorizedLimit;
    return actualStart <= actualEnd ? (actualEnd - actualStart + 1) : 0;
  }
}

/// Represents calculated hafalan progress for a single juz.
class JuzProgress {
  final int juzNumber;
  final int totalAyat;
  final int memorizedAyat;
  final List<SurahProgress> surahProgressList;

  const JuzProgress({
    required this.juzNumber,
    required this.totalAyat,
    required this.memorizedAyat,
    required this.surahProgressList,
  });

  double get percentage =>
      totalAyat == 0 ? 0 : memorizedAyat / totalAyat;

  bool get isComplete => memorizedAyat >= totalAyat;
}

/// Represents overall hafalan progress for a santri.
class OverallHafalanProgress {
  final int totalAyatQuran;
  final int totalMemorized;
  final List<JuzProgress> juzProgressList;

  const OverallHafalanProgress({
    required this.totalAyatQuran,
    required this.totalMemorized,
    required this.juzProgressList,
  });

  double get percentage =>
      totalAyatQuran == 0 ? 0 : totalMemorized / totalAyatQuran;

  /// Total juz completed (all ayat memorized).
  int get completedJuz =>
      juzProgressList.where((j) => j.isComplete).length;
}