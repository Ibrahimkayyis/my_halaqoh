import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_halaqoh/src/modules/master_data/domain/models/guru_model.dart';

/// Maps [GuruModel] ↔ Firestore document JSON.
class GuruMapper {
  const GuruMapper._();

  static GuruModel fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data()!;
    return GuruModel(
      id: doc.id,
      nip: data['nip'] as String,
      nama: data['nama'] as String,
      phone: data['phone'] as String?,
      profilePicture: data['profilePicture'] as String?,
      program: data['program'] as String? ?? 'R', // Default R for backward compatibility
      authUid: data['authUid'] as String?,
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      updatedAt: (data['updatedAt'] as Timestamp).toDate(),
    );
  }

  static Map<String, dynamic> toFirestore(GuruModel model) {
    return {
      'nip': model.nip,
      'nama': model.nama,
      'phone': model.phone,
      'profilePicture': model.profilePicture,
      'program': model.program,
      'authUid': model.authUid,
      'createdAt': Timestamp.fromDate(model.createdAt),
      'updatedAt': Timestamp.fromDate(model.updatedAt),
    };
  }
}
