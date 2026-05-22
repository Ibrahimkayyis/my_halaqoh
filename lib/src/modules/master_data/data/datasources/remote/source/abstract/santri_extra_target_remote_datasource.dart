/// Abstract remote data source for `/santriExtraTarget/{santriId}`.
abstract class SantriExtraTargetRemoteDataSource {
  /// Real-time stream of extra juz numbers for [santriId].
  Stream<List<int>> watchExtraJuz(String santriId);

  /// Appends [juzNum] to the `extraJuz` array in Firestore (arrayUnion).
  /// Creates the document with merge semantics on first call.
  Future<void> addExtraJuz(String santriId, int juzNum);
}
