import 'package:freezed_annotation/freezed_annotation.dart';

part 'wali_santri_model.freezed.dart';
part 'wali_santri_model.g.dart';

/// Nested model representing wali santri (parent/guardian) info.
/// Stored inside SantriModel document, not a separate collection.
@freezed
abstract class WaliSantriModel with _$WaliSantriModel {
  const factory WaliSantriModel({
    required String nama,
    required String phone,
    /// "Ayah", "Ibu", or "Wali"
    required String hubungan,
  }) = _WaliSantriModel;

  factory WaliSantriModel.fromJson(Map<String, dynamic> json) =>
      _$WaliSantriModelFromJson(json);
}
