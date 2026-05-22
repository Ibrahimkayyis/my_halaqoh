import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:logger/logger.dart';
import 'package:my_halaqoh/src/modules/master_data/data/datasources/remote/source/abstract/santri_extra_target_remote_datasource.dart';

class SantriExtraTargetRemoteDataSourceImpl
    implements SantriExtraTargetRemoteDataSource {
  final FirebaseFirestore _firestore;
  final _log = Logger();

  SantriExtraTargetRemoteDataSourceImpl(this._firestore);

  DocumentReference<Map<String, dynamic>> _doc(String santriId) =>
      _firestore.collection('santriExtraTarget').doc(santriId);

  @override
  Stream<List<int>> watchExtraJuz(String santriId) {
    return _doc(santriId).snapshots().map((snap) {
      if (!snap.exists || snap.data() == null) return <int>[];
      final raw = snap.data()!['extraJuz'];
      if (raw == null) return <int>[];
      return List<int>.from(raw as List);
    });
  }

  @override
  Future<void> addExtraJuz(String santriId, int juzNum) async {
    try {
      await _doc(santriId).set(
        {
          'santriId': santriId,
          'extraJuz': FieldValue.arrayUnion([juzNum]),
          'updatedAt': FieldValue.serverTimestamp(),
        },
        SetOptions(merge: true),
      );
    } catch (e, st) {
      _log.e(
        'SantriExtraTargetDS: failed to add juz $juzNum for santri $santriId',
        error: e,
        stackTrace: st,
      );
      rethrow;
    }
  }
}
