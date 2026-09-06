import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_halaqoh/src/modules/feedback/data/datasources/remote/mapper/feedback_mapper.dart';
import 'package:my_halaqoh/src/modules/feedback/domain/models/feedback_model.dart';

void main() {
  group('FeedbackMapper & FeedbackModel Tests', () {
    test('FeedbackModel creates valid instance with defaults', () {
      const model = FeedbackModel(
        userId: 'user_123',
        userName: 'Ahmad Dahlan',
        userRole: 'guru',
        userIdentifier: '19850101',
        category: 'bug',
        title: 'Error saat simpan absensi',
        description: 'Aplikasi freeze ketika menekan tombol simpan absensi.',
        appVersion: '1.0.0+1',
        deviceModel: 'Samsung Galaxy A52',
        osVersion: 'Android 13 (SDK 33)',
      );

      expect(model.userId, 'user_123');
      expect(model.userName, 'Ahmad Dahlan');
      expect(model.userRole, 'guru');
      expect(model.userIdentifier, '19850101');
      expect(model.category, 'bug');
      expect(model.status, 'open');
      expect(model.attachmentUrls, isEmpty);
    });

    test('FeedbackMapper.toFirestore converts model accurately', () {
      final now = DateTime(2026, 9, 6, 10, 30);
      final model = FeedbackModel(
        id: 'fb_123',
        userId: 'user_123',
        userName: 'Ahmad Dahlan',
        userRole: 'guru',
        userIdentifier: '19850101',
        category: 'saran',
        title: 'Tambahkan fitur export Excel',
        description: 'Sangat membantu jika laporan bisa di-export ke Excel selain PDF.',
        attachmentUrls: const ['https://storage.googleapis.com/img1.jpg'],
        appVersion: '1.0.0+1',
        deviceModel: 'Pixel 7',
        osVersion: 'Android 14',
        status: 'open',
        createdAt: now,
      );

      final map = FeedbackMapper.toFirestore(model);

      expect(map['userId'], 'user_123');
      expect(map['userName'], 'Ahmad Dahlan');
      expect(map['userRole'], 'guru');
      expect(map['userIdentifier'], '19850101');
      expect(map['category'], 'saran');
      expect(map['title'], 'Tambahkan fitur export Excel');
      expect(map['description'], contains('export ke Excel'));
      expect(map['attachmentUrls'], ['https://storage.googleapis.com/img1.jpg']);
      expect(map['appVersion'], '1.0.0+1');
      expect(map['deviceModel'], 'Pixel 7');
      expect(map['osVersion'], 'Android 14');
      expect(map['status'], 'open');
      expect(map['createdAt'], isA<Timestamp>());
    });

    test('FeedbackModel serialization and deserialization via JSON', () {
      const model = FeedbackModel(
        userId: 'user_wali',
        userName: 'Ibu Fatimah',
        userRole: 'santri',
        userIdentifier: '2024001',
        category: 'pertanyaan',
        title: 'Bagaimana cara melihat nilai tajwid?',
        description: 'Saya ingin melihat detail nilai tajwid hafalan anak saya.',
        appVersion: '1.0.0+1',
        deviceModel: 'Xiaomi Redmi Note 10',
        osVersion: 'Android 12',
      );

      final json = model.toJson();
      final fromJson = FeedbackModel.fromJson(json);

      expect(fromJson.userId, model.userId);
      expect(fromJson.userName, model.userName);
      expect(fromJson.userRole, model.userRole);
      expect(fromJson.category, 'pertanyaan');
      expect(fromJson.status, 'open');
    });
  });
}
