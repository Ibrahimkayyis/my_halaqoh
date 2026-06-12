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
      tahunAjaran: json['tahunAjaran'] as String? ?? '',
      semesterAktif: (json['semesterAktif'] as num?)?.toInt(),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$TargetHafalanModelToJson(_TargetHafalanModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'kelas': instance.kelas,
      'program': instance.program,
      'tahunAjaran': instance.tahunAjaran,
      'semesterAktif': instance.semesterAktif,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
    };
