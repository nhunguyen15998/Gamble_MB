import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gamble/src/screens/master/views/master.dart';
import 'package:gamble/src/screens/users/authentications/bloc/authentication_bloc.dart';
import 'package:gamble/src/screens/users/signin/signin.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gamble/src/screens/users/signup/bloc/signup_bloc.dart';
import 'package:gamble/src/services/authentication_service.dart';
import 'package:formz/formz.dart';

class SignIn extends StatelessWidget {
  const SignIn({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double ratio = size.width / size.height;

    final authenticationService =
        RepositoryProvider.of<AuthenticationService>(context);
    final authenticationBloc = BlocProvider.of<AuthenticationBloc>(context);

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: BlocBuilder<AuthenticationBloc, AuthenticationState>(
        builder: (context, state) {
          if(state is AuthenticationAuthenticated){
            return const Master(index: 0);
          }
          return BlocProvider(
            create: (context) => SignInBloc(authenticationBloc, authenticationService),
            child: BlocBuilder<SignInBloc, SignInState>(
              builder: (context, state) {
                if(state.status == FormzStatus.submissionInProgress){
                  return const Center(child: CircularProgressIndicator());
                }
                return const SignInBody();
              },
            )
          );
        }
      )
    );
  }
}

class SignInBody extends StatefulWidget {
  const SignInBody({super.key});

  @override
  State<SignInBody> createState() => _SignInBodyState();
}

class _SignInBodyState extends State<SignInBody> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double ratio = size.width / size.height;

    final authenticationService =
        RepositoryProvider.of<AuthenticationService>(context);
    final authenticationBloc = BlocProvider.of<AuthenticationBloc>(context);

    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.only(top: ratio * 200),
          width: size.width,
          height: size.height,
          decoration: BoxDecoration(
            color: Colors.purple,
            image: DecorationImage(
              image: const AssetImage("lib/assets/images/xyz-bg.png"),
              fit: BoxFit.cover,
              colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.6), BlendMode.dstATop))),
          child: BlocProvider(
            create: (context) => SignInBloc(authenticationBloc, authenticationService),
            child: Stack(
              children: <Widget>[
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Center(
                      child: Image.asset('lib/assets/images/logo.png'),
                    ),
                    SignInForm()
                  ]
                ),
              ],
            )
          )
        )
      )
    );
  }
}