import 'package:dartz/dartz.dart';
import 'package:my_halaqoh/src/modules/master_data/domain/models/guru_model.dart';

abstract class GuruRepository {
  Stream<List<GuruModel>> watchAll();
  Future<Either<String, List<GuruModel>>> getAll();
  Future<Either<String, GuruModel>> getById(String id);
  Future<Either<String, String>> add(GuruModel model);
  Future<Either<String, int>> addBulk(List<GuruModel> models);
  Future<Either<String, void>> update(GuruModel model);
  Future<Either<String, void>> delete(String id);
  Future<Either<String, void>> resetPassword(String authUid);
}
