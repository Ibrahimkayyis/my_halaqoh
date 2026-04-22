import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_halaqoh/src/modules/guru_profile/domain/repositories/guru_profile_repository.dart';
import 'package:my_halaqoh/src/modules/guru_profile/presentation/cubits/guru_profile_state.dart';
import 'package:my_halaqoh/src/modules/master_data/domain/models/guru_model.dart';

/// Cubit managing the Guru Profile feature state.
///
/// Handles loading the profile, updating profile fields,
/// uploading photos, and changing passwords.
class GuruProfileCubit extends Cubit<GuruProfileState> {
  final GuruProfileRepository _repository;

  GuruProfileCubit(this._repository)
      : super(const GuruProfileState.initial());

  /// Load the guru's profile by their Firestore document ID.
  Future<void> loadProfile(String guruDocId) async {
    emit(const GuruProfileState.loading());
    final result = await _repository.getProfile(guruDocId);
    result.fold(
      (error) => emit(GuruProfileState.error(error)),
      (guru) => emit(GuruProfileState.loaded(guru)),
    );
  }

  /// Update the guru's profile fields.
  /// Returns `true` if successful, `false` otherwise.
  Future<bool> updateProfile(GuruModel model) async {
    final currentGuru = _getCurrentGuru();
    if (currentGuru != null) {
      emit(GuruProfileState.updating(currentGuru));
    }

    final result = await _repository.updateProfile(model);
    return result.fold(
      (error) {
        emit(GuruProfileState.error(error));
        return false;
      },
      (_) {
        emit(GuruProfileState.updateSuccess(model));
        return true;
      },
    );
  }

  /// Upload a profile photo and update the Firestore document.
  /// Returns the download URL on success, null on failure.
  Future<String?> uploadPhoto(String guruDocId, File file) async {
    final result = await _repository.uploadProfilePhoto(
      guruDocId: guruDocId,
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
        emit(GuruProfileState.error(error));
        return false;
      },
      (_) => true,
    );
  }

  /// Helper to extract the current GuruModel from state if available.
  GuruModel? _getCurrentGuru() {
    return state.maybeWhen(
      loaded: (guru) => guru,
      updating: (guru) => guru,
      updateSuccess: (guru) => guru,
      orElse: () => null,
    );
  }
}
