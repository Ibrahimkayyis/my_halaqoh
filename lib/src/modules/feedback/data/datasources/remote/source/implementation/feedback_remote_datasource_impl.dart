import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:logger/logger.dart';
import 'package:my_halaqoh/src/core/constants/legal_constants.dart';
import '../../../../../domain/models/feedback_model.dart';
import '../../mapper/feedback_mapper.dart';
import '../abstract/feedback_remote_datasource.dart';

/// Implementation of [FeedbackRemoteDataSource] using Cloud Firestore
/// and Firebase Storage.
class FeedbackRemoteDataSourceImpl implements FeedbackRemoteDataSource {
  final FirebaseFirestore _firestore;
  final FirebaseStorage _storage;
  final Logger _logger = Logger();

  FeedbackRemoteDataSourceImpl(this._firestore, [FirebaseStorage? storage])
      : _storage = storage ?? FirebaseStorage.instance;

  @override
  Future<String> submitFeedback(FeedbackModel feedback) async {
    try {
      final docRef = _firestore.collection('feedback').doc();
      final data = FeedbackMapper.toFirestore(feedback);
      await docRef.set(data);
      return docRef.id;
    } catch (e, stack) {
      _logger.e('Error submitting feedback to Firestore', error: e, stackTrace: stack);
      rethrow;
    }
  }

  @override
  Future<String> uploadAttachment({
    required String feedbackId,
    required String filePath,
    required int index,
  }) async {
    try {
      final file = File(filePath);
      final ext = filePath.split('.').last.toLowerCase();
      final mimeType = ext == 'png' ? 'image/png' : 'image/jpeg';
      final fileName = 'attachment_${index}_${DateTime.now().millisecondsSinceEpoch}.$ext';
      final ref = _storage
          .ref()
          .child('feedback_attachments')
          .child(feedbackId)
          .child(fileName);

      final uploadTask = await ref.putFile(
        file,
        SettableMetadata(contentType: mimeType),
      );

      return await uploadTask.ref.getDownloadURL();
    } catch (e, stack) {
      _logger.e('Error uploading feedback attachment to Firebase Storage',
          error: e, stackTrace: stack);
      rethrow;
    }
  }

  @override
  Future<void> sendEmailNotification({
    required FeedbackModel feedback,
    required String feedbackId,
  }) async {
    try {
      final attachmentsHtml = feedback.attachmentUrls.isEmpty
          ? '<p><em>Tidak ada lampiran gambar.</em></p>'
          : '<ul>${feedback.attachmentUrls.map((url) => '<li><a href="$url">$url</a></li>').join()}</ul>';

      final htmlContent = '''
<h2>[MyHalaqoh Feedback] ${feedback.category.toUpperCase()}</h2>
<p><strong>Judul:</strong> ${feedback.title}</p>
<p><strong>Deskripsi:</strong></p>
<blockquote style="background:#f4f4f4;padding:12px;border-left:4px solid #115D69;">
${feedback.description.replaceAll('\n', '<br/>')}
</blockquote>

<hr/>
<h3>Informasi Pengirim</h3>
<ul>
  <li><strong>Nama:</strong> ${feedback.userName}</li>
  <li><strong>Role:</strong> ${feedback.userRole}</li>
  <li><strong>NIP / NIS:</strong> ${feedback.userIdentifier}</li>
  <li><strong>User ID:</strong> ${feedback.userId}</li>
</ul>

<h3>Informasi Teknis Perangkat</h3>
<ul>
  <li><strong>Aplikasi:</strong> MyHalaqoh v${feedback.appVersion}</li>
  <li><strong>Perangkat:</strong> ${feedback.deviceModel}</li>
  <li><strong>OS:</strong> ${feedback.osVersion}</li>
  <li><strong>Feedback ID:</strong> $feedbackId</li>
</ul>

<h3>Lampiran</h3>
$attachmentsHtml
''';

      final textContent = '''
[MyHalaqoh Feedback] ${feedback.category.toUpperCase()}
Judul: ${feedback.title}

Deskripsi:
${feedback.description}

---
Pengirim: ${feedback.userName} (${feedback.userRole} - ${feedback.userIdentifier})
Perangkat: ${feedback.deviceModel} | ${feedback.osVersion}
App: v${feedback.appVersion}
Feedback ID: $feedbackId
Lampiran: ${feedback.attachmentUrls.join(', ')}
''';

      // Writes to /mail collection to trigger 'Trigger Email from Firestore' extension
      await _firestore.collection('mail').add({
        'to': LegalConstants.developerFeedbackEmail,
        'message': {
          'subject': '[MyHalaqoh Feedback] [${feedback.category.toUpperCase()}] ${feedback.title}',
          'text': textContent,
          'html': htmlContent,
        },
        'createdAt': FieldValue.serverTimestamp(),
        'feedbackId': feedbackId,
        'status': 'pending',
      });
    } catch (e, stack) {
      // Swallowed: Failure to send mail notification must not crash or fail user submission
      _logger.w('Warning: Failed to enqueue email notification to /mail',
          error: e, stackTrace: stack);
    }
  }

  @override
  Future<List<FeedbackModel>> getFeedbackByUserId(String userId) async {
    try {
      final snapshot = await _firestore
          .collection('feedback')
          .where('userId', isEqualTo: userId)
          .orderBy('createdAt', descending: true)
          .get();

      return snapshot.docs.map(FeedbackMapper.fromFirestore).toList();
    } catch (e, stack) {
      _logger.e('Error getting user feedback', error: e, stackTrace: stack);
      rethrow;
    }
  }
}
