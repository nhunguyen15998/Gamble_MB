import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:gamble/src/services/settings_service.dart';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
part 'profile_security_event.dart';
part 'profile_security_state.dart';

class ProfileSecurityBloc extends Bloc<ProfileSecurityEvent, ProfileSecurityState> {
  SettingsService settingsService;
  ProfileSecurityBloc(this.settingsService) : super(const ProfileSecurityState()) {
    on<ProfileSecurityInitial>(_mapProfileSecurityInitialToState);
    on<WithdrawPasswordSettingChanged>(_mapWithdrawPasswordSettingChangedToState);
    on<TransferPasswordSettingChanged>(_mapTransferPasswordSettingChangedToState);
    on<UpdateSettingPasswordSettingChanged>(_mapUpdateSettingPasswordSettingChangedToState);
    on<ProfileSecurityBtnSaveClicked>(_mapProfileSecurityBtnSaveClickedToState);
  }

  Future<void> _mapProfileSecurityInitialToState(ProfileSecurityInitial event, Emitter<ProfileSecurityState> emit) async {
    try {
      final result = await settingsService.getSettingConfigs();
      if(result['code'] == 200){
        final config = jsonDecode(result['config']) as Map<String, dynamic>;
        emit(ProfileSecurityInitialized(
          isWithdrawOn: config['withdraw_password'] == 1 ? true : false,
          isTransferOn: config['transfer_password'] == 1 ? true : false,
          isUpdateSettingOn: config['setting_password'] == 1 ? true : false
        ));
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> _mapWithdrawPasswordSettingChangedToState(WithdrawPasswordSettingChanged event, Emitter<ProfileSecurityState> emit) async {
    final isWithdrawOn = event.isWithdrawOn;
    ProfileSecurityInitialized profileSecurityInitialized = state as ProfileSecurityInitialized;
    emit(profileSecurityInitialized.copyWith(isWithdrawOn: isWithdrawOn));
  }

  Future<void> _mapTransferPasswordSettingChangedToState(TransferPasswordSettingChanged event, Emitter<ProfileSecurityState> emit) async {
    final isTransferOn = event.isTransferOn;
    ProfileSecurityInitialized profileSecurityInitialized = state as ProfileSecurityInitialized;
    emit(profileSecurityInitialized.copyWith(isTransferOn: isTransferOn));
  }

  Future<void> _mapUpdateSettingPasswordSettingChangedToState(UpdateSettingPasswordSettingChanged event, Emitter<ProfileSecurityState> emit) async {
    final isUpdateSettingOn = event.isUpdateSettingOn;
    ProfileSecurityInitialized profileSecurityInitialized = state as ProfileSecurityInitialized;
    emit(profileSecurityInitialized.copyWith(isUpdateSettingOn: isUpdateSettingOn));
  }

  Future<void> _mapProfileSecurityBtnSaveClickedToState(ProfileSecurityBtnSaveClicked event, Emitter<ProfileSecurityState> emit) async {
    final isBtnDisabled = event.isBtnDisabled;
    ProfileSecurityInitialized profileSecurityInitialized = state as ProfileSecurityInitialized;
    emit(profileSecurityInitialized.copyWith(isBtnDisabled: isBtnDisabled, status: "Processing"));
    try {
      var config = jsonEncode({
        "withdraw_password": profileSecurityInitialized.isWithdrawOn ? 1 : 0,
        "transfer_password": profileSecurityInitialized.isTransferOn ? 1 : 0,
        "setting_password": profileSecurityInitialized.isUpdateSettingOn ? 1 : 0
      });
      final result = await settingsService.updateSettingConfigs(config, 'user/configs/update');
      if(result['code'] == 200){
        emit(profileSecurityInitialized.copyWith(status: "Completed", message: result['message'].toString(), code: result['code']));
      } else {
        emit(profileSecurityInitialized.copyWith(status: "Failed", message: result['message'].toString(), code: result['code']));
      }
    } catch (e) {
      print(e);
    }
  }
}
