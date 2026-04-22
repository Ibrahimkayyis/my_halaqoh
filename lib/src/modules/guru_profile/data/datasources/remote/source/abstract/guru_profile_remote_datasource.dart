import 'dart:io';

import 'package:my_halaqoh/src/modules/master_data/domain/models/guru_model.dart';

/// Abstract interface for Guru Profile remote data operations.
abstract class GuruProfileRemoteDataSource {
  /// Fetch a single guru document by Firestore document ID.
  Future<GuruModel> getById(String docId);

  /// Update an existing guru document in Firestore.
  Future<void> update(GuruModel model);

  /// Upload a profile photo to Firebase Storage.
  /// Returns the download URL.
  Future<String> uploadPhoto({
    required String guruDocId,
    required File file,
  });

  /// Change the current user's password via Firebase Auth.
  /// Re-authenticates with [currentPassword] before updating.
  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  });
}
