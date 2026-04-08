import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_halaqoh/src/modules/master_data/domain/models/santri_model.dart';
import 'package:my_halaqoh/src/modules/master_data/domain/models/wali_santri_model.dart';

/// Maps [SantriModel] ↔ Firestore document JSON.
class SantriMapper {
  const SantriMapper._();

  static SantriModel fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data()!;
    return SantriModel(
      id: doc.id,
      nis: data['nis'] as String,
      nama: data['nama'] as String,
      profilePicture: data['profilePicture'] as String?,
      kelas: data['kelas'] as String,
      program: data['program'] as String,
      halaqohId: data['halaqohId'] as String?,
      waliSantri: data['waliSantri'] != null
          ? WaliSantriModel.fromJson(
              Map<String, dynamic>.from(data['waliSantri'] as Map))
          : null,
      authUid: data['authUid'] as String?,
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      updatedAt: (data['updatedAt'] as Timestamp).toDate(),
    );
  }

  static Map<String, dynamic> toFirestore(SantriModel model) {
    return {
      'nis': model.nis,
      'nama': model.nama,
      'profilePicture': model.profilePicture,
      'kelas': model.kelas,
      'program': model.program,
      'halaqohId': model.halaqohId,
      'waliSantri': model.waliSantri?.toJson(),
      'authUid': model.authUid,
      'createdAt': Timestamp.fromDate(model.createdAt),
      'updatedAt': Timestamp.fromDate(model.updatedAt),
    };
  }
}
