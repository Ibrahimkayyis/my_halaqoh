import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_halaqoh/src/modules/master_data/domain/models/target_hafalan_model.dart';

/// Maps [TargetHafalanModel] ↔ Firestore document JSON.
class TargetHafalanMapper {
  const TargetHafalanMapper._();

  static TargetHafalanModel fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data()!;
    return TargetHafalanModel(
      id: doc.id,
      kelas: data['kelas'] as String,
      program: data['program'] as String,
      tahunAjaran: data['tahunAjaran'] as String? ?? '',
      semesterAktif: data['semesterAktif'] as int?,
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      updatedAt: (data['updatedAt'] as Timestamp).toDate(),
    );
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

