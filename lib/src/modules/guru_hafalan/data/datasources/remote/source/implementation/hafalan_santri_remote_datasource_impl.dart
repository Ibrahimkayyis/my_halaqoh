import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../../domain/models/hafalan_santri_model.dart';
import '../abstract/hafalan_santri_remote_datasource.dart';
import '../../mapper/hafalan_santri_mapper.dart';

class HafalanSantriRemoteDataSourceImpl implements HafalanSantriRemoteDataSource {
  final FirebaseFirestore _firestore;

  HafalanSantriRemoteDataSourceImpl(this._firestore);

  CollectionReference get _collection => _firestore.collection('hafalan_santri');

  @override
  Future<HafalanSantriModel> put(HafalanSantriModel model) async {
    final docRef = _collection.doc(model.id);
    await docRef.set(HafalanSantriMapper.toFirestore(model));
    return model.copyWith(isSynced: true);
  }

  @override
  Future<List<HafalanSantriModel>> getBySantriId(String santriId) async {
    final snapshot = await _collection.where('santriId', isEqualTo: santriId).get();
    return snapshot.docs.map((doc) {
      final data = doc.data() as Map<String, dynamic>;
      data['id'] = doc.id;
      return HafalanSantriMapper.fromFirestore(data);
    }).toList();
  }
}
