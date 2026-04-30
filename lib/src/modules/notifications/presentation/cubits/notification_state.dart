import 'package:freezed_annotation/freezed_annotation.dart';

part 'notification_state.freezed.dart';

/// State for [NotificationCubit].
///
/// Tracks the lifecycle of FCM token registration and refresh.
@freezed
abstract class NotificationState with _$NotificationState {
  /// Initial state before [NotificationCubit.initialize] is called.
  const factory NotificationState.initial() = _Initial;

  /// Requesting OS permission and/or saving token to Firestore.
  const factory NotificationState.loading() = _Loading;

  /// Token successfully obtained and persisted to Firestore.
  const factory NotificationState.tokenSaved() = _TokenSaved;

  /// Permission denied or FCM unavailable — no token registered.
  /// This is NOT treated as a failure; the app continues normally.
  const factory NotificationState.permissionDenied() = _PermissionDenied;

  /// An unexpected error occurred during token retrieval or Firestore write.
  const factory NotificationState.error(String message) = _Error;
}
