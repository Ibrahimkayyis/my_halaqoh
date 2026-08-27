import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_halaqoh/src/modules/sertifikasi_tahfidz/data/datasources/remote/mapper/sertifikasi_mapper.dart';
import 'package:my_halaqoh/src/modules/sertifikasi_tahfidz/data/datasources/remote/source/abstract/sertifikasi_remote_datasource.dart';
import 'package:my_halaqoh/src/modules/sertifikasi_tahfidz/domain/models/sertifikasi_model.dart';

class SertifikasiRemoteDataSourceImpl implements SertifikasiRemoteDataSource {
  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> get _col =>
      _firestore.collection('sertifikasi_tahfidz');

  SertifikasiRemoteDataSourceImpl(this._firestore);

  @override
  Stream<List<SertifikasiModel>> watchByGuruId(String guruId) {
    return _col
        .where('guruId', isEqualTo: guruId)
        .snapshots()
        .map((snapshot) {
      final list = snapshot.docs
          .map(SertifikasiMapper.fromFirestore)
          .toList();
      list.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      return list;
    });
  }

  @override
  Stream<List<SertifikasiModel>> watchBySantriId(String santriId) {
    return _col
        .where('santriId', isEqualTo: santriId)
        .snapshots()
        .map((snapshot) {
      final list = snapshot.docs
          .map(SertifikasiMapper.fromFirestore)
          .toList();
      list.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      return list;
    });
  }

  @override
  Stream<List<SertifikasiModel>> watchAll() {
    return _col.snapshots().map((snapshot) {
      final list = snapshot.docs
          .map(SertifikasiMapper.fromFirestore)
          .toList();
      list.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      return list;
    });
  }

  @override
  Future<List<SertifikasiModel>> getByGuruId(String guruId) async {
    final snap = await _col.where('guruId', isEqualTo: guruId).get();
    final list = snap.docs.map(SertifikasiMapper.fromFirestore).toList();
    list.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return list;
  }

  @override
  Future<List<SertifikasiModel>> getBySantriId(String santriId) async {
    final snap = await _col.where('santriId', isEqualTo: santriId).get();
    final list = snap.docs.map(SertifikasiMapper.fromFirestore).toList();
    list.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return list;
  }

  @override
  Future<SertifikasiModel?> getById(String id) async {
    final doc = await _col.doc(id).get();
    if (!doc.exists) return null;
    return SertifikasiMapper.fromFirestore(doc);
  }

  @override
  Future<String> add(SertifikasiModel model) async {
    final docRef = _col.doc();
    final updatedModel = model.copyWith(id: docRef.id);
    await docRef.set(SertifikasiMapper.toFirestore(updatedModel));
    return docRef.id;
  }

  @override
  Future<void> update(SertifikasiModel model) async {
    await _col.doc(model.id).update(SertifikasiMapper.toFirestore(model));
  }

  @override
  Future<void> delete(String id) async {
    await _col.doc(id).delete();
  }
}
