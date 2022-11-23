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

class SignUpFormB extends StatelessWidget {
  const SignUpFormB({Key? key}) : super(key: key);

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
          child: BlocBuilder<SignUpBloc, SignUpState>(
            builder: (context, state) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Text(
                    "Register".toUpperCase(),
                    style: const TextStyle(
                      fontFamily: "Play",
                      fontSize: 20,
                      color: Color.fromRGBO(255, 255, 255, 1),
                      fontWeight: FontWeight.w600
                    )
                  ),
                  SignUpPhoneInput(value: state.phone.valid ? state.phone.value : null),
                  SignUpEmailInput(value: state.email.valid ? state.email.value : null),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      //btn back
                      BlocBuilder<SignUpBloc, SignUpState>(
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
                                key: const Key('SignUpFormB_continue_backBtn'),
                                onPressed: state.status == FormzStatus.valid ?
                                  () {
                                      context.read<SignUpBloc>().add(const SignUpStepChanged(1));
                                    } : null,
                                child: Text('Back'.toUpperCase(),
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: ratio * 40,
                                        fontFamily: "Play")),
                              )
                            )
                          );
                        }
                      ),
                      //btn next
                      BlocBuilder<SignUpBloc, SignUpState>(
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
                                key: const Key('SignUpFormB_continue_nextBtn'),
                                onPressed: state.status == FormzStatus.valid ?
                                  () {
                                    context.read<SignUpBloc>().add(const SignUpStepChanged(3));
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
                      )
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
              );
            } 
          )
        ),
      )
    );
  }
}

/* Phone */
class SignUpPhoneInput extends StatefulWidget {
  SignUpPhoneInput({Key? key, required this.value}):super(key: key);
  String? value;
  @override
  State<SignUpPhoneInput> createState() => _SignUpPhoneInputState();
}

class _SignUpPhoneInputState extends State<SignUpPhoneInput> {
  TextEditingController controller = TextEditingController();
  @override
  void initState() {
    super.initState();
    controller = TextEditingController(text: widget.value ?? "");
  }
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double ratio = size.width / size.height;
    return BlocBuilder<SignUpBloc, SignUpState>(
      buildWhen: (previous, current) => previous.phone != current.phone,
      builder: (context, state) {
        return TextField(
          controller: controller,
          key: const Key('SignUpFormB_phoneInput_phoneField'),
          keyboardType: TextInputType.phone,
          style: const TextStyle(color: Color.fromRGBO(255, 255, 255, 1)),
          decoration: InputDecoration(
            labelText: 'Phone number',
            errorText:state.phone.invalid ? 'Phone number is required' : null,
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
              context.read<SignUpBloc>().add(SignUpPhoneChanged(phone))
          
        );
      }
    );
  }
}

class SignUpPhone extends StatelessWidget {
  const SignUpPhone({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double ratio = size.width / size.height;
    return BlocBuilder<SignUpBloc, SignUpState>(
      buildWhen: (previous, current) => previous.phone != current.phone,
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 20),
          child: TextField(
          key: const Key('SignUpFormB_phoneInput_phoneField'),
          keyboardType: TextInputType.phone,
          style: const TextStyle(color: Color.fromRGBO(255, 255, 255, 1)),
          decoration: InputDecoration(
            labelText: 'Phone number',
            errorText:state.phone.invalid ? 'Phone number is required' : null,
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
              context.read<SignUpBloc>().add(SignUpPhoneChanged(phone))
          )
        );
      }
    );
  }
}
/* End phone */

/* Email */
class SignUpEmailInput extends StatefulWidget {
  SignUpEmailInput({Key? key, required this.value}):super(key: key);
  String? value;
  @override
  State<SignUpEmailInput> createState() => _SignUpEmailInputState();
}

class _SignUpEmailInputState extends State<SignUpEmailInput> {
  TextEditingController controller = TextEditingController();
  @override
  void initState() {
    super.initState();
    controller = TextEditingController(text: widget.value ?? "");
  }
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double ratio = size.width / size.height;
    return BlocBuilder<SignUpBloc, SignUpState>(
      buildWhen: (previous, current) => previous.email != current.email,
      builder: (context, state) {
        return TextField(
          controller: controller,
          key: const Key('SignUpFormB_emailInput_emailField'),
          keyboardType: TextInputType.text,
          style: const TextStyle(color: Color.fromRGBO(255, 255, 255, 1)),
          decoration: InputDecoration(
            labelText: 'Email',
            labelStyle: TextStyle(
              fontSize: ratio * 35,
              color: const Color.fromRGBO(255, 255, 255, 1),
              fontFamily: "Play"
            ),
            errorText: state.email.invalid ? 'Email is required' : null,
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
              child: const Icon(FontAwesomeIcons.envelope,
              size: 18, color: Colors.white)
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
          onChanged: (email) =>
            context.read<SignUpBloc>().add(SignUpEmailChanged(email))
        );
      }
    );
  }
}

class SignUpEmail extends StatelessWidget {
  const SignUpEmail({super.key});
  
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double ratio = size.width / size.height;
    return BlocBuilder<SignUpBloc, SignUpState>(
      buildWhen: (previous, current) => previous.email != current.email,
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 20),
          child: TextField(
            key: const Key('SignUpFormB_emailInput_emailField'),
            keyboardType: TextInputType.text,
            style: const TextStyle(color: Color.fromRGBO(255, 255, 255, 1)),
            decoration: InputDecoration(
              labelText: 'Email',
              labelStyle: TextStyle(
                fontSize: ratio * 35,
                color: const Color.fromRGBO(255, 255, 255, 1),
                fontFamily: "Play"
              ),
              errorText: state.email.invalid ? 'Email is required' : null,
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
                child: const Icon(FontAwesomeIcons.envelope,
                size: 18, color: Colors.white)
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
            onChanged: (email) =>
              context.read<SignUpBloc>().add(SignUpEmailChanged(email))
          )
        );
      }
    );
  }
}
/* End email */

/* Btn back */
class SignUpBtnBackB extends StatelessWidget {
  const SignUpBtnBackB({super.key});

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
              key: const Key('SignUpFormB_continue_backBtn'),
              onPressed: 
                () {
                    context.read<SignUpBloc>().add(const SignUpStepChanged(1));
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

/* Btn next */
class SignUpBtnNextB extends StatelessWidget {
  const SignUpBtnNextB({super.key});

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
              key: const Key('SignUpFormB_continue_nextBtn'),
              onPressed: state.status == FormzStatus.valid ?
                () {
                  print("Click me");
                  context.read<SignUpBloc>().add(const SignUpStepChanged(3));
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
