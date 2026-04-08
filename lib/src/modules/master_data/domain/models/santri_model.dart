import 'package:freezed_annotation/freezed_annotation.dart';
import 'wali_santri_model.dart';

part 'santri_model.freezed.dart';
part 'santri_model.g.dart';

/// Domain model for Santri (student).
/// Maps to Firestore collection: `/santri/{id}`
@freezed
abstract class SantriModel with _$SantriModel {
  const factory SantriModel({
    /// Firestore document ID
    required String id,

    /// NIS — 12 digit unique identifier, also the barcode value on student card
    required String nis,

    /// Full name
    required String nama,

    /// Class level: "7", "8", "9", "10", "11", "12"
    required String kelas,

    /// Program type: "R" (Reguler) or "T" (Takhassus)
    required String program,

    /// Reference to halaqoh document ID (nullable — assigned when halaqoh is created)
    String? halaqohId,

    /// Nested wali santri (parent/guardian) information
    WaliSantriModel? waliSantri,

    /// Firebase Auth UID (nullable — set after auth account is created)
    String? authUid,

    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _SantriModel;

  factory SantriModel.fromJson(Map<String, dynamic> json) =>
      _$SantriModelFromJson(json);
}
