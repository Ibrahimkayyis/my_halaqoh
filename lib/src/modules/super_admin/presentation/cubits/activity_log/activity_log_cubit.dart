import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_halaqoh/src/modules/super_admin/domain/models/activity_log_model.dart';
import 'package:my_halaqoh/src/modules/super_admin/domain/repositories/activity_log_repository.dart';
import 'activity_log_state.dart';

/// Cubit for the Activity Log screen.
///
/// Registered as [registerFactory] — only needed while [ActivityLogScreen]
/// is active.
class ActivityLogCubit extends Cubit<ActivityLogState> {
  ActivityLogCubit(this._repository) : super(const ActivityLogState.initial());

  final ActivityLogRepository _repository;
  StreamSubscription<List<ActivityLogModel>>? _subscription;

  /// Start a real-time stream of the [limit] most recent log entries.
  void watchRecent({int limit = 50}) {
    emit(const ActivityLogState.loading());
    _subscription?.cancel();
    _subscription = _repository.watchRecent(limit: limit).listen(
      (logs) => emit(ActivityLogState.loaded(logs)),
      onError: (Object e) => emit(ActivityLogState.error(e.toString())),
    );
  }

  /// Fetch filtered log entries (one-shot, for filter panel).
  Future<void> getFiltered({
    String? filterRole,
    String? filterModule,
    String? filterAction,
    DateTime? fromDate,
    DateTime? toDate,
    int limit = 30,
  }) async {
    emit(const ActivityLogState.loading());
    final result = await _repository.getFiltered(
      filterRole: filterRole,
      filterModule: filterModule,
      filterAction: filterAction,
      fromDate: fromDate,
      toDate: toDate,
      limit: limit,
    );
    result.fold(
      (err) => emit(ActivityLogState.error(err)),
      (logs) => emit(ActivityLogState.loaded(logs)),
    );
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
