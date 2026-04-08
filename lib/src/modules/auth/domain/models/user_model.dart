import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_model.freezed.dart';
part 'user_model.g.dart';

/// User metadata stored in Firestore `/users/{uid}`
@freezed
abstract class UserModel with _$UserModel {
  const factory UserModel({
    /// Firebase Auth UID
    required String uid,
    
    /// The unique login string (NIP, NIS, or "admin")
    required String identifier,
    
    /// Role of the user: "admin", "guru", or "santri"
    required String role,

    /// Program type ("R" for Reguler, "T" for Takhassus) - nullable for Admin
    String? programType,
    
    /// User's chosen display name
    required String displayName,
    
    /// Reference to their actual document ID in /guru or /santri collection
    /// If role is admin, this might just be "SYSTEM"
    required String linkedDocId,
  }) = _UserModel;

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);
}
