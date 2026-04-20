import '../../../../../domain/models/absensi_model.dart';

/// Contract for the remote attendance data source.
abstract class AbsensiRemoteDataSource {
  /// Real-time stream of attendance records for a halaqoh.
  Stream<List<AbsensiModel>> watchByHalaqoh(String halaqohId);

  /// One-time fetch of attendance records for a halaqoh.
  Future<List<AbsensiModel>> getByHalaqoh(String halaqohId);

  /// Find an existing session by halaqoh + date + session.
  Future<AbsensiModel?> findExisting(
    String halaqohId,
    DateTime tanggal,
    String sesi,
  );

  /// Create a new attendance document. Returns the document ID.
  Future<String> add(AbsensiModel model);

  /// Update an existing attendance document.
  Future<void> update(AbsensiModel model);

  /// Delete an attendance document by ID.
  Future<void> delete(String id);
}
