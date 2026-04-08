import 'package:dartz/dartz.dart';
import 'package:my_halaqoh/src/modules/master_data/domain/models/halaqoh_model.dart';

abstract class HalaqohRepository {
  Stream<List<HalaqohModel>> watchAll();
  Future<Either<String, List<HalaqohModel>>> getAll();
  Future<Either<String, HalaqohModel>> getById(String id);
  Future<Either<String, String>> add(HalaqohModel model);
  Future<Either<String, void>> update(HalaqohModel model);
  Future<Either<String, void>> delete(String id);
}
