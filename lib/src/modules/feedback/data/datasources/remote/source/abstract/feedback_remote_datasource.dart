import '../../../../../domain/models/feedback_model.dart';

/// Abstract interface for Feedback Remote Data Source.
abstract class FeedbackRemoteDataSource {
  /// Saves the feedback document to Firestore `/feedback/{autoId}`.
  /// Returns the newly generated document ID.
  Future<String> submitFeedback(FeedbackModel feedback);

  /// Uploads an image file to Firebase Storage under `feedback_attachments/{feedbackId}/`
  /// and returns the public download URL.
  Future<String> uploadAttachment({
    required String feedbackId,
    required String filePath,
    required int index,
  });

  /// Writes a document to Firestore `/mail` collection to trigger
  /// the Firebase 'Trigger Email from Firestore' extension, delivering an email
  /// to the developer in real time.
  Future<void> sendEmailNotification({
    required FeedbackModel feedback,
    required String feedbackId,
  });

  /// Fetches feedbacks submitted by a specific user.
  Future<List<FeedbackModel>> getFeedbackByUserId(String userId);
}
