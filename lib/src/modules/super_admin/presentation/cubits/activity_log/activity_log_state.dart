import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:my_halaqoh/src/modules/super_admin/domain/models/activity_log_model.dart';

part 'activity_log_state.freezed.dart';

/// State for [ActivityLogCubit].
@freezed
abstract class ActivityLogState with _$ActivityLogState {
  const factory ActivityLogState.initial() = _Initial;
  const factory ActivityLogState.loading() = _Loading;
  const factory ActivityLogState.loaded(List<ActivityLogModel> logs) = _Loaded;
  const factory ActivityLogState.error(String message) = _Error;
}
