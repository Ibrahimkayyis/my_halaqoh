import 'package:dartz/dartz.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

/// Contract for FCM device token management.
///
/// Responsibilities:
///   - Request OS notification permission and retrieve the current FCM token.
///   - Save / clear the token in Firestore under `/users/{uid}.fcmToken`.
///   - Expose a stream that emits whenever FCM rotates the token, so the
///     caller can persist the new token without polling.
abstract class NotificationRepository {
  /// Requests OS-level notification permission and retrieves the FCM device
  /// token. Returns `null` if the user denies permission or if FCM is
  /// unavailable on this device.
  Future<String?> requestPermissionAndGetToken();

  /// Cek status permission notifikasi OS saat ini tanpa memunculkan dialog.
  /// Digunakan oleh [NotificationCubit.enableNotification] untuk memutuskan
  /// apakah token bisa langsung diambil atau user perlu diarahkan ke Settings.
  Future<AuthorizationStatus> checkPermissionStatus();

  /// Ambil FCM token tanpa request permission baru.
  /// Hanya panggil setelah dipastikan permission sudah authorized.
  Future<String?> getTokenOnly();

  /// Persists [token] to Firestore at `/users/{uid}` under the `fcmToken`
  /// and `fcmTokenUpdatedAt` fields.
  Future<Either<String, void>> saveToken(String uid, String token);

  /// Clears the FCM token from Firestore (sets `fcmToken` to null).
  /// Call this on user logout so stale tokens are not stored.
  Future<Either<String, void>> clearToken(String uid);

  /// Emits a new token string whenever FCM refreshes the device token.
  /// Subscribers should immediately call [saveToken] with the new value.
  Stream<String> get onTokenRefresh;
}
