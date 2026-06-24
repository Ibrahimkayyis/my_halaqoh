import 'package:freezed_annotation/freezed_annotation.dart';

part 'notification_state.freezed.dart';

/// State untuk [NotificationCubit].
///
/// Melacak lifecycle pendaftaran dan refresh FCM token,
/// serta status toggle notifikasi dari screen Pengaturan.
@freezed
abstract class NotificationState with _$NotificationState {
  /// State awal sebelum [NotificationCubit.initialize] dipanggil.
  const factory NotificationState.initial() = _Initial;

  /// Sedang meminta permission OS dan/atau menyimpan token ke Firestore.
  const factory NotificationState.loading() = _Loading;

  /// Token berhasil diperoleh dan disimpan ke Firestore.
  const factory NotificationState.tokenSaved() = _TokenSaved;

  /// Permission denied atau FCM tidak tersedia — token tidak terdaftar.
  /// BUKAN error fatal; app tetap berjalan normal.
  const factory NotificationState.permissionDenied() = _PermissionDenied;

  /// Notifikasi berhasil diaktifkan dan token tersimpan di Firestore.
  /// Dipancarkan setelah [NotificationCubit.enableNotification] sukses.
  const factory NotificationState.notificationEnabled() = _NotificationEnabled;

  /// Notifikasi berhasil dinonaktifkan dan token dihapus dari Firestore.
  /// Dipancarkan setelah [NotificationCubit.disableNotification] sukses.
  const factory NotificationState.notificationDisabled() = _NotificationDisabled;

  /// Permission masih `denied` di level OS — user perlu membuka Settings HP
  /// untuk mengaktifkan izin notifikasi terlebih dahulu.
  const factory NotificationState.needsSystemSettings() = _NeedsSystemSettings;

  /// Error tak terduga saat pengambilan token atau penulisan ke Firestore.
  const factory NotificationState.error(String message) = _Error;
}
