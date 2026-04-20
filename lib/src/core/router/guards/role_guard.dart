import 'package:auto_route/auto_route.dart';
import 'package:my_halaqoh/src/core/router/app_router.dart';
import 'package:my_halaqoh/src/modules/auth/presentation/cubits/auth_cubit.dart';
import 'package:my_halaqoh/src/modules/auth/presentation/cubits/auth_state.dart';

/// Ensures the authenticated user has one of the [allowedRoles] before
/// allowing navigation.
///
/// If the user's role is not in [allowedRoles], navigation is blocked
/// and the user is redirected to an Access Denied screen.
class RoleGuard extends AutoRouteGuard {
  final AuthCubit _authCubit;
  final List<String> allowedRoles;

  RoleGuard(this._authCubit, {required this.allowedRoles});

  @override
  void onNavigation(NavigationResolver resolver, StackRouter router) {
    final state = _authCubit.state;
    final userRole = state.maybeWhen(
      authenticated: (user) => user.role,
      orElse: () => null,
    );

    if (userRole != null && allowedRoles.contains(userRole)) {
      resolver.next(true);
    } else {
      // Show access denied screen instead of silently redirecting
      router.push(AccessDeniedRoute(
        attemptedRole: userRole ?? 'unknown',
        requiredRoles: allowedRoles,
      ));
      resolver.next(false);
    }
  }
}

