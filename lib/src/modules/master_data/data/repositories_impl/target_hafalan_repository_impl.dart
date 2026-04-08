import 'package:dartz/dartz.dart';
import 'package:my_halaqoh/src/modules/master_data/data/datasources/local/master_data_local_datasource.dart';
import 'package:my_halaqoh/src/modules/master_data/data/datasources/remote/source/abstract/target_hafalan_remote_datasource.dart';
import 'package:my_halaqoh/src/modules/master_data/domain/models/target_hafalan_model.dart';
import 'package:my_halaqoh/src/modules/master_data/domain/repositories/target_hafalan_repository.dart';

class TargetHafalanRepositoryImpl implements TargetHafalanRepository {
  final TargetHafalanRemoteDataSource _remote;
  final MasterDataLocalDataSource _local;

  TargetHafalanRepositoryImpl(this._remote, this._local);

  @override
  Stream<List<TargetHafalanModel>> watchAll() {
    return _remote.watchAll().map((list) {
      _local.cacheTargetHafalan(list);
      return list;
    });
  }

  @override
  Future<Either<String, List<TargetHafalanModel>>> getAll() async {
    try {
      final list = await _remote.getAll();
      await _local.cacheTargetHafalan(list);
      return Right(list);
    } catch (e) {
      final cached = _local.getAllTargetHafalan();
      if (cached.isNotEmpty) return Right(cached);
      return Left('Gagal memuat target hafalan: $e');
    }
  }

  @override
  Future<Either<String, TargetHafalanModel>> getByKelasProgram(
      String kelas, String program) async {
    try {
      final model = await _remote.getByKelasProgram(kelas, program);
      if (model == null) return const Left('Target hafalan tidak ditemukan');
      return Right(model);
    } catch (e) {
      return Left('Gagal memuat target hafalan: $e');
    }
  }

  @override
  Future<Either<String, void>> save(TargetHafalanModel model) async {
    try {
      await _remote.save(model);
      await _local.putTargetHafalan(model);
      return const Right(null);
    } catch (e) {
      return Left('Gagal menyimpan target hafalan: $e');
    }
  }

  @override
  Future<Either<String, void>> delete(String id) async {
    try {
      await _remote.delete(id);
      await _local.deleteTargetHafalan(id);
      return const Right(null);
    } catch (e) {
      return Left('Gagal menghapus target hafalan: $e');
    }
  }
}
