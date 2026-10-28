import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_halaqoh/src/modules/master_data/domain/models/target_hafalan_model.dart';

/// Maps [TargetHafalanModel] ↔ Firestore document JSON.
class TargetHafalanMapper {
  const TargetHafalanMapper._();

  static TargetHafalanModel fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data() ?? {};
    return TargetHafalanModel(
      id: doc.id,
      kelas: data['kelas']?.toString() ?? '',
      program: data['program']?.toString() ?? '',
      tahunAjaran: data['tahunAjaran']?.toString() ?? '',
      semesterAktif: (data['semesterAktif'] as num?)?.toInt(),
      createdAt: _parseDateTime(data['createdAt']),
      updatedAt: _parseDateTime(data['updatedAt']),
    );
  }

  static DateTime _parseDateTime(dynamic value) {
    if (value is Timestamp) return value.toDate();
    if (value is DateTime) return value;
    if (value is String) {
      final parsed = DateTime.tryParse(value);
      if (parsed != null) return parsed;
    }
    return DateTime.now();
  }

  static Map<String, dynamic> toFirestore(TargetHafalanModel model) {
    return {
      'kelas': model.kelas,
      'program': model.program,
      'tahunAjaran': model.tahunAjaran,
      'semesterAktif': model.semesterAktif,
      'createdAt': Timestamp.fromDate(model.createdAt),
      'updatedAt': Timestamp.fromDate(model.updatedAt),
    };
  }
}
