import '../../domain/models/feedback_model.dart';
import '../../domain/repositories/feedback_repository.dart';
import '../datasources/remote/source/abstract/feedback_remote_datasource.dart';

/// Implementation of [FeedbackRepository].
class FeedbackRepositoryImpl implements FeedbackRepository {
  final FeedbackRemoteDataSource _remoteDataSource;

  FeedbackRepositoryImpl(this._remoteDataSource);

  @override
  Future<String> submitFeedback(FeedbackModel feedback) async {
    final feedbackId = await _remoteDataSource.submitFeedback(feedback);

    // Enqueue email notification to /mail for developer (Option A)
    await _remoteDataSource.sendEmailNotification(
      feedback: feedback,
      feedbackId: feedbackId,
    );

    return feedbackId;
  }

  @override
  Future<String> uploadAttachment({
    required String feedbackId,
    required String filePath,
    required int index,
  }) {
    return _remoteDataSource.uploadAttachment(
      feedbackId: feedbackId,
      filePath: filePath,
      index: index,
    );
  }

  @override
  Future<List<FeedbackModel>> getFeedbackByUserId(String userId) {
    return _remoteDataSource.getFeedbackByUserId(userId);
  }
}
