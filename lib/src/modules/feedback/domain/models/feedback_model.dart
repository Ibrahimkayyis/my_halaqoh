import 'package:freezed_annotation/freezed_annotation.dart';

part 'feedback_model.freezed.dart';
part 'feedback_model.g.dart';

/// Model representing a user feedback or bug report submission.
@freezed
abstract class FeedbackModel with _$FeedbackModel {
  const factory FeedbackModel({
    /// Firestore document ID (null before creation)
    String? id,

    /// Firebase Auth UID of the submitting user
    required String userId,

    /// User's display name
    required String userName,

    /// Role of user: 'guru', 'santri', 'admin', 'super_admin'
    required String userRole,

    /// Login identifier (NIP, NIS, or 'admin')
    required String userIdentifier,

    /// Feedback category: 'bug', 'saran', 'pertanyaan'
    required String category,

    /// Short subject / title of the feedback
    required String title,

    /// Detailed description of the issue or idea
    required String description,

    /// URLs of uploaded screenshots in Firebase Storage (max 3)
    @Default([]) List<String> attachmentUrls,

    /// Application version string (e.g. "1.0.0+1")
    required String appVersion,

    /// Device manufacturer & model (e.g. "Samsung Galaxy A52")
    required String deviceModel,

    /// Operating system version (e.g. "Android 13 (SDK 33)")
    required String osVersion,

    /// Current handling status: 'open', 'in_progress', 'resolved'
    @Default('open') String status,

    /// Timestamp when the feedback was created
    DateTime? createdAt,
  }) = _FeedbackModel;

  factory FeedbackModel.fromJson(Map<String, dynamic> json) =>
      _$FeedbackModelFromJson(json);
}
