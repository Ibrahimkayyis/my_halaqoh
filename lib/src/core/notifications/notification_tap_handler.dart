import 'package:flutter/foundation.dart';

/// Global [ValueNotifier] for cross-layer notification-tap routing.
///
/// **Set by**: The app-level FCM handlers registered in `main.dart`:
///   - [FirebaseMessaging.onMessageOpenedApp] → background state
///   - [FirebaseMessaging.instance.getInitialMessage] → terminated state
///   - [FlutterLocalNotificationsPlugin.onDidReceiveNotificationResponse]
///     → foreground local-notification tap
///
/// **Consumed by**: [WaliSantriDashboardWrapperScreen], which listens to
/// changes and calls `_navigateToTab()` accordingly.
///
/// Values:
///   `null` — no pending navigation
///   `1`    — navigate to Hafalan tab
///   `2`    — navigate to Absensi tab
final ValueNotifier<int?> pendingNotificationTab = ValueNotifier<int?>(null);
