import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_halaqoh/src/modules/master_data/data/datasources/remote/mapper/halaqoh_mapper.dart';
import 'package:my_halaqoh/src/modules/master_data/data/datasources/remote/source/abstract/halaqoh_remote_datasource.dart';
import 'package:my_halaqoh/src/modules/master_data/domain/models/halaqoh_model.dart';

class HalaqohRemoteDataSourceImpl implements HalaqohRemoteDataSource {
  final FirebaseFirestore _firestore;
  CollectionReference<Map<String, dynamic>> get _col =>
      _firestore.collection('halaqoh');

  HalaqohRemoteDataSourceImpl(this._firestore);

  @override
  Stream<List<HalaqohModel>> watchAll() {
    return _col.orderBy('nama').snapshots().map(
          (snap) => snap.docs.map(HalaqohMapper.fromFirestore).toList(),
        );
  }

  @override
  Future<List<HalaqohModel>> getAll() async {
    final snap = await _col.orderBy('nama').get();
    return snap.docs.map(HalaqohMapper.fromFirestore).toList();
  }

  @override
  Future<HalaqohModel?> getById(String id) async {
    final doc = await _col.doc(id).get();
    if (!doc.exists) return null;
    return HalaqohMapper.fromFirestore(doc);
  }

  @override
  Future<String> add(HalaqohModel model) async {
    final docRef = await _col.add(HalaqohMapper.toFirestore(model));

    // Update halaqohId on each santri in this halaqoh
    final batch = _firestore.batch();
    for (final santriId in model.santriIds) {
      batch.update(
        _firestore.collection('santri').doc(santriId),
        {'halaqohId': docRef.id},
      );
    }
    await batch.commit();

    return docRef.id;
  }

  @override
  Future<void> update(HalaqohModel model) async {
    // Get old halaqoh to find removed santri
    final oldDoc = await _col.doc(model.id).get();
    List<String> oldSantriIds = [];
    if (oldDoc.exists) {
      oldSantriIds = List<String>.from(oldDoc.data()?['santriIds'] ?? []);
    }

    // Update halaqoh document
    await _col.doc(model.id).update(HalaqohMapper.toFirestore(model));

    // Batch update santri halaqohId references
    final batch = _firestore.batch();

    // Clear halaqohId from removed santri
    final removedSantri = oldSantriIds
        .where((id) => !model.santriIds.contains(id));
    for (final santriId in removedSantri) {
      batch.update(
        _firestore.collection('santri').doc(santriId),
        {'halaqohId': null},
      );
    }

    // Set halaqohId on newly added santri
    final newSantri = model.santriIds
        .where((id) => !oldSantriIds.contains(id));
    for (final santriId in newSantri) {
      batch.update(
        _firestore.collection('santri').doc(santriId),
        {'halaqohId': model.id},
      );
    }

    await batch.commit();
  }

  @override
  Future<void> delete(String id) async {
    // Clear halaqohId from all santri in this halaqoh
    final doc = await _col.doc(id).get();
    if (doc.exists) {
      final santriIds = List<String>.from(doc.data()?['santriIds'] ?? []);
      final batch = _firestore.batch();
      for (final santriId in santriIds) {
        batch.update(
          _firestore.collection('santri').doc(santriId),
          {'halaqohId': null},
        );
      }
      await batch.commit();
    }

    await _col.doc(id).delete();
  }
}
