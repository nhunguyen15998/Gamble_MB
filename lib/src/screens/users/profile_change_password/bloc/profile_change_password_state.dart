part of 'profile_change_password_bloc.dart';

class ProfileChangePasswordState extends Equatable {
  ProfileChangePasswordState({
    this.oldPassword = const ChangePassword.pure(),
    this.newPassword = const ChangePassword.pure(),
    this.confirmNewPassword = const ChangePassword.pure(),
    this.status = FormzStatus.invalid
  });

  ChangePassword oldPassword;
  ChangePassword newPassword;
  ChangePassword confirmNewPassword;
  FormzStatus status;

  ProfileChangePasswordState copyWith({
    ChangePassword? oldPassword,
    ChangePassword? newPassword,
    ChangePassword? confirmNewPassword,
    FormzStatus? status,
  }){
    return ProfileChangePasswordState(
      oldPassword: oldPassword ?? this.oldPassword,
      newPassword: newPassword ?? this.newPassword,
      confirmNewPassword: confirmNewPassword ?? this.confirmNewPassword,
      status: status ?? this.status
    );
  }
  
  @override
  List<Object?> get props => [oldPassword, newPassword, confirmNewPassword, status];
}

class ProfileChangePasswordLoading extends ProfileChangePasswordState {}

class ProfileChangePasswordLoaded extends ProfileChangePasswordState {
  ProfileChangePasswordLoaded({
    required this.code,
    required this.message
  });
  int code;
  String message;
  @override
  List<Object?> get props => [code, message];
}

