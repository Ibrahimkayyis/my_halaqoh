import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:my_halaqoh/src/modules/master_data/domain/models/santri_model.dart';

part 'wali_santri_profile_state.freezed.dart';

/// States for the Wali Santri Profile feature.
@freezed
abstract class WaliSantriProfileState with _$WaliSantriProfileState {
  /// Initial state before any data is loaded.
  const factory WaliSantriProfileState.initial() = _Initial;

  /// Loading profile data from Firestore.
  const factory WaliSantriProfileState.loading() = _Loading;

  /// Profile data successfully loaded.
  const factory WaliSantriProfileState.loaded(SantriModel santri) = _Loaded;

  /// A profile update or password change is in progress.
  const factory WaliSantriProfileState.updating(SantriModel santri) = _Updating;

  /// Profile update completed successfully.
  const factory WaliSantriProfileState.updateSuccess(SantriModel santri) = _UpdateSuccess;

  /// An error occurred during any operation.
  const factory WaliSantriProfileState.error(String message) = _Error;
}
