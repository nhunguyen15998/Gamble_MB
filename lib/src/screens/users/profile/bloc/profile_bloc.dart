import 'package:bloc/bloc.dart';
import 'package:gamble/src/services/profile_service.dart';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final ProfileService profileService;
  ProfileBloc(this.profileService) : super(ProfileInitialized()) {
    on<ProfileInitial>(_mapProfileInitialToState);
  }

  Future<void> _mapProfileInitialToState(ProfileInitial event, Emitter<ProfileState> emit) async {
    try {
      final currentUser = await profileService.getUserProfile();
      if(currentUser != null){
        emit(ProfileLoaded(wallpaper: currentUser.wallpaper, 
                           thumbnail: currentUser.thumbnail, 
                           name: '${currentUser.firstName} ${currentUser.lastName}',
                           balance: currentUser.balance));
      }
    } catch (e) {
      print(e);
    }
  }

}
