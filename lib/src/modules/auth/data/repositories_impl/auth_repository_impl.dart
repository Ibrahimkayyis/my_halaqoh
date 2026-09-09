import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:my_halaqoh/gen/i18n/translations.g.dart';
import 'package:my_halaqoh/src/modules/auth/data/datasources/remote/auth_remote_datasource.dart';
import 'package:my_halaqoh/src/modules/auth/domain/models/device_session_model.dart';
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

  @override
  Future<Either<String, void>> deleteOwnAccount() async {
    try {
      await _remoteDataSource.deleteOwnAccount();
      return const Right(null);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'requires-recent-login') {
        return const Left(
          'Demi keamanan, silakan keluar dan masuk kembali sebelum menghapus akun.',
        );
      }
      return Left(_mapFirebaseAuthError(e));
    } catch (e) {
      return Left(e.toString().replaceAll('Exception: ', ''));
    }
  }

  @override
  Future<Either<String, void>> registerSession({
    required String uid,
    required String role,
    required DeviceSessionModel session,
  }) async {
    try {
      await _remoteDataSource.registerSession(
        uid: uid,
        role: role,
        session: session,
      );
      return const Right(null);
    } catch (e) {
      return Left('Gagal mendaftarkan sesi perangkat: ${e.toString()}');
    }
  }

  @override
  Future<Either<String, void>> unregisterSession({
    required String uid,
    required String deviceId,
  }) async {
    try {
      await _remoteDataSource.unregisterSession(
        uid: uid,
        deviceId: deviceId,
      );
      return const Right(null);
    } catch (e) {
      return Left('Gagal menghapus sesi perangkat: ${e.toString()}');
    }
  }

  @override
  Stream<DeviceSessionModel?> watchDeviceSession({
    required String uid,
    required String deviceId,
  }) {
    return _remoteDataSource.watchDeviceSession(
      uid: uid,
      deviceId: deviceId,
    );
  }

  @override
  Future<void> updateDeviceHeartbeat({
    required String uid,
    required String deviceId,
  }) {
    return _remoteDataSource.updateDeviceHeartbeat(
      uid: uid,
      deviceId: deviceId,
    );
  }


  String _mapFirebaseAuthError(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
      case 'wrong-password':
      case 'invalid-credential':
        // Standardized anti-enumeration error message:
        // Returns the same message whether the identifier does not exist
        // or the password was incorrect.
        return t.auth.errorInvalidCredentials;
      case 'invalid-email':
        return t.auth.errorInvalidEmail;
      case 'network-request-failed':
        return t.auth.errorNetwork;
      case 'too-many-requests':
        return t.auth.errorTooManyRequests;
      case 'user-disabled':
        return t.auth.errorUserDisabled;
      default:
        return t.auth.errorGeneric(message: e.message ?? '');
    }
  }
}
