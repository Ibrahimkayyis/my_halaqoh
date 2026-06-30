import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_halaqoh/src/modules/super_admin/domain/models/activity_log_model.dart';

/// Maps between [ActivityLogModel] domain objects and Firestore documents.
class ActivityLogMapper {
  const ActivityLogMapper._();

  /// Creates an [ActivityLogModel] from a Firestore document snapshot.
  static ActivityLogModel fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return ActivityLogModel(
      id: doc.id,
      userId: data['userId'] as String? ?? '',
      userRole: data['userRole'] as String? ?? 'unknown',
      userName: data['userName'] as String? ?? '',
      action: data['action'] as String? ?? '',
      module: data['module'] as String? ?? '',
      entityId: data['entityId'] as String?,
      entityName: data['entityName'] as String?,
      description: data['description'] as String?,
      metadata: (data['metadata'] as Map<String, dynamic>?) ?? {},
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  /// Converts an [ActivityLogModel] to a Firestore-compatible map.
  /// Note: `id` is the document ID and is NOT included in the map.
  static Map<String, dynamic> toFirestore(ActivityLogModel model) {
    return {
      'userId': model.userId,
      'userRole': model.userRole,
      'userName': model.userName,
      'action': model.action,
      'module': model.module,
      if (model.entityId != null) 'entityId': model.entityId,
      if (model.entityName != null) 'entityName': model.entityName,
      if (model.description != null) 'description': model.description,
      if (model.metadata.isNotEmpty) 'metadata': model.metadata,
      'createdAt': Timestamp.fromDate(model.createdAt),
    };
  }
}
