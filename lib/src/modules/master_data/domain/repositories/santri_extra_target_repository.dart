import 'package:dartz/dartz.dart';

/// Contract for reading and writing teacher-added juz targets per santri.
/// Backed by Firestore (`/santriExtraTarget/{santriId}`).
abstract class SantriExtraTargetRepository {
  /// Stream of extra juz numbers the teacher has added for [santriId].
  /// Emits an empty list when no document exists yet.
  Stream<List<int>> watchExtraJuz(String santriId);

  /// Adds [juzNum] to the teacher-added target list for [santriId].
  /// Creates the document if it does not exist yet (merge semantics).
  Future<Either<String, void>> addExtraJuz(String santriId, int juzNum);
}
