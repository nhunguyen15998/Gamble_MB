part of 'profile_security_bloc.dart';

class ProfileSecurityEvent extends Equatable {
  ProfileSecurityEvent();
  @override
  List<Object?> get props => [];
}

class ProfileSecurityInitial extends ProfileSecurityEvent {
  ProfileSecurityInitial();
  @override
  List<Object?> get props => [];
}

//withdraw
class WithdrawPasswordSettingChanged extends ProfileSecurityEvent {
  WithdrawPasswordSettingChanged({this.isWithdrawOn = false});
  bool isWithdrawOn;
  @override
  List<Object?> get props => [isWithdrawOn];
}

//transfer
class TransferPasswordSettingChanged extends ProfileSecurityEvent {
  TransferPasswordSettingChanged({this.isTransferOn = false});
  bool isTransferOn;
  @override
  List<Object?> get props => [isTransferOn];
}

//update setting
class UpdateSettingPasswordSettingChanged extends ProfileSecurityEvent {
  UpdateSettingPasswordSettingChanged({this.isUpdateSettingOn = false});
  bool isUpdateSettingOn;
  @override
  List<Object?> get props => [isUpdateSettingOn];
}

//btn save
class ProfileSecurityBtnSaveClicked extends ProfileSecurityEvent {
  ProfileSecurityBtnSaveClicked({this.isBtnDisabled = false});
  bool isBtnDisabled;
  @override
  List<Object?> get props => [isBtnDisabled];
}