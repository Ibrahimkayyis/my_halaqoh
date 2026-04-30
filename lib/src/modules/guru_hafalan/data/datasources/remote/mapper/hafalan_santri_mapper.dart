import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../domain/models/hafalan_santri_model.dart';

class HafalanSantriMapper {
  static HafalanSantriModel fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return HafalanSantriModel(
      id: doc.id,
      santriId: data['santriId'] as String? ?? '',
      guruId: data['guruId'] as String? ?? '',
      halaqohId: data['halaqohId'] as String? ?? '',
      tanggalSetoran: (data['tanggalSetoran'] as Timestamp).toDate(),
      jenis: data['jenis'] as String? ?? '',
      surahId: data['surahId'] as int? ?? 1,
      surahName: data['surahName'] as String? ?? '',
      ayatMulai: data['ayatMulai'] as int? ?? 1,
      ayatSelesai: data['ayatSelesai'] as int? ?? 1,
      juz: data['juz'] as int? ?? 1,
      nilaiKelancaran: data['nilaiKelancaran'] as int? ?? 0,
      nilaiTajwid: data['nilaiTajwid'] as int? ?? 0,
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      isSynced: true, // Data from Firestore is by definition synced
      // CRITICAL: notifiedAt is a Firestore Timestamp set by Cloud Function.
      // Must be explicitly cast — json_serializable cannot handle Timestamp
      // automatically and will throw a type-casting crash otherwise.
      notifiedAt: (data['notifiedAt'] as Timestamp?)?.toDate(),
    );
  }

  static Map<String, dynamic> toFirestore(HafalanSantriModel model) {
    // NOTE: `notifiedAt` is intentionally EXCLUDED from this map.
    // It is a server-only field written exclusively by the Cloud Function
    // after dispatching FCM messages. Writing it from the client would
    // corrupt the deduplication logic in sendHafalanNotification.
    return {
      'santriId': model.santriId,
      'guruId': model.guruId,
      'halaqohId': model.halaqohId,
      'tanggalSetoran': Timestamp.fromDate(model.tanggalSetoran),
      'jenis': model.jenis,
      'surahId': model.surahId,
      'surahName': model.surahName,
      'ayatMulai': model.ayatMulai,
      'ayatSelesai': model.ayatSelesai,
      'juz': model.juz,
      'nilaiKelancaran': model.nilaiKelancaran,
      'nilaiTajwid': model.nilaiTajwid,
      'createdAt': Timestamp.fromDate(model.createdAt),
      'isSynced': true, // Always true — data going to Firestore is synced by definition
    };
  }
}
