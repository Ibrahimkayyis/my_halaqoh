import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:my_halaqoh/src/modules/master_data/data/datasources/remote/mapper/guru_mapper.dart';
import 'package:my_halaqoh/src/modules/master_data/data/datasources/remote/source/abstract/guru_remote_datasource.dart';
import 'package:my_halaqoh/src/modules/master_data/domain/models/guru_model.dart';

class GuruRemoteDataSourceImpl implements GuruRemoteDataSource {
  final FirebaseFirestore _firestore;
  final FirebaseFunctions _functions;

  CollectionReference<Map<String, dynamic>> get _col =>
      _firestore.collection('guru');

  GuruRemoteDataSourceImpl(this._firestore, this._functions);

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
    // 1. Get document reference first to obtain ID
    final docRef = _col.doc();
    
    // 2. Call Cloud Function to create User Account mapped to this ID
    try {
      final callable = _functions.httpsCallable('createUserAccount');
      final response = await callable.call({
        'identifier': model.nip,
        'name': model.nama,
        'role': 'guru',
        'program': model.program,
        'linkedDocId': docRef.id,
      });

      // 3. Extract the created Auth UID from response
      final String uid = response.data['uid'];
      
      // Update model with the Auth UID and explicit generated ID
      final updatedModel = model.copyWith(
        id: docRef.id,
        authUid: uid,
      );

      // 4. Save to Firestore
      await docRef.set(GuruMapper.toFirestore(updatedModel));
      return docRef.id;

    } on FirebaseFunctionsException catch (error) {
      throw Exception('Gagal membuat akun autentikasi: ${error.message}');
    } catch (error) {
      throw Exception('Gagal membuat data guru: $error');
    }
  }

  @override
  Future<int> addBulk(List<GuruModel> models) async {
    try {
      final callable = _functions.httpsCallable('bulkCreateUserAccounts');
      
      final users = models.map((m) => {
        'identifier': m.nip,
        'name': m.nama,
        'role': 'guru',
        'program': m.program,
        'phone': m.phone,
      }).toList();

      final response = await callable.call({'users': users});
      return response.data['successCount'] as int;

    } on FirebaseFunctionsException catch (error) {
      throw Exception('Gagal membuat akun bulk: ${error.message}');
    } catch (error) {
      throw Exception('Gagal memproses data bulk: $error');
    }
  }

  @override
  Future<void> update(GuruModel model) async {
    await _col.doc(model.id).update(GuruMapper.toFirestore(model));
  }

  @override
  Future<void> delete(String id) async {
    await _col.doc(id).delete();
  }

  @override
  Future<void> resetPassword(String authUid) async {
    try {
      final callable = _functions.httpsCallable('resetUserPassword');
      await callable.call({'uid': authUid});
    } on FirebaseFunctionsException catch (error) {
      throw Exception('Gagal mereset password: ${error.message}');
    } catch (error) {
      throw Exception('Gagal mereset password: $error');
    }
  }
}
