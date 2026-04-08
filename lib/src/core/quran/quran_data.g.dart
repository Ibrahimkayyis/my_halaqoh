// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'quran_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_QuranData _$QuranDataFromJson(Map<String, dynamic> json) => _QuranData(
  surahs: (json['surahs'] as List<dynamic>)
      .map((e) => SurahModel.fromJson(e as Map<String, dynamic>))
      .toList(),
  juz: (json['juz'] as List<dynamic>)
      .map((e) => JuzModel.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$QuranDataToJson(_QuranData instance) =>
    <String, dynamic>{'surahs': instance.surahs, 'juz': instance.juz};
