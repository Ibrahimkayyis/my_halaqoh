import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:logger/logger.dart';

class StorageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final Logger _logger = Logger();

  /// Uploads a file to Firebase Storage at the given [path].
  /// Returns the download URL if successful, or null if it fails.
  Future<String?> uploadFile({
    required File file,
    required String path,
  }) async {
    try {
      final ref = _storage.ref().child(path);
      
      // Upload the file
      final uploadTask = await ref.putFile(file);
      
      // Get the download URL
      final downloadUrl = await uploadTask.ref.getDownloadURL();
      return downloadUrl;
    } catch (e, stackTrace) {
      _logger.e('Failed to upload file to Storage', error: e, stackTrace: stackTrace);
      return null;
    }
  }

  /// Deletes a file from Firebase Storage at the given [path].
  Future<bool> deleteFile(String path) async {
    try {
      final ref = _storage.ref().child(path);
      await ref.delete();
      return true;
    } catch (e, stackTrace) {
      _logger.e('Failed to delete file from Storage', error: e, stackTrace: stackTrace);
      return false;
    }
  }
}
