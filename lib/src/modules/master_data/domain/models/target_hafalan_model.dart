import 'package:freezed_annotation/freezed_annotation.dart';

part 'target_hafalan_model.freezed.dart';
part 'target_hafalan_model.g.dart';

/// Domain model for Target Hafalan per class + program.
/// Maps to Firestore collection: `/targetHafalan/{id}`
/// Document ID format: "{kelas}_{program}", e.g. "7_Reguler"
@freezed
abstract class TargetHafalanModel with _$TargetHafalanModel {
  const factory TargetHafalanModel({
    /// Document ID: "{kelas}_{program}", e.g. "7_Reguler"
    required String id,

    /// Class level: "7", "8", ..., "12"
    required String kelas,

    /// Program: "Reguler" or "Takhassus"
    required String program,

    /// Number of target juz, e.g. 2 or 5
    required int targetJuz,

    /// List of specific juz numbers, e.g. [29, 30]
    @Default([]) List<int> juzList,

    /// Academic year, e.g. "2025 / 2026"
    @Default('') String tahunAjaran,

    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _TargetHafalanModel;

  factory TargetHafalanModel.fromJson(Map<String, dynamic> json) =>
      _$TargetHafalanModelFromJson(json);
}
