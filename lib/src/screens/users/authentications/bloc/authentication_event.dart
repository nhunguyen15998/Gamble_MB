part of 'authentication_bloc.dart';

abstract class AuthenticationEvent extends Equatable {
  const AuthenticationEvent();

  @override
  List<Object> get props => [];
}

// Fired just after the app is launched
class AppLoaded extends AuthenticationEvent {}

// Fired when a user has successfully logged in
class UserLoggedIn extends AuthenticationEvent {
  final User user;

  const UserLoggedIn({required this.user});

  @override
  List<Object> get props => [user];
}

class UserRegister extends AuthenticationEvent {}

class UserLogIn extends AuthenticationEvent {}

// Fired when the user has logged out
class UserLoggedOut extends AuthenticationEvent {}
