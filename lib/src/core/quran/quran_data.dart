import 'package:freezed_annotation/freezed_annotation.dart';
import 'juz_model.dart';
import 'surah_model.dart';

part 'quran_data.freezed.dart';
part 'quran_data.g.dart';

/// Top-level model representing the entire quran.json asset.
@freezed
abstract class QuranData with _$QuranData {
  const factory QuranData({
    required List<SurahModel> surahs,
    required List<JuzModel> juz,
  }) = _QuranData;

  const QuranData._();

  factory QuranData.fromJson(Map<String, dynamic> json) =>
      _$QuranDataFromJson(json);
}