import 'package:freezed_annotation/freezed_annotation.dart';

part 'device_session_model.freezed.dart';
part 'device_session_model.g.dart';

/// Represents an active device session stored under `/users/{uid}/devices/{deviceId}`.
@freezed
abstract class DeviceSessionModel with _$DeviceSessionModel {
  const factory DeviceSessionModel({
    /// Unique persistent device identifier
    required String deviceId,

    /// Human-friendly device name (e.g. "Samsung Galaxy S21")
    required String deviceName,

    /// Unique session identifier generated on login
    required String sessionId,

    /// Push notification token for this device
    String? fcmToken,

    /// Timestamp of the last activity or login
    required DateTime lastActiveAt,

    /// OS platform ("android", "ios", etc.)
    required String platform,

    /// Flag set if this session was terminated remotely
    @Default(false) bool isTerminated,

    /// The name of the device that displaced/terminated this session
    String? terminatedBy,
  }) = _DeviceSessionModel;

  factory DeviceSessionModel.fromJson(Map<String, dynamic> json) =>
      _$DeviceSessionModelFromJson(json);
}
