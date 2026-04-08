import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_halaqoh/src/modules/master_data/data/datasources/remote/mapper/santri_mapper.dart';
import 'package:my_halaqoh/src/modules/master_data/data/datasources/remote/source/abstract/santri_remote_datasource.dart';
import 'package:my_halaqoh/src/modules/master_data/domain/models/santri_model.dart';

class SantriRemoteDataSourceImpl implements SantriRemoteDataSource {
  final FirebaseFirestore _firestore;
  CollectionReference<Map<String, dynamic>> get _col =>
      _firestore.collection('santri');

  SantriRemoteDataSourceImpl(this._firestore);

  @override
  Stream<List<SantriModel>> watchAll() {
    return _col.orderBy('nama').snapshots().map(
          (snap) => snap.docs.map(SantriMapper.fromFirestore).toList(),
        );
  }

  @override
  Future<List<SantriModel>> getAll() async {
    final snap = await _col.orderBy('nama').get();
    return snap.docs.map(SantriMapper.fromFirestore).toList();
  }

  @override
  Future<SantriModel?> getById(String id) async {
    final doc = await _col.doc(id).get();
    if (!doc.exists) return null;
    return SantriMapper.fromFirestore(doc);
  }

  @override
  Future<SantriModel?> getByNis(String nis) async {
    final snap = await _col.where('nis', isEqualTo: nis).limit(1).get();
    if (snap.docs.isEmpty) return null;
    return SantriMapper.fromFirestore(snap.docs.first);
  }

  @override
  Future<List<SantriModel>> getByFilter({String? kelas, String? program}) async {
    Query<Map<String, dynamic>> query = _col;
    if (kelas != null) query = query.where('kelas', isEqualTo: kelas);
    if (program != null) query = query.where('program', isEqualTo: program);
    final snap = await query.orderBy('nama').get();
    return snap.docs.map(SantriMapper.fromFirestore).toList();
  }

  @override
  Future<String> add(SantriModel model) async {
    final docRef = await _col.add(SantriMapper.toFirestore(model));
    return docRef.id;
  }

  @override
  Future<void> update(SantriModel model) async {
    await _col.doc(model.id).update(SantriMapper.toFirestore(model));
  }

  @override
  Future<void> delete(String id) async {
    await _col.doc(id).delete();
  }

  @override
  Future<void> updateHalaqohId(String santriId, String? halaqohId) async {
    await _col.doc(santriId).update({'halaqohId': halaqohId});
  }
}
