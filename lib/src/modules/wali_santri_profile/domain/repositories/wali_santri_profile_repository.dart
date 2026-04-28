import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:my_halaqoh/src/modules/master_data/domain/models/santri_model.dart';

/// Abstract repository for Wali Santri Profile operations.
/// Handles profile reading, updating, photo uploads, and password changes.
abstract class WaliSantriProfileRepository {
  /// Fetch the logged-in santri's profile by their Firestore document ID.
  Future<Either<String, SantriModel>> getProfile(String santriDocId);

  /// Update the santri's profile fields in Firestore.
  /// Only [nama], [profilePicture], and [waliSantri.phone] are updated.
  Future<Either<String, void>> updateProfile(SantriModel model);

  /// Upload a profile photo to Firebase Storage.
  /// Returns the download URL on success.
  Future<Either<String, String>> uploadProfilePhoto({
    required String santriDocId,
    required File imageFile,
  });

  /// Change the current user's Firebase Auth password.
  /// Requires the old password for re-authentication.
  Future<Either<String, void>> changePassword({
    required String currentPassword,
    required String newPassword,
  });
}
