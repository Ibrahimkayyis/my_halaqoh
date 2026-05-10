import 'package:dartz/dartz.dart';
import 'package:my_halaqoh/src/modules/master_data/domain/models/santri_model.dart';

abstract class SantriRepository {
  Stream<List<SantriModel>> watchAll();
  Future<Either<String, List<SantriModel>>> getAll();
  Future<Either<String, SantriModel>> getById(String id);
  Future<Either<String, List<SantriModel>>> getByFilter({String? kelas, String? program});
  Future<Either<String, String>> add(SantriModel model);
  Future<Either<String, void>> update(SantriModel model);
  Future<Either<String, void>> delete(String id);
  Future<Either<String, void>> resetPassword(String authUid);
}
