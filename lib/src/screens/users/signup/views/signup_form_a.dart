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

class SignUpFormA extends StatelessWidget {
  const SignUpFormA({Key? key}) : super(key: key);

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
              const SignUpFirstName(),
              const SignUpLastName(),
              const SignUpBtnNextA(),
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

/* First name */
class SignUpFirstName extends StatelessWidget {
  const SignUpFirstName({super.key});
  
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double ratio = size.width / size.height;
    return BlocBuilder<SignUpBloc, SignUpState>(
      buildWhen: (previous, current) => previous.firstName != current.firstName,
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 30),
          child: TextField(
            key: const Key('SignUpFormA_firstNameInput_firstNameField'),
            keyboardType: TextInputType.text,
            style: const TextStyle(color: Color.fromRGBO(255, 255, 255, 1)),
            decoration: InputDecoration(
              labelText: 'First name',
              labelStyle: TextStyle(
                fontSize: ratio * 35,
                color: const Color.fromRGBO(255, 255, 255, 1),
                fontFamily: "Play"
              ),
              errorText: state.firstName.invalid ? '' : null,
              errorStyle: const TextStyle(color: Color.fromRGBO(255, 255, 255, 1)),
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
                  borderRadius: const BorderRadius.all(Radius.circular(50)),
                ),
                child: const Icon(Icons.abc, size: 23, color: Colors.white)
              ),
              focusedBorder: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(50)),
                borderSide: BorderSide(color: Color.fromRGBO(210, 213, 252, 1), width: 1)
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
            onChanged: (firstName) =>
              context.read<SignUpBloc>().add(SignUpFirstNameChanged(firstName))
          )
        );
      }
    );
  }
}
/* End first name */

/* Last name */
class SignUpLastName extends StatelessWidget {
  const SignUpLastName({super.key});
  
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double ratio = size.width / size.height;
    return BlocBuilder<SignUpBloc, SignUpState>(
      buildWhen: (previous, current) => previous.lastName != current.lastName,
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 20),
          child: TextField(
            key: const Key('SignUpFormA_lastNameInput_lastNameField'),
            keyboardType: TextInputType.text,
            style: const TextStyle(color: Color.fromRGBO(255, 255, 255, 1)),
            decoration: InputDecoration(
              labelText: 'Last name',
              labelStyle: TextStyle(
                fontSize: ratio * 35,
                color: const Color.fromRGBO(255, 255, 255, 1),
                fontFamily: "Play"
              ),
              errorText: state.lastName.invalid ? '' : null,
              errorStyle: const TextStyle(color: Color.fromRGBO(255, 255, 255, 1)),
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
                  borderRadius: const BorderRadius.all(Radius.circular(50)),
                ),
                child: const Icon(Icons.abc, size: 18, color: Colors.white)
              ),
              focusedBorder: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(50)),
                borderSide: BorderSide(color: Color.fromRGBO(210, 213, 252, 1), width: 1)
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
            onChanged: (lastName) =>
              context.read<SignUpBloc>().add(SignUpLastNameChanged(lastName))
          )
        );
      }
    );
  }
}
/* End last name */

/* Btn next */
class SignUpBtnNextA extends StatelessWidget {
  const SignUpBtnNextA({super.key});

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
              key: const Key('SignUpFormA_continue_nextBtn'),
              onPressed: state.status == FormzStatus.valid
                  ? () {
                      print("Click me");
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const SignUp(type: 2)));           
                    }
                  : null,
              child: Text('Next'.toUpperCase(),
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
/* Btn next */
