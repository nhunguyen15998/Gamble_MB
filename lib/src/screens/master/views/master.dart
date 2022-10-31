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
import 'package:gamble/src/screens/users/profile/profile.dart';

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
      child: BlocProvider(
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
                  
                },
              ),
            ],
          ),
          drawer: Drawer(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                const DrawerHeader(
                  decoration: BoxDecoration(
                    color: Colors.blue,
                  ),
                  child: Text('Drawer Header'),
                ),
                ListTile(
                  title: const Text('Item 1'),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  title: const Text('Item 2'),
                  onTap: () {
                    Navigator.pop(context);
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
                    component = const Profile();
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
      )
    );
  }
}