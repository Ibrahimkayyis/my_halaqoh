import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_halaqoh/src/modules/master_data/domain/models/guru_model.dart';
import 'package:my_halaqoh/src/modules/master_data/domain/models/santri_model.dart';
import 'package:my_halaqoh/src/modules/super_admin/domain/models/impersonation_context.dart';
import 'impersonation_state.dart';

/// Global singleton Cubit that tracks which role the super admin is currently
/// impersonating.
///
/// Registered as [registerSingleton] so the state persists across screen
/// navigations. A Factory registration would destroy this state on disposal.
class ImpersonationCubit extends Cubit<ImpersonationState> {
  ImpersonationCubit() : super(const ImpersonationState.idle());

  /// Enter admin perspective.
  void impersonateAsAdmin() {
    emit(
      const ImpersonationState.active(
        ImpersonationContext(targetRole: 'admin'),
      ),
    );
  }

  /// Enter guru perspective using [guru]'s identity.
  void impersonateAsGuru(GuruModel guru) {
    emit(
      ImpersonationState.active(
        ImpersonationContext(
          targetRole: 'guru',
          linkedDocId: guru.id,
          displayName: guru.nama,
          programType: guru.program,
        ),
      ),
    );
  }

  /// Enter wali santri perspective using [santri]'s identity.
  void impersonateAsSantri(SantriModel santri) {
    emit(
      ImpersonationState.active(
        ImpersonationContext(
          targetRole: 'santri',
          linkedDocId: santri.id,
          displayName: santri.nama,
          programType: santri.program,
        ),
      ),
    );
  }

  /// Return to the picker screen and clear the active impersonation.
  void exitImpersonation() {
    emit(const ImpersonationState.idle());
  }
}
