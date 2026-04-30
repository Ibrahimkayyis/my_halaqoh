/// Abstract contract for the FCM notification remote data source.
///
/// All methods interact directly with the `firebase_messaging` SDK and
/// Firestore. This layer has no knowledge of Either or domain types —
/// it throws on error and the repository implementation handles wrapping.
abstract class NotificationRemoteDataSource {
  /// Requests OS notification permission and returns the FCM device token.
  /// Returns `null` if permission is denied or FCM is unavailable.
  Future<String?> requestPermissionAndGetToken();

  /// Writes [token] to `/users/{uid}` as `fcmToken`.
  Future<void> saveToken(String uid, String token);

  /// Sets `fcmToken` to null in `/users/{uid}`.
  Future<void> clearToken(String uid);

  /// Stream that emits whenever FCM issues a new device token.
  Stream<String> get onTokenRefresh;
}
