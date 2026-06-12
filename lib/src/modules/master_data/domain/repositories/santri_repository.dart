import 'package:dartz/dartz.dart';
import 'package:my_halaqoh/src/modules/master_data/domain/models/santri_model.dart';
import 'package:my_halaqoh/src/modules/master_data/domain/models/target_hafalan_model.dart';

abstract class SantriRepository {
  Stream<List<SantriModel>> watchAll();
  Future<Either<String, List<SantriModel>>> getAll();
  Future<Either<String, SantriModel>> getById(String id);
  Future<Either<String, List<SantriModel>>> getByFilter({String? kelas, String? program});
  Future<Either<String, String>> add(SantriModel model);
  Future<Either<String, int>> addBulk(List<SantriModel> models);
  Future<Either<String, void>> update(SantriModel model);
  Future<Either<String, void>> delete(String id);
  Future<Either<String, void>> resetPassword(String authUid);

  /// Menaikkan kelas semua santri aktif dalam satu Firestore batch write.
  /// - Santri kelas 7–11 → kelas + 1
  /// - Santri kelas 12   → isAlumni = true (diarsipkan)
  /// Sekaligus memperbarui semua [TargetHafalanModel] dengan
  /// [tahunAjaran] + [semesterAktif] baru untuk tahun ajaran mendatang.
  Future<Either<String, void>> promoteAll({
    required String tahunAjaran,
    required int semesterAktif,
    required List<SantriModel> aktivSantri,
    required List<TargetHafalanModel> currentTargets,
  });
}
