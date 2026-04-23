import '../../../../../domain/models/hafalan_santri_model.dart';

abstract class HafalanSantriRemoteDataSource {
  /// Add or update a hafalan record in Firestore
  Future<HafalanSantriModel> put(HafalanSantriModel model);

  /// Note: We might not need watchAll or getAll from RemoteDataSource since we 
  /// are relying primarily on the Offline-First Local DataSource for the UI, 
  /// but we could implement it for pulling down existing data if the user reinstalls the app.
}
