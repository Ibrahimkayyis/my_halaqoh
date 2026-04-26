import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../domain/models/wali_santri_hafalan_model.dart';

class WaliSantriHafalanMapper {
  const WaliSantriHafalanMapper._();

  static WaliSantriHafalanModel fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data()!;
    return WaliSantriHafalanModel(
      id: doc.id,
      santriId: data['santriId'] as String,
      guruId: data['guruId'] as String,
      halaqohId: data['halaqohId'] as String,
      tanggalSetoran: (data['tanggalSetoran'] as Timestamp).toDate(),
      jenis: data['jenis'] as String,
      surahId: data['surahId'] as int,
      surahName: data['surahName'] as String,
      ayatMulai: data['ayatMulai'] as int,
      ayatSelesai: data['ayatSelesai'] as int,
      juz: data['juz'] as int,
      nilaiKelancaran: data['nilaiKelancaran'] as int,
      nilaiTajwid: data['nilaiTajwid'] as int,
      createdAt: (data['createdAt'] as Timestamp).toDate(),
    );
  }
}
