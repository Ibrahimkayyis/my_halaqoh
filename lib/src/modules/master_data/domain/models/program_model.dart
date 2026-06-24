import 'package:freezed_annotation/freezed_annotation.dart';

part 'program_model.freezed.dart';
part 'program_model.g.dart';

@freezed
abstract class ProgramModel with _$ProgramModel {
  const factory ProgramModel({
    required String id,        // unique ID (e.g., 'R', 'T')
    required String nama,      // e.g., 'Reguler', 'Takhassus'
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _ProgramModel;

  factory ProgramModel.fromJson(Map<String, dynamic> json) => _$ProgramModelFromJson(json);
}
