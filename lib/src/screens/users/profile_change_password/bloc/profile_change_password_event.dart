part of 'profile_change_password_bloc.dart';

class ProfileChangePasswordEvent extends Equatable {
  ProfileChangePasswordEvent();
  
  @override
  List<Object?> get props => [];
} 
 
class ProfileOldPasswordChanged extends ProfileChangePasswordEvent {
  ProfileOldPasswordChanged({required this.password});
  String password;
  @override
  List<Object?> get props => [password];
}

class ProfileNewPasswordChanged extends ProfileChangePasswordEvent {
  ProfileNewPasswordChanged({required this.password});
  String password;
  @override
  List<Object?> get props => [password];
}

class ProfileConfirmNewPasswordChanged extends ProfileChangePasswordEvent {
  ProfileConfirmNewPasswordChanged({required this.password});
  String password;
  @override
  List<Object?> get props => [password];
}

class ProfileBtnChangePasswordClicked extends ProfileChangePasswordEvent {}

class ProfileAlertBtnOKClicked extends ProfileChangePasswordEvent {}