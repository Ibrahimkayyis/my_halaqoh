import 'package:freezed_annotation/freezed_annotation.dart';

part 'wali_santri_hafalan_model.freezed.dart';
part 'wali_santri_hafalan_model.g.dart';

@freezed
abstract class WaliSantriHafalanModel with _$WaliSantriHafalanModel {
  const factory WaliSantriHafalanModel({
    required String id,
    required String santriId,
    required String guruId,
    required String halaqohId,
    required DateTime tanggalSetoran,
    required String jenis, // "Ziyadah" or "Murajaah"
    required int surahId,
    required String surahName,
    required int ayatMulai,
    required int ayatSelesai,
    required int juz,
    required int nilaiKelancaran,
    required int nilaiTajwid,
    required DateTime createdAt,
  }) = _WaliSantriHafalanModel;

  factory WaliSantriHafalanModel.fromJson(Map<String, dynamic> json) =>
      _$WaliSantriHafalanModelFromJson(json);
}
