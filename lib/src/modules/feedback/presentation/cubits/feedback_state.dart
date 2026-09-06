import 'package:freezed_annotation/freezed_annotation.dart';

part 'feedback_state.freezed.dart';

/// States for [FeedbackCubit].
@freezed
abstract class FeedbackState with _$FeedbackState {
  const factory FeedbackState.initial() = _Initial;

  /// Emitted while uploading attachments and writing to Firestore.
  const factory FeedbackState.submitting({
    @Default(0) int currentUpload,
    @Default(0) int totalUpload,
  }) = _Submitting;

  /// Emitted upon successful submission.
  const factory FeedbackState.success() = _Success;

  /// Emitted when an error occurs.
  const factory FeedbackState.failure(String message) = _Failure;
}
