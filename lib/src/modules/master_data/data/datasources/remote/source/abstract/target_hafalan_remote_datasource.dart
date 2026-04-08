import 'package:my_halaqoh/src/modules/master_data/domain/models/target_hafalan_model.dart';

/// Abstract interface for Target Hafalan remote data operations.
abstract class TargetHafalanRemoteDataSource {
  /// Real-time stream of all target hafalan documents.
  Stream<List<TargetHafalanModel>> watchAll();

  /// Fetch all target hafalan documents once.
  Future<List<TargetHafalanModel>> getAll();

  /// Fetch target hafalan by kelas and program.
  Future<TargetHafalanModel?> getByKelasProgram(String kelas, String program);

  /// Save (create or update) a target hafalan.
  /// Uses composite key "{kelas}_{program}" as document ID.
  Future<void> save(TargetHafalanModel model);

  /// Delete a target hafalan by document ID.
  Future<void> delete(String id);
}
