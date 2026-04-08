// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'guru_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_GuruModel _$GuruModelFromJson(Map<String, dynamic> json) => _GuruModel(
  id: json['id'] as String,
  nip: json['nip'] as String,
  nama: json['nama'] as String,
  phone: json['phone'] as String?,
  profilePicture: json['profilePicture'] as String?,
  program: json['program'] as String,
  authUid: json['authUid'] as String?,
  createdAt: DateTime.parse(json['createdAt'] as String),
  updatedAt: DateTime.parse(json['updatedAt'] as String),
);

Map<String, dynamic> _$GuruModelToJson(_GuruModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'nip': instance.nip,
      'nama': instance.nama,
      'phone': instance.phone,
      'profilePicture': instance.profilePicture,
      'program': instance.program,
      'authUid': instance.authUid,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
    };
