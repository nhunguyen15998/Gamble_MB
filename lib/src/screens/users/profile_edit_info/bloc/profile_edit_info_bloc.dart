import 'package:bloc/bloc.dart';
import 'package:gamble/src/services/profile_service.dart';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

part 'profile_edit_info_event.dart';
part 'profile_edit_info_state.dart';

class ProfileEditInfoBloc extends Bloc<ProfileEditInfoEvent, ProfileEditInfoState> {
  final ProfileService profileService;
  
  ProfileEditInfoBloc(this.profileService) : super(ProfileEditInfoInitialized()) {
    on<ProfileEditInfoInitial>(_mapProfileEditInfoInitialToState);
  }

  Future<void> _mapProfileEditInfoInitialToState(ProfileEditInfoInitial event, Emitter<ProfileEditInfoState> emit) async {
    try {
      final currentUser = await profileService.getUserProfile();
      if(currentUser != null){
        emit(ProfileEditInfoLoaded(firstName: currentUser.firstName, 
                                    lastName: currentUser.lastName,
                                    phone: currentUser.phone,
                                    email: currentUser.email,
                                    birth: currentUser.birth,
                                    gender: currentUser.gender));
      }
    } catch (e) {
      print(e);
    }
  }

}
