import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_halaqoh/src/modules/master_data/data/datasources/remote/mapper/program_mapper.dart';
import 'package:my_halaqoh/src/modules/master_data/data/datasources/remote/source/abstract/program_remote_datasource.dart';
import 'package:my_halaqoh/src/modules/master_data/domain/models/program_model.dart';

class ProgramRemoteDataSourceImpl implements ProgramRemoteDataSource {
  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> get _col => _firestore.collection('program');

  ProgramRemoteDataSourceImpl(this._firestore);

  @override
  Stream<List<ProgramModel>> watchAll() {
    return _col.snapshots().map((snap) {
      final list = snap.docs.map(ProgramMapper.fromFirestore).toList();
      list.sort((a, b) => a.nama.compareTo(b.nama));
      return list;
    });
  }

  @override
  Future<List<ProgramModel>> getAll() async {
    final snap = await _col.get();
    final list = snap.docs.map(ProgramMapper.fromFirestore).toList();
    list.sort((a, b) => a.nama.compareTo(b.nama));
    return list;
  }

  @override
  Future<void> add(ProgramModel model) async {
    final docRef = model.id.isEmpty ? _col.doc() : _col.doc(model.id);
    final modelWithId = model.id.isEmpty ? model.copyWith(id: docRef.id) : model;
    await docRef.set(ProgramMapper.toFirestore(modelWithId));
  }

  @override
  Future<void> update(ProgramModel model) async {
    await _col.doc(model.id).update(ProgramMapper.toFirestore(model));
  }

  @override
  Future<void> delete(String id) async {
    await _col.doc(id).delete();
  }
}
