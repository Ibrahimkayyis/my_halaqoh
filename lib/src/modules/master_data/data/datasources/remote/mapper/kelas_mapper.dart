import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_halaqoh/src/modules/master_data/domain/models/kelas_model.dart';

class KelasMapper {
  const KelasMapper._();

  static KelasModel fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data()!;
    return KelasModel(
      id: doc.id,
      nama: data['nama'] as String,
      urutan: data['urutan'] as int? ?? 0,
      nextKelasId: data['nextKelasId'] as String?,
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      updatedAt: (data['updatedAt'] as Timestamp).toDate(),
    );
  }

  static Map<String, dynamic> toFirestore(KelasModel model) {
    return {
      'nama': model.nama,
      'urutan': model.urutan,
      'nextKelasId': model.nextKelasId,
      'createdAt': Timestamp.fromDate(model.createdAt),
      'updatedAt': Timestamp.fromDate(model.updatedAt),
    };
  }
}
