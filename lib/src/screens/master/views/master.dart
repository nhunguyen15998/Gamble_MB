import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gamble/src/screens/blogs/blog.dart';
import 'package:gamble/src/screens/blogs/views/blog.dart';
import 'package:gamble/src/screens/blogs/views/blog_search.dart';
import 'package:gamble/src/screens/games/views/game.dart';
import 'package:gamble/src/screens/home/home.dart';
import 'package:gamble/src/screens/master/master.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gamble/src/screens/users/authentications/authentication.dart';
import 'package:gamble/src/screens/users/profile/profile.dart';
import 'package:gamble/src/screens/users/profile_notification/views/profile_notification.dart';
import 'package:gamble/src/screens/users/signin/views/signin_page.dart';
import 'package:gamble/src/services/authentication_service.dart';

class Master extends StatefulWidget {
  const Master({Key? key, required this.index}) : super(key:key);

  final int index;
  @override
  State<Master> createState() => _MasterState();
}

class _MasterState extends State<Master> {
  final GlobalKey<ScaffoldState> _key = GlobalKey();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double ratio = size.width / size.height;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      // child: BlocProvider<AuthenticationBloc>(
      //   create: (context) {
      //     final authenticationService = FakeAuthenticationService();
      //     var authenticationBloc = AuthenticationBloc(authenticationService);
      //     return authenticationBloc;
      //   },
        child: BlocBuilder<AuthenticationBloc, AuthenticationState>(
          builder: (context, state) {
            print(state);
            if(state is AuthenticationNotAuthenticated){
              return const SignIn();
            }
            return BlocProvider(
              create: (context) =>  MasterBloc()..add(PageIndexChanged(widget.index)),
              // create: (ctx) {
              //   var master = MasterBloc();
              //   master.add(PageIndexChanged(widget.index));
              //   return master;
              // },
              child: Scaffold(
                key: _key,
                appBar: AppBar(
                  leading: IconButton(
                    focusColor: const Color.fromRGBO(250, 0, 159, 1),
                    icon: const Icon(FontAwesomeIcons.bars),
                    onPressed: () {
                      _key.currentState?.openDrawer();
                    },
                  ),
                  title: BlocBuilder<MasterBloc, MasterState>(
                    buildWhen: (previous, current) => previous.pageIndex != current.pageIndex,
                    builder: (context, state) {
                      if(state.pageIndex == 1){
                        return const SizedBox();
                      } else {
                        return Image.asset('lib/assets/images/logo.png', height: size.height * 0.03);
                      }
                    },
                  ),
                  backgroundColor: const Color.fromRGBO(62, 29, 117, 1),
                  actions: <Widget>[
                    BlocBuilder<MasterBloc, MasterState>(
                      buildWhen: (previous, current) => previous.pageIndex != current.pageIndex,
                      builder: (context, state) {
                        if(state.pageIndex == 1){
                          return const BlogSearchIconButton();
                        } else {
                          return const SizedBox();
                        }
                      },
                    ),
                    IconButton(
                      focusColor: const Color.fromRGBO(250, 0, 159, 1),
                      icon: const Icon(Icons.notifications),
                      onPressed: () {
                        Navigator.push(context, 
                          MaterialPageRoute(builder: ((context) {
                            return const ProfileNotification();
                          }))
                        );
                      },
                    ),
                  ],
                ),
                drawer: Drawer(
                  child: ListView(
                    padding: EdgeInsets.zero,
                    children: [
                      DrawerHeader(
                        decoration: const BoxDecoration(
                          color: Color.fromARGB(255, 79, 13, 117),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // Image.asset('lib/assets/images/bitcoin.png', width: ratio*150),
                            // Expanded(
                            //   child: Column(
                            //     mainAxisAlignment: MainAxisAlignment.center,
                            //     children: [
                            //       Padding(
                            //         padding: EdgeInsets.symmetric(vertical: ratio*10),
                            //         child: Text('Name',
                            //           style: TextStyle(
                            //             fontFamily: 'Play',
                            //             fontSize: ratio*30,
                            //             color: Colors.white
                            //           ),
                            //         )
                            //       ),
                            //       Padding(
                            //         padding: EdgeInsets.symmetric(vertical: ratio*10),
                            //         child: Text('Name',
                            //           style: TextStyle(
                            //             fontFamily: 'Play',
                            //             fontSize: ratio*30,
                            //             color: Colors.white
                            //           ),
                            //         )
                            //       ),
                            //       Padding(
                            //         padding: EdgeInsets.symmetric(vertical: ratio*10),
                            //         child: Text('Name',
                            //           style: TextStyle(
                            //             fontFamily: 'Play',
                            //             fontSize: ratio*30,
                            //             color: Colors.white
                            //           ),
                            //         )
                            //       ),
                            //     ],
                            //   )
                            // )
                          ],
                        )
                      ),
                      BlocBuilder<AuthenticationBloc, AuthenticationState>(
                        builder: (context, state) {
                          return ListTile(
                            trailing: const Icon(Icons.logout),
                            title: Text('Sign out',
                              style: TextStyle(
                                fontFamily: 'Play',
                                fontSize: ratio*40
                              ),
                            ),
                            onTap: () {
                              context.read<AuthenticationBloc>().add(UserLoggedOut());
                            },
                          );
                        },
                      ),
                    ],
                  ),
                ),
                body: Container(
                  width: size.width,
                  height: size.height,
                  color: Colors.blueAccent,
                  child: BlocBuilder<MasterBloc, MasterState>(
                    buildWhen: (previous, current) => previous.pageIndex != current.pageIndex,
                    builder: (context, state) {
                      Widget component = const Home();
                      var index = state.pageIndex;
                      switch (index) {
                        case 0:
                          component = const Home();
                          break;
                        case 1:
                          component = const Blogs();
                          break;
                        case 2:
                          component = const Games();
                          break;
                        case 3:
                          component = const UserProfile();
                          break;
                      }
                      return component;// Text(state.pageIndex.toString());
                    },
                  ),
                ),
                bottomNavigationBar: BlocBuilder<MasterBloc, MasterState>(
                  buildWhen: (previous, current) => previous.pageIndex != current.pageIndex,
                  builder: (context, state) {
                    Color backgroundColor = const Color.fromRGBO(31, 6, 68, 1);
                    Color color = Colors.white;
                    Color iconColor = const Color.fromRGBO(62, 29, 117, 1);
                    switch (state.pageIndex) {
                      case 0:
                      case 2:
                      case 3:
                        break;
                      case 1:
                        backgroundColor = const Color.fromARGB(255, 236, 238, 250);
                        color = const Color.fromRGBO(31, 6, 68, 1);
                        iconColor = Colors.white;
                        break;
                    }
                    return CurvedNavigationBar(
                      index: state.pageIndex,
                      onTap: (int index){
                        context.read<MasterBloc>().add(PageIndexChanged(index));
                      },
                      backgroundColor: backgroundColor,
                      color: color,
                      items: [
                        Icon(Icons.home, size: 30, color: iconColor),
                        Icon(Icons.newspaper, size: 30, color: iconColor),
                        Icon(Icons.gamepad_sharp, size: 30, color: iconColor),
                        Icon(Icons.person, size: 30, color: iconColor)
                      ],
                    );
                  },
                )
              )
            );
          }
        )
      //)
    );
  }
}