import 'package:dartz/dartz.dart';
import 'package:my_halaqoh/src/modules/auth/domain/models/device_session_model.dart';
import 'package:my_halaqoh/src/modules/auth/domain/models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

abstract class AuthRepository {
  /// Sign in and return a UserModel if successful, or an error message.
  Future<Either<String, UserModel>> signIn(String identifier, String password);

  /// Get current user metadata.
  Future<Either<String, UserModel>> getCurrentUserMeta();

  /// Sign out
  Future<Either<String, void>> signOut();

  /// Deletes the currently authenticated user's account permanently.
  Future<Either<String, void>> deleteOwnAccount();

  /// Expose the raw auth state stream
  Stream<User?> get authStateChanges;

  /// Registers or updates a device session for [uid] with role-based limits.
  Future<Either<String, void>> registerSession({
    required String uid,
    required String role,
    required DeviceSessionModel session,
  });

  /// Unregisters the current device session upon logout.
  Future<Either<String, void>> unregisterSession({
    required String uid,
    required String deviceId,
  });

  /// Streams the current device's session status from Firestore.
  Stream<DeviceSessionModel?> watchDeviceSession({
    required String uid,
    required String deviceId,
  });

  /// Updates heartbeat/last active timestamp for this device session.
  Future<void> updateDeviceHeartbeat({
    required String uid,
    required String deviceId,
  });
}

