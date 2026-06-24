import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_halaqoh/src/modules/master_data/data/datasources/remote/mapper/kelas_mapper.dart';
import 'package:my_halaqoh/src/modules/master_data/data/datasources/remote/source/abstract/kelas_remote_datasource.dart';
import 'package:my_halaqoh/src/modules/master_data/domain/models/kelas_model.dart';

class KelasRemoteDataSourceImpl implements KelasRemoteDataSource {
  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> get _col => _firestore.collection('kelas');

  KelasRemoteDataSourceImpl(this._firestore);

  @override
  Stream<List<KelasModel>> watchAll() {
    return _col.snapshots().map((snap) {
      final list = snap.docs.map(KelasMapper.fromFirestore).toList();
      list.sort((a, b) => a.urutan.compareTo(b.urutan));
      return list;
    });
  }

  @override
  Future<List<KelasModel>> getAll() async {
    final snap = await _col.get();
    final list = snap.docs.map(KelasMapper.fromFirestore).toList();
    list.sort((a, b) => a.urutan.compareTo(b.urutan));
    return list;
  }

  @override
  Future<void> add(KelasModel model) async {
    // If id is empty, auto-generate doc path in Firestore
    final docRef = model.id.isEmpty ? _col.doc() : _col.doc(model.id);
    final modelWithId = model.id.isEmpty ? model.copyWith(id: docRef.id) : model;
    await docRef.set(KelasMapper.toFirestore(modelWithId));
  }

  @override
  Future<void> update(KelasModel model) async {
    await _col.doc(model.id).update(KelasMapper.toFirestore(model));
  }

  @override
  Future<void> delete(String id) async {
    await _col.doc(id).delete();
  }
}
