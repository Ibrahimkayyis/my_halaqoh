import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:my_halaqoh/src/modules/auth/data/datasources/remote/auth_remote_datasource.dart';
import 'package:my_halaqoh/src/modules/auth/domain/models/user_model.dart';
import 'package:my_halaqoh/src/modules/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _remoteDataSource;

  AuthRepositoryImpl(this._remoteDataSource);

  @override
  Stream<User?> get authStateChanges => _remoteDataSource.authStateChanges;

  @override
  Future<Either<String, UserModel>> getCurrentUserMeta() async {
    try {
      final userMeta = await _remoteDataSource.getCurrentUserMeta();
      return Right(userMeta);
    } on FirebaseAuthException catch (e) {
      return Left(_mapFirebaseAuthError(e));
    } catch (e) {
      return Left('Failed to load user info: ${e.toString()}');
    }
  }

  @override
  Future<Either<String, UserModel>> signIn(String identifier, String password) async {
    try {
      final userMeta = await _remoteDataSource.signIn(identifier, password);
      return Right(userMeta);
    } on FirebaseAuthException catch (e) {
      return Left(_mapFirebaseAuthError(e));
    } catch (e) {
      return Left('Terjadi kesalahan yang tidak terduga: ${e.toString()}');
    }
  }

  @override
  Future<Either<String, void>> signOut() async {
    try {
      await _remoteDataSource.signOut();
      return const Right(null);
    } catch (e) {
      return Left('Gagal untuk keluar: ${e.toString()}');
    }
  }

  String _mapFirebaseAuthError(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
      case 'invalid-credential':
      case 'invalid-email':
      case 'wrong-password':
        return 'NIP/NIS atau Password salah';
      case 'network-request-failed':
        return 'Tidak ada koneksi internet';
      case 'too-many-requests':
        return 'Terlalu banyak percobaan. Harap tunggu sesaat.';
      case 'user-disabled':
        return 'Akun pengguna ini telah dinonaktifkan.';
      default:
        return 'Error autentikasi: ${e.message}';
    }
  }
}
