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
    on<SignUpSubmitted>(_mapSignUpSubmittedToState);
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

  Future<void> _mapSignUpSubmittedToState(
    SignUpSubmitted event,
    Emitter<SignUpState> emit,
  ) async {
    if (state.status.isValidated) {
      emit(state.copyWith(status: FormzStatus.submissionInProgress));
      try {
        var result = await _authenticationService.signUpAction(
            state.firstName.value,
            state.lastName.value,
            state.phone.value,
            state.email.value,
            state.password.value,
            state.confirmedPassword.value);
        print(result);
        if (result != null) {
          _authenticationBloc.add(UserLoggedIn(user: result));
          emit(state.copyWith(status: FormzStatus.submissionSuccess));
        } else {
          emit(state.copyWith(
              status: FormzStatus.submissionFailure,
              error: "Whoops! Something went wrong"));
        }

        // if (result['error'] == false) {
        //   emit(state.copyWith(status: FormzStatus.submissionSuccess));
        // } else {
        //   emit(state.copyWith(
        //       status: FormzStatus.submissionFailure, error: result['message']));
        // }
      } on Exception catch (e) {
        print(e);
        emit(state.copyWith(status: FormzStatus.submissionFailure));
      }
    }
  }

  Stream<SignUpState> _mapCloseDialogToState(
    CloseDialog event,
    SignUpState state,
  ) async* {
    yield state.copyWith(error: "");
  }
}
