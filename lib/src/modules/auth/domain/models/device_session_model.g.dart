// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'device_session_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_DeviceSessionModel _$DeviceSessionModelFromJson(Map<String, dynamic> json) =>
    _DeviceSessionModel(
      deviceId: json['deviceId'] as String,
      deviceName: json['deviceName'] as String,
      sessionId: json['sessionId'] as String,
      fcmToken: json['fcmToken'] as String?,
      lastActiveAt: DateTime.parse(json['lastActiveAt'] as String),
      platform: json['platform'] as String,
      isTerminated: json['isTerminated'] as bool? ?? false,
      terminatedBy: json['terminatedBy'] as String?,
    );

Map<String, dynamic> _$DeviceSessionModelToJson(_DeviceSessionModel instance) =>
    <String, dynamic>{
      'deviceId': instance.deviceId,
      'deviceName': instance.deviceName,
      'sessionId': instance.sessionId,
      'fcmToken': instance.fcmToken,
      'lastActiveAt': instance.lastActiveAt.toIso8601String(),
      'platform': instance.platform,
      'isTerminated': instance.isTerminated,
      'terminatedBy': instance.terminatedBy,
    };
