import 'package:my_halaqoh/src/modules/master_data/domain/models/santri_model.dart';

/// Abstract interface for Santri remote data operations.
abstract class SantriRemoteDataSource {
  /// Real-time stream of all santri documents.
  Stream<List<SantriModel>> watchAll();

  /// Fetch all santri documents once.
  Future<List<SantriModel>> getAll();

  /// Fetch a single santri by document ID.
  Future<SantriModel?> getById(String id);

  /// Fetch a single santri by NIS.
  Future<SantriModel?> getByNis(String nis);

  /// Fetch santri filtered by kelas and/or program.
  Future<List<SantriModel>> getByFilter({String? kelas, String? program});

  /// Add a new santri via Cloud Function (creates Auth account + Firestore doc).
  /// Returns the created document ID.
  Future<String> add(SantriModel model);

  /// Add multiple santri directly to Firestore WITHOUT creating Auth accounts.
  /// Intended for bulk CSV upload. Writes each document individually so partial
  /// success is possible (failed rows are skipped, not the whole batch).
  /// Returns the number of successfully written documents.
  Future<int> addBulk(List<SantriModel> models);

  /// Update an existing santri.
  Future<void> update(SantriModel model);

  /// Delete a santri by document ID.
  Future<void> delete(String id);

  /// Update the halaqohId field for a specific santri.
  Future<void> updateHalaqohId(String santriId, String? halaqohId);

  /// Reset a santri's Firebase Auth password.
  Future<void> resetPassword(String authUid);
}
