import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:my_halaqoh/src/modules/notifications/domain/models/wali_santri_notification_item.dart';

part 'notification_badge_state.freezed.dart';

/// State for the global notification badge pipeline ([NotificationBadgeCubit]).
@freezed
abstract class NotificationBadgeState with _$NotificationBadgeState {
  /// No active session — badge pipeline stopped (e.g., after logout).
  const factory NotificationBadgeState.idle() = _Idle;

  /// Live data received. [unreadCount] drives the red dot indicator.
  const factory NotificationBadgeState.loaded({
    required List<WaliSantriNotificationItem> items,
    required int unreadCount,
  }) = _Loaded;
}