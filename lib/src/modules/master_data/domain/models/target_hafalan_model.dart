import 'package:freezed_annotation/freezed_annotation.dart';

part 'target_hafalan_model.freezed.dart';
part 'target_hafalan_model.g.dart';

/// Domain model for Target Hafalan per class + program.
/// Maps to Firestore collection: `/targetHafalan/{id}`
/// Document ID format: "{kelas}_{program}", e.g. "7_Reguler"
///
/// NOTE: The actual curriculum content (which juz per semester/period) is
/// stored as compile-time constants in [CurriculumData], not in this model.
/// This model only stores admin-configured metadata: tahunAjaran + semesterAktif.
@freezed
abstract class TargetHafalanModel with _$TargetHafalanModel {
  const factory TargetHafalanModel({
    /// Document ID: "{kelas}_{program}", e.g. "7_Reguler"
    required String id,

    /// Class level: "7", "8", ..., "12"
    required String kelas,

    /// Program: "Reguler" or "Takhassus"
    required String program,

    /// Academic year, e.g. "2025 / 2026"
    @Default('') String tahunAjaran,

    /// Active semester set by admin: 1 or 2. Null = not yet set.
    @Default(null) int? semesterAktif,

    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _TargetHafalanModel;

  factory TargetHafalanModel.fromJson(Map<String, dynamic> json) =>
      _$TargetHafalanModelFromJson(json);
}
