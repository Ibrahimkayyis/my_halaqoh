import 'package:freezed_annotation/freezed_annotation.dart';
import 'juz_segment_model.dart';

part 'juz_model.freezed.dart';
part 'juz_model.g.dart';

/// Represents a single juz of the Quran.
/// [surahs] contains segments where [JuzSegmentModel.surahId] is the surah number.
@freezed
abstract class JuzModel with _$JuzModel {
  const factory JuzModel({
    required int number,
    @JsonKey(name: 'total_ayat') required int totalAyat,
    required List<JuzSegmentModel> surahs,
  }) = _JuzModel;

  const JuzModel._();

  factory JuzModel.fromJson(Map<String, dynamic> json) =>
      _$JuzModelFromJson(json);

  // ── Helpers ──────────────────────────────────────────────────────────────

  /// Returns all surah IDs in this juz.
  List<int> get surahIds => surahs.map((s) => s.surahId).toList();

  /// Returns the segment for a specific surah. Null if not in this juz.
  JuzSegmentModel? segmentForSurah(int surahId) {
    try {
      return surahs.firstWhere((s) => s.surahId == surahId);
    } catch (_) {
      return null;
    }
  }
}