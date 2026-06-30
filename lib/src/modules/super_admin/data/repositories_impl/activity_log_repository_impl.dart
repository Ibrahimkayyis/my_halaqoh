import 'package:dartz/dartz.dart';
import 'package:logger/logger.dart';
import 'package:my_halaqoh/src/modules/super_admin/data/datasources/remote/source/abstract/activity_log_remote_datasource.dart';
import 'package:my_halaqoh/src/modules/super_admin/domain/models/activity_log_model.dart';
import 'package:my_halaqoh/src/modules/super_admin/domain/repositories/activity_log_repository.dart';

/// Concrete implementation of [ActivityLogRepository].
///
/// No local (Hive) cache is used — activity logs are always streamed/fetched
/// directly from Firestore.
class ActivityLogRepositoryImpl implements ActivityLogRepository {
  ActivityLogRepositoryImpl(this._remote);

  final ActivityLogRemoteDataSource _remote;
  final Logger _logger = Logger();

  @override
  Stream<List<ActivityLogModel>> watchRecent({int limit = 50}) {
    return _remote.watchRecent(limit: limit);
  }

  @override
  Future<Either<String, List<ActivityLogModel>>> getFiltered({
    String? filterRole,
    String? filterModule,
    String? filterAction,
    DateTime? fromDate,
    DateTime? toDate,
    int limit = 30,
  }) async {
    try {
      final list = await _remote.getFiltered(
        filterRole: filterRole,
        filterModule: filterModule,
        filterAction: filterAction,
        fromDate: fromDate,
        toDate: toDate,
        limit: limit,
      );
      return Right(list);
    } catch (e) {
      _logger.e('ActivityLogRepository: getFiltered gagal — $e');
      return Left('Gagal memuat log aktivitas: $e');
    }
  }
}
