import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_halaqoh/src/modules/master_data/data/datasources/remote/mapper/guru_mapper.dart';
import 'package:my_halaqoh/src/modules/master_data/data/datasources/remote/source/abstract/guru_remote_datasource.dart';
import 'package:my_halaqoh/src/modules/master_data/domain/models/guru_model.dart';

class GuruRemoteDataSourceImpl implements GuruRemoteDataSource {
  final FirebaseFirestore _firestore;
  CollectionReference<Map<String, dynamic>> get _col =>
      _firestore.collection('guru');

  GuruRemoteDataSourceImpl(this._firestore);

  @override
  Stream<List<GuruModel>> watchAll() {
    return _col.orderBy('nama').snapshots().map(
          (snap) => snap.docs.map(GuruMapper.fromFirestore).toList(),
        );
  }

  @override
  Future<List<GuruModel>> getAll() async {
    final snap = await _col.orderBy('nama').get();
    return snap.docs.map(GuruMapper.fromFirestore).toList();
  }

  @override
  Future<GuruModel?> getById(String id) async {
    final doc = await _col.doc(id).get();
    if (!doc.exists) return null;
    return GuruMapper.fromFirestore(doc);
  }

  @override
  Future<GuruModel?> getByNip(String nip) async {
    final snap = await _col.where('nip', isEqualTo: nip).limit(1).get();
    if (snap.docs.isEmpty) return null;
    return GuruMapper.fromFirestore(snap.docs.first);
  }

  @override
  Future<String> add(GuruModel model) async {
    final docRef = await _col.add(GuruMapper.toFirestore(model));
    return docRef.id;
  }

  @override
  Future<void> update(GuruModel model) async {
    await _col.doc(model.id).update(GuruMapper.toFirestore(model));
  }

  @override
  Future<void> delete(String id) async {
    await _col.doc(id).delete();
  }
}
