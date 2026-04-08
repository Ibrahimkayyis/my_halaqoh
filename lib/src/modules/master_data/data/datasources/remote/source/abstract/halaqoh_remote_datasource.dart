import 'package:my_halaqoh/src/modules/master_data/domain/models/halaqoh_model.dart';

/// Abstract interface for Halaqoh remote data operations.
abstract class HalaqohRemoteDataSource {
  /// Real-time stream of all halaqoh documents.
  Stream<List<HalaqohModel>> watchAll();

  /// Fetch all halaqoh documents once.
  Future<List<HalaqohModel>> getAll();

  /// Fetch a single halaqoh by document ID.
  Future<HalaqohModel?> getById(String id);

  /// Add a new halaqoh. Returns the created document ID.
  Future<String> add(HalaqohModel model);

  /// Update an existing halaqoh.
  Future<void> update(HalaqohModel model);

  /// Delete a halaqoh by document ID.
  Future<void> delete(String id);
}
