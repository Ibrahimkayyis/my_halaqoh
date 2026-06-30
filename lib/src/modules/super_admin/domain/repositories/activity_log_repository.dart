import 'package:dartz/dartz.dart';
import 'package:my_halaqoh/src/modules/super_admin/domain/models/activity_log_model.dart';

/// Abstract contract for the activity log repository.
///
/// Domain layer only — no data layer imports allowed here.
abstract class ActivityLogRepository {
  /// Real-time stream of the [limit] most recent log entries,
  /// ordered by `createdAt` descending.
  Stream<List<ActivityLogModel>> watchRecent({int limit = 50});

  /// Fetches log entries with optional filters.
  ///
  /// Returns [Left] with an error message on failure,
  /// or [Right] with the matching list on success.
  Future<Either<String, List<ActivityLogModel>>> getFiltered({
    String? filterRole,
    String? filterModule,
    String? filterAction,
    DateTime? fromDate,
    DateTime? toDate,
    int limit = 30,
  });
}
