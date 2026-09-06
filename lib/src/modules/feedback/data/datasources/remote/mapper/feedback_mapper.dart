import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../domain/models/feedback_model.dart';

/// Mapper class converting between Firestore documents and [FeedbackModel].
class FeedbackMapper {
  FeedbackMapper._();

  /// Converts a Firestore [DocumentSnapshot] into a [FeedbackModel].
  static FeedbackModel fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>? ?? {};
    return FeedbackModel(
      id: doc.id,
      userId: data['userId'] as String? ?? '',
      userName: data['userName'] as String? ?? '',
      userRole: data['userRole'] as String? ?? '',
      userIdentifier: data['userIdentifier'] as String? ?? '',
      category: data['category'] as String? ?? 'saran',
      title: data['title'] as String? ?? '',
      description: data['description'] as String? ?? '',
      attachmentUrls: (data['attachmentUrls'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      appVersion: data['appVersion'] as String? ?? '',
      deviceModel: data['deviceModel'] as String? ?? '',
      osVersion: data['osVersion'] as String? ?? '',
      status: data['status'] as String? ?? 'open',
      createdAt: (data['createdAt'] as Timestamp?)?.toDate(),
    );
  }

  /// Converts a [FeedbackModel] into a Firestore document map.
  static Map<String, dynamic> toFirestore(FeedbackModel model) {
    return {
      'userId': model.userId,
      'userName': model.userName,
      'userRole': model.userRole,
      'userIdentifier': model.userIdentifier,
      'category': model.category,
      'title': model.title,
      'description': model.description,
      'attachmentUrls': model.attachmentUrls,
      'appVersion': model.appVersion,
      'deviceModel': model.deviceModel,
      'osVersion': model.osVersion,
      'status': model.status,
      'createdAt': model.createdAt != null
          ? Timestamp.fromDate(model.createdAt!)
          : FieldValue.serverTimestamp(),
    };
  }
}
