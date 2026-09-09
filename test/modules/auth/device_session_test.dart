import 'package:flutter_test/flutter_test.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_halaqoh/src/modules/auth/domain/models/device_session_model.dart';
import 'package:my_halaqoh/src/modules/auth/data/datasources/remote/mapper/device_session_mapper.dart';

void main() {
  group('DeviceSessionModel & DeviceSessionMapper Tests', () {
    final now = DateTime(2026, 9, 7, 12, 0, 0);

    final testSession = DeviceSessionModel(
      deviceId: 'device-123',
      deviceName: 'Samsung Galaxy S24',
      sessionId: 'device-123_1788672000000',
      fcmToken: 'fcm-token-xyz',
      lastActiveAt: now,
      platform: 'android',
      isTerminated: false,
      terminatedBy: null,
    );

    test('DeviceSessionModel creates valid instance', () {
      expect(testSession.deviceId, equals('device-123'));
      expect(testSession.deviceName, equals('Samsung Galaxy S24'));
      expect(testSession.isTerminated, isFalse);
      expect(testSession.terminatedBy, isNull);
    });

    test('DeviceSessionModel JSON serialization and deserialization', () {
      final json = testSession.toJson();
      expect(json['deviceId'], equals('device-123'));
      expect(json['deviceName'], equals('Samsung Galaxy S24'));
      expect(json['sessionId'], equals('device-123_1788672000000'));
      expect(json['fcmToken'], equals('fcm-token-xyz'));
      expect(json['isTerminated'], isFalse);

      final deserialized = DeviceSessionModel.fromJson(json);
      expect(deserialized.deviceId, equals(testSession.deviceId));
      expect(deserialized.deviceName, equals(testSession.deviceName));
      expect(deserialized.sessionId, equals(testSession.sessionId));
      expect(deserialized.fcmToken, equals(testSession.fcmToken));
      expect(deserialized.isTerminated, equals(testSession.isTerminated));
    });

    test('DeviceSessionMapper.toFirestore maps all fields correctly with FieldValue.serverTimestamp()', () {
      final map = DeviceSessionMapper.toFirestore(testSession);
      expect(map['deviceId'], equals('device-123'));
      expect(map['deviceName'], equals('Samsung Galaxy S24'));
      expect(map['sessionId'], equals('device-123_1788672000000'));
      expect(map['fcmToken'], equals('fcm-token-xyz'));
      expect(map['lastActiveAt'], isA<FieldValue>());
      expect(map['platform'], equals('android'));
      expect(map['isTerminated'], isFalse);
      expect(map['terminatedBy'], isNull);
    });

    test('DeviceSessionModel copyWith works as expected', () {
      final terminated = testSession.copyWith(
        isTerminated: true,
        terminatedBy: 'Xiaomi 13 Pro',
      );

      expect(terminated.isTerminated, isTrue);
      expect(terminated.terminatedBy, equals('Xiaomi 13 Pro'));
      expect(terminated.deviceId, equals(testSession.deviceId));
      expect(terminated.deviceName, equals(testSession.deviceName));
    });
  });
}
