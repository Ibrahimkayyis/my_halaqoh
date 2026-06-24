import 'dart:async';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../domain/repositories/notification_repository.dart';
import 'notification_state.dart';

/// Manages FCM device token registration and automatic refresh for the
/// currently logged-in Wali Santri.
///
/// Registered as a **Singleton** in GetIt — the [onTokenRefresh] subscription
/// must persist for the entire app session. A Factory registration would tear
/// it down on every navigation, causing missed token rotations.
///
/// Lifecycle:
///   1. [initialize] is called once when the Wali Santri logs in.
///   2. [clearToken] is called by [AuthCubit.logout] before signing out.
class NotificationCubit extends Cubit<NotificationState> {
  final NotificationRepository _repository;
  final SharedPreferences _prefs;
  final _log = Logger();

  StreamSubscription<String>? _tokenRefreshSub;

  NotificationCubit(this._repository, this._prefs) : super(const NotificationState.initial());

  String _prefsKey(String uid) => 'notification_enabled_$uid';

  /// Checks whether notifications are enabled locally in preferences (defaults to true).
  bool isNotificationEnabledLocally(String uid) {
    return _prefs.getBool(_prefsKey(uid)) ?? true;
  }

  /// Requests OS notification permission, retrieves the FCM token, and
  /// persists it to `/users/{uid}.fcmToken` in Firestore.
  ///
  /// Also subscribes to [NotificationRepository.onTokenRefresh] so that
  /// rotated tokens are automatically re-persisted without any user action.
  ///
  /// Safe to call multiple times — subsequent calls cancel and re-subscribe.
  Future<void> initialize(String uid) async {
    emit(const NotificationState.loading());

    final localEnabled = _prefs.getBool(_prefsKey(uid)) ?? true;
    if (!localEnabled) {
      _log.i('NotificationCubit.initialize: notifications disabled by user preference.');
      // Make sure token is cleared from Firestore
      await _repository.clearToken(uid);
      emit(const NotificationState.notificationDisabled());
      return;
    }

    final status = await _repository.checkPermissionStatus();
    _log.i('NotificationCubit.initialize: OS permission status is $status');

    if (status == AuthorizationStatus.denied) {
      _log.w('NotificationCubit.initialize: OS permission is denied.');
      // Make sure token is cleared from Firestore
      await _repository.clearToken(uid);
      emit(const NotificationState.notificationDisabled());
      return;
    }

    if (status == AuthorizationStatus.notDetermined) {
      // Prompt user for permission (first time)
      final token = await _repository.requestPermissionAndGetToken();
      if (token == null) {
        emit(const NotificationState.notificationDisabled());
        return;
      }
      await _saveTokenAndSubscribe(uid, token);
      return;
    }

    // If status is authorized or provisional, get token and save
    final token = await _repository.getTokenOnly();
    if (token == null) {
      emit(const NotificationState.notificationDisabled());
      return;
    }
    await _saveTokenAndSubscribe(uid, token);
  }

  /// Enables notification by checking the OS permission status.
  /// If permission is denied, emits [NotificationState.needsSystemSettings].
  /// If authorized, retrieves the FCM token, persists it, and saves the preference.
  Future<void> enableNotification(String uid) async {
    emit(const NotificationState.loading());

    final status = await _repository.checkPermissionStatus();
    _log.i('NotificationCubit.enableNotification: OS permission status is $status');

    if (status == AuthorizationStatus.denied) {
      _log.w('NotificationCubit.enableNotification: OS permission is denied. Needs system settings.');
      emit(const NotificationState.needsSystemSettings());
      return;
    }

    if (status == AuthorizationStatus.notDetermined) {
      // Prompt OS permission dialog
      final token = await _repository.requestPermissionAndGetToken();
      if (token == null) {
        _log.w('NotificationCubit.enableNotification: permission denied by user.');
        emit(const NotificationState.notificationDisabled());
        return;
      }
      await _prefs.setBool(_prefsKey(uid), true);
      await _saveTokenAndSubscribe(uid, token);
      return;
    }

    // If status is authorized or provisional
    final token = await _repository.getTokenOnly();
    if (token == null) {
      _log.w('NotificationCubit.enableNotification: failed to get token.');
      emit(const NotificationState.notificationDisabled());
      return;
    }
    await _prefs.setBool(_prefsKey(uid), true);
    await _saveTokenAndSubscribe(uid, token);
  }

  /// Disables notification by clearing the token in Firestore and setting preference to false.
  Future<void> disableNotification(String uid) async {
    emit(const NotificationState.loading());

    await _prefs.setBool(_prefsKey(uid), false);
    _tokenRefreshSub?.cancel();
    _tokenRefreshSub = null;

    final result = await _repository.clearToken(uid);
    result.fold(
      (error) {
        _log.e('NotificationCubit.disableNotification failed: $error');
        emit(NotificationState.error(error));
      },
      (_) {
        _log.i('NotificationCubit: token cleared for uid=$uid');
        emit(const NotificationState.notificationDisabled());
      },
    );
  }

  Future<void> _saveTokenAndSubscribe(String uid, String token) async {
    final saveResult = await _repository.saveToken(uid, token);
    saveResult.fold(
      (error) {
        _log.e('NotificationCubit: saveToken failed — $error');
        emit(NotificationState.error(error));
      },
      (_) {
        _log.i('NotificationCubit: token saved for uid=$uid');
        emit(const NotificationState.notificationEnabled());
      },
    );

    // Subscribe to token refresh events
    _tokenRefreshSub?.cancel();
    _tokenRefreshSub = _repository.onTokenRefresh.listen(
      (newToken) async {
        _log.i('NotificationCubit: FCM token rotated — persisting new token.');
        final result = await _repository.saveToken(uid, newToken);
        result.fold(
          (error) => _log.e('NotificationCubit: failed to persist rotated token — $error'),
          (_) => _log.i('NotificationCubit: rotated token saved.'),
        );
      },
      onError: (e) => _log.e('NotificationCubit: onTokenRefresh stream error — $e'),
    );
  }

  /// Clears the FCM token from Firestore. Call this BEFORE [AuthCubit.logout]
  /// so the server does not retain a stale token for a logged-out user.
  Future<void> clearToken(String uid) async {
    _tokenRefreshSub?.cancel();
    _tokenRefreshSub = null;

    final result = await _repository.clearToken(uid);
    result.fold(
      (error) => _log.e('NotificationCubit.clearToken failed: $error'),
      (_) {
        _log.i('NotificationCubit: token cleared for uid=$uid');
        emit(const NotificationState.initial());
      },
    );
  }

  @override
  Future<void> close() {
    _tokenRefreshSub?.cancel();
    return super.close();
  }
}
