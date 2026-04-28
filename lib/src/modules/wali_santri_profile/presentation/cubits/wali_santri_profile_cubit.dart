import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_halaqoh/src/modules/master_data/domain/models/santri_model.dart';
import 'package:my_halaqoh/src/modules/wali_santri_profile/domain/repositories/wali_santri_profile_repository.dart';
import 'package:my_halaqoh/src/modules/wali_santri_profile/presentation/cubits/wali_santri_profile_state.dart';

/// Cubit managing the Wali Santri Profile feature state.
///
/// Handles loading the santri profile, updating profile fields,
/// uploading profile photos, and changing passwords.
class WaliSantriProfileCubit extends Cubit<WaliSantriProfileState> {
  final WaliSantriProfileRepository _repository;

  WaliSantriProfileCubit(this._repository)
      : super(const WaliSantriProfileState.initial());

  /// Load the santri's profile by their Firestore document ID.
  Future<void> loadProfile(String santriDocId) async {
    emit(const WaliSantriProfileState.loading());
    final result = await _repository.getProfile(santriDocId);
    result.fold(
      (error) => emit(WaliSantriProfileState.error(error)),
      (santri) => emit(WaliSantriProfileState.loaded(santri)),
    );
  }

  /// Update the santri's profile fields.
  /// Returns `true` if successful, `false` otherwise.
  Future<bool> updateProfile(SantriModel model) async {
    final current = _getCurrentSantri();
    if (current != null) {
      emit(WaliSantriProfileState.updating(current));
    }

    final result = await _repository.updateProfile(model);
    return result.fold(
      (error) {
        emit(WaliSantriProfileState.error(error));
        return false;
      },
      (_) {
        emit(WaliSantriProfileState.updateSuccess(model));
        return true;
      },
    );
  }

  /// Upload a profile photo and update the Firestore document.
  /// Returns the download URL on success, null on failure.
  Future<String?> uploadPhoto(String santriDocId, File file) async {
    final result = await _repository.uploadProfilePhoto(
      santriDocId: santriDocId,
      imageFile: file,
    );
    return result.fold(
      (error) => null,
      (url) => url,
    );
  }

  /// Change the current user's password.
  /// Returns `true` if successful, `false` otherwise.
  Future<bool> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    final result = await _repository.changePassword(
      currentPassword: currentPassword,
      newPassword: newPassword,
    );
    return result.fold(
      (error) {
        emit(WaliSantriProfileState.error(error));
        return false;
      },
      (_) => true,
    );
  }

  /// Helper to extract the current SantriModel from state if available.
  SantriModel? _getCurrentSantri() {
    return state.maybeWhen(
      loaded: (santri) => santri,
      updating: (santri) => santri,
      updateSuccess: (santri) => santri,
      orElse: () => null,
    );
  }
}
