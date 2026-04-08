import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_halaqoh/src/modules/master_data/domain/models/halaqoh_model.dart';

/// Maps [HalaqohModel] ↔ Firestore document JSON.
class HalaqohMapper {
  const HalaqohMapper._();

  static HalaqohModel fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data()!;
    return HalaqohModel(
      id: doc.id,
      nama: data['nama'] as String,
      kelas: data['kelas'] as String,
      program: data['program'] as String,
      guruId: data['guruId'] as String,
      guruNama: data['guruNama'] as String,
      santriIds: List<String>.from(data['santriIds'] ?? []),
      jumlahSantri: data['jumlahSantri'] as int? ?? 0,
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      updatedAt: (data['updatedAt'] as Timestamp).toDate(),
    );
  }

  static Map<String, dynamic> toFirestore(HalaqohModel model) {
    return {
      'nama': model.nama,
      'kelas': model.kelas,
      'program': model.program,
      'guruId': model.guruId,
      'guruNama': model.guruNama,
      'santriIds': model.santriIds,
      'jumlahSantri': model.jumlahSantri,
      'createdAt': Timestamp.fromDate(model.createdAt),
      'updatedAt': Timestamp.fromDate(model.updatedAt),
    };
  }
}
