// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hafalan_santri_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_HafalanSantriModel _$HafalanSantriModelFromJson(Map<String, dynamic> json) =>
    _HafalanSantriModel(
      id: json['id'] as String,
      santriId: json['santriId'] as String,
      guruId: json['guruId'] as String,
      halaqohId: json['halaqohId'] as String,
      tanggalSetoran: DateTime.parse(json['tanggalSetoran'] as String),
      jenis: json['jenis'] as String,
      surahId: (json['surahId'] as num).toInt(),
      surahName: json['surahName'] as String,
      ayatMulai: (json['ayatMulai'] as num).toInt(),
      ayatSelesai: (json['ayatSelesai'] as num).toInt(),
      juz: (json['juz'] as num).toInt(),
      nilaiKelancaran: (json['nilaiKelancaran'] as num).toInt(),
      nilaiTajwid: (json['nilaiTajwid'] as num).toInt(),
      createdAt: DateTime.parse(json['createdAt'] as String),
      isSynced: json['isSynced'] as bool? ?? false,
      notifiedAt: json['notifiedAt'] == null
          ? null
          : DateTime.parse(json['notifiedAt'] as String),
    );

Map<String, dynamic> _$HafalanSantriModelToJson(_HafalanSantriModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'santriId': instance.santriId,
      'guruId': instance.guruId,
      'halaqohId': instance.halaqohId,
      'tanggalSetoran': instance.tanggalSetoran.toIso8601String(),
      'jenis': instance.jenis,
      'surahId': instance.surahId,
      'surahName': instance.surahName,
      'ayatMulai': instance.ayatMulai,
      'ayatSelesai': instance.ayatSelesai,
      'juz': instance.juz,
      'nilaiKelancaran': instance.nilaiKelancaran,
      'nilaiTajwid': instance.nilaiTajwid,
      'createdAt': instance.createdAt.toIso8601String(),
      'isSynced': instance.isSynced,
      'notifiedAt': instance.notifiedAt?.toIso8601String(),
    };
