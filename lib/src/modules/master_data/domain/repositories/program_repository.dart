import 'package:dartz/dartz.dart';
import 'package:my_halaqoh/src/modules/master_data/domain/models/program_model.dart';

abstract class ProgramRepository {
  Stream<List<ProgramModel>> watchAll();
  Future<Either<String, List<ProgramModel>>> getAll();
  Future<Either<String, void>> add(ProgramModel model);
  Future<Either<String, void>> update(ProgramModel model);
  Future<Either<String, void>> delete(String id);
}
