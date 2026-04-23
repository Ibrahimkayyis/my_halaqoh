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
}
