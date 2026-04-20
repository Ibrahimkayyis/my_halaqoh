import 'package:cloud_firestore/cloud_firestore.dart';
import '../abstract/absensi_remote_datasource.dart';
import '../../../../../domain/models/absensi_model.dart';
import '../../mapper/absensi_mapper.dart';

/// Firestore implementation of [AbsensiRemoteDataSource].
class AbsensiRemoteDataSourceImpl implements AbsensiRemoteDataSource {
  final FirebaseFirestore _firestore;

  AbsensiRemoteDataSourceImpl(this._firestore);

  CollectionReference<Map<String, dynamic>> get _collection =>
      _firestore.collection('absensi');

  @override
  Stream<List<AbsensiModel>> watchByHalaqoh(String halaqohId) {
    return _collection
        .where('halaqohId', isEqualTo: halaqohId)
        .snapshots()
        .map((snap) {
      final list = snap.docs.map(AbsensiMapper.fromFirestore).toList();
      list.sort((a, b) => b.tanggal.compareTo(a.tanggal));
      return list;
    });
  }

  @override
  Future<List<AbsensiModel>> getByHalaqoh(String halaqohId) async {
    final snap = await _collection
        .where('halaqohId', isEqualTo: halaqohId)
        .get();
    final list = snap.docs.map(AbsensiMapper.fromFirestore).toList();
    list.sort((a, b) => b.tanggal.compareTo(a.tanggal));
    return list;
  }

  @override
  Future<AbsensiModel?> findExisting(
    String halaqohId,
    DateTime tanggal,
    String sesi,
  ) async {
    final dateOnly = DateTime(tanggal.year, tanggal.month, tanggal.day);
    final allRecords = await getByHalaqoh(halaqohId);

    try {
      return allRecords.firstWhere(
        (m) =>
            m.sesi == sesi &&
            m.tanggal.year == dateOnly.year &&
            m.tanggal.month == dateOnly.month &&
            m.tanggal.day == dateOnly.day,
      );
    } catch (_) {
      return null;
    }
  }

  @override
  Future<String> add(AbsensiModel model) async {
    final docRef = await _collection.add(AbsensiMapper.toFirestore(model));
    return docRef.id;
  }

  @override
  Future<void> update(AbsensiModel model) async {
    await _collection.doc(model.id).update(AbsensiMapper.toFirestore(model));
  }

  @override
  Future<void> delete(String id) async {
    await _collection.doc(id).delete();
  }
}
