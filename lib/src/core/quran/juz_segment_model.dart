import 'package:freezed_annotation/freezed_annotation.dart';

part 'juz_segment_model.freezed.dart';
part 'juz_segment_model.g.dart';

/// Used in two contexts:
/// 1. [SurahModel.juzMappings] — field "juz" = juz number, ayat range within that juz
/// 2. [JuzModel.surahs]       — field "surahId" = surah number, ayat range within that surah
@freezed
abstract class JuzSegmentModel with _$JuzSegmentModel {
  const factory JuzSegmentModel({
    /// In SurahModel.juzMappings: the juz number.
    /// In JuzModel.surahs: not used (use surahId instead).
    @Default(0) int juz,

    /// In JuzModel.surahs: the surah ID.
    /// In SurahModel.juzMappings: not used (use juz instead).
    @JsonKey(name: 'surah_id') @Default(0) int surahId,

    @JsonKey(name: 'ayat_start') required int ayatStart,
    @JsonKey(name: 'ayat_end') required int ayatEnd,
  }) = _JuzSegmentModel;

  factory JuzSegmentModel.fromJson(Map<String, dynamic> json) =>
      _$JuzSegmentModelFromJson(json);
}