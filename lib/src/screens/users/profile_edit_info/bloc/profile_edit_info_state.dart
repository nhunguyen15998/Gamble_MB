part of 'profile_edit_info_bloc.dart';

class ProfileEditInfoState extends Equatable {
  const ProfileEditInfoState();
  @override
  List<Object> get props => [];
}

class ProfileEditInfoInitialized extends ProfileEditInfoState {}

class ProfileEditInfoLoaded extends ProfileEditInfoState {
  ProfileEditInfoLoaded({
    this.firstNameLoaded = '',
    this.lastNameLoaded = '',
    this.phoneLoaded = '',
    this.emailLoaded = '',
    this.birthLoaded = '',
    this.genderLoaded = 0,
    //
    this.status = FormzStatus.valid,
    this.firstName = const FirstNameUpdate.pure(),
    this.lastName = const LastNameUpdate.pure(),
    this.email = const EmailUpdate.pure(),
  });

  String firstNameLoaded;
  String lastNameLoaded;
  String phoneLoaded;
  String emailLoaded;
  String birthLoaded;
  int genderLoaded;

  FirstNameUpdate firstName;
  LastNameUpdate lastName;
  EmailUpdate email;
  FormzStatus status;

  ProfileEditInfoLoaded copyWith({
    FirstNameUpdate? firstName, 
    LastNameUpdate? lastName, 
    EmailUpdate? email, 
    String? phone,
    String? birth,
    int? gender,
    FormzStatus? status
  })
  {
    return ProfileEditInfoLoaded(
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      phoneLoaded: phone ?? phoneLoaded,
      birthLoaded: birth ?? birthLoaded,
      genderLoaded: gender ?? genderLoaded,
      status: status ?? this.status
    );
  }

  @override
  List<Object> get props => [firstName, lastName, phoneLoaded, email, birthLoaded, genderLoaded, status,
    firstNameLoaded, lastNameLoaded, emailLoaded
  ];
}

class ProfileEditInfoUpdateLoading extends ProfileEditInfoState {}

class ProfileEditInfoUpdatedSuccessful extends ProfileEditInfoState {}

class ProfileEditInfoUpdatedFailed extends ProfileEditInfoState {}

