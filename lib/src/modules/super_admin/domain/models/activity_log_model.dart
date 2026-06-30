import 'package:freezed_annotation/freezed_annotation.dart';

part 'activity_log_model.freezed.dart';
part 'activity_log_model.g.dart';

/// Domain model for an activity log entry.
/// Maps to Firestore collection: `/activity_log/{id}`
///
/// Note: This model does NOT have a Hive adapter — logs are never cached
/// locally; they are always streamed directly from Firestore.
@freezed
abstract class ActivityLogModel with _$ActivityLogModel {
  const factory ActivityLogModel({
    /// Firestore document ID (auto-generated)
    required String id,

    /// Firebase Auth UID of the user who performed the action
    required String userId,

    /// Role of the actor: `'admin'` | `'guru'` | `'santri'` | `'super_admin'`
    required String userRole,

    /// Display name of the actor
    required String userName,

    /// Action type: `'login'` | `'logout'` | `'create'` | `'update'` |
    /// `'delete'` | `'save_absensi'` | `'sync_absensi'` | `'add_hafalan'` |
    /// `'sync_hafalan'`
    required String action,

    /// Module name: `'auth'` | `'guru'` | `'santri'` | `'halaqoh'` |
    /// `'target_hafalan'` | `'absensi'` | `'hafalan'`
    required String module,

    /// Firestore doc ID of the affected entity (nullable)
    String? entityId,

    /// Human-readable name of the affected entity (nullable)
    String? entityName,

    /// Human-readable description of the action in Bahasa Indonesia
    String? description,

    /// Additional context data (nullable)
    @Default({}) Map<String, dynamic> metadata,

    /// Timestamp of the log entry
    required DateTime createdAt,
  }) = _ActivityLogModel;

  factory ActivityLogModel.fromJson(Map<String, dynamic> json) =>
      _$ActivityLogModelFromJson(json);
}
