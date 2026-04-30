import 'package:dartz/dartz.dart';
import 'package:logger/logger.dart';

import '../../domain/repositories/notification_repository.dart';
import '../datasources/remote/source/abstract/notification_remote_datasource.dart';

/// Implements [NotificationRepository] by delegating to
/// [NotificationRemoteDataSource] and wrapping errors in [Either].
///
/// There is no local cache for FCM tokens — they are server-authoritative
/// and must always be fresh.
class NotificationRepositoryImpl implements NotificationRepository {
  final NotificationRemoteDataSource _remote;
  final _log = Logger();

  NotificationRepositoryImpl(this._remote);

  @override
  Future<String?> requestPermissionAndGetToken() async {
    try {
      return await _remote.requestPermissionAndGetToken();
    } catch (e) {
      _log.e('NotificationRepository.requestPermissionAndGetToken failed: $e');
      return null;
    }
  }

  @override
  Future<Either<String, void>> saveToken(String uid, String token) async {
    try {
      await _remote.saveToken(uid, token);
      return const Right(null);
    } catch (e) {
      _log.e('NotificationRepository.saveToken failed for uid=$uid: $e');
      return Left('Gagal menyimpan token notifikasi: $e');
    }
  }

  @override
  Future<Either<String, void>> clearToken(String uid) async {
    try {
      await _remote.clearToken(uid);
      return const Right(null);
    } catch (e) {
      _log.e('NotificationRepository.clearToken failed for uid=$uid: $e');
      return Left('Gagal menghapus token notifikasi: $e');
    }
  }

  @override
  Stream<String> get onTokenRefresh => _remote.onTokenRefresh;
}
