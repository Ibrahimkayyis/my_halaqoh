import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:my_halaqoh/src/modules/super_admin/domain/models/impersonation_context.dart';

part 'impersonation_state.freezed.dart';

/// State for [ImpersonationCubit].
///
/// - [idle]: super admin is on the picker screen, no role selected yet.
/// - [active]: super admin is operating within a specific role's perspective.
@freezed
abstract class ImpersonationState with _$ImpersonationState {
  /// Super admin has not yet chosen a role to impersonate.
  const factory ImpersonationState.idle() = _Idle;

  /// Super admin is actively operating as another role.
  const factory ImpersonationState.active(ImpersonationContext context) =
      _Active;
}
