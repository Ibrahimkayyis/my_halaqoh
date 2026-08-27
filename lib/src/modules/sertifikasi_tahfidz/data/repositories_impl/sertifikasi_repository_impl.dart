import 'package:dartz/dartz.dart';
import 'package:my_halaqoh/src/modules/sertifikasi_tahfidz/data/datasources/remote/source/abstract/sertifikasi_remote_datasource.dart';
import 'package:my_halaqoh/src/modules/sertifikasi_tahfidz/domain/models/sertifikasi_model.dart';
import 'package:my_halaqoh/src/modules/sertifikasi_tahfidz/domain/repositories/sertifikasi_repository.dart';

class SertifikasiRepositoryImpl implements SertifikasiRepository {
  final SertifikasiRemoteDataSource _remote;

  SertifikasiRepositoryImpl(this._remote);

  @override
  Stream<List<SertifikasiModel>> watchByGuruId(String guruId) {
    return _remote.watchByGuruId(guruId);
  }

  @override
  Stream<List<SertifikasiModel>> watchBySantriId(String santriId) {
    return _remote.watchBySantriId(santriId);
  }

  @override
  Stream<List<SertifikasiModel>> watchAll() {
    return _remote.watchAll();
  }

  @override
  Future<Either<String, List<SertifikasiModel>>> getByGuruId(
      String guruId) async {
    try {
      final list = await _remote.getByGuruId(guruId);
      return Right(list);
    } catch (e) {
      return Left('Gagal memuat data sertifikasi: $e');
    }
  }

  @override
  Future<Either<String, List<SertifikasiModel>>> getBySantriId(
      String santriId) async {
    try {
      final list = await _remote.getBySantriId(santriId);
      return Right(list);
    } catch (e) {
      return Left('Gagal memuat data sertifikasi santri: $e');
    }
  }

  @override
  Future<Either<String, SertifikasiModel>> getById(String id) async {
    try {
      final model = await _remote.getById(id);
      if (model == null) {
        return const Left('Data sertifikasi tidak ditemukan');
      }
      return Right(model);
    } catch (e) {
      return Left('Gagal memuat detail sertifikasi: $e');
    }
  }

  @override
  Future<Either<String, String>> add(SertifikasiModel model) async {
    try {
      final id = await _remote.add(model);
      return Right(id);
    } catch (e) {
      return Left('Gagal mengajukan sertifikasi: $e');
    }
  }

  @override
  Future<Either<String, void>> update(SertifikasiModel model) async {
    try {
      await _remote.update(model);
      return const Right(null);
    } catch (e) {
      return Left('Gagal memperbarui sertifikasi: $e');
    }
  }

  @override
  Future<Either<String, void>> delete(String id) async {
    try {
      await _remote.delete(id);
      return const Right(null);
    } catch (e) {
      return Left('Gagal menghapus sertifikasi: $e');
    }
  }
}
