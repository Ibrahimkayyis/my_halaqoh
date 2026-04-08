// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'halaqoh_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_HalaqohModel _$HalaqohModelFromJson(Map<String, dynamic> json) =>
    _HalaqohModel(
      id: json['id'] as String,
      nama: json['nama'] as String,
      kelas: json['kelas'] as String,
      program: json['program'] as String,
      guruId: json['guruId'] as String,
      guruNama: json['guruNama'] as String,
      santriIds:
          (json['santriIds'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      jumlahSantri: (json['jumlahSantri'] as num?)?.toInt() ?? 0,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$HalaqohModelToJson(_HalaqohModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'nama': instance.nama,
      'kelas': instance.kelas,
      'program': instance.program,
      'guruId': instance.guruId,
      'guruNama': instance.guruNama,
      'santriIds': instance.santriIds,
      'jumlahSantri': instance.jumlahSantri,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
    };
