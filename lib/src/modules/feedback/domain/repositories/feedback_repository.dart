import '../models/feedback_model.dart';

/// Abstract repository interface for Feedback & Bug Report operations.
abstract class FeedbackRepository {
  /// Submits a feedback or bug report to the remote store.
  /// Also triggers an email notification record to developer.
  /// Returns the created feedback document ID.
  Future<String> submitFeedback(FeedbackModel feedback);

  /// Uploads a screenshot file to Firebase Storage under `feedback_attachments/`
  /// and returns the public/download URL.
  Future<String> uploadAttachment({
    required String feedbackId,
    required String filePath,
    required int index,
  });

  /// Fetches feedback submitted by a specific user.
  Future<List<FeedbackModel>> getFeedbackByUserId(String userId);
}
