import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_halaqoh/src/modules/wali_santri_hafalan/domain/models/wali_santri_hafalan_model.dart';
import '../abstract/wali_santri_hafalan_remote_datasource.dart';
import '../../mapper/wali_santri_hafalan_mapper.dart';

class WaliSantriHafalanRemoteDataSourceImpl
    implements WaliSantriHafalanRemoteDataSource {
  final FirebaseFirestore _firestore;

  WaliSantriHafalanRemoteDataSourceImpl(this._firestore);

  @override
  Stream<List<WaliSantriHafalanModel>> watchHafalanBySantriId(
    String santriId,
    int month,
    int year,
  ) {
    // Start of month: 00:00:00
    final start = DateTime(year, month, 1);
    // End of month: Calculate by moving to the next month, day 1, minus 1 millisecond
    final end = DateTime(
      year,
      month + 1,
      1,
    ).subtract(const Duration(milliseconds: 1));

    return _firestore
        .collection('hafalan_santri')
        .where('santriId', isEqualTo: santriId)
        .where(
          'tanggalSetoran',
          isGreaterThanOrEqualTo: Timestamp.fromDate(start),
        )
        .where('tanggalSetoran', isLessThanOrEqualTo: Timestamp.fromDate(end))
        .orderBy('tanggalSetoran', descending: true)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs
              .map(WaliSantriHafalanMapper.fromFirestore)
              .toList();
        });
  }

  @override
  Stream<List<WaliSantriHafalanModel>> watchAllZiyadahBySantriId(
    String santriId,
  ) {
    return _firestore
        .collection('hafalan_santri')
        .where('santriId', isEqualTo: santriId)
        .where('jenis', isEqualTo: 'Ziyadah')
        .snapshots()
        .map((snapshot) {
          return snapshot.docs
              .map(WaliSantriHafalanMapper.fromFirestore)
              .toList();
        });
  }
}
