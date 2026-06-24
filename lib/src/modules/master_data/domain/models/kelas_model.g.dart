// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'kelas_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_KelasModel _$KelasModelFromJson(Map<String, dynamic> json) => _KelasModel(
  id: json['id'] as String,
  nama: json['nama'] as String,
  urutan: (json['urutan'] as num).toInt(),
  nextKelasId: json['nextKelasId'] as String?,
  createdAt: DateTime.parse(json['createdAt'] as String),
  updatedAt: DateTime.parse(json['updatedAt'] as String),
);

Map<String, dynamic> _$KelasModelToJson(_KelasModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'nama': instance.nama,
      'urutan': instance.urutan,
      'nextKelasId': instance.nextKelasId,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
    };
