import 'package:dartz/dartz.dart';
import 'package:logger/logger.dart';
import 'package:my_halaqoh/src/modules/master_data/data/datasources/remote/source/abstract/santri_extra_target_remote_datasource.dart';
import 'package:my_halaqoh/src/modules/master_data/domain/repositories/santri_extra_target_repository.dart';

class SantriExtraTargetRepositoryImpl implements SantriExtraTargetRepository {
  final SantriExtraTargetRemoteDataSource _remote;
  final _log = Logger();

  SantriExtraTargetRepositoryImpl(this._remote);

  @override
  Stream<List<int>> watchExtraJuz(String santriId) {
    return _remote.watchExtraJuz(santriId);
  }

  @override
  Future<Either<String, void>> addExtraJuz(
      String santriId, int juzNum) async {
    try {
      await _remote.addExtraJuz(santriId, juzNum);
      return const Right(null);
    } catch (e, st) {
      _log.e('Failed to add extra juz', error: e, stackTrace: st);
      return Left('Gagal menyimpan target juz tambahan: $e');
    }
  }
}
