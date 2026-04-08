// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'target_hafalan_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_TargetHafalanModel _$TargetHafalanModelFromJson(Map<String, dynamic> json) =>
    _TargetHafalanModel(
      id: json['id'] as String,
      kelas: json['kelas'] as String,
      program: json['program'] as String,
      targetJuz: (json['targetJuz'] as num).toInt(),
      juzList:
          (json['juzList'] as List<dynamic>?)
              ?.map((e) => (e as num).toInt())
              .toList() ??
          const [],
      tahunAjaran: json['tahunAjaran'] as String? ?? '',
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$TargetHafalanModelToJson(_TargetHafalanModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'kelas': instance.kelas,
      'program': instance.program,
      'targetJuz': instance.targetJuz,
      'juzList': instance.juzList,
      'tahunAjaran': instance.tahunAjaran,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
    };
