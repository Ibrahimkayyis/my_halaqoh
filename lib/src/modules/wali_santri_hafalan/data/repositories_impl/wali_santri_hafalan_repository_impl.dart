import 'package:my_halaqoh/src/modules/wali_santri_hafalan/domain/models/wali_santri_hafalan_model.dart';
import 'package:my_halaqoh/src/modules/wali_santri_hafalan/domain/repositories/wali_santri_hafalan_repository.dart';
import '../datasources/remote/source/abstract/wali_santri_hafalan_remote_datasource.dart';

class WaliSantriHafalanRepositoryImpl implements WaliSantriHafalanRepository {
  final WaliSantriHafalanRemoteDataSource _remote;

  WaliSantriHafalanRepositoryImpl(this._remote);

  @override
  Stream<List<WaliSantriHafalanModel>> watchRiwayatHafalan(
    String santriId,
    int month,
    int year,
  ) {
    return _remote.watchHafalanBySantriId(santriId, month, year);
  }

  @override
  Stream<List<WaliSantriHafalanModel>> watchAllZiyadahBySantriId(
    String santriId,
  ) {
    return _remote.watchAllZiyadahBySantriId(santriId);
  }
}
