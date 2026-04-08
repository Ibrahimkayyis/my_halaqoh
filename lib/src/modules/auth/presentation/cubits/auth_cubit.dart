import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_halaqoh/src/modules/auth/domain/repositories/auth_repository.dart';
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
    await _repository.signOut();
    emit(const AuthState.unauthenticated());
  }

  @override
  Future<void> close() {
    _authSubscription?.cancel();
    return super.close();
  }
}
