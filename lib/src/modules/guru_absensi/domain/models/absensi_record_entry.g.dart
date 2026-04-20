// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'absensi_record_entry.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AbsensiRecordEntry _$AbsensiRecordEntryFromJson(Map<String, dynamic> json) =>
    _AbsensiRecordEntry(
      santriId: json['santriId'] as String,
      nis: json['nis'] as String,
      nama: json['nama'] as String,
      status: json['status'] as String,
    );

Map<String, dynamic> _$AbsensiRecordEntryToJson(_AbsensiRecordEntry instance) =>
    <String, dynamic>{
      'santriId': instance.santriId,
      'nis': instance.nis,
      'nama': instance.nama,
      'status': instance.status,
    };
