import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:logger/logger.dart';
import 'package:package_info_plus/package_info_plus.dart';
import '../../../../modules/auth/presentation/cubits/auth_cubit.dart';
import '../../../../modules/auth/presentation/cubits/auth_state.dart';
import '../../domain/models/feedback_model.dart';
import '../../domain/repositories/feedback_repository.dart';
import 'feedback_state.dart';

/// Cubit managing feedback and bug report submissions.
class FeedbackCubit extends Cubit<FeedbackState> {
  final FeedbackRepository _repository;
  final AuthCubit _authCubit;
  final Logger _logger = Logger();

  FeedbackCubit(this._repository, this._authCubit)
      : super(const FeedbackState.initial());

  /// Resets the cubit to initial state.
  void reset() {
    emit(const FeedbackState.initial());
  }

  /// Submits feedback or bug report with optional screenshot file paths.
  Future<void> submit({
    required String category,
    required String title,
    required String description,
    List<String> attachmentFilePaths = const [],
  }) async {
    emit(const FeedbackState.submitting());

    try {
      // 1. Resolve current user identity
      final user = _authCubit.state.maybeWhen(
        authenticated: (u) => u,
        orElse: () => null,
      );

      if (user == null) {
        emit(const FeedbackState.failure('Pengguna tidak terautentikasi.'));
        return;
      }

      // 2. Auto-capture Device and App info
      final deviceInfo = DeviceInfoPlugin();
      String deviceModel = 'Unknown Device';
      String osVersion = 'Unknown OS';

      try {
        if (Platform.isAndroid) {
          final androidInfo = await deviceInfo.androidInfo;
          deviceModel = '${androidInfo.manufacturer} ${androidInfo.model}';
          osVersion =
              'Android ${androidInfo.version.release} (SDK ${androidInfo.version.sdkInt})';
        } else if (Platform.isIOS) {
          final iosInfo = await deviceInfo.iosInfo;
          deviceModel = iosInfo.utsname.machine;
          osVersion = '${iosInfo.systemName} ${iosInfo.systemVersion}';
        }
      } catch (e) {
        _logger.w('Failed to capture device details: $e');
      }

      String appVersion = '1.0.0+1';
      try {
        final packageInfo = await PackageInfo.fromPlatform();
        appVersion = '${packageInfo.version}+${packageInfo.buildNumber}';
      } catch (e) {
        _logger.w('Failed to capture package details: $e');
      }

      // 3. Upload attachments if any
      final attachmentUrls = <String>[];
      final tempFeedbackId = 'fb_${DateTime.now().millisecondsSinceEpoch}';

      for (int i = 0; i < attachmentFilePaths.length; i++) {
        emit(FeedbackState.submitting(
          currentUpload: i + 1,
          totalUpload: attachmentFilePaths.length,
        ));

        final url = await _repository.uploadAttachment(
          feedbackId: tempFeedbackId,
          filePath: attachmentFilePaths[i],
          index: i + 1,
        );
        attachmentUrls.add(url);
      }

      // 4. Construct FeedbackModel and submit
      final feedback = FeedbackModel(
        userId: user.uid,
        userName: user.displayName,
        userRole: user.role,
        userIdentifier: user.identifier,
        category: category,
        title: title.trim(),
        description: description.trim(),
        attachmentUrls: attachmentUrls,
        appVersion: appVersion,
        deviceModel: deviceModel,
        osVersion: osVersion,
        status: 'open',
      );

      await _repository.submitFeedback(feedback);

      emit(const FeedbackState.success());
    } catch (e, stack) {
      _logger.e('Failed to submit feedback', error: e, stackTrace: stack);
      emit(FeedbackState.failure(e.toString()));
    }
  }
}
