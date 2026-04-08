import 'package:dartz/dartz.dart';
import 'package:my_halaqoh/src/modules/auth/domain/models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

abstract class AuthRepository {
  /// Sign in and return a UserModel if successful, or an error message.
  Future<Either<String, UserModel>> signIn(String identifier, String password);

  /// Get current user metadata.
  Future<Either<String, UserModel>> getCurrentUserMeta();

  /// Sign out
  Future<Either<String, void>> signOut();

  /// Expose the raw auth state stream
  Stream<User?> get authStateChanges;
}
