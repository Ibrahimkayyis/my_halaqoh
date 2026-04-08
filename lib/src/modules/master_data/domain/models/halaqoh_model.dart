import 'package:freezed_annotation/freezed_annotation.dart';

part 'halaqoh_model.freezed.dart';
part 'halaqoh_model.g.dart';

/// Domain model for Halaqoh (Quran study group).
/// Maps to Firestore collection: `/halaqoh/{id}`
@freezed
abstract class HalaqohModel with _$HalaqohModel {
  const factory HalaqohModel({
    /// Firestore document ID
    required String id,

    /// Free-text name, e.g. "AL FATIH 1"
    required String nama,

    /// Class level: "7", "8", ..., "12"
    required String kelas,

    /// Program type: "R" (Reguler) or "T" (Takhassus)
    required String program,

    /// Reference to guru document ID
    required String guruId,

    /// Denormalized guru name for display without extra query
    required String guruNama,

    /// List of santri document IDs in this halaqoh
    @Default([]) List<String> santriIds,

    /// Denormalized santri count
    @Default(0) int jumlahSantri,

    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _HalaqohModel;

  factory HalaqohModel.fromJson(Map<String, dynamic> json) =>
      _$HalaqohModelFromJson(json);
}
