import 'package:my_halaqoh/src/modules/super_admin/domain/models/activity_log_model.dart';

/// Abstract interface for the activity log remote data source.
abstract class ActivityLogRemoteDataSource {
  /// Real-time stream of the most recent [limit] log entries,
  /// ordered by `createdAt` descending.
  Stream<List<ActivityLogModel>> watchRecent({int limit = 50});

  /// Fetches log entries from Firestore with optional filters.
  Future<List<ActivityLogModel>> getFiltered({
    String? filterRole,
    String? filterModule,
    String? filterAction,
    DateTime? fromDate,
    DateTime? toDate,
    int limit = 30,
  });
}
