import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:logger/logger.dart';

/// Service that records user activity into the Firestore `/activity_log`
/// collection.
///
/// Design decisions:
/// - Accesses Firestore and FirebaseAuth directly (same pattern as
///   [StorageService]) to avoid circular dependencies with the repository chain.
/// - All [log] calls must be wrapped with `unawaited()` at call sites so they
///   never block the primary operation.
/// - On any failure, the error is logged via [Logger] and swallowed — a
///   logging failure must never surface to the user.
class ActivityLogService {
  /// Creates an [ActivityLogService] with the given Firebase instances.
  ActivityLogService(this._firestore, this._auth);

  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;
  final Logger _logger = Logger();

  /// In-memory cache: uid → {role, displayName} to avoid repeated Firestore
  /// reads on every log entry within the same session.
  final Map<String, Map<String, String>> _userMetaCache = {};

  /// Records an activity entry to `/activity_log/{autoId}`.
  ///
  /// [action] — one of: `'login'`, `'logout'`, `'create'`, `'update'`,
  ///   `'delete'`, `'save_absensi'`, `'sync_absensi'`, `'add_hafalan'`,
  ///   `'sync_hafalan'`.
  ///
  /// [module] — one of: `'auth'`, `'guru'`, `'santri'`, `'halaqoh'`,
  ///   `'target_hafalan'`, `'absensi'`, `'hafalan'`.
  ///
  /// [description] — human-readable sentence in Bahasa Indonesia.
  Future<void> log({
    required String action,
    required String module,
    String? entityId,
    String? entityName,
    String? description,
    Map<String, dynamic>? metadata,
  }) async {
    try {
      final user = _auth.currentUser;
      if (user == null) return;

      final meta = await _getUserMeta(user.uid);
      final userRole = meta['role'] ?? 'unknown';
      final userName = meta['displayName'] ?? user.email ?? user.uid;

      final effectiveDescription = description ??
          'User $userName melakukan $action pada $module';

      await _firestore.collection('activity_log').add({
        'userId': user.uid,
        'userRole': userRole,
        'userName': userName,
        'action': action,
        'module': module,
        if (entityId != null) 'entityId': entityId,
        if (entityName != null) 'entityName': entityName,
        'description': effectiveDescription,
        if (metadata != null) 'metadata': metadata,
        'createdAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      _logger.w('ActivityLog: gagal mencatat log — $e');
    }
  }

  /// Fetches user role and displayName from `/users/{uid}`.
  /// Result is cached in [_userMetaCache] to avoid repeated reads.
  Future<Map<String, String>> _getUserMeta(String uid) async {
    if (_userMetaCache.containsKey(uid)) {
      return _userMetaCache[uid]!;
    }

    try {
      final doc = await _firestore.collection('users').doc(uid).get();
      if (doc.exists) {
        final data = doc.data()!;
        final meta = {
          'role': (data['role'] as String?) ?? 'unknown',
          'displayName': (data['displayName'] as String?) ?? uid,
        };
        _userMetaCache[uid] = meta;
        return meta;
      }
    } catch (e) {
      _logger.w('ActivityLog: gagal fetch user meta untuk uid=$uid — $e');
    }

    return {'role': 'unknown', 'displayName': uid};
  }

  /// Clears the in-memory user meta cache (call on logout).
  void clearCache() {
    _userMetaCache.clear();
  }
}
