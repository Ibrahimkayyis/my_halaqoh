import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:logger/logger.dart';

import '../abstract/notification_remote_datasource.dart';

/// Concrete implementation that uses [FirebaseMessaging] for FCM token
/// management and [FirebaseFirestore] to persist the token in Firestore.
///
/// Constructor dependencies are injected via GetIt — never instantiate
/// directly from UI or Cubits.
class NotificationRemoteDataSourceImpl implements NotificationRemoteDataSource {
  final FirebaseMessaging _messaging;
  final FirebaseFirestore _firestore;
  final _log = Logger();

  NotificationRemoteDataSourceImpl(this._messaging, this._firestore);

  // ── Permission & Token Retrieval ──────────────────────────────────────────

  @override
  Future<String?> requestPermissionAndGetToken() async {
    // Step 1: Request OS-level notification permission.
    // On Android 12 and below this is granted automatically.
    // On Android 13+ and iOS this shows a system dialog.
    final settings = await _messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    final status = settings.authorizationStatus;
    if (status == AuthorizationStatus.denied ||
        status == AuthorizationStatus.notDetermined) {
      _log.w(
        'NotificationRemoteDataSource: permission not granted — status: $status',
      );
      return null;
    }

    return _getTokenInternal();
  }

  @override
  Future<AuthorizationStatus> checkPermissionStatus() async {
    // getNotificationSettings() hanya membaca status — TIDAK memunculkan
    // dialog baru kepada user.
    final settings = await _messaging.getNotificationSettings();
    _log.d(
      'NotificationRemoteDataSource: permission status = ${settings.authorizationStatus}',
    );
    return settings.authorizationStatus;
  }

  @override
  Future<String?> getTokenOnly() => _getTokenInternal();

  // ── Internal helper ───────────────────────────────────────────────────────

  Future<String?> _getTokenInternal() async {
    final token = await _messaging.getToken();
    if (token == null) {
      _log.w(
        'NotificationRemoteDataSource: FCM token is null — device may not support FCM.',
      );
    } else {
      _log.i(
        'NotificationRemoteDataSource: FCM token retrieved — ${token.substring(0, 20)}...',
      );
    }
    return token;
  }

  // ── Firestore Token Persistence ───────────────────────────────────────────

  @override
  Future<void> saveToken(String uid, String token) async {
    await _firestore.collection('users').doc(uid).update({
      'fcmToken': token,
      'fcmTokenUpdatedAt': FieldValue.serverTimestamp(),
    });
    _log.i('NotificationRemoteDataSource: FCM token saved for uid=$uid');
  }

  @override
  Future<void> clearToken(String uid) async {
    await _firestore.collection('users').doc(uid).update({
      'fcmToken': null,
      'fcmTokenUpdatedAt': FieldValue.serverTimestamp(),
    });
    _log.i('NotificationRemoteDataSource: FCM token cleared for uid=$uid');
  }

  // ── Token Refresh Stream ──────────────────────────────────────────────────

  @override
  Stream<String> get onTokenRefresh => _messaging.onTokenRefresh;
}
