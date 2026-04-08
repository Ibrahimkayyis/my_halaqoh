// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'surah_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_SurahModel _$SurahModelFromJson(Map<String, dynamic> json) => _SurahModel(
  id: (json['id'] as num).toInt(),
  name: json['name'] as String,
  nameAr: json['name_ar'] as String,
  ayatCount: (json['ayat_count'] as num).toInt(),
  juzStart: (json['juz_start'] as num).toInt(),
  juzMappings: (json['juz_mappings'] as List<dynamic>)
      .map((e) => JuzSegmentModel.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$SurahModelToJson(_SurahModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'name_ar': instance.nameAr,
      'ayat_count': instance.ayatCount,
      'juz_start': instance.juzStart,
      'juz_mappings': instance.juzMappings,
    };
