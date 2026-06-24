import 'package:dartz/dartz.dart';
import 'package:logger/logger.dart';
import 'package:my_halaqoh/src/modules/master_data/data/datasources/remote/source/abstract/program_remote_datasource.dart';
import 'package:my_halaqoh/src/modules/master_data/domain/models/program_model.dart';
import 'package:my_halaqoh/src/modules/master_data/domain/repositories/program_repository.dart';

class ProgramRepositoryImpl implements ProgramRepository {
  final ProgramRemoteDataSource _remote;
  final _log = Logger();
  bool _isSeeded = false;

  ProgramRepositoryImpl(this._remote);

  Future<void> _checkAndSeed() async {
    if (_isSeeded) return;
    try {
      final list = await _remote.getAll();
      if (list.isEmpty) {
        _log.i('Program collection is empty. Seeding default programs...');
        final now = DateTime.now();
        final defaultPrograms = [
          ProgramModel(id: 'R', nama: 'Reguler', createdAt: now, updatedAt: now),
          ProgramModel(id: 'T', nama: 'Takhassus', createdAt: now, updatedAt: now),
        ];
        for (final p in defaultPrograms) {
          await _remote.add(p);
        }
        _log.i('Seeding default programs completed.');
      }
      _isSeeded = true;
    } catch (e, st) {
      _log.e('Failed to check or seed default programs', error: e, stackTrace: st);
    }
  }

  @override
  Stream<List<ProgramModel>> watchAll() async* {
    await _checkAndSeed();
    yield* _remote.watchAll();
  }

  @override
  Future<Either<String, List<ProgramModel>>> getAll() async {
    try {
      await _checkAndSeed();
      final list = await _remote.getAll();
      return Right(list);
    } catch (e, st) {
      _log.e('Failed to get all program', error: e, stackTrace: st);
      return Left('Gagal mengambil data program: $e');
    }
  }

  @override
  Future<Either<String, void>> add(ProgramModel model) async {
    try {
      await _remote.add(model);
      return const Right(null);
    } catch (e, st) {
      _log.e('Failed to add program', error: e, stackTrace: st);
      return Left('Gagal menambah program: $e');
    }
  }

  @override
  Future<Either<String, void>> update(ProgramModel model) async {
    try {
      await _remote.update(model);
      return const Right(null);
    } catch (e, st) {
      _log.e('Failed to update program', error: e, stackTrace: st);
      return Left('Gagal memperbarui program: $e');
    }
  }

  @override
  Future<Either<String, void>> delete(String id) async {
    try {
      await _remote.delete(id);
      return const Right(null);
    } catch (e, st) {
      _log.e('Failed to delete program', error: e, stackTrace: st);
      return Left('Gagal menghapus program: $e');
    }
  }
}
