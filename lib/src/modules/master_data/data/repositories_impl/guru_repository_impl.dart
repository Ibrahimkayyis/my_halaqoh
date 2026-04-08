import 'package:dartz/dartz.dart';
import 'package:my_halaqoh/src/modules/master_data/data/datasources/local/master_data_local_datasource.dart';
import 'package:my_halaqoh/src/modules/master_data/data/datasources/remote/source/abstract/guru_remote_datasource.dart';
import 'package:my_halaqoh/src/modules/master_data/domain/models/guru_model.dart';
import 'package:my_halaqoh/src/modules/master_data/domain/repositories/guru_repository.dart';

class GuruRepositoryImpl implements GuruRepository {
  final GuruRemoteDataSource _remote;
  final MasterDataLocalDataSource _local;

  GuruRepositoryImpl(this._remote, this._local);

  @override
  Stream<List<GuruModel>> watchAll() {
    return _remote.watchAll().map((list) {
      // Side-effect: update Hive cache on every Firestore change
      _local.cacheGuru(list);
      return list;
    });
  }

  @override
  Future<Either<String, List<GuruModel>>> getAll() async {
    try {
      final list = await _remote.getAll();
      await _local.cacheGuru(list);
      return Right(list);
    } catch (e) {
      // Fallback to local cache
      final cached = _local.getAllGuru();
      if (cached.isNotEmpty) return Right(cached);
      return Left('Gagal memuat data guru: $e');
    }
  }

  @override
  Future<Either<String, GuruModel>> getById(String id) async {
    try {
      final model = await _remote.getById(id);
      if (model == null) return const Left('Guru tidak ditemukan');
      return Right(model);
    } catch (e) {
      return Left('Gagal memuat guru: $e');
    }
  }

  @override
  Future<Either<String, String>> add(GuruModel model) async {
    try {
      final id = await _remote.add(model);
      final created = model.copyWith(id: id);
      await _local.putGuru(created);
      return Right(id);
    } catch (e) {
      return Left('Gagal menambahkan guru: $e');
    }
  }

  @override
  Future<Either<String, void>> update(GuruModel model) async {
    try {
      await _remote.update(model);
      await _local.putGuru(model);
      return const Right(null);
    } catch (e) {
      return Left('Gagal mengupdate guru: $e');
    }
  }

  @override
  Future<Either<String, void>> delete(String id) async {
    try {
      await _remote.delete(id);
      await _local.deleteGuru(id);
      return const Right(null);
    } catch (e) {
      return Left('Gagal menghapus guru: $e');
    }
  }
}
