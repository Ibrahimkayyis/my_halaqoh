import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:my_halaqoh/src/core/service_locator/service_locator.dart';
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
        // User is authenticated under Firebase, let's fetch their role metadata
        _fetchUserMeta();
      }
    });
  }

  Future<void> _fetchUserMeta() async {
    final result = await _repository.getCurrentUserMeta();
    result.fold(
      (failure) {
        // We log them out if we can't find metadata, meaning invalid state
        _repository.signOut();
        emit(AuthState.error(failure));
        emit(const AuthState.unauthenticated());
      },
      (userMeta) => emit(AuthState.authenticated(userMeta)),
    );
  }

  Future<void> login(String identifier, String password) async {
    emit(const AuthState.loading());
    final result = await _repository.signIn(identifier, password);

    result.fold(
      (failure) => emit(AuthState.error(failure)),
      // If success, we don't need to manually emit authenticated here because
      // the authStateChanges listener will trigger _fetchUserMeta automatically
      (userMeta) {}, // listener handles it
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
    emit(const AuthState.unauthenticated());
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
