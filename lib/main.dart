import 'package:flutter/material.dart';
import 'package:gamble/src/screens/home/home.dart';
import 'package:gamble/src/screens/master/views/master.dart';
import 'package:gamble/src/screens/users/authentications/authentication.dart';
import 'package:gamble/src/screens/users/profile/profile.dart';
import 'package:gamble/src/screens/users/profile/views/profile_change_password.dart';
import 'package:gamble/src/screens/users/profile/views/profile_edit.dart';
import 'package:gamble/src/screens/users/profile/views/profile_notification.dart';
import 'package:gamble/src/screens/users/profile/views/profile_security.dart';
import 'package:gamble/src/screens/users/signin/views/signin.dart';
import 'package:gamble/src/screens/users/signup/views/signup.dart';
import 'package:gamble/src/services/authentications/authentication_service.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  runApp(RepositoryProvider<AuthenticationService>(
    create: (context) {
      return FakeAuthenticationService();
    },
    // Injects the Authentication BLoC
    child: BlocProvider<AuthenticationBloc>(
      create: (context) {
        final authService =
            RepositoryProvider.of<AuthenticationService>(context);
        return AuthenticationBloc(authService)..add(AppLoaded());
      },
      child: const Gameble(),
    ),
  ));
}

class Gameble extends StatelessWidget {
  const Gameble({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(primarySwatch: Colors.blue, scaffoldBackgroundColor: Colors.white),
      home: //BlocBuilder<AuthenticationBloc, AuthenticationState>(
          //builder: (context, state) {
        //if (state is AuthenticationAuthenticated) {
          //return 
          //const ProfileSecurity(),
          const Master(index: 0,),
        //}
        //return const SignIn();
      //}),
      initialRoute: '/',
      routes: {
        '/signin': (context) => const SignIn(),
        '/signup': (context) => const SignUp(),
      },
    );
  }
}
 