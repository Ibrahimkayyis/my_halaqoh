import 'dart:io';

import 'package:my_halaqoh/src/modules/master_data/domain/models/santri_model.dart';

/// Abstract remote data source for Wali Santri Profile operations.
abstract class WaliSantriProfileRemoteDataSource {
  /// Fetch a single santri document by Firestore document ID.
  Future<SantriModel> getById(String santriDocId);

  /// Update the santri's profile fields in Firestore.
  Future<void> update(SantriModel model);

  /// Upload a profile photo to Firebase Storage and update the Firestore document.
  /// Returns the download URL.
  Future<String> uploadPhoto({
    required String santriDocId,
    required File file,
  });

  /// Change the current Firebase Auth user's password.
  /// Requires re-authentication with [currentPassword].
  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  });
}
