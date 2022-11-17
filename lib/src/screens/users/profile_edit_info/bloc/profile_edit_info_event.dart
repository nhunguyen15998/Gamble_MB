part of 'profile_edit_info_bloc.dart';

class ProfileEditInfoEvent extends Equatable {
  const ProfileEditInfoEvent();
  @override
  List<Object> get props => [];
}

class ProfileEditInfoFirstNameChanged extends ProfileEditInfoEvent {
  ProfileEditInfoFirstNameChanged({required this.firstName});
  String firstName;
  @override
  List<Object> get props => [firstName];
}

class ProfileEditInfoLastNameChanged extends ProfileEditInfoEvent {
  ProfileEditInfoLastNameChanged({required this.lastName});
  String lastName;
  @override
  List<Object> get props => [lastName];
}

class ProfileEditInfoEmailChanged extends ProfileEditInfoEvent {
  ProfileEditInfoEmailChanged({required this.email});
  String email;
  @override
  List<Object> get props => [email];
}

class ProfileEditInfoBirthChanged extends ProfileEditInfoEvent {
  ProfileEditInfoBirthChanged({required this.birth});
  String birth;
  @override
  List<Object> get props => [birth];
}

class ProfileEditInfoGenderChanged extends ProfileEditInfoEvent {
  ProfileEditInfoGenderChanged({required this.gender});
  int gender;
  @override
  List<Object> get props => [gender];
}

class ProfileEditInfoSaveBtnClicked extends ProfileEditInfoEvent {
  const ProfileEditInfoSaveBtnClicked();

  @override
  List<Object> get props => [];
}

class ProfileEditInfoInitial extends ProfileEditInfoEvent {}

class ProfileEditInfoUpdating extends ProfileEditInfoEvent {}
