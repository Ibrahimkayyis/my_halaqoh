import 'package:dartz/dartz.dart';
import 'package:my_halaqoh/src/modules/master_data/data/datasources/local/master_data_local_datasource.dart';
import 'package:my_halaqoh/src/modules/master_data/data/datasources/remote/source/abstract/santri_remote_datasource.dart';
import 'package:my_halaqoh/src/modules/master_data/domain/models/santri_model.dart';
import 'package:my_halaqoh/src/modules/master_data/domain/repositories/santri_repository.dart';

class SantriRepositoryImpl implements SantriRepository {
  final SantriRemoteDataSource _remote;
  final MasterDataLocalDataSource _local;

  SantriRepositoryImpl(this._remote, this._local);

  @override
  Stream<List<SantriModel>> watchAll() {
    return _remote.watchAll().map((list) {
      _local.cacheSantri(list);
      return list;
    });
  }

  @override
  Future<Either<String, List<SantriModel>>> getAll() async {
    try {
      final list = await _remote.getAll();
      await _local.cacheSantri(list);
      return Right(list);
    } catch (e) {
      final cached = _local.getAllSantri();
      if (cached.isNotEmpty) return Right(cached);
      return Left('Gagal memuat data santri: $e');
    }
  }

  @override
  Future<Either<String, SantriModel>> getById(String id) async {
    try {
      final model = await _remote.getById(id);
      if (model == null) return const Left('Santri tidak ditemukan');
      return Right(model);
    } catch (e) {
      return Left('Gagal memuat santri: $e');
    }
  }

  @override
  Future<Either<String, List<SantriModel>>> getByFilter({
    String? kelas,
    String? program,
  }) async {
    try {
      final list = await _remote.getByFilter(kelas: kelas, program: program);
      return Right(list);
    } catch (e) {
      // Fallback: filter locally
      final cached = _local.getAllSantri().where((s) {
        if (kelas != null && s.kelas != kelas) return false;
        if (program != null && s.program != program) return false;
        return true;
      }).toList();
      if (cached.isNotEmpty) return Right(cached);
      return Left('Gagal memfilter santri: $e');
    }
  }

  @override
  Future<Either<String, String>> add(SantriModel model) async {
    try {
      final id = await _remote.add(model);
      final created = model.copyWith(id: id);
      await _local.putSantri(created);
      return Right(id);
    } catch (e) {
      return Left('Gagal menambahkan santri: $e');
    }
  }

  @override
  Future<Either<String, void>> update(SantriModel model) async {
    try {
      await _remote.update(model);
      await _local.putSantri(model);
      return const Right(null);
    } catch (e) {
      return Left('Gagal mengupdate santri: $e');
    }
  }

  @override
  Future<Either<String, void>> delete(String id) async {
    try {
      await _remote.delete(id);
      await _local.deleteSantri(id);
      return const Right(null);
    } catch (e) {
      return Left('Gagal menghapus santri: $e');
    }
  }

  @override
  Future<Either<String, void>> resetPassword(String authUid) async {
    try {
      await _remote.resetPassword(authUid);
      return const Right(null);
    } catch (e) {
      return Left(e.toString().replaceAll('Exception: ', ''));
    }
  }
}
