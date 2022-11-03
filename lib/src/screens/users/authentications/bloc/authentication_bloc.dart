// ignore: depend_on_referenced_packages
import 'package:bloc/bloc.dart';
// ignore: depend_on_referenced_packages
import 'package:equatable/equatable.dart';
import 'package:gamble/src/screens/users/models/model.dart';
import 'package:gamble/src/services/authentication_service.dart';

part 'authentication_state.dart';
part 'authentication_event.dart';

class AuthenticationBloc extends Bloc<AuthenticationEvent, AuthenticationState> {
  final AuthenticationService _authenticationService;

  AuthenticationBloc(this._authenticationService)
      : super(AuthenticationInitial()) {
    on<AppLoaded>(_mapAppLoadedToState);
    on<UserLoggedIn>(_mapUserLoggedInToState);
    on<UserLoggedOut>(_mapUserLoggedOutToState);
  }

  Future<void> _mapAppLoadedToState(
      AppLoaded event, Emitter<AuthenticationState> emit) async {
    emit(AuthenticationLoading());
    try {
      await Future.delayed(const Duration(milliseconds: 500)); // a simulated delay
      var currentUser = await _authenticationService.getCurrentUser();

      if(state is AuthenticationAuthenticated){
        AuthenticationAuthenticated authenticationAuthenticated = state as AuthenticationAuthenticated;
        currentUser = authenticationAuthenticated.user;
      }

      if (currentUser != null) {
        emit(AuthenticationAuthenticated(user: currentUser));
      } else {
        emit(AuthenticationNotAuthenticated());
      }
    } catch (e) {
      emit(AuthenticationFailure(message: e.toString()));
    }
  }

  Future<void> _mapUserLoggedInToState(
      UserLoggedIn event, Emitter<AuthenticationState> emit) async {
    emit(AuthenticationAuthenticated(user: event.user));
  }

  Future<void> _mapUserLoggedOutToState(
      UserLoggedOut event, Emitter<AuthenticationState> emit) async {
    await _authenticationService.signOut();
    emit(AuthenticationNotAuthenticated());
  }
}
