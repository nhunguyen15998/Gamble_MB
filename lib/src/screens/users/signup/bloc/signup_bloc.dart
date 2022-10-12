// ignore: depend_on_referenced_packages
import 'package:bloc/bloc.dart';
// ignore: depend_on_referenced_packages
import 'package:equatable/equatable.dart';
// ignore: depend_on_referenced_packages
import 'package:formz/formz.dart';
import 'package:gamble/src/screens/users/signup/signup.dart';
import 'package:gamble/src/services/authentications/service.dart';
import 'package:gamble/src/screens/users/authentications/authentication.dart';

part 'signup_event.dart';
part 'signup_state.dart';

class SignUpBloc extends Bloc<SignUpEvent, SignUpState> {
  final AuthenticationBloc _authenticationBloc;
  final AuthenticationService _authenticationService;

  SignUpBloc(this._authenticationBloc, this._authenticationService)
      : super(const SignUpState()) {
    on<SignUpPhoneChanged>(_mapPhoneChangedToState);
    on<SignUpPasswordChanged>(_mapPasswordChangedToState);
    on<SignUpShowPasswordChanged>(_mapShowPasswordChangedToState);
  }

  void _mapPhoneChangedToState(
    SignUpPhoneChanged event,
    Emitter<SignUpState> emit,
  ) {
    final phone = Phone.dirty(event.phone);
    emit(state.copyWith(
      phone: phone,
      status: Formz.validate([state.password, phone]),
    ));
  }

  void _mapPasswordChangedToState(
    SignUpPasswordChanged event,
    Emitter<SignUpState> emit,
  ) {
    final password = Password.dirty(event.password);
    emit(state.copyWith(
      password: password,
      status: Formz.validate([password, state.phone]),
    ));
  }

  void _mapShowPasswordChangedToState(
    SignUpShowPasswordChanged event,
    Emitter<SignUpState> emit,
  ) {
    final showPassword = state.showPassword;
    emit(state.copyWith(showPassword: !showPassword));
  }

  Stream<SignUpState> _mapCloseDialogToState(
    CloseDialog event,
    SignUpState state,
  ) async* {
    yield state.copyWith(error: "");
  }
}
