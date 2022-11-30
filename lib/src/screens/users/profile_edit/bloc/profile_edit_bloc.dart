import 'package:bloc/bloc.dart';
import 'package:gamble/src/services/profile_service.dart';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

part 'profile_edit_event.dart';
part 'profile_edit_state.dart';

class ProfileEditBloc extends Bloc<ProfileEditEvent, ProfileEditState> {
  final ProfileService profileService;
  
  ProfileEditBloc(this.profileService) : super(ProfileEditInitialized()) {
    on<ProfileEditInitial>(_mapProfileEditInitialToState);
  }

  Future<void> _mapProfileEditInitialToState(ProfileEditInitial event, Emitter<ProfileEditState> emit) async {
    try {
      final currentUser = await profileService.getUserProfile();
      if(currentUser != null){
        emit(ProfileEditLoaded(wallpaper: currentUser.wallpaper ?? "", 
                               thumbnail: currentUser.thumbnail, 
                               firstName: currentUser.firstName, 
                               lastName: currentUser.lastName,
                               phone: currentUser.phone,
                               email: currentUser.email,
                               birth: currentUser.birth));
      }
    } catch (e) {
      print(e);
    }
  }

}
