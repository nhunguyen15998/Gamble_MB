import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:gamble/src/screens/users/profile_change_password/models/change_password.dart';
import 'package:gamble/src/services/authentication_service.dart';
import 'package:gamble/src/services/profile_service.dart';
import 'package:meta/meta.dart';
import 'package:formz/formz.dart';
import 'package:equatable/equatable.dart';
part 'profile_change_password_event.dart';
part 'profile_change_password_state.dart';

class ProfileChangePasswordBloc extends Bloc<ProfileChangePasswordEvent, ProfileChangePasswordState> {
  ProfileService profileService;
  ProfileChangePasswordBloc(this.profileService) : super(ProfileChangePasswordState()) {
    on<ProfileChangePasswordEvent>(_mapProfileChangePasswordEventToState);
    on<ProfileOldPasswordChanged>(_mapProfileOldPasswordChangedToState);
    on<ProfileNewPasswordChanged>(_mapProfileNewPasswordChangedToState);
    on<ProfileConfirmNewPasswordChanged>(_mapProfileConfirmNewPasswordChangedToState);
    on<ProfileBtnChangePasswordClicked>(_mapProfileBtnChangePasswordClickedToState);
    on<ProfileAlertBtnOKClicked>(_mapProfileAlertBtnOKClickedToState);
  }

  Future<void> _mapProfileChangePasswordEventToState(ProfileChangePasswordEvent event, Emitter<ProfileChangePasswordState> emit) async {}

  Future<void> _mapProfileAlertBtnOKClickedToState(ProfileAlertBtnOKClicked event, Emitter<ProfileChangePasswordState> emit) async {
    ProfileChangePasswordLoaded profileChangePasswordLoaded = state as ProfileChangePasswordLoaded;
    emit(state.copyWith(status: profileChangePasswordLoaded.code != 200 ? 
                                FormzStatus.pure
                                : FormzStatus.submissionSuccess)
        );
  }

  Future<void> _mapProfileOldPasswordChangedToState(ProfileOldPasswordChanged event, Emitter<ProfileChangePasswordState> emit) async {
    final oldPassword = ChangePassword.dirty(event.password);
    var isValid = Formz.validate([oldPassword, state.newPassword, state.confirmNewPassword]);
    print(isValid);
    emit(state.copyWith(oldPassword: oldPassword, status: isValid));
  }

  Future<void> _mapProfileNewPasswordChangedToState(ProfileNewPasswordChanged event, Emitter<ProfileChangePasswordState> emit) async {
    final newPassword = ChangePassword.dirty(event.password);
    var isValid = Formz.validate([newPassword, state.oldPassword, state.confirmNewPassword]);
    emit(state.copyWith(newPassword: newPassword, status: isValid));
  }

  Future<void> _mapProfileConfirmNewPasswordChangedToState(ProfileConfirmNewPasswordChanged event, Emitter<ProfileChangePasswordState> emit) async {
    final confirmNewPassword = ChangePassword.dirty(event.password);
    var isValid = Formz.validate([confirmNewPassword, state.newPassword, state.oldPassword]);
    emit(state.copyWith(confirmNewPassword: confirmNewPassword, status: isValid));
  }

  Future<void> _mapProfileBtnChangePasswordClickedToState(ProfileBtnChangePasswordClicked event, Emitter<ProfileChangePasswordState> emit) async {
    final requestBody = jsonEncode({
      "old_password": state.oldPassword.value,
      "new_password": state.newPassword.value,
      "confirm_new_password": state.confirmNewPassword.value
    });
    emit(ProfileChangePasswordLoading());
    try {
      final result = await profileService.changePassword(requestBody);
      emit(ProfileChangePasswordLoaded(code: result['code'], message: result['message']));
    } catch (e) {
      print(e);
    }
  }
}
