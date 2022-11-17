import 'package:bloc/bloc.dart';
import 'package:gamble/src/screens/users/profile_edit_info/models/email.dart';
import 'package:gamble/src/screens/users/profile_edit_info/models/last_name.dart';
import 'package:gamble/src/screens/users/profile_edit_info/models/first_name.dart';
import 'package:gamble/src/screens/users/profile_edit_info/models/user_profile_update.dart';
import 'package:gamble/src/services/profile_service.dart';
import 'package:intl/intl.dart';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';

part 'profile_edit_info_event.dart';
part 'profile_edit_info_state.dart';

class ProfileEditInfoBloc extends Bloc<ProfileEditInfoEvent, ProfileEditInfoState> {
  final ProfileService profileService;
  
  ProfileEditInfoBloc(this.profileService) : super(ProfileEditInfoInitialized()) {
    on<ProfileEditInfoInitial>(_mapProfileEditInfoInitialToState);
    on<ProfileEditInfoFirstNameChanged>(_mapProfileEditInfoFirstNameChangedToState);
    on<ProfileEditInfoLastNameChanged>(_mapProfileEditInfoLastNameChangedToState);
    on<ProfileEditInfoEmailChanged>(_mapProfileEditInfoEmailChangedToState);
    on<ProfileEditInfoBirthChanged>(_mapProfileEditInfoBirthChangedToState);
    on<ProfileEditInfoGenderChanged>(_mapProfileEditInfoGenderChangedToState);
    on<ProfileEditInfoSaveBtnClicked>(_mapProfileEditInfoSaveBtnClickedToState);
  }

  Future<void> _mapProfileEditInfoInitialToState(ProfileEditInfoInitial event, Emitter<ProfileEditInfoState> emit) async {
    try {
      final currentUser = await profileService.getUserProfile();
      if(currentUser != null){
        final firstName = currentUser.firstName;
        final lastName = currentUser.lastName;
        final email = currentUser.email;
        emit(ProfileEditInfoLoaded(firstNameLoaded: firstName,
                                    firstName: FirstNameUpdate.dirty(firstName), 
                                    lastNameLoaded: lastName,
                                    lastName: LastNameUpdate.dirty(lastName),
                                    phoneLoaded: currentUser.phone,
                                    emailLoaded: email,
                                    email: EmailUpdate.dirty(email),
                                    birthLoaded: currentUser.birth,
                                    genderLoaded: currentUser.gender));
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> _mapProfileEditInfoFirstNameChangedToState(ProfileEditInfoFirstNameChanged event, Emitter<ProfileEditInfoState> emit) async {
    final firstName = FirstNameUpdate.dirty(event.firstName);
    ProfileEditInfoLoaded profileEditInfoLoaded = state as ProfileEditInfoLoaded;
    var isValid = Formz.validate([firstName, profileEditInfoLoaded.lastName, profileEditInfoLoaded.email]);
    emit(profileEditInfoLoaded.copyWith(firstName: firstName, status: isValid));
  }

  Future<void> _mapProfileEditInfoLastNameChangedToState(ProfileEditInfoLastNameChanged event, Emitter<ProfileEditInfoState> emit) async {
    final lastName = LastNameUpdate.dirty(event.lastName);
    ProfileEditInfoLoaded profileEditInfoLoaded = state as ProfileEditInfoLoaded;
    var isValid = Formz.validate([lastName, profileEditInfoLoaded.firstName, profileEditInfoLoaded.email]);
    emit(profileEditInfoLoaded.copyWith(lastName: lastName, status: isValid));
  }

  Future<void> _mapProfileEditInfoEmailChangedToState(ProfileEditInfoEmailChanged event, Emitter<ProfileEditInfoState> emit) async {
    final email = EmailUpdate.dirty(event.email);
    ProfileEditInfoLoaded profileEditInfoLoaded = state as ProfileEditInfoLoaded;
    var isValid = Formz.validate([email, profileEditInfoLoaded.firstName, profileEditInfoLoaded.lastName]);
    emit(profileEditInfoLoaded.copyWith(email: email, status: isValid));
  }

  Future<void> _mapProfileEditInfoBirthChangedToState(ProfileEditInfoBirthChanged event, Emitter<ProfileEditInfoState> emit) async {
    final birth = event.birth;
    ProfileEditInfoLoaded profileEditInfoLoaded = state as ProfileEditInfoLoaded;
    emit(profileEditInfoLoaded.copyWith(birth: birth));
  }

  Future<void> _mapProfileEditInfoGenderChangedToState(ProfileEditInfoGenderChanged event, Emitter<ProfileEditInfoState> emit) async {
    final gender = event.gender;
    ProfileEditInfoLoaded profileEditInfoLoaded = state as ProfileEditInfoLoaded;
    emit(profileEditInfoLoaded.copyWith(gender: gender));
  }

  Future<void> _mapProfileEditInfoSaveBtnClickedToState(ProfileEditInfoSaveBtnClicked event, Emitter<ProfileEditInfoState> emit) async {
    ProfileEditInfoLoaded profileEditInfoLoaded = state as ProfileEditInfoLoaded;
    if(profileEditInfoLoaded.status.isValidated){
      emit(profileEditInfoLoaded.copyWith(status: FormzStatus.submissionInProgress));
      try {
        final firstName = profileEditInfoLoaded.firstName;
        final lastName = profileEditInfoLoaded.lastName;
        final email = profileEditInfoLoaded.email;
        var birth = DateFormat('yyyy-MM-dd').parse(DateFormat('dd/MM/yyyy').parse(profileEditInfoLoaded.birthLoaded).toString()).toString().substring(0,10);
        final phone = profileEditInfoLoaded.phoneLoaded;
        final gender = profileEditInfoLoaded.genderLoaded;
        print("just clicked");
        final updated = await profileService.updateUserProfile(ProfileUpdate(
                                                                firstName: firstName.value,
                                                                lastName: lastName.value,
                                                                email: email.value,
                                                                birth: birth,
                                                                gender: gender
                                                              ));
        if(updated){
          emit(profileEditInfoLoaded.copyWith(
            status: FormzStatus.submissionSuccess
          ));
        } else {
          emit(profileEditInfoLoaded.copyWith(
            status: FormzStatus.submissionFailure
          ));
        }
      } on Exception catch (e) {
        print(e);
        emit(profileEditInfoLoaded.copyWith(status: FormzStatus.submissionFailure));
      }
    }
  }

}
