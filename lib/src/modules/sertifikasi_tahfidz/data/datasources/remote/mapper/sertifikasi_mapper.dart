import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_halaqoh/src/modules/sertifikasi_tahfidz/domain/models/sertifikasi_model.dart';

/// Maps [SertifikasiModel] ↔ Firestore document JSON.
class SertifikasiMapper {
  const SertifikasiMapper._();

  static SertifikasiModel fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data()!;
    return SertifikasiModel(
      id: doc.id,
      santriId: data['santriId'] as String? ?? '',
      santriNama: data['santriNama'] as String? ?? '',
      nis: data['nis'] as String? ?? '',
      kelas: data['kelas'] as String? ?? '',
      program: data['program'] as String? ?? 'R',
      profilePicture: data['profilePicture'] as String?,
      halaqohId: data['halaqohId'] as String? ?? '',
      halaqohNama: data['halaqohNama'] as String? ?? '',
      guruId: data['guruId'] as String? ?? '',
      guruNama: data['guruNama'] as String? ?? '',
      juz: data['juz'] as int? ?? 1,
      catatanGuru: data['catatanGuru'] as String?,
      status: data['status'] as String? ?? 'pending',
      tanggalUjian: (data['tanggalUjian'] as Timestamp?)?.toDate(),
      sesiUjian: data['sesiUjian'] as String?,
      pengujiId: data['pengujiId'] as String?,
      pengujiNama: data['pengujiNama'] as String?,
      catatanAdmin: data['catatanAdmin'] as String?,
      alasanPenolakan: data['alasanPenolakan'] as String?,
      nilai: data['nilai'] as int?,
      predikat: data['predikat'] as String?,
      catatanPenguji: data['catatanPenguji'] as String?,
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      updatedAt: (data['updatedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      completedAt: (data['completedAt'] as Timestamp?)?.toDate(),
    );
  }

  static Map<String, dynamic> toFirestore(SertifikasiModel model) {
    return {
      'santriId': model.santriId,
      'santriNama': model.santriNama,
      'nis': model.nis,
      'kelas': model.kelas,
      'program': model.program,
      'profilePicture': model.profilePicture,
      'halaqohId': model.halaqohId,
      'halaqohNama': model.halaqohNama,
      'guruId': model.guruId,
      'guruNama': model.guruNama,
      'juz': model.juz,
      'catatanGuru': model.catatanGuru,
      'status': model.status,
      'tanggalUjian': model.tanggalUjian != null
          ? Timestamp.fromDate(model.tanggalUjian!)
          : null,
      'sesiUjian': model.sesiUjian,
      'pengujiId': model.pengujiId,
      'pengujiNama': model.pengujiNama,
      'catatanAdmin': model.catatanAdmin,
      'alasanPenolakan': model.alasanPenolakan,
      'nilai': model.nilai,
      'predikat': model.predikat,
      'catatanPenguji': model.catatanPenguji,
      'createdAt': Timestamp.fromDate(model.createdAt),
      'updatedAt': Timestamp.fromDate(model.updatedAt),
      'completedAt': model.completedAt != null
          ? Timestamp.fromDate(model.completedAt!)
          : null,
    };
  }
}
