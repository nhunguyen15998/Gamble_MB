part of 'profile_edit_bloc.dart';

class ProfileEditState extends Equatable {
  const ProfileEditState();

  @override
  List<Object> get props => [];
}

class ProfileEditInitialized extends ProfileEditState {}

class ProfileEditLoaded extends ProfileEditState {
  ProfileEditLoaded({
    this.wallpaper = "",
    required this.thumbnail,
    required this.firstName,
    required this.lastName,
    required this.phone,
    required this.email,
    required this.birth
  });

  String wallpaper;
  String thumbnail;
  String firstName;
  String lastName;
  String phone;
  String email;
  String birth;

  @override
  List<Object> get props => [wallpaper, thumbnail, firstName, lastName, phone, email, birth];
}
