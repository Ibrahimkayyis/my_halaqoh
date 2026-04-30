import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../domain/models/absensi_model.dart';
import '../../../../domain/models/absensi_record_entry.dart';

/// Maps between Firestore documents and [AbsensiModel].
class AbsensiMapper {
  const AbsensiMapper._();

  static AbsensiModel fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final data = doc.data()!;
    final recordsList = (data['records'] as List<dynamic>?) ?? [];
    final records = recordsList.map((r) {
      final map = r as Map<String, dynamic>;
      return AbsensiRecordEntry(
        santriId: map['santriId'] as String,
        nis: map['nis'] as String,
        nama: map['nama'] as String,
        status: map['status'] as String,
      );
    }).toList();

    return AbsensiModel(
      id: doc.id,
      halaqohId: data['halaqohId'] as String,
      guruId: data['guruId'] as String,
      tanggal: (data['tanggal'] as Timestamp).toDate(),
      sesi: data['sesi'] as String,
      records: records,
      isSynced: true,
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      updatedAt: (data['updatedAt'] as Timestamp).toDate(),
      // CRITICAL: notifiedAt is a Firestore Timestamp set by Cloud Function.
      // Must be explicitly cast — json_serializable cannot handle Timestamp
      // automatically and will throw a type-casting crash otherwise.
      notifiedAt: (data['notifiedAt'] as Timestamp?)?.toDate(),
    );
  }

  static Map<String, dynamic> toFirestore(AbsensiModel model) {
    // NOTE: `notifiedAt` is intentionally EXCLUDED from this map.
    // It is a server-only field written exclusively by the Cloud Function
    // after dispatching FCM messages. Writing it from the client would
    // corrupt the deduplication logic in sendAbsensiNotification.
    return {
      'halaqohId': model.halaqohId,
      'guruId': model.guruId,
      'tanggal': Timestamp.fromDate(model.tanggal),
      'sesi': model.sesi,
      'records': model.records
          .map((r) => {
                'santriId': r.santriId,
                'nis': r.nis,
                'nama': r.nama,
                'status': r.status,
              })
          .toList(),
      'isSynced': true,
      'createdAt': Timestamp.fromDate(model.createdAt),
      'updatedAt': Timestamp.fromDate(model.updatedAt),
    };
  }
}

