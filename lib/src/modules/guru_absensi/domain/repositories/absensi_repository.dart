import 'package:dartz/dartz.dart';
import '../models/absensi_model.dart';

/// Repository contract for attendance operations.
abstract class AbsensiRepository {
  /// Stream all attendance records for a specific halaqoh (real-time).
  Stream<List<AbsensiModel>> watchByHalaqoh(String halaqohId);

  /// One-time fetch of attendance records for a specific halaqoh.
  Future<Either<String, List<AbsensiModel>>> getByHalaqoh(String halaqohId);

  /// Find an existing session for the given halaqoh + date + session.
  /// Returns `null` if no duplicate exists.
  Future<AbsensiModel?> findExisting(
    String halaqohId,
    DateTime tanggal,
    String sesi,
  );

  /// Save (create or update) an attendance session.
  /// Returns Right(docId) on success, Left(errorMsg) on failure.
  Future<Either<String, String>> saveSession(AbsensiModel model);

  /// Delete an attendance session by document ID.
  Future<Either<String, void>> delete(String id);

  /// Sync all unsynced local records to Firestore.
  Future<void> syncPendingRecords();
}
