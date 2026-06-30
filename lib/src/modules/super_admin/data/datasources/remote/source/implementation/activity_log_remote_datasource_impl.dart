import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:logger/logger.dart';
import 'package:my_halaqoh/src/modules/super_admin/data/datasources/remote/mapper/activity_log_mapper.dart';
import 'package:my_halaqoh/src/modules/super_admin/data/datasources/remote/source/abstract/activity_log_remote_datasource.dart';
import 'package:my_halaqoh/src/modules/super_admin/domain/models/activity_log_model.dart';

/// Firestore implementation of [ActivityLogRemoteDataSource].
class ActivityLogRemoteDataSourceImpl implements ActivityLogRemoteDataSource {
  ActivityLogRemoteDataSourceImpl(this._firestore);

  final FirebaseFirestore _firestore;
  final Logger _logger = Logger();

  CollectionReference<Map<String, dynamic>> get _col =>
      _firestore.collection('activity_log');

  @override
  Stream<List<ActivityLogModel>> watchRecent({int limit = 50}) {
    return _col
        .orderBy('createdAt', descending: true)
        .limit(limit)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map(ActivityLogMapper.fromFirestore)
              .toList(),
        );
  }

  @override
  Future<List<ActivityLogModel>> getFiltered({
    String? filterRole,
    String? filterModule,
    String? filterAction,
    DateTime? fromDate,
    DateTime? toDate,
    int limit = 30,
  }) async {
    try {
      // Ambil lebih banyak dokumen lalu filter di client-side.
      // Pendekatan ini menghindari kebutuhan composite index di Firestore
      // (kombinasi where + orderBy memerlukan index yang harus dibuat manual).
      // Fetch 200 dokumen terbaru lalu filter/slice di client.
      const fetchLimit = 200;
      final snapshot = await _col
          .orderBy('createdAt', descending: true)
          .limit(fetchLimit)
          .get();

      var results = snapshot.docs.map(ActivityLogMapper.fromFirestore).toList();

      // Filter di client-side
      if (filterRole != null && filterRole.isNotEmpty) {
        results = results.where((l) => l.userRole == filterRole).toList();
      }
      if (filterModule != null && filterModule.isNotEmpty) {
        results = results.where((l) => l.module == filterModule).toList();
      }
      if (filterAction != null && filterAction.isNotEmpty) {
        results = results.where((l) => l.action == filterAction).toList();
      }
      if (fromDate != null) {
        results = results.where((l) => !l.createdAt.isBefore(fromDate)).toList();
      }
      if (toDate != null) {
        results = results.where((l) => !l.createdAt.isAfter(toDate)).toList();
      }

      // Terapkan limit akhir setelah filter
      if (results.length > limit) {
        results = results.take(limit).toList();
      }

      return results;
    } catch (e, st) {
      _logger.e('ActivityLogRemoteDS: getFiltered gagal', error: e, stackTrace: st);
      rethrow;
    }
  }
}
