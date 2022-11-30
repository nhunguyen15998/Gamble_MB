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
      : super(const AuthenticationState()) {
    on<AppLoaded>(_mapAppLoadedToState);
    on<UserLoggedIn>(_mapUserLoggedInToState);
    on<UserRegister>(_mapUserRegisterToState);
    on<UserLogIn>(_mapUserLogInToState);
    on<UserLoggedOut>(_mapUserLoggedOutToState);
  }

  Future<void> _mapAppLoadedToState(
      AppLoaded event, Emitter<AuthenticationState> emit) async {
    emit(AuthenticationLoading());
    try {
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

  void _mapUserRegisterToState(UserRegister event, Emitter<AuthenticationState> emit) {
    emit(AuthenticationRegistered());
  }

  void _mapUserLogInToState(UserLogIn event, Emitter<AuthenticationState> emit){
    emit(AuthenticationNotAuthenticated());
  }

  Future<void> _mapUserLoggedOutToState(
      UserLoggedOut event, Emitter<AuthenticationState> emit) async {
    emit(AuthenticationLoading());
    _authenticationService.signOut();
    emit(AuthenticationNotAuthenticated());
  }
}
