import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';

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
  final _log = Logger();

  StreamSubscription<String>? _tokenRefreshSub;

  NotificationCubit(this._repository) : super(const NotificationState.initial());

  /// Requests OS notification permission, retrieves the FCM token, and
  /// persists it to `/users/{uid}.fcmToken` in Firestore.
  ///
  /// Also subscribes to [NotificationRepository.onTokenRefresh] so that
  /// rotated tokens are automatically re-persisted without any user action.
  ///
  /// Safe to call multiple times — subsequent calls cancel and re-subscribe.
  Future<void> initialize(String uid) async {
    emit(const NotificationState.loading());

    // Step 1: Get token (includes permission request)
    final token = await _repository.requestPermissionAndGetToken();

    if (token == null) {
      // Permission denied or FCM unavailable — not an error, just log & exit.
      _log.w('NotificationCubit.initialize: no token — permission likely denied.');
      emit(const NotificationState.permissionDenied());
      return;
    }

    // Step 2: Persist the token to Firestore
    final saveResult = await _repository.saveToken(uid, token);
    saveResult.fold(
      (error) {
        _log.e('NotificationCubit.initialize: saveToken failed — $error');
        emit(NotificationState.error(error));
      },
      (_) {
        _log.i('NotificationCubit.initialize: token saved for uid=$uid');
        emit(const NotificationState.tokenSaved());
      },
    );

    // Step 3: Subscribe to token refresh events for this session
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

  /// Clears the FCM token from Firestore. Call this BEFORE [FirebaseAuth.signOut]
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
