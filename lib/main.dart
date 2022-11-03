import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:gamble/src/screens/blogs/views/blog_detail.dart';
import 'package:gamble/src/screens/blogs/views/blog_search.dart';
import 'package:gamble/src/screens/blogs/views/blogs_by_cate.dart';
import 'package:gamble/src/screens/home/home.dart';
import 'package:gamble/src/screens/master/views/master.dart';
import 'package:gamble/src/screens/users/authentications/authentication.dart';
import 'package:gamble/src/screens/users/profile/profile.dart';
import 'package:gamble/src/screens/users/profile_change_password/views/profile_change_password.dart';
import 'package:gamble/src/screens/users/profile_edit/views/profile_edit.dart';
import 'package:gamble/src/screens/users/profile_notification/views/profile_notification.dart';
import 'package:gamble/src/screens/users/profile_security/views/profile_security.dart';
import 'package:gamble/src/screens/users/signin/views/signin.dart';
import 'package:gamble/src/screens/users/signup/views/signup.dart';
import 'package:gamble/src/services/authentication_service.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_bloc/flutter_bloc.dart';


void main() async {
  await dotenv.load(fileName: ".env");
  runApp(RepositoryProvider<AuthenticationService>(
    create: (context) {
      return FakeAuthenticationService();
    },
    // Injects the Authentication BLoC
    child: BlocProvider<AuthenticationBloc>(
      create: (context) {
        final authService = RepositoryProvider.of<AuthenticationService>(context);
        return AuthenticationBloc(authService)..add(AppLoaded());
      },
      child: const Gamble(),
    ),
  ));
}

class Gamble extends StatelessWidget {
  const Gamble({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(primarySwatch: Colors.blue, scaffoldBackgroundColor: Colors.white),
      home: 
      BlocBuilder<AuthenticationBloc, AuthenticationState>(
          builder: (context, state) {
        if (state is AuthenticationAuthenticated) {
          return 
          //const BlogSearch(),
          const Master(index: 0);
        }
      return const SignIn();
      }),
      initialRoute: '/',
      routes: {
        '/signin': (context) => const SignIn(),
        '/signup': (context) => const SignUp(),
      },
    );
  }
}
 