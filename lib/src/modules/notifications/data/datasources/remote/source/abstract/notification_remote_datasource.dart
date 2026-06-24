import 'package:firebase_messaging/firebase_messaging.dart';

/// Abstract contract for the FCM notification remote data source.
///
/// All methods interact directly with the `firebase_messaging` SDK and
/// Firestore. This layer has no knowledge of Either or domain types —
/// it throws on error and the repository implementation handles wrapping.
abstract class NotificationRemoteDataSource {
  /// Requests OS notification permission and returns the FCM device token.
  /// Returns `null` if permission is denied or FCM is unavailable.
  Future<String?> requestPermissionAndGetToken();

  /// Cek status permission notifikasi OS saat ini **tanpa** memunculkan
  /// dialog permission baru. Berguna untuk menentukan apakah token dapat
  /// langsung diambil atau user perlu diarahkan ke Settings HP.
  Future<AuthorizationStatus> checkPermissionStatus();

  /// Ambil FCM token tanpa meminta permission baru.
  /// Hanya dipanggil setelah dipastikan permission sudah [AuthorizationStatus.authorized].
  Future<String?> getTokenOnly();

  /// Writes [token] to `/users/{uid}` as `fcmToken`.
  Future<void> saveToken(String uid, String token);

  /// Sets `fcmToken` to null in `/users/{uid}`.
  Future<void> clearToken(String uid);

  /// Stream that emits whenever FCM issues a new device token.
  Stream<String> get onTokenRefresh;
}
