part of 'profile_security_bloc.dart';

class ProfileSecurityState extends Equatable {
  const ProfileSecurityState();
  @override
  List<Object?> get props => [];
}

class ProfileSecurityInitialized extends ProfileSecurityState {
  ProfileSecurityInitialized({
    this.isWithdrawOn = false,
    this.isTransferOn = false,
    this.isUpdateSettingOn = false,
    this.isBtnDisabled = false,
    this.status = "",
    this.code = 0,
    this.message = ""
  });

  bool isWithdrawOn;
  bool isTransferOn;
  bool isUpdateSettingOn;
  bool isBtnDisabled;
  String status;
  int code;
  String message;

  ProfileSecurityInitialized copyWith({
    bool? isWithdrawOn,
    bool? isTransferOn,
    bool? isUpdateSettingOn,
    bool? isBtnDisabled,
    String? status,
    int? code,
    String? message,
  }){
    return ProfileSecurityInitialized(
      isWithdrawOn: isWithdrawOn ?? this.isWithdrawOn,
      isTransferOn: isTransferOn ?? this.isTransferOn,
      isUpdateSettingOn: isUpdateSettingOn ?? this.isUpdateSettingOn,
      isBtnDisabled: isBtnDisabled ?? this.isBtnDisabled,
      status: status ?? this.status,
      code: code ?? this.code,
      message: message ?? this.message,
    );
  }

  @override
  List<Object?> get props => [isWithdrawOn, isTransferOn, isUpdateSettingOn, 
                              isBtnDisabled, status, code, message];
}
