import 'package:my_halaqoh/src/modules/master_data/domain/models/program_model.dart';

abstract class ProgramRemoteDataSource {
  Stream<List<ProgramModel>> watchAll();
  Future<List<ProgramModel>> getAll();
  Future<void> add(ProgramModel model);
  Future<void> update(ProgramModel model);
  Future<void> delete(String id);
}
