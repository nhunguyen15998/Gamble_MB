// ignore: depend_on_referenced_packages
import 'package:bloc/bloc.dart';
// ignore: depend_on_referenced_packages
import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';
// ignore: depend_on_referenced_packages
import 'package:formz/formz.dart';
import 'package:gamble/src/screens/users/signup/signup.dart';
import 'package:gamble/src/services/service.dart';
import 'package:gamble/src/screens/users/authentications/authentication.dart';

part 'signup_event.dart';
part 'signup_state.dart';

class SignUpBloc extends Bloc<SignUpEvent, SignUpState> {
  final AuthenticationService _authenticationService;

  SignUpBloc(this._authenticationService):super(const SignUpState()) {
    on<SignUpFirstNameChanged>(_mapSignUpFirstNameChangedToState);
    on<SignUpLastNameChanged>(_mapSignUpLastNameChangedToState);
    on<SignUpPhoneChanged>(_mapPhoneChangedToState);
    on<SignUpEmailChanged>(_mapSignUpEmailChangedToState);
    on<SignUpPasswordChanged>(_mapPasswordChangedToState);
    on<SignUpShowPasswordChanged>(_mapShowPasswordChangedToState);
    on<SignUpConfirmedPasswordChanged>(_mapSignUpConfirmedPasswordChangedToState);
    on<SignUpShowConfirmedPasswordChanged>(_mapSignUpShowConfirmedPasswordChangedToState);
    
    on<SignUpStepChanged>(_mapStepChangedToState);
    on<SignUpSubmitted>(_mapSignUpSubmittedToState);
    on<SignUpAlertBtnOKClicked>(_mapSignUpAlertBtnOKClickedToState);
  }

  void _mapSignUpFirstNameChangedToState(SignUpFirstNameChanged event, Emitter<SignUpState> emit) {
    final firstName = FirstName.dirty(event.firstName);
    var isValid = Formz.validate([firstName, state.lastName]);
    emit(state.copyWith(firstName: firstName, status: isValid));
  }

  void _mapSignUpLastNameChangedToState(SignUpLastNameChanged event, Emitter<SignUpState> emit) {
    final lastName = LastName.dirty(event.lastName);
    var isValid = Formz.validate([lastName, state.firstName]);
    emit(state.copyWith(lastName: lastName, status: isValid));
  }

  void _mapPhoneChangedToState(SignUpPhoneChanged event,Emitter<SignUpState> emit) {
    final phone = Phone.dirty(event.phone);
    var isValid = Formz.validate([phone, state.email]);
    emit(state.copyWith(phone: phone, status: isValid));
  }

  void _mapSignUpEmailChangedToState(SignUpEmailChanged event,Emitter<SignUpState> emit) {
    final email = Email.dirty(event.email);
    var isValid = Formz.validate([state.phone, email]);
    emit(state.copyWith(email: email, status: isValid));
  }

  void _mapPasswordChangedToState(SignUpPasswordChanged event, Emitter<SignUpState> emit) {
    final password = Password.dirty(event.password);
    var isValid = Formz.validate([state.confirmedPassword, password]);
    emit(state.copyWith(password: password, status: isValid));
  }

  void _mapShowPasswordChangedToState(SignUpShowPasswordChanged event, Emitter<SignUpState> emit) {
    final showPassword = state.showPassword;
    emit(state.copyWith(showPassword: !showPassword));
  }

  void _mapSignUpConfirmedPasswordChangedToState(SignUpConfirmedPasswordChanged event, Emitter<SignUpState> emit) {
    final confirmedPassword = ConfirmedPassword.dirty(event.password);
    var isValid = Formz.validate([confirmedPassword, state.password]);
    emit(state.copyWith(confirmedPassword: confirmedPassword, status: isValid));
  }

  void _mapSignUpShowConfirmedPasswordChangedToState(SignUpShowConfirmedPasswordChanged event, Emitter<SignUpState> emit) {
    final showConfirmedPassword = state.showConfirmedPassword;
    emit(state.copyWith(showConfirmedPassword: !showConfirmedPassword));
  }

  void _mapStepChangedToState(SignUpStepChanged event, Emitter<SignUpState> emit){
    final step = event.step;
    emit(state.copyWith(step: step));
    // print(state.firstName);
    // print(state.lastName);
    // print(state.phone);
    // print(state.email);
    // print(state.password);
    // print(state.confirmedPassword);
  }

  //submit
  Future<void> _mapSignUpSubmittedToState(SignUpSubmitted event, Emitter<SignUpState> emit) async {
    emit(state.copyWith(status: FormzStatus.submissionInProgress));
    try {
      final result = await _authenticationService.signUpAction(
        state.firstName.value, state.lastName.value, 
        state.email.value, state.phone.value, 
        state.password.value, state.confirmedPassword.value);
      if(result['code'] == 200){
        emit(state.copyWith(status: FormzStatus.submissionSuccess));
      } else {
        emit(state.copyWith(status: FormzStatus.submissionFailure, error: result['message']));
      }
    } catch (e) {
      print(e);
    }
  }

  void _mapSignUpAlertBtnOKClickedToState(SignUpAlertBtnOKClicked event, Emitter<SignUpState> emit) {
    emit(state.copyWith(status: FormzStatus.valid, error: ''));
  }

  Stream<SignUpState> _mapCloseDialogToState(
    CloseDialog event,
    SignUpState state,
  ) async* {
    yield state.copyWith(error: "");
  }
}
