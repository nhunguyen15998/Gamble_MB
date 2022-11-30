import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gamble/src/screens/master/views/master.dart';
import 'package:gamble/src/screens/users/authentications/bloc/authentication_bloc.dart';
import 'package:gamble/src/screens/users/signup/signup.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gamble/src/services/authentication_service.dart';
import 'package:formz/formz.dart';
import 'package:gamble/src/screens/users/signin/views/signin_page.dart';

class SignUp extends StatelessWidget {
  const SignUp({Key? key}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double ratio = size.width / size.height;
    final authenticationService = RepositoryProvider.of<AuthenticationService>(context);
    final authenticationBloc = BlocProvider.of<AuthenticationBloc>(context);

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: BlocBuilder<AuthenticationBloc, AuthenticationState>(
        builder: (context, state) {
          if(state is AuthenticationNotAuthenticated){
            return const SignIn();
          }
          return BlocProvider(
            create: (context) => SignUpBloc(authenticationService, authenticationBloc),
            child: BlocBuilder<SignUpBloc, SignUpState>(
              builder: (context, state) {
                if(state.status == FormzStatus.submissionInProgress){
                  return const Center(child: CircularProgressIndicator());
                }
                return const SignUpBody();
              },
            )
          );
        }
      )
    );
  }
}

class SignUpBody extends StatelessWidget {
  const SignUpBody({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double ratio = size.width / size.height;

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
              colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.6), BlendMode.dstATop)
            )
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Center(
                child: Image.asset('lib/assets/images/logo.png'),
              ),
              BlocBuilder<SignUpBloc, SignUpState>(
                buildWhen: (previous, current) => previous.step != current.step,
                builder: (context, state) {
                  Widget component = const SignUpFormA();
                  if (state.step == 1){
                    component = const SignUpFormA();
                  } else if(state.step == 2) {
                    component = const SignUpFormB();
                  } else {
                    component = const SignUpFormC();
                  }
                  return component;
                }
              )
            ]
          )
        )
        
      ),
    );
  }
}

