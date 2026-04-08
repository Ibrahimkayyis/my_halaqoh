import 'package:freezed_annotation/freezed_annotation.dart';
import 'juz_segment_model.dart';

part 'surah_model.freezed.dart';
part 'surah_model.g.dart';

/// Represents a single surah of the Quran with its juz mapping data.
@freezed
abstract class SurahModel with _$SurahModel {
  const factory SurahModel({
    required int id,
    required String name,
    @JsonKey(name: 'name_ar') required String nameAr,
    @JsonKey(name: 'ayat_count') required int ayatCount,
    @JsonKey(name: 'juz_start') required int juzStart,

    /// Each entry maps this surah to a juz: {juz, ayat_start, ayat_end}
    @JsonKey(name: 'juz_mappings')
    required List<JuzSegmentModel> juzMappings,
  }) = _SurahModel;

  const SurahModel._();

  factory SurahModel.fromJson(Map<String, dynamic> json) =>
      _$SurahModelFromJson(json);

  // ── Helpers ──────────────────────────────────────────────────────────────

  /// Returns true if this surah spans more than one juz.
  bool get isMultiJuz => juzMappings.length > 1;

  /// Returns juz numbers this surah belongs to.
  List<int> get juzNumbers => juzMappings.map((m) => m.juz).toList();

  /// Returns the segment for a given juz number. Null if not in that juz.
  JuzSegmentModel? segmentForJuz(int juzNumber) {
    try {
      return juzMappings.firstWhere((m) => m.juz == juzNumber);
    } catch (_) {
      return null;
    }
  }

  /// How many ayat of this surah fall in a given juz.
  int ayatCountInJuz(int juzNumber) {
    final seg = segmentForJuz(juzNumber);
    if (seg == null) return 0;
    return seg.ayatEnd - seg.ayatStart + 1;
  }

  /// Returns which juz a given ayat number belongs to.
  int? juzForAyat(int ayatNumber) {
    for (final seg in juzMappings) {
      if (ayatNumber >= seg.ayatStart && ayatNumber <= seg.ayatEnd) {
        return seg.juz;
      }
    }
    return null;
  }
}