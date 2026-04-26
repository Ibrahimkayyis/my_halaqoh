import 'package:my_halaqoh/src/modules/wali_santri_hafalan/domain/models/wali_santri_hafalan_model.dart';

abstract class WaliSantriHafalanRemoteDataSource {
  Stream<List<WaliSantriHafalanModel>> watchHafalanBySantriId(
    String santriId,
    int month,
    int year,
  );
  Stream<List<WaliSantriHafalanModel>> watchAllZiyadahBySantriId(
    String santriId,
  );
}
