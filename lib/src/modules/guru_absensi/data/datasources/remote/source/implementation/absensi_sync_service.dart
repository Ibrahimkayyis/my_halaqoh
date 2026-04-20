import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import '../../../../../domain/repositories/absensi_repository.dart';

/// Listens for connectivity changes and syncs pending Hive records to Firestore.
class AbsensiSyncService {
  final AbsensiRepository _repository;
  final Connectivity _connectivity;
  StreamSubscription<List<ConnectivityResult>>? _subscription;

  AbsensiSyncService(this._repository, [Connectivity? connectivity])
      : _connectivity = connectivity ?? Connectivity();

  /// Start listening for connectivity changes.
  void start() {
    _subscription = _connectivity.onConnectivityChanged.listen((results) {
      final hasInternet = results.any(
        (r) => r != ConnectivityResult.none,
      );
      if (hasInternet) {
        _repository.syncPendingRecords();
      }
    });

    // Also try an immediate sync on start
    _trySyncNow();
  }

  /// Stop listening.
  void dispose() {
    _subscription?.cancel();
    _subscription = null;
  }

  Future<void> _trySyncNow() async {
    final results = await _connectivity.checkConnectivity();
    final hasInternet = results.any(
      (r) => r != ConnectivityResult.none,
    );
    if (hasInternet) {
      await _repository.syncPendingRecords();
    }
  }
}
