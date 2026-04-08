import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:my_halaqoh/src/modules/auth/domain/models/user_model.dart';

abstract class AuthRemoteDataSource {
  /// Sign in using the user's NIP/NIS and password.
  Future<UserModel> signIn(String identifier, String password);

  /// Signs the user out of the application.
  Future<void> signOut();

  /// Retrieves the current authenticated user's metadata from Firestore.
  /// Throws if no user is logged in.
  Future<UserModel> getCurrentUserMeta();
  
  /// Gets a stream of the authentication state natively.
  Stream<User?> get authStateChanges;
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firestore;

  AuthRemoteDataSourceImpl(this._firebaseAuth, this._firestore);

  @override
  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  @override
  Future<UserModel> signIn(String identifier, String password) async {
    // 1. Build the invisible email used for the account
    final normalizedIdentifier = identifier.trim();
    final email = '$normalizedIdentifier@myhalaqoh.app';

    // 2. Sign in with Firebase Auth natively
    final userCredential = await _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    final uid = userCredential.user!.uid;

    // 3. Fetch metadata from users collection
    final docSnap = await _firestore.collection('users').doc(uid).get();
    if (!docSnap.exists) {
      throw Exception('User metadata not found in the users collection database.');
    }

    final data = docSnap.data()!;
    data['uid'] = uid; // Inject uid into map for JSON processing
    
    return UserModel.fromJson(data);
  }

  @override
  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  @override
  Future<UserModel> getCurrentUserMeta() async {
    final currentUser = _firebaseAuth.currentUser;
    if (currentUser == null) {
      throw Exception('Tidak ada user yang sedang login');
    }

    final docSnap = await _firestore.collection('users').doc(currentUser.uid).get();
    if (!docSnap.exists) {
      // In case metadata is somehow missing but auth matches
      throw Exception('Data metadata pengguna tidak ditemukan di database.');
    }

    final data = docSnap.data()!;
    data['uid'] = currentUser.uid;
    return UserModel.fromJson(data);
  }
}
