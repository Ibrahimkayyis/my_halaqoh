import 'package:freezed_annotation/freezed_annotation.dart';

part 'sertifikasi_model.freezed.dart';
part 'sertifikasi_model.g.dart';

/// Domain model for Sertifikasi Ujian Tahfidz (1 Juz Full Exam Certification).
/// Maps to Firestore collection: /sertifikasi_tahfidz/{id}
@freezed
abstract class SertifikasiModel with _$SertifikasiModel {
  const factory SertifikasiModel({
    /// Document ID in Firestore
    required String id,

    /// Target Santri Info
    required String santriId,
    required String santriNama,
    required String nis,
    required String kelas,
    required String program,
    String? profilePicture,

    /// Halaqoh & Teacher Info
    required String halaqohId,
    required String halaqohNama,
    required String guruId,
    required String guruNama,

    /// Tested Juz (1..30)
    required int juz,

    /// Teacher's preparation note
    String? catatanGuru,

    /// Status: 'pending' | 'scheduled' | 'rejected' | 'passed' | 'failed'
    @Default('pending') String status,

    /// Scheduling info (filled by Waka Tahfidz)
    DateTime? tanggalUjian,
    String? sesiUjian,
    String? pengujiId,
    String? pengujiNama,
    String? catatanAdmin,
    String? alasanPenolakan,

    /// Exam Score & Evaluation (filled after exam)
    double? nilaiKelancaran,
    double? nilaiTajwid,
    double? nilaiMakhroj,
    double? nilaiTotal,
    String? predikat,
    String? catatanPenguji,

    /// Timestamps
    required DateTime createdAt,
    required DateTime updatedAt,
    DateTime? completedAt,
  }) = _SertifikasiModel;

  factory SertifikasiModel.fromJson(Map<String, dynamic> json) =>
      _$SertifikasiModelFromJson(json);
}
