import '../../../../../domain/models/hafalan_santri_model.dart';

abstract class HafalanSantriRemoteDataSource {
  /// Add or update a hafalan record in Firestore.
  Future<HafalanSantriModel> put(HafalanSantriModel model);

  /// Fetch ALL hafalan records for a specific santri from Firestore.
  /// Used to seed the local Hive cache after a fresh install / Hive wipe.
  Future<List<HafalanSantriModel>> fetchBySantriId(String santriId);
}
