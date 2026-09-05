import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:my_halaqoh/src/core/service_locator/service_locator.dart';
import 'package:my_halaqoh/src/core/services/activity_log_service.dart';
import 'package:my_halaqoh/src/modules/notifications/presentation/cubits/notification_badge_cubit.dart';
import 'package:my_halaqoh/src/modules/auth/domain/repositories/auth_repository.dart';
import 'package:my_halaqoh/src/modules/notifications/presentation/cubits/notification_cubit.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepository _repository;
  StreamSubscription? _authSubscription;

  AuthCubit(this._repository) : super(const AuthState.initial());

  /// Checks if the user is already logged in or not.
  /// Automatically listens to Firebase Auth changes.
  void checkAuthStatus() {
    emit(const AuthState.loading());

    _authSubscription?.cancel();
    _authSubscription = _repository.authStateChanges.listen((user) async {
      if (user == null) {
        emit(const AuthState.unauthenticated());
      } else {
        await _fetchUserMeta();
      }
    });
  }

  Future<void> _fetchUserMeta() async {
    final result = await _repository.getCurrentUserMeta();
    result.fold((failure) async {
      // Sign out dari Firebase Auth terlebih dahulu
      await _repository.signOut();

      // Bersihkan semua Hive cache agar tidak ada data stale
      // yang tertinggal saat database di-reset atau state tidak valid
      try {
        await Hive.deleteFromDisk();
      } catch (_) {
        // Abaikan error jika Hive belum terinisialisasi
      }

      emit(AuthState.error(failure));
      emit(const AuthState.unauthenticated());
    }, (userMeta) => emit(AuthState.authenticated(userMeta)));
  }

  Future<void> login(String identifier, String password) async {
    // Pause the authStateChanges subscription during the login attempt.
    // Without this, a failed signIn leaves Firebase Auth state unchanged
    // (still null/unauthenticated). The active stream would then immediately
    // re-emit unauthenticated, overwriting the error state before
    // BlocListener on LoginScreen has a chance to show the error SnackBar.
    _authSubscription?.pause();

    emit(const AuthState.loading());
    final result = await _repository.signIn(identifier, password);

    result.fold(
      (failure) {
        // Resume the subscription first so future auth changes are tracked,
        // then emit the error so BlocListener can display the SnackBar.
        _authSubscription?.resume();
        emit(AuthState.error(failure));
      },
      // On success: resume the subscription and let the authStateChanges
      // stream fire _fetchUserMeta — it will emit authenticated automatically.
      (_) => _authSubscription?.resume(),
    );
  }

  Future<void> logout() async {
    emit(const AuthState.loading());

    // Clear FCM token BEFORE signing out so the server does not retain a
    // stale token for a logged-out user. The NotificationCubit is a Singleton
    // registered in GetIt, so it is safe to resolve directly here.
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid != null) {
      await sl<NotificationCubit>().clearToken(uid);
    }

    await _repository.signOut();

    // Stop the global notification badge pipeline (cancels Firestore streams).
    unawaited(sl<NotificationBadgeCubit>().stop());

    // Clear the ActivityLogService in-memory user meta cache so a different
    // account logging in on this device never reuses stale role/displayName
    // metadata (rule §13.5.4).
    sl<ActivityLogService>().clearCache();

    emit(const AuthState.unauthenticated());
  }

  /// Permanently deletes the currently authenticated user's account,
  /// clears server FCM token, cancels notification pipelines, and cleans local caches.
  /// Returns `null` on success, or an error message string if deletion failed.
  Future<String?> deleteAccount() async {
    emit(const AuthState.loading());

    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid != null) {
      await sl<NotificationCubit>().clearToken(uid);
    }

    final result = await _repository.deleteOwnAccount();

    unawaited(sl<NotificationBadgeCubit>().stop());
    sl<ActivityLogService>().clearCache();
    try {
      await Hive.deleteFromDisk();
    } catch (_) {}

    return result.fold(
      (failure) {
        emit(AuthState.error(failure));
        emit(const AuthState.unauthenticated());
        return failure;
      },
      (_) {
        emit(const AuthState.unauthenticated());
        return null;
      },
    );
  }


  /// Resets the Cubit back to [AuthState.initial].
  ///
  /// Called by [LoginScreen] immediately after displaying an error snackbar
  /// so that the stale [AuthState.error] cannot re-trigger the snackbar if
  /// the widget tree is rebuilt (e.g. keyboard dismissal, orientation change).
  void reset() => emit(const AuthState.initial());

  @override
  Future<void> close() {
    _authSubscription?.cancel();
    return super.close();
  }
}
