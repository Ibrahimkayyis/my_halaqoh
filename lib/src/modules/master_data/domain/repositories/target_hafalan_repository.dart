import 'package:dartz/dartz.dart';
import 'package:my_halaqoh/src/modules/master_data/domain/models/target_hafalan_model.dart';

abstract class TargetHafalanRepository {
  Stream<List<TargetHafalanModel>> watchAll();
  Future<Either<String, List<TargetHafalanModel>>> getAll();
  Future<Either<String, TargetHafalanModel>> getByKelasProgram(String kelas, String program);
  Future<Either<String, void>> save(TargetHafalanModel model);
  Future<Either<String, void>> delete(String id);
}
