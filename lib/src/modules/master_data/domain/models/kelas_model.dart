import 'package:freezed_annotation/freezed_annotation.dart';

part 'kelas_model.freezed.dart';
part 'kelas_model.g.dart';

@freezed
abstract class KelasModel with _$KelasModel {
  const factory KelasModel({
    required String id,        // unique ID (e.g., '7', '8', dll)
    required String nama,      // e.g., '7', '8', '9'
    required int urutan,       // tingkat/urutan kelas
    String? nextKelasId,       // ID kelas berikutnya (null = alumni/lulus)
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _KelasModel;

  factory KelasModel.fromJson(Map<String, dynamic> json) => _$KelasModelFromJson(json);
}
