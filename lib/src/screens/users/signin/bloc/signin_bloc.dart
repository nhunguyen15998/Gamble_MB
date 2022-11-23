// ignore: depend_on_referenced_packages
import 'package:bloc/bloc.dart';
// ignore: depend_on_referenced_packages
import 'package:equatable/equatable.dart';
// ignore: depend_on_referenced_packages
import 'package:formz/formz.dart';
import 'package:gamble/src/screens/users/signin/signin.dart';
import 'package:gamble/src/services/service.dart';
import 'package:gamble/src/screens/users/authentications/authentication.dart';

part 'signin_event.dart';
part 'signin_state.dart';

class SignInBloc extends Bloc<SignInEvent, SignInState> {
  final AuthenticationBloc _authenticationBloc;
  final AuthenticationService _authenticationService;

  SignInBloc(this._authenticationBloc, this._authenticationService)
      : super(const SignInState()) {
    on<SignInPhoneChanged>(_mapPhoneChangedToState);
    on<SignInPasswordChanged>(_mapPasswordChangedToState);
    on<SignInShowPasswordChanged>(_mapShowPasswordChangedToState);
    on<SignInSubmitted>(_mapSignInSubmittedToState);
    on<SignInAlertBtnOKClicked>(_mapSignInAlertBtnOKClickedToState);
  }

  void _mapPhoneChangedToState(
    SignInPhoneChanged event,
    Emitter<SignInState> emit,
  ) {
    final phone = Phone.dirty(event.phone);
    var isvalid = Formz.validate([phone, state.password]);
    emit(state.copyWith(
      phone: phone,
      status: isvalid,
      )
    );
  }

  void _mapPasswordChangedToState(
    SignInPasswordChanged event,
    Emitter<SignInState> emit,
  ) {
    final password = Password.dirty(event.password);
    emit(state.copyWith(
      password: password,
      status: Formz.validate([password, state.phone]),
    ));
  }

  void _mapShowPasswordChangedToState(
    SignInShowPasswordChanged event,
    Emitter<SignInState> emit,
  ) {
    final showPassword = state.showPassword;
    emit(state.copyWith(showPassword: !showPassword));
  }

  Future<void> _mapSignInSubmittedToState(
    SignInSubmitted event,
    Emitter<SignInState> emit,
  ) async {
    if (state.status.isValidated) {
      emit(state.copyWith(status: FormzStatus.submissionInProgress));
      try {
        var result = await _authenticationService.signInAction(
            state.phone.value, state.password.value);
        if (result['code'] == 200) {
          _authenticationBloc.add(UserLoggedIn(user: result['user']));
          emit(state.copyWith(status: FormzStatus.submissionSuccess, message: result['message']));
        } else {
          emit(state.copyWith(
              status: FormzStatus.submissionFailure,
              message: result['message']));
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

  Stream<SignInState> _mapCloseDialogToState(
    CloseDialog event,
    SignInState state,
  ) async* {
    yield state.copyWith(message: "");
  }

  Future<void> _mapSignInAlertBtnOKClickedToState(SignInAlertBtnOKClicked event, Emitter<SignInState> emit) async {
    emit(state.copyWith(status: FormzStatus.valid));
  }
}
