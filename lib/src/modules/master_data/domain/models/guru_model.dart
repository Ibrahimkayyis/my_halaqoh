import 'package:freezed_annotation/freezed_annotation.dart';

part 'guru_model.freezed.dart';
part 'guru_model.g.dart';

/// Domain model for Guru (teacher/ustadz).
/// Maps to Firestore collection: `/guru/{id}`
@freezed
abstract class GuruModel with _$GuruModel {
  const factory GuruModel({
    /// Firestore document ID
    required String id,

    /// NIP — 13 digit unique identifier, also used for login
    required String nip,

    /// Full name, e.g. "Ustadz Ahmad Fauzi, S.Pd.I"
    required String nama,

    /// Phone number
    required String phone,

    /// Firebase Auth UID (nullable — set after auth account is created)
    String? authUid,

    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _GuruModel;

  factory GuruModel.fromJson(Map<String, dynamic> json) =>
      _$GuruModelFromJson(json);
}
