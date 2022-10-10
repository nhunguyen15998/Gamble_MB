import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// ignore: depend_on_referenced_packages
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gamble/src/screens/users/signup/bloc/signup_bloc.dart';
// ignore: depend_on_referenced_packages
import 'package:formz/formz.dart';
import 'package:gamble/src/screens/users/signup/signup.dart';

class SignUpFormC extends StatelessWidget {
  const SignUpFormC({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double ratio = size.width / size.height;

    return Padding(
      padding: EdgeInsets.only(bottom: 18, top: size.height * 0.1),
      child: Container(
        height: size.height,
        width: double.infinity,
        margin: const EdgeInsets.all(10),
        decoration: BoxDecoration(color: Colors.white.withOpacity(0.0)),
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(bottom: 30),
                child: Text(
                  "Register".toUpperCase(),
                  style: const TextStyle(
                    fontFamily: "Play",
                    fontSize: 20,
                    color: Color.fromRGBO(255, 255, 255, 1),
                    fontWeight: FontWeight.w600
                  )
                )
              ),
              const SignUpPassword(),
              const SignUpConfirmedPassword(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: const <Widget>[
                  SignUpBtnBackC(),
                  SignUpButton()
                ],
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text("Already a member? ",
                      style: TextStyle(
                          fontFamily: "Play",
                          fontSize: ratio * 40,
                          color: const Color.fromRGBO(255, 255, 255, 1))),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, '/signin');
                    },
                    child: Text("Sign In",
                        style: TextStyle(
                            fontFamily: "Play",
                            fontSize: ratio * 40,
                            color: const Color.fromRGBO(233, 132, 41, 1))),
                  )
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 50),
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
        ),
      )
    );
  }
}

/* Password */
class SignUpPassword extends StatelessWidget {
  const SignUpPassword({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double ratio = size.width / size.height;
    return BlocBuilder<SignUpBloc, SignUpState>(
        buildWhen: (previous, current) =>
            previous.password != current.password ||
            previous.showPassword != current.showPassword,
        builder: (context, state) {
          return Padding(
          padding: const EdgeInsets.only(bottom: 20),
          child: TextField(
            key: const Key('SignUpFormC_passwordInput_passwordField'),
            obscureText: state.showPassword,
            style: const TextStyle(color: Color.fromRGBO(255, 255, 255, 1)),
            decoration: InputDecoration(
                labelText: 'Password',
                errorText:
                    state.password.invalid ? 'Please enter password!' : null,
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
                        .read<SignUpBloc>()
                        .add(SignUpShowPasswordChanged(state.showPassword));
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
                .read<SignUpBloc>()
                .add(SignUpPasswordChanged(password)))
          );
      }
    );
  }
}
/* End Password */

/* Password */
class SignUpConfirmedPassword extends StatelessWidget {
  const SignUpConfirmedPassword({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double ratio = size.width / size.height;
    return BlocBuilder<SignUpBloc, SignUpState>(
      buildWhen: (previous, current) =>
        previous.password != current.password ||
        previous.showPassword != current.showPassword,
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 20),
          child: TextField(
            key: const Key('SignUpFormC_confirmedPasswordInput_confirmedPasswordField'),
            obscureText: state.showPassword,
            style: const TextStyle(color: Color.fromRGBO(255, 255, 255, 1)),
            decoration: InputDecoration(
              labelText: 'Confirmation password',
              errorText: state.password.invalid ? 'Please enter confirmation password!' : null,
              labelStyle: TextStyle(
                fontSize: ratio * 35,
                color: const Color.fromRGBO(255, 255, 255, 1),
                fontFamily: "Play"),
              errorStyle: const TextStyle(color: Color.fromRGBO(255, 255, 255, 1)),
              contentPadding: const EdgeInsets.all(0),
              suffixIcon: GestureDetector(
                onTap: () {
                  context.read<SignUpBloc>()
                        .add(SignUpShowPasswordChanged(state.showPassword));
                },
                child: Icon(
                  state.showPassword ? FontAwesomeIcons.eye : FontAwesomeIcons.eyeSlash,
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
                  border: Border.all(color: const Color.fromRGBO(180, 67, 170, 1)),
                  borderRadius: const BorderRadius.all(Radius.circular(50))
                ),
                child: const Icon(FontAwesomeIcons.key, size: 18, color: Colors.white)
              ),
              border: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(50)),
                borderSide: BorderSide(
                color: Color.fromRGBO(210, 213, 252, 1), width: 1)
              ),
              focusedBorder: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(50)),
                borderSide: BorderSide(
                color: Color.fromRGBO(210, 213, 252, 1), width: 1)
              ),
              enabledBorder: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(50)),
                borderSide: BorderSide(
                color: Color.fromRGBO(210, 213, 252, 1), width: 1)
              ),
              errorBorder: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(50)),
                borderSide: BorderSide(
                color: Color.fromRGBO(218, 62, 59, 1), width: 1)
              ),
              focusedErrorBorder: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(50)),
                borderSide: BorderSide(
                color: Color.fromRGBO(218, 62, 59, 1), width: 1)
              )
            ),
            onChanged: (password) => context.read<SignUpBloc>()
                                            .add(SignUpPasswordChanged(password))
          )
        );
      }
    );
  }
}
/* End Password */

/* Btn back */
class SignUpBtnBackC extends StatelessWidget {
  const SignUpBtnBackC({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double ratio = size.width / size.height;
    return BlocBuilder<SignUpBloc, SignUpState>(
      buildWhen: (previous, current) => previous.status != current.status,
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.only(top: 30, bottom: 20),
          child: SizedBox(
            width: ratio * 300,
            height: ratio * 100,
            child: ElevatedButton(
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(
                      const Color.fromRGBO(233, 132, 41, 1)),
                  shape: MaterialStateProperty.all(RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(ratio * 50)))),
              key: const Key('SignUpFormC_continue_backBtn'),
              onPressed: 
                   () {
                      print("Click me");
                      Navigator.pop(context);
                    },
              child: Text('Back'.toUpperCase(),
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: ratio * 40,
                      fontFamily: "Play")),
            )
          )
        );
      }
    );
  }
}
/* Btn back */

/* Btn Sign Up */
class SignUpButton extends StatelessWidget {
  const SignUpButton({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double ratio = size.width / size.height;
    return BlocBuilder<SignUpBloc, SignUpState>(
      buildWhen: (previous, current) => previous.status != current.status,
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.only(top: 30, bottom: 20),
          child: SizedBox(
            width: ratio * 300,
            height: ratio * 100,
            child: ElevatedButton(
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(
                      const Color.fromRGBO(233, 132, 41, 1)),
                  shape: MaterialStateProperty.all(RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(ratio * 50)))),
              key: const Key('SignUpFormC_continue_raisedButton'),
              onPressed: state.status == FormzStatus.valid
                  ? () {
                      print("Click me");
                      context.read<SignUpBloc>().add(const SignUpSubmitted());
                    }
                  : null,
              child: Text('Sign Up'.toUpperCase(),
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: ratio * 40,
                      fontFamily: "Play")),
            )
          )
        );
      }
    );
  }
}
/* Btn Sign Up */
