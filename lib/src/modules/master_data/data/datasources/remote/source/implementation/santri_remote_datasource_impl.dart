import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:my_halaqoh/src/modules/master_data/data/datasources/remote/mapper/santri_mapper.dart';
import 'package:my_halaqoh/src/modules/master_data/data/datasources/remote/source/abstract/santri_remote_datasource.dart';
import 'package:my_halaqoh/src/modules/master_data/domain/models/santri_model.dart';

class SantriRemoteDataSourceImpl implements SantriRemoteDataSource {
  final FirebaseFirestore _firestore;
  final FirebaseFunctions _functions;

  CollectionReference<Map<String, dynamic>> get _col =>
      _firestore.collection('santri');

  SantriRemoteDataSourceImpl(this._firestore, this._functions);

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
    // 1. Pre-generate a document ID so we can pass linkedDocId to the Cloud Function
    final docRef = _col.doc();

    // 2. Call Cloud Function — it creates Auth user + writes /users + writes /santri atomically
    try {
      final callable = _functions.httpsCallable('createUserAccount');
      await callable.call({
        'identifier': model.nis,
        'name': model.nama,
        'role': 'santri',
        'program': model.program,
        'linkedDocId': docRef.id,
        // Additional santri fields written server-side to bypass Security Rules
        'kelas': model.kelas,
        'profilePicture': model.profilePicture,
        'createdAt': model.createdAt.millisecondsSinceEpoch,
      });

      // Cloud Function succeeded — santri doc was written server-side
      return docRef.id;

    } on FirebaseFunctionsException catch (error) {
      throw Exception('Gagal membuat akun autentikasi: ${error.message}');
    } catch (error) {
      throw Exception('Gagal membuat data santri: $error');
    }
  }

  @override
  Future<int> addBulk(List<SantriModel> models) async {
    try {
      final callable = _functions.httpsCallable('bulkCreateUserAccounts');
      
      // Map to expected CF payload
      final users = models.map((m) => {
        'identifier': m.nis,
        'name': m.nama,
        'role': 'santri',
        'program': m.program,
        'kelas': m.kelas,
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
