import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_halaqoh/src/modules/master_data/data/datasources/remote/mapper/target_hafalan_mapper.dart';
import 'package:my_halaqoh/src/modules/master_data/data/datasources/remote/source/abstract/target_hafalan_remote_datasource.dart';
import 'package:my_halaqoh/src/modules/master_data/domain/models/target_hafalan_model.dart';

class TargetHafalanRemoteDataSourceImpl
    implements TargetHafalanRemoteDataSource {
  final FirebaseFirestore _firestore;
  CollectionReference<Map<String, dynamic>> get _col =>
      _firestore.collection('targetHafalan');

  TargetHafalanRemoteDataSourceImpl(this._firestore);

  @override
  Stream<List<TargetHafalanModel>> watchAll() {
    return _col.snapshots().map(
          (snap) =>
              snap.docs.map(TargetHafalanMapper.fromFirestore).toList(),
        );
  }

  @override
  Future<List<TargetHafalanModel>> getAll() async {
    final snap = await _col.get();
    return snap.docs.map(TargetHafalanMapper.fromFirestore).toList();
  }

  @override
  Future<TargetHafalanModel?> getByKelasProgram(
      String kelas, String program) async {
    final docId = '${kelas}_$program';
    final doc = await _col.doc(docId).get();
    if (!doc.exists) return null;
    return TargetHafalanMapper.fromFirestore(doc);
  }

  @override
  Future<void> save(TargetHafalanModel model) async {
    // Use composite key as document ID
    final docId = '${model.kelas}_${model.program}';
    await _col.doc(docId).set(
          TargetHafalanMapper.toFirestore(model),
          SetOptions(merge: true),
        );
  }

  @override
  Future<void> delete(String id) async {
    await _col.doc(id).delete();
  }
}
