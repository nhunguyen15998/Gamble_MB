import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gamble/src/screens/users/authentications/bloc/authentication_bloc.dart';
import 'package:gamble/src/screens/users/signin/bloc/signin_bloc.dart';
// ignore: depend_on_referenced_packages
import 'package:formz/formz.dart';

import '../../signin/models/phone.dart';
import '../../signup/views/signup_page.dart';

class SignInForm extends StatelessWidget {
  const SignInForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double ratio = size.width / size.height;

    return Padding(
      padding: EdgeInsets.only(bottom: 18, top: size.height * 0.1),
      child: Container(
        height: size.height * 0.6,
        width: double.infinity,
        margin: const EdgeInsets.all(10),
        decoration: BoxDecoration(color: Colors.white.withOpacity(0.0)),
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: BlocBuilder<SignInBloc, SignInState>(
            builder: (context, state) {
              print(state);
              Widget widget = const SizedBox();
              if(state.status == FormzStatus.submissionInProgress){
                widget = const Center(child: CircularProgressIndicator());
              }
              if(state.status == FormzStatus.submissionFailure){
                widget = AlertDialog(
                  icon: const Icon(Icons.error_outline_rounded),
                  content: Text(state.message),
                  actions: <Widget>[
                    TextButton(
                      child: const Text('OK'),
                      onPressed: () {
                        context.read<SignInBloc>().add(SignInAlertBtnOKClicked());
                      },
                    ),
                  ],
                );
              }
              return Stack(
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Text("Sign In".toUpperCase(),
                          style: const TextStyle(
                              fontFamily: "Play",
                              fontSize: 20,
                              color: Color.fromRGBO(255, 255, 255, 1),
                              fontWeight: FontWeight.w600)),
                      const SignInPhone(),
                      const SignInPassword(),
                      SizedBox(
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              child: Row(
                                children: <Widget>[
                                  const Icon(
                                    Icons.check_circle,
                                    color: Color.fromRGBO(255, 255, 255, 1),
                                  ),
                                  const SizedBox(
                                    width: 3.0,
                                  ),
                                  Text("Rememeber",
                                      style: TextStyle(
                                          fontFamily: "Play",
                                          fontSize: ratio * 30,
                                          color:
                                              const Color.fromRGBO(255, 255, 255, 1)))
                                ],
                              ),
                            ),
                            Expanded(
                              child: Align(
                                alignment: Alignment.centerRight,
                                child: GestureDetector(
                                  onTap: () {},
                                  child: Text("Forgot password?",
                                      style: TextStyle(
                                          color:
                                              const Color.fromRGBO(255, 255, 255, 1),
                                          fontFamily: "Play",
                                          fontSize: ratio * 30)),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      const SignInButton(),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text("Don't have account? ",
                              style: TextStyle(
                                  fontFamily: "Play",
                                  fontSize: ratio * 30,
                                  color: const Color.fromRGBO(255, 255, 255, 1))),
                          BlocBuilder<AuthenticationBloc, AuthenticationState>(
                            builder: (context, state) {
                              return GestureDetector(
                                onTap: () async {
                                  context.read<AuthenticationBloc>().add(UserRegister());
                                  //Navigator.pushNamed(context, '/signup');
                                },
                                child: Text("Register",
                                    style: TextStyle(
                                        fontFamily: "Play",
                                        fontSize: ratio * 30,
                                        color: const Color.fromRGBO(233, 132, 41, 1))),
                              );
                            }
                          )
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 20),
                        child: GestureDetector(
                          onTap: () {},
                          child: Icon(
                            Icons.fingerprint,
                            size: ratio * 130,
                            color: const Color.fromRGBO(250, 0, 159, 1),
                          ),
                        ),
                      ),
                    ],
                  ),
                  state.status == FormzStatus.submissionInProgress || state.status == FormzStatus.submissionFailure ?
                  Positioned(
                    bottom: -65,
                    left: -27,
                    child: Container(
                      width: size.width,
                      height: size.height,
                      color: Colors.transparent,
                      //Color.fromARGB(44, 250, 0, 158),
                      child: widget,
                    )
                  ) : const SizedBox() 
                ]
              );
            },
          )
        ),
      )
    );
  }
}

class SignInPhone extends StatelessWidget {
  const SignInPhone({Key? key}):super(key: key);

  String? getErrorMsg(Phone phone){
    print(phone.invalid);
    String msg = '';
    if(phone.invalid){
      switch (phone.error!.index) {
        case 0:
          msg = 'Phone is required';
          break;
        case 1:
          msg = 'Invalid phone format';
          break;
      }
    }
    return msg != '' ? msg : null;
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double ratio = size.width / size.height;
    return BlocBuilder<SignInBloc, SignInState>(
        buildWhen: (previous, current) => previous.phone != current.phone,
        builder: (context, state) {
          return TextField(
              key: const Key('SignInForm_phoneInput_phoneField'),
              keyboardType: TextInputType.phone,
              style: const TextStyle(color: Color.fromRGBO(255, 255, 255, 1)),
              decoration: InputDecoration(
                  labelText: 'Phone number',
                  errorText: getErrorMsg(state.phone),
                  labelStyle: TextStyle(
                    fontSize: ratio * 35,
                    color: const Color.fromRGBO(255, 255, 255, 1),
                    fontFamily: "Play",
                  ),
                  errorStyle:
                      const TextStyle(color: Color.fromRGBO(255, 255, 255, 1)),
                  contentPadding: const EdgeInsets.all(0),
                  filled: true,
                  fillColor: Colors.white.withOpacity(0.2),
                  prefixIcon: Container(
                      margin: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                          color: const Color.fromRGBO(250, 0, 159, 1),
                          border: Border.all(
                            color: const Color.fromRGBO(180, 67, 170, 1),
                          ),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(50))),
                      child: const Icon(FontAwesomeIcons.mobile,
                          size: 18, color: Colors.white)),
                  focusedBorder: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(50)),
                      borderSide: BorderSide(
                          color: Color.fromRGBO(210, 213, 252, 1), width: 1)),
                  enabledBorder: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(50)),
                      borderSide: BorderSide(
                          color: Color.fromRGBO(210, 213, 252, 1), width: 1)),
                  errorBorder: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(50)),
                      borderSide: BorderSide(
                          color: Color.fromRGBO(218, 62, 59, 1), width: 1)),
                  focusedErrorBorder: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(50)),
                      borderSide: BorderSide(
                          color: Color.fromRGBO(218, 62, 59, 1), width: 1))),
              onChanged: (phone) =>
                  context.read<SignInBloc>().add(SignInPhoneChanged(phone)));
        });
  }
}

class SignInPassword extends StatelessWidget {
  const SignInPassword({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double ratio = size.width / size.height;
    return BlocBuilder<SignInBloc, SignInState>(
        buildWhen: (previous, current) =>
            previous.password != current.password ||
            previous.showPassword != current.showPassword,
        builder: (context, state) {
          return TextField(
              key: const Key('SignInForm_passwordInput_textField'),
              obscureText: state.showPassword,
              style: const TextStyle(color: Color.fromRGBO(255, 255, 255, 1)),
              decoration: InputDecoration(
                  labelText: 'Password',
                  errorText:
                      state.password.invalid ? 'Password is required' : null,
                  labelStyle: TextStyle(
                      fontSize: ratio * 35,
                      color: const Color.fromRGBO(255, 255, 255, 1),
                      fontFamily: "Play"),
                  errorStyle:
                      const TextStyle(color: Color.fromRGBO(255, 255, 255, 1)),
                  contentPadding: const EdgeInsets.all(0),
                  suffixIcon: GestureDetector(
                    onTap: () {
                      context
                          .read<SignInBloc>()
                          .add(SignInShowPasswordChanged(state.showPassword));
                    },
                    child: Icon(
                      state.showPassword
                          ? FontAwesomeIcons.eye
                          : FontAwesomeIcons.eyeSlash,
                      size: ratio * 40,
                      color: const Color.fromRGBO(255, 255, 255, 1),
                    ),
                  ),
                  filled: true,
                  fillColor: Colors.white.withOpacity(0.2),
                  prefixIcon: Container(
                      margin: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                          color: const Color.fromRGBO(250, 0, 159, 1),
                          border: Border.all(
                            color: const Color.fromRGBO(180, 67, 170, 1),
                          ),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(50))),
                      child: const Icon(FontAwesomeIcons.key,
                          size: 18, color: Colors.white)),
                  border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(50)),
                      borderSide: BorderSide(
                          color: Color.fromRGBO(210, 213, 252, 1), width: 1)),
                  focusedBorder: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(50)),
                      borderSide: BorderSide(
                          color: Color.fromRGBO(210, 213, 252, 1), width: 1)),
                  enabledBorder: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(50)),
                      borderSide: BorderSide(
                          color: Color.fromRGBO(210, 213, 252, 1), width: 1)),
                  errorBorder: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(50)),
                      borderSide: BorderSide(
                          color: Color.fromRGBO(218, 62, 59, 1), width: 1)),
                  focusedErrorBorder: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(50)),
                      borderSide: BorderSide(
                          color: Color.fromRGBO(218, 62, 59, 1), width: 1))),
              onChanged: (password) => context
                  .read<SignInBloc>()
                  .add(SignInPasswordChanged(password)));
        });
  }
}

class SignInButton extends StatelessWidget {
  const SignInButton({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double ratio = size.width / size.height;
    return BlocBuilder<SignInBloc, SignInState>(
        buildWhen: (previous, current) => previous.status != current.status,
        builder: (context, state) {
          return SizedBox(
              width: double.infinity,
              height: ratio * 100,
              child: ElevatedButton(
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(
                        const Color.fromRGBO(233, 132, 41, 1)),
                    shape: MaterialStateProperty.all(RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(ratio * 50)))),
                key: const Key('SignInForm_continue_raisedButton'),
                onPressed: state.status == FormzStatus.valid
                    ? () {
                        print("CLick me");
                        context.read<SignInBloc>().add(const SignInSubmitted());
                      }
                    : null,
                child: Text('Sign In'.toUpperCase(),
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: ratio * 40,
                        fontFamily: "Play")),
              ));
        });
  }
}
