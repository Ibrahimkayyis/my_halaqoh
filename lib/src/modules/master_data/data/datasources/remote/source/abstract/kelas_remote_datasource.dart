import 'package:my_halaqoh/src/modules/master_data/domain/models/kelas_model.dart';

abstract class KelasRemoteDataSource {
  Stream<List<KelasModel>> watchAll();
  Future<List<KelasModel>> getAll();
  Future<void> add(KelasModel model);
  Future<void> update(KelasModel model);
  Future<void> delete(String id);
}
