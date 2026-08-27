import 'package:my_halaqoh/src/modules/sertifikasi_tahfidz/domain/models/sertifikasi_model.dart';

/// Abstract remote data source interface for Tahfidz Certification operations.
abstract class SertifikasiRemoteDataSource {
  /// Stream real-time certification records for a specific teacher/halaqoh.
  Stream<List<SertifikasiModel>> watchByGuruId(String guruId);

  /// Stream real-time certification records for a specific student (Wali Santri view).
  Stream<List<SertifikasiModel>> watchBySantriId(String santriId);

  /// Stream all certification records (for Admin / Waka Tahfidz).
  Stream<List<SertifikasiModel>> watchAll();

  /// Fetch certification records once by guru ID.
  Future<List<SertifikasiModel>> getByGuruId(String guruId);

  /// Fetch certification records once by santri ID.
  Future<List<SertifikasiModel>> getBySantriId(String santriId);

  /// Fetch a single certification record by document ID.
  Future<SertifikasiModel?> getById(String id);

  /// Add a new certification registration. Returns generated document ID.
  Future<String> add(SertifikasiModel model);

  /// Update an existing certification record (status, schedule, score, etc.).
  Future<void> update(SertifikasiModel model);

  /// Delete a certification record by document ID.
  Future<void> delete(String id);
}
