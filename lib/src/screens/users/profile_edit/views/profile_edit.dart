import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:gamble/src/screens/users/profile/views/profile.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gamble/src/screens/users/profile_edit/bloc/profile_edit_bloc.dart';
import 'package:gamble/src/screens/users/profile_edit_info/views/profile_edit_info.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gamble/src/services/profile_service.dart';

class ProfileEdit extends StatefulWidget {
  const ProfileEdit({Key? key}) : super(key: key);

  @override
  State<ProfileEdit> createState() => _ProfileEditState();
}

class _ProfileEditState extends State<ProfileEdit> {
  
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double ratio = size.width / size.height;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: RepositoryProvider(
        create: (context) => ProfileManagement(),
        child: BlocProvider(
          create: (context) => ProfileEditBloc(RepositoryProvider.of<ProfileManagement>(context))..add(ProfileEditInitial()),
          child: Scaffold(
            appBar: AppBar(
              leading: IconButton(
                focusColor: const Color.fromRGBO(250, 0, 159, 1),
                icon: const Icon(FontAwesomeIcons.chevronLeft),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              centerTitle: true,
              title: Text('Edit Profile', 
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'Play',
                  fontSize: ratio*40
                ),
              ),
              backgroundColor: const Color.fromRGBO(62, 29, 117, 1),
              
            ),
            backgroundColor: const Color.fromRGBO(31, 6, 68, 1),
            body: const ProfileEditBody()
          ),
        ),
      )
    );
  }
}

class ProfileEditBody extends StatefulWidget {
  const ProfileEditBody({super.key});

  @override
  State<ProfileEditBody> createState() => _ProfileEditBodyState();
}

class _ProfileEditBodyState extends State<ProfileEditBody> {

  late ProfileEditBloc profileEditBloc;

  Future<void> onRefresh() async {
    profileEditBloc.add(ProfileEditInitial());
  }

  @override
  void initState() {
    super.initState();
    profileEditBloc = context.read<ProfileEditBloc>(); 
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double ratio = size.width / size.height;
    
    return RefreshIndicator(
      onRefresh: onRefresh,
      child: SingleChildScrollView(
        child: Column(
          children: [
            ProfileEditHeaderTitle(headerTitle: 'Profile picture'),
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: Container(
                margin: EdgeInsets.only(bottom: ratio),
                child: ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(ratio*320)),
                  child: BlocBuilder<ProfileEditBloc, ProfileEditState>(
                    builder: (context, state) {
                      if(state is ProfileEditLoaded){
                        String thumbnail = state.thumbnail.isNotEmpty ? dotenv.env['HOST']!+state.thumbnail : '${dotenv.env['HOST']!}images/defaults/section-bg.jpg';
                        return Image.network(thumbnail, height: ratio*250, width: ratio*250, fit: BoxFit.cover);
                      }
                      return const CircularProgressIndicator();
                    },
                  )
                ),
              ),
            ),
            ProfileEditHeaderTitle(headerTitle: 'Cover photo'),
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: Container(
                margin: EdgeInsets.only(bottom: ratio),
                child: ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(ratio*50)),
                  child: BlocBuilder<ProfileEditBloc, ProfileEditState>(
                    builder: (context, state) {
                      if(state is ProfileEditLoaded){
                        String wallpaper = state.wallpaper.isNotEmpty ? dotenv.env['HOST']!+state.wallpaper : '${dotenv.env['HOST']!}images/defaults/section-bg.jpg';
                        return Image.network(wallpaper, fit: BoxFit.cover);
                      }
                      return const CircularProgressIndicator();
                    },
                  )
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 30, bottom: 20, left: 20, right: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Account information',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: ratio*45,
                      fontFamily: 'Play',
                      fontWeight: FontWeight.bold
                    ),
                  ),
                  TextButton(
                    onPressed: () => {
                      Navigator.push(context, 
                        MaterialPageRoute(builder: ((context) {
                          return ProfileEditInfo();
                        }))
                      )
                    },
                    child: const Text('Edit',
                      style: TextStyle(
                        color: Color.fromRGBO(250, 0, 159, 1),
                        fontFamily: 'Play',
                      )
                    )
                  )
                ],
              )
            ),
            BlocBuilder<ProfileEditBloc, ProfileEditState>(
              builder: (context, state) {
                if(state is ProfileEditLoaded){
                  return Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 20, left: 20, right: 20),
                        child: SizedBox(
                          height: ratio*100,
                          width: double.infinity,
                          child: Row(
                            children: [
                              SizedBox(
                                width: ratio*230,
                                child: Text('First name',
                                  style: TextStyle(
                                    fontFamily: 'Play', 
                                    fontSize: ratio*35,
                                    color: Colors.white
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Text(state.firstName,
                                  style: TextStyle(
                                    fontFamily: 'Play', 
                                    fontSize: ratio*35,
                                    color: Colors.white
                                  ),
                                )
                              )
                            ],
                          )
                        )
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 20, left: 20, right: 20),
                        child: SizedBox(
                          height: ratio*100,
                          width: double.infinity,
                          child: Row(
                            children: [
                              SizedBox(
                                width: ratio*230,
                                child: Text('Last name',
                                  style: TextStyle(
                                    fontFamily: 'Play', 
                                    fontSize: ratio*35,
                                    color: Colors.white
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Text(state.lastName,
                                  style: TextStyle(
                                    fontFamily: 'Play', 
                                    fontSize: ratio*35,
                                    color: Colors.white
                                  ),
                                )
                              )
                            ],
                          )
                        )
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 20, left: 20, right: 20),
                        child: SizedBox(
                          height: ratio*100,
                          width: double.infinity,
                          child: Row(
                            children: [
                              SizedBox(
                                width: ratio*230,
                                child: Text('Phone',
                                  style: TextStyle(
                                    fontFamily: 'Play', 
                                    fontSize: ratio*35,
                                    color: Colors.white
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Text(state.phone,
                                  style: TextStyle(
                                    fontFamily: 'Play', 
                                    fontSize: ratio*35,
                                    color: Colors.white
                                  ),
                                )
                              )
                            ],
                          )
                        )
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 20, left: 20, right: 20),
                        child: SizedBox(
                          height: ratio*100,
                          width: double.infinity,
                          child: Row(
                            children: [
                              SizedBox(
                                width: ratio*230,
                                child: Text('Email',
                                  style: TextStyle(
                                    fontFamily: 'Play', 
                                    fontSize: ratio*35,
                                    color: Colors.white
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Text(state.email,
                                  style: TextStyle(
                                    fontFamily: 'Play', 
                                    fontSize: ratio*35,
                                    color: Colors.white
                                  ),
                                )
                              )
                            ],
                          )
                        )
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 20, left: 20, right: 20),
                        child: SizedBox(
                          height: ratio*100,
                          width: double.infinity,
                          child: Row(
                            children: [
                              SizedBox(
                                width: ratio*230,
                                child: Text('Birth',
                                  style: TextStyle(
                                    fontFamily: 'Play', 
                                    fontSize: ratio*35,
                                    color: Colors.white
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Text(state.birth,
                                  style: TextStyle(
                                    fontFamily: 'Play', 
                                    fontSize: ratio*35,
                                    color: Colors.white
                                  ),
                                )
                              )
                            ],
                          )
                        )
                      )
                    ],
                  );
                }
                return const CircularProgressIndicator();
              },
            )
          ],
        ),
      )
    );
  }
}

class ProfileEditHeaderTitle extends StatefulWidget {
  ProfileEditHeaderTitle({Key? key, required this.headerTitle}):super(key: key);

  String headerTitle;

  @override
  State<ProfileEditHeaderTitle> createState() => _ProfileEditHeaderTitleState();
}

class _ProfileEditHeaderTitleState extends State<ProfileEditHeaderTitle> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double ratio = size.width / size.height;
    final headerTitle = widget.headerTitle;

    return Padding(
      padding: const EdgeInsets.only(top: 20, bottom: 20, left: 20, right: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(headerTitle,
            style: TextStyle(
              color: Colors.white,
              fontSize: ratio*45,
              fontFamily: 'Play',
              fontWeight: FontWeight.bold
            ),
          ),
          TextButton(
            onPressed: () => showDialog<String>(
              context: context,
              builder: (BuildContext context) => AlertDialog(
                title: const Text('Select image'),
                content: SizedBox(
                  height: ratio*250,
                  width: size.width,
                  child: Column(
                    children: [
                      Container(
                        height: ratio*100,
                        width: size.width*0.5,
                        margin: EdgeInsets.only(bottom: ratio*50),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(ratio*50)),
                          color: const Color.fromRGBO(62, 29, 117, 1),
                        ),
                        child: TextButton(
                          onPressed: () async {
                            Navigator.pop(context);
                            //image = await picker.pickImage(source: ImageSource.gallery); 
                            // setState(() {
                            //   //update UI
                            // });
                          }, 
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding: EdgeInsets.only(right: ratio*30),
                                child: Icon(FontAwesomeIcons.images, color: Colors.white, size: ratio*40),
                              ),
                              Text('From gallery',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: ratio * 35,
                                  fontFamily: "Play"
                                )
                              )
                            ],
                          )
                        )
                      ),
                      Container(
                        height: ratio*100,
                        width: size.width*0.5,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(ratio*50)),
                          color: const Color.fromRGBO(62, 29, 117, 1),
                        ),
                        child: TextButton(
                          onPressed: () async {
                            Navigator.pop(context);
                            // image = await picker.pickImage(source: ImageSource.camera); 
                            // setState(() {
                            //   //update UI
                            // });
                          }, 
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding: EdgeInsets.only(right: ratio*30),
                                child: Icon(FontAwesomeIcons.camera, color: Colors.white, size: ratio*40),
                              ),
                              Text('From camera',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: ratio * 35,
                                  fontFamily: "Play"
                                )
                              )
                            ],
                          )
                        )
                      )
                    ],
                  )
                ),
                actions: <Widget>[
                  TextButton(
                    onPressed: () => Navigator.pop(context, 'Cancel'),
                    child: const Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: () => Navigator.pop(context, 'OK'),
                    child: const Text('OK'),
                  ),
                ],
              )
            ),
            child: const Text('Edit',
              style: TextStyle(
                color: Color.fromRGBO(250, 0, 159, 1),
                fontFamily: 'Play',
              )
            )
          )
        ],
      )
    );
  }
}