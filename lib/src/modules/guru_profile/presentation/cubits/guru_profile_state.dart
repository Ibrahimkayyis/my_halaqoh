import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:my_halaqoh/src/modules/master_data/domain/models/guru_model.dart';

part 'guru_profile_state.freezed.dart';

/// States for the Guru Profile feature.
@freezed
abstract class GuruProfileState with _$GuruProfileState {
  /// Initial state before any data is loaded.
  const factory GuruProfileState.initial() = _Initial;

  /// Loading profile data from Firestore.
  const factory GuruProfileState.loading() = _Loading;

  /// Profile data successfully loaded.
  const factory GuruProfileState.loaded(GuruModel guru) = _Loaded;

  /// A profile update or password change is in progress.
  const factory GuruProfileState.updating(GuruModel guru) = _Updating;

  /// Profile update completed successfully.
  const factory GuruProfileState.updateSuccess(GuruModel guru) = _UpdateSuccess;

  /// An error occurred during any operation.
  const factory GuruProfileState.error(String message) = _Error;
}
