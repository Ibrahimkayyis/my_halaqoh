import 'package:my_halaqoh/src/modules/wali_santri_hafalan/domain/models/wali_santri_hafalan_model.dart';

abstract class WaliSantriHafalanRepository {
  /// Stream hafalan records for a specific santri, filtered by month and year
  Stream<List<WaliSantriHafalanModel>> watchRiwayatHafalan(
    String santriId,
    int month,
    int year,
  );

  /// Stream all Ziyadah records for a specific santri (used for overall progress calculation)
  Stream<List<WaliSantriHafalanModel>> watchAllZiyadahBySantriId(
    String santriId,
  );
}
