// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'juz_segment_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_JuzSegmentModel _$JuzSegmentModelFromJson(Map<String, dynamic> json) =>
    _JuzSegmentModel(
      juz: (json['juz'] as num?)?.toInt() ?? 0,
      surahId: (json['surah_id'] as num?)?.toInt() ?? 0,
      ayatStart: (json['ayat_start'] as num).toInt(),
      ayatEnd: (json['ayat_end'] as num).toInt(),
    );

Map<String, dynamic> _$JuzSegmentModelToJson(_JuzSegmentModel instance) =>
    <String, dynamic>{
      'juz': instance.juz,
      'surah_id': instance.surahId,
      'ayat_start': instance.ayatStart,
      'ayat_end': instance.ayatEnd,
    };
