import 'package:auto_route/auto_route.dart';
import 'package:my_halaqoh/src/core/router/app_router.dart';
import 'package:my_halaqoh/src/modules/auth/presentation/cubits/auth_cubit.dart';
import 'package:my_halaqoh/src/modules/auth/presentation/cubits/auth_state.dart';

/// Ensures the user is authenticated before allowing navigation.
///
/// If the user is not authenticated, they are redirected to the [LoginRoute].
class AuthGuard extends AutoRouteGuard {
  final AuthCubit _authCubit;

  AuthGuard(this._authCubit);

  @override
  void onNavigation(NavigationResolver resolver, StackRouter router) {
    final state = _authCubit.state;
    final isAuthenticated = state.maybeWhen(
      authenticated: (_) => true,
      orElse: () => false,
    );

    if (isAuthenticated) {
      resolver.next(true);
    } else {
      // Redirect to login and prevent further navigation
      router.push(const LoginRoute());
      resolver.next(false);
    }
  }
}

