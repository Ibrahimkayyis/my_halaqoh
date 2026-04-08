// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'juz_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_JuzModel _$JuzModelFromJson(Map<String, dynamic> json) => _JuzModel(
  number: (json['number'] as num).toInt(),
  totalAyat: (json['total_ayat'] as num).toInt(),
  surahs: (json['surahs'] as List<dynamic>)
      .map((e) => JuzSegmentModel.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$JuzModelToJson(_JuzModel instance) => <String, dynamic>{
  'number': instance.number,
  'total_ayat': instance.totalAyat,
  'surahs': instance.surahs,
};
