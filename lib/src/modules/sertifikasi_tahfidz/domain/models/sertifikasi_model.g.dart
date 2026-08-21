// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sertifikasi_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_SertifikasiModel _$SertifikasiModelFromJson(Map<String, dynamic> json) =>
    _SertifikasiModel(
      id: json['id'] as String,
      santriId: json['santriId'] as String,
      santriNama: json['santriNama'] as String,
      nis: json['nis'] as String,
      kelas: json['kelas'] as String,
      program: json['program'] as String,
      profilePicture: json['profilePicture'] as String?,
      halaqohId: json['halaqohId'] as String,
      halaqohNama: json['halaqohNama'] as String,
      guruId: json['guruId'] as String,
      guruNama: json['guruNama'] as String,
      juz: (json['juz'] as num).toInt(),
      catatanGuru: json['catatanGuru'] as String?,
      status: json['status'] as String? ?? 'pending',
      tanggalUjian: json['tanggalUjian'] == null
          ? null
          : DateTime.parse(json['tanggalUjian'] as String),
      sesiUjian: json['sesiUjian'] as String?,
      pengujiId: json['pengujiId'] as String?,
      pengujiNama: json['pengujiNama'] as String?,
      catatanAdmin: json['catatanAdmin'] as String?,
      alasanPenolakan: json['alasanPenolakan'] as String?,
      nilaiKelancaran: (json['nilaiKelancaran'] as num?)?.toDouble(),
      nilaiTajwid: (json['nilaiTajwid'] as num?)?.toDouble(),
      nilaiMakhroj: (json['nilaiMakhroj'] as num?)?.toDouble(),
      nilaiTotal: (json['nilaiTotal'] as num?)?.toDouble(),
      predikat: json['predikat'] as String?,
      catatanPenguji: json['catatanPenguji'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      completedAt: json['completedAt'] == null
          ? null
          : DateTime.parse(json['completedAt'] as String),
    );

Map<String, dynamic> _$SertifikasiModelToJson(_SertifikasiModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'santriId': instance.santriId,
      'santriNama': instance.santriNama,
      'nis': instance.nis,
      'kelas': instance.kelas,
      'program': instance.program,
      'profilePicture': instance.profilePicture,
      'halaqohId': instance.halaqohId,
      'halaqohNama': instance.halaqohNama,
      'guruId': instance.guruId,
      'guruNama': instance.guruNama,
      'juz': instance.juz,
      'catatanGuru': instance.catatanGuru,
      'status': instance.status,
      'tanggalUjian': instance.tanggalUjian?.toIso8601String(),
      'sesiUjian': instance.sesiUjian,
      'pengujiId': instance.pengujiId,
      'pengujiNama': instance.pengujiNama,
      'catatanAdmin': instance.catatanAdmin,
      'alasanPenolakan': instance.alasanPenolakan,
      'nilaiKelancaran': instance.nilaiKelancaran,
      'nilaiTajwid': instance.nilaiTajwid,
      'nilaiMakhroj': instance.nilaiMakhroj,
      'nilaiTotal': instance.nilaiTotal,
      'predikat': instance.predikat,
      'catatanPenguji': instance.catatanPenguji,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
      'completedAt': instance.completedAt?.toIso8601String(),
    };
