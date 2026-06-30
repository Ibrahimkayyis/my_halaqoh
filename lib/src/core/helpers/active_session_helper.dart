import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_halaqoh/src/modules/auth/presentation/cubits/auth_cubit.dart';
import 'package:my_halaqoh/src/modules/auth/presentation/cubits/auth_state.dart';
import 'package:my_halaqoh/src/modules/super_admin/presentation/cubits/impersonation/impersonation_cubit.dart';
import 'package:my_halaqoh/src/modules/super_admin/presentation/cubits/impersonation/impersonation_state.dart';

/// Utility helpers for resolving the "effective" user identity.
///
/// When a super admin is impersonating another role, these helpers return the
/// impersonated user's data instead of the actual logged-in super admin's data.
/// For all other roles, they fall back to [AuthCubit]'s [UserModel] directly.
///
/// Usage:
/// ```dart
/// final guruId = ActiveSessionHelper.getActiveLinkedDocId(context);
/// ```
class ActiveSessionHelper {
  const ActiveSessionHelper._();

  /// Returns the effective `linkedDocId`:
  /// - If super_admin is impersonating → returns the impersonated user's [ImpersonationContext.linkedDocId]
  /// - Otherwise → returns the authenticated user's `linkedDocId`
  static String? getActiveLinkedDocId(BuildContext context) {
    final authState = context.read<AuthCubit>().state;
    return authState.maybeWhen(
      authenticated: (user) {
        if (user.role == 'super_admin') {
          final impersonation = context.read<ImpersonationCubit>().state;
          return impersonation.maybeWhen(
            active: (ctx) => ctx.linkedDocId,
            orElse: () => null,
          );
        }
        return user.linkedDocId;
      },
      orElse: () => null,
    );
  }

  /// Returns the effective `programType`:
  /// - If super_admin is impersonating → returns [ImpersonationContext.programType]
  /// - Otherwise → returns the authenticated user's `programType`
  static String? getActiveProgramType(BuildContext context) {
    final authState = context.read<AuthCubit>().state;
    return authState.maybeWhen(
      authenticated: (user) {
        if (user.role == 'super_admin') {
          final impersonation = context.read<ImpersonationCubit>().state;
          return impersonation.maybeWhen(
            active: (ctx) => ctx.programType,
            orElse: () => null,
          );
        }
        return user.programType;
      },
      orElse: () => null,
    );
  }

  /// Returns the effective active role string:
  /// - If super_admin is impersonating → returns [ImpersonationContext.targetRole]
  /// - Otherwise → returns the authenticated user's `role`
  static String? getActiveRole(BuildContext context) {
    final authState = context.read<AuthCubit>().state;
    return authState.maybeWhen(
      authenticated: (user) {
        if (user.role == 'super_admin') {
          final impersonation = context.read<ImpersonationCubit>().state;
          return impersonation.maybeWhen(
            active: (ctx) => ctx.targetRole,
            orElse: () => 'super_admin',
          );
        }
        return user.role;
      },
      orElse: () => null,
    );
  }

  /// Returns `true` if the current user is a super admin actively impersonating
  /// another role. Use this to decide whether to show [ImpersonationAppBar].
  static bool isImpersonating(BuildContext context) {
    final authState = context.read<AuthCubit>().state;
    final isSuperAdmin = authState.maybeWhen(
      authenticated: (user) => user.role == 'super_admin',
      orElse: () => false,
    );
    if (!isSuperAdmin) return false;

    final impersonationState = context.read<ImpersonationCubit>().state;
    return impersonationState.maybeWhen(
      active: (_) => true,
      orElse: () => false,
    );
  }
}
