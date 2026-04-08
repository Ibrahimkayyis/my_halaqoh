/// Represents calculated hafalan progress for a single surah.
class SurahProgress {
  final int surahId;
  final String surahName;
  final int totalAyat;
  final int memorizedAyat;

  const SurahProgress({
    required this.surahId,
    required this.surahName,
    required this.totalAyat,
    required this.memorizedAyat,
  });

  double get percentage =>
      totalAyat == 0 ? 0 : memorizedAyat / totalAyat;

  bool get isComplete => memorizedAyat >= totalAyat;
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