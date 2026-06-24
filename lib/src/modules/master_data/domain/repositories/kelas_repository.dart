import 'package:dartz/dartz.dart';
import 'package:my_halaqoh/src/modules/master_data/domain/models/kelas_model.dart';

abstract class KelasRepository {
  Stream<List<KelasModel>> watchAll();
  Future<Either<String, List<KelasModel>>> getAll();
  Future<Either<String, void>> add(KelasModel model);
  Future<Either<String, void>> update(KelasModel model);
  Future<Either<String, void>> delete(String id);
}
