import 'package:freezed_annotation/freezed_annotation.dart';

part 'santri_extra_target_model.freezed.dart';

/// Stores juz numbers that a teacher has manually added as targets for a
/// specific santri, beyond the admin-defined [TargetHafalanModel].
///
/// Firestore path: `/santriExtraTarget/{santriId}`
/// The document ID equals [santriId].
@freezed
abstract class SantriExtraTargetModel with _$SantriExtraTargetModel {
  const factory SantriExtraTargetModel({
    /// Santri document ID — also the Firestore document ID.
    required String santriId,

    /// Juz numbers added by the teacher. May be empty.
    @Default([]) List<int> extraJuz,

    required DateTime updatedAt,
  }) = _SantriExtraTargetModel;
}
