import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:my_halaqoh/src/modules/master_data/domain/models/guru_model.dart';

/// Abstract repository for Guru Profile operations.
/// Handles profile reading, updating, photo uploads, and password changes.
abstract class GuruProfileRepository {
  /// Fetch the current guru's profile by their Firestore document ID.
  Future<Either<String, GuruModel>> getProfile(String guruDocId);

  /// Update the current guru's profile fields in Firestore.
  Future<Either<String, void>> updateProfile(GuruModel model);

  /// Upload a profile photo to Firebase Storage.
  /// Returns the download URL on success.
  Future<Either<String, String>> uploadProfilePhoto({
    required String guruDocId,
    required File imageFile,
  });

  /// Change the current user's Firebase Auth password.
  /// Requires the old password for re-authentication.
  Future<Either<String, void>> changePassword({
    required String currentPassword,
    required String newPassword,
  });
}
