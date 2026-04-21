import 'package:freezed_annotation/freezed_annotation.dart';

part 'hafalan_santri_model.freezed.dart';
part 'hafalan_santri_model.g.dart';

@freezed
abstract class HafalanSantriModel with _$HafalanSantriModel {
  const factory HafalanSantriModel({
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
    @Default(false) bool isSynced,
  }) = _HafalanSantriModel;

  factory HafalanSantriModel.fromJson(Map<String, dynamic> json) =>
      _$HafalanSantriModelFromJson(json);
}
