// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'santri_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_SantriModel _$SantriModelFromJson(Map<String, dynamic> json) => _SantriModel(
  id: json['id'] as String,
  nis: json['nis'] as String,
  nama: json['nama'] as String,
  profilePicture: json['profilePicture'] as String?,
  kelas: json['kelas'] as String,
  program: json['program'] as String,
  halaqohId: json['halaqohId'] as String?,
  waliSantri: json['waliSantri'] == null
      ? null
      : WaliSantriModel.fromJson(json['waliSantri'] as Map<String, dynamic>),
  authUid: json['authUid'] as String?,
  isAlumni: json['isAlumni'] as bool? ?? false,
  createdAt: DateTime.parse(json['createdAt'] as String),
  updatedAt: DateTime.parse(json['updatedAt'] as String),
);

Map<String, dynamic> _$SantriModelToJson(_SantriModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'nis': instance.nis,
      'nama': instance.nama,
      'profilePicture': instance.profilePicture,
      'kelas': instance.kelas,
      'program': instance.program,
      'halaqohId': instance.halaqohId,
      'waliSantri': instance.waliSantri,
      'authUid': instance.authUid,
      'isAlumni': instance.isAlumni,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
    };
