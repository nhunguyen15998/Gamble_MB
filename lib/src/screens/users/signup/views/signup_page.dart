import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gamble/src/screens/users/authentications/bloc/authentication_bloc.dart';
import 'package:gamble/src/screens/users/signup/signup.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gamble/src/services/authentications/authentication_service.dart';

class SignUp extends StatelessWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double ratio = size.width / size.height;

    final authenticationService =
        RepositoryProvider.of<AuthenticationService>(context);
    final authenticationBloc = BlocProvider.of<AuthenticationBloc>(context);

    return AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: Scaffold(
            body: SingleChildScrollView(
                child: Container(
                    padding: EdgeInsets.only(top: ratio * 300),
                    width: size.width,
                    height: size.height,
                    decoration: BoxDecoration(
                        color: Colors.purple,
                        image: DecorationImage(
                            image: const AssetImage(
                                "lib/assets/images/xyz-bg.png"),
                            fit: BoxFit.cover,
                            colorFilter: ColorFilter.mode(
                                Colors.black.withOpacity(0.6),
                                BlendMode.dstATop))),
                    child: BlocProvider(
                        create: (context) => SignUpBloc(
                            authenticationBloc, authenticationService),
                        child: Stack(
                          children: <Widget>[
                            Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Center(
                                    child: Image.asset(
                                        'lib/assets/images/logo.png'),
                                  ),
                                  SignUpForm()
                                ]),
                          ],
                        ))))));
  }
}
