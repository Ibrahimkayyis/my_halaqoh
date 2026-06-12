import 'package:my_halaqoh/src/modules/master_data/domain/models/guru_model.dart';

/// Abstract interface for Guru remote data operations.
abstract class GuruRemoteDataSource {
  /// Real-time stream of all guru documents.
  Stream<List<GuruModel>> watchAll();

  /// Fetch all guru documents once.
  Future<List<GuruModel>> getAll();

  /// Fetch a single guru by document ID.
  Future<GuruModel?> getById(String id);

  /// Fetch a single guru by NIP.
  Future<GuruModel?> getByNip(String nip);

  /// Add a new guru. Returns the created document ID.
  Future<String> add(GuruModel model);

  /// Add multiple guru directly to Firestore in bulk.
  /// Returns the number of successfully written documents.
  Future<int> addBulk(List<GuruModel> models);

  /// Update an existing guru.
  Future<void> update(GuruModel model);

  /// Delete a guru by document ID.
  Future<void> delete(String id);

  /// Reset a guru's Firebase Auth password.
  Future<void> resetPassword(String authUid);
}
