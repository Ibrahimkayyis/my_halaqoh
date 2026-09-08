import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_halaqoh/src/modules/auth/domain/models/device_session_model.dart';

/// Maps [DeviceSessionModel] ↔ Firestore document JSON for `/users/{uid}/devices/{deviceId}`.
class DeviceSessionMapper {
  const DeviceSessionMapper._();

  static DeviceSessionModel fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data()!;
    return DeviceSessionModel(
      deviceId: (data['deviceId'] as String?) ?? doc.id,
      deviceName: (data['deviceName'] as String?) ?? 'Perangkat',
      sessionId: (data['sessionId'] as String?) ?? '',
      fcmToken: data['fcmToken'] as String?,
      lastActiveAt: data['lastActiveAt'] != null
          ? (data['lastActiveAt'] as Timestamp).toDate()
          : DateTime.now(),
      platform: (data['platform'] as String?) ?? 'android',
      isTerminated: (data['isTerminated'] as bool?) ?? false,
      terminatedBy: data['terminatedBy'] as String?,
    );
  }

  static Map<String, dynamic> toFirestore(DeviceSessionModel model) {
    return {
      'deviceId': model.deviceId,
      'deviceName': model.deviceName,
      'sessionId': model.sessionId,
      'fcmToken': model.fcmToken,
      'lastActiveAt': FieldValue.serverTimestamp(),
      'platform': model.platform,
      'isTerminated': model.isTerminated,
      'terminatedBy': model.terminatedBy,
    };
  }
}
