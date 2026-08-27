import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_halaqoh/src/modules/notifications/data/services/wali_santri_notification_service.dart';
import 'package:my_halaqoh/src/modules/notifications/domain/models/wali_santri_notification_item.dart';

import 'notification_badge_state.dart';

/// Global singleton cubit that owns THE single live subscription for in-app
/// notifications (absensi / hafalan / sertifikasi).
///
/// Design (Instagram-style badge):
/// - Started once per login session by the dashboard wrappers (or lazily by
///   [NotificationListScreen] on deep links) via [start].
/// - Dashboard headers and the notification list screen consume THIS cubit's
///   state instead of each creating their own Firestore subscriptions.
/// - Read-state changes (SharedPreferences) are pushed reactively by
///   [WaliSantriNotificationService], so marking notifications as read updates
///   every badge instantly — no tab switching required.
///
/// MUST be registered as a Singleton in GetIt (same reasoning as
/// [NotificationCubit]) and stopped on logout via [stop].
class NotificationBadgeCubit extends Cubit<NotificationBadgeState> {
  final WaliSantriNotificationService _service;

  StreamSubscription<List<WaliSantriNotificationItem>>? _sub;

  // Active session parameters — used for idempotent restart guards and
  // for resolving the correct SharedPreferences read-state key.
  String? _activeUid;
  String? _activeLinkedDocId;
  bool? _activeIsWaliSantri;

  /// Whether the badge pipeline currently holds a live subscription.
  bool get isRunning => _sub != null;

  NotificationBadgeCubit(this._service) : super(const NotificationBadgeState.idle());

  /// Starts (or restarts) the live notification pipeline.
  ///
  /// [isWaliSantri] — `true` for santri/wali santri sources (absensi +
  ///   hafalan + sertifikasi), `false` for guru sources (sertifikasi).
  /// [linkedDocId] — the effective guru/santri document id (use
  ///   `ActiveSessionHelper.getActiveLinkedDocId` so impersonation works).
  /// [uid] — the REAL logged-in Firebase Auth uid (SharedPreferences key).
  Future<void> start({
    required bool isWaliSantri,
    required String linkedDocId,
    required String uid,
  }) async {
    if (linkedDocId.isEmpty || uid.isEmpty) return;

    // Idempotent guard: ignore restarts for the exact same session.
    if (_sub != null &&
        _activeIsWaliSantri == isWaliSantri &&
        _activeLinkedDocId == linkedDocId &&
        _activeUid == uid) {
      return;
    }

    await stop();

    _activeIsWaliSantri = isWaliSantri;
    _activeLinkedDocId = linkedDocId;
    _activeUid = uid;

    final stream = isWaliSantri
        ? _service.watchNotificationsForSantri(linkedDocId, uid)
        : _service.watchNotificationsForGuru(linkedDocId, uid);

    _sub = stream.listen(
      (items) {
        if (isClosed) return;
        final unreadCount = items.where((n) => !n.isRead).length;
        emit(NotificationBadgeState.loaded(items: items, unreadCount: unreadCount));
      },
      // Errors are swallowed — a broken notification stream must never crash
      // or surface errors to the user.
      onError: (_) {},
    );
  }

  /// Cancels the live subscription and resets to idle. Call on logout.
  Future<void> stop() async {
    await _sub?.cancel();
    _sub = null;
    _activeUid = null;
    _activeLinkedDocId = null;
    _activeIsWaliSantri = null;
    if (!isClosed) {
      emit(const NotificationBadgeState.idle());
    }
  }

  /// Latest loaded items (empty when idle).
  List<WaliSantriNotificationItem> get currentItems => state.maybeWhen(
        loaded: (items, _) => items,
        orElse: () => const [],
      );

  /// Marks ALL currently loaded notifications as read. The service fires a
  /// reactive re-emission, so every listening UI updates instantly.
  Future<void> markAllAsRead() async {
    final uid = _activeUid;
    if (uid == null || uid.isEmpty) return;
    await _service.markAllAsRead(
      uid,
      currentItems.map((n) => n.id).toList(),
    );
  }

  /// Marks a single notification as read. Reactive — see [markAllAsRead].
  Future<void> markAsRead(WaliSantriNotificationItem item) async {
    final uid = _activeUid;
    if (uid == null || uid.isEmpty) return;
    await _service.markAsRead(uid, item.id);
  }
}