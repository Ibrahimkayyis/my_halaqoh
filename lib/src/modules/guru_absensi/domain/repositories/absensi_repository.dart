import 'package:dartz/dartz.dart';
import '../models/absensi_model.dart';

/// Repository contract for attendance operations.
abstract class AbsensiRepository {
  /// Stream all attendance records for a specific halaqoh from Hive (offline-first).
  /// Used by the guru who writes and reads from the same device.
  Stream<List<AbsensiModel>> watchByHalaqoh(String halaqohId);

  /// Stream all attendance records for a specific halaqoh from Firestore directly.
  /// Used by read-only consumers (wali santri) on different devices who need
  /// real-time data that the guru has submitted.
  Stream<List<AbsensiModel>> watchByHalaqohFromRemote(String halaqohId);

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

  /// Seed the local Hive cache from Firestore for a specific halaqoh.
  /// Only performs a network fetch if the local box has NO records for this halaqoh.
  /// Call when opening any screen that reads from Hive to ensure historical
  /// data is present after a fresh install or cache wipe.
  Future<void> seedFromRemoteIfEmpty(String halaqohId);

  /// Sync all unsynced local records to Firestore.
  Future<void> syncPendingRecords();
}
