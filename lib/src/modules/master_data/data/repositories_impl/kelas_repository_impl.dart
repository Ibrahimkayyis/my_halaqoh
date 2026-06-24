import 'package:dartz/dartz.dart';
import 'package:logger/logger.dart';
import 'package:my_halaqoh/src/modules/master_data/data/datasources/remote/source/abstract/kelas_remote_datasource.dart';
import 'package:my_halaqoh/src/modules/master_data/domain/models/kelas_model.dart';
import 'package:my_halaqoh/src/modules/master_data/domain/repositories/kelas_repository.dart';

class KelasRepositoryImpl implements KelasRepository {
  final KelasRemoteDataSource _remote;
  final _log = Logger();
  bool _isSeeded = false;

  KelasRepositoryImpl(this._remote);

  Future<void> _checkAndSeed() async {
    if (_isSeeded) return;
    try {
      final list = await _remote.getAll();
      if (list.isEmpty) {
        _log.i('Kelas collection is empty. Seeding default classes...');
        final now = DateTime.now();
        final defaultClasses = [
          KelasModel(id: '7', nama: '7', urutan: 1, nextKelasId: '8', createdAt: now, updatedAt: now),
          KelasModel(id: '8', nama: '8', urutan: 2, nextKelasId: '9', createdAt: now, updatedAt: now),
          KelasModel(id: '9', nama: '9', urutan: 3, nextKelasId: '10', createdAt: now, updatedAt: now),
          KelasModel(id: '10', nama: '10', urutan: 4, nextKelasId: '11', createdAt: now, updatedAt: now),
          KelasModel(id: '11', nama: '11', urutan: 5, nextKelasId: '12', createdAt: now, updatedAt: now),
          KelasModel(id: '12', nama: '12', urutan: 6, nextKelasId: null, createdAt: now, updatedAt: now),
        ];
        for (final k in defaultClasses) {
          await _remote.add(k);
        }
        _log.i('Seeding default classes completed.');
      }
      _isSeeded = true;
    } catch (e, st) {
      _log.e('Failed to check or seed default classes', error: e, stackTrace: st);
    }
  }

  @override
  Stream<List<KelasModel>> watchAll() async* {
    await _checkAndSeed();
    yield* _remote.watchAll();
  }

  @override
  Future<Either<String, List<KelasModel>>> getAll() async {
    try {
      await _checkAndSeed();
      final list = await _remote.getAll();
      return Right(list);
    } catch (e, st) {
      _log.e('Failed to get all kelas', error: e, stackTrace: st);
      return Left('Gagal mengambil data kelas: $e');
    }
  }

  @override
  Future<Either<String, void>> add(KelasModel model) async {
    try {
      await _remote.add(model);
      return const Right(null);
    } catch (e, st) {
      _log.e('Failed to add kelas', error: e, stackTrace: st);
      return Left('Gagal menambah kelas: $e');
    }
  }

  @override
  Future<Either<String, void>> update(KelasModel model) async {
    try {
      await _remote.update(model);
      return const Right(null);
    } catch (e, st) {
      _log.e('Failed to update kelas', error: e, stackTrace: st);
      return Left('Gagal memperbarui kelas: $e');
    }
  }

  @override
  Future<Either<String, void>> delete(String id) async {
    try {
      await _remote.delete(id);
      return const Right(null);
    } catch (e, st) {
      _log.e('Failed to delete kelas', error: e, stackTrace: st);
      return Left('Gagal menghapus kelas: $e');
    }
  }
}
