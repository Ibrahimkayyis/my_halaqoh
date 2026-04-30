// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'absensi_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AbsensiModel _$AbsensiModelFromJson(Map<String, dynamic> json) =>
    _AbsensiModel(
      id: json['id'] as String,
      halaqohId: json['halaqohId'] as String,
      guruId: json['guruId'] as String,
      tanggal: DateTime.parse(json['tanggal'] as String),
      sesi: json['sesi'] as String,
      records: (json['records'] as List<dynamic>)
          .map((e) => AbsensiRecordEntry.fromJson(e as Map<String, dynamic>))
          .toList(),
      isSynced: json['isSynced'] as bool? ?? false,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      notifiedAt: json['notifiedAt'] == null
          ? null
          : DateTime.parse(json['notifiedAt'] as String),
    );

Map<String, dynamic> _$AbsensiModelToJson(_AbsensiModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'halaqohId': instance.halaqohId,
      'guruId': instance.guruId,
      'tanggal': instance.tanggal.toIso8601String(),
      'sesi': instance.sesi,
      'records': instance.records,
      'isSynced': instance.isSynced,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
      'notifiedAt': instance.notifiedAt?.toIso8601String(),
    };
