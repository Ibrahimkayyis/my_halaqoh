import 'package:dartz/dartz.dart';
import 'package:my_halaqoh/src/modules/sertifikasi_tahfidz/domain/models/sertifikasi_model.dart';

/// Abstract repository contract for Tahfidz Certification.
abstract class SertifikasiRepository {
  /// Real-time stream of certifications for a specific teacher/halaqoh.
  Stream<List<SertifikasiModel>> watchByGuruId(String guruId);

  /// Real-time stream of certifications for a specific student.
  Stream<List<SertifikasiModel>> watchBySantriId(String santriId);

  /// Real-time stream of all certifications (admin/waka).
  Stream<List<SertifikasiModel>> watchAll();

  /// Fetch certifications for a teacher once.
  Future<Either<String, List<SertifikasiModel>>> getByGuruId(String guruId);

  /// Fetch certifications for a student once.
  Future<Either<String, List<SertifikasiModel>>> getBySantriId(String santriId);

  /// Fetch a single certification by ID.
  Future<Either<String, SertifikasiModel>> getById(String id);

  /// Register a new certification.
  Future<Either<String, String>> add(SertifikasiModel model);

  /// Update an existing certification.
  Future<Either<String, void>> update(SertifikasiModel model);

  /// Delete a certification record.
  Future<Either<String, void>> delete(String id);
}
