part of 'profile_edit_info_bloc.dart';

class ProfileEditInfoState extends Equatable {
  const ProfileEditInfoState();

  @override
  List<Object> get props => [];
}

class ProfileEditInfoInitialized extends ProfileEditInfoState {}

class ProfileEditInfoLoaded extends ProfileEditInfoState {
  ProfileEditInfoLoaded({
    required this.firstName,
    required this.lastName,
    required this.phone,
    required this.email,
    required this.birth,
    required this.gender,
  });

  String firstName;
  String lastName;
  String phone;
  String email;
  String birth;
  int gender;

  @override
  List<Object> get props => [firstName, lastName, phone, email, birth, gender];
}

class ProfileEditInfoUpdateLoading extends ProfileEditInfoState {}

class ProfileEditInfoUpdatedSuccessful extends ProfileEditInfoState {}

class ProfileEditInfoUpdatedFailed extends ProfileEditInfoState {}