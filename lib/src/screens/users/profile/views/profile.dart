import 'dart:io';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gamble/src/screens/users/profile/bloc/profile_bloc.dart';
import 'package:gamble/src/screens/users/profile_change_password/views/profile_change_password.dart';
import 'package:gamble/src/screens/users/profile_edit/views/profile_edit.dart';
import 'package:gamble/src/screens/users/profile_security/views/profile_security.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gamble/src/screens/users/wallet_deposit/views/wallet_deposit.dart';
import 'package:gamble/src/screens/users/wallet_transaction/views/wallet_transaction.dart';
import 'package:gamble/src/screens/users/wallet_transfer/views/wallet_transfer.dart';
import 'package:gamble/src/screens/users/wallet_withdraw/views/wallet_withdraw.dart';
import 'package:gamble/src/services/profile_service.dart';
import 'package:image_picker/image_picker.dart';

// import 'package:image_picker/image_picker.dart';

//UserProfile:menu edit, security(2 step verification, setting), change pass, log out, noti

class UserProfile extends StatefulWidget {
  const UserProfile({Key? key}) : super(key: key);

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> with TickerProviderStateMixin{
  List<IconData> icons = [
    Icons.cloud_outlined,
    Icons.beach_access_sharp,
    Icons.brightness_5_sharp
  ];

  ImagePicker picker = ImagePicker();
  XFile? image;
  File? imageFile;
  /// Get from gallery
  getFromGallery() async {
    XFile? pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      maxWidth: 1800,
      maxHeight: 1800,
    );
    if (pickedFile != null) {
      imageFile = File(pickedFile.path);
    }
  }
  /// Get from Camera
  getFromCamera() async {
    XFile? pickedFile = await ImagePicker().pickImage(
      source: ImageSource.camera,
      maxWidth: 1800,
      maxHeight: 1800,
    );
    if (pickedFile != null) {
      setState(() {
        imageFile = File(pickedFile.path);
      });
    }
  }
  
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double ratio = size.width / size.height;

    int selectedTab = 0;
    final TabController tabController = TabController(length: 3, vsync: this);

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: RepositoryProvider(
        create: (context) => ProfileManagement(),
        child: BlocProvider(
          create: (context) => ProfileBloc(RepositoryProvider.of<ProfileManagement>(context))..add(ProfileInitial()),
          child: Scaffold(
            backgroundColor: const Color.fromRGBO(31, 6, 68, 1),
            body: Column(
              children: <Widget>[
                BlocBuilder<ProfileBloc, ProfileState>(
                  builder: (context, state) {
                    if(state is ProfileLoaded){
                      String wallpaper = state.wallpaper.isNotEmpty ? dotenv.env['HOST']!+state.wallpaper : '${dotenv.env['HOST']!}images/defaults/section-bg.jpg';
                      return SizedBox(
                        height: size.height*0.38,
                        width: size.width,
                        //WALLPAPER
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              alignment: Alignment.topCenter,
                              image: NetworkImage(wallpaper),
                              fit: BoxFit.fitWidth
                            ),
                          ),
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  //AVATAR
                                  Container(
                                    margin: EdgeInsets.only(bottom: ratio),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.all(Radius.circular(ratio*320)),
                                      child: Image.network(dotenv.env['HOST']!+state.thumbnail, height: ratio*320, width: ratio*320, fit: BoxFit.cover),
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.symmetric(vertical: ratio*45, horizontal: ratio*45),
                                    child: Text(state.name,
                                      textAlign: TextAlign.left,
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                      style: TextStyle(
                                        fontFamily: "Play",
                                        fontSize: ratio * 50,
                                        fontWeight: FontWeight.w300,
                                        color: Colors.white
                                      )
                                    ),
                                  )
                                ],
                              ),
                              //UPLOAD AVATAR
                              Positioned(
                                bottom: ratio*150,
                                right: ratio*250,
                                child: Container(
                                  height: ratio*70,
                                  width:  ratio*70,
                                  decoration: BoxDecoration(
                                    color: const Color.fromRGBO(250, 0, 159, 1),
                                    borderRadius: BorderRadius.all(Radius.circular(ratio*50)),
                                  ),
                                  child: IconButton(
                                    icon: Icon(FontAwesomeIcons.camera, size: ratio*30, color: Colors.white),
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
                                                    image = await picker.pickImage(source: ImageSource.gallery); 
                                                    setState(() {
                                                      print("abc");
                                                    });
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
                                  )
                                ),
                              )
                            ],
                          )
                        )
                      );
                    }
                    return const CircularProgressIndicator();
                  },
                ),
                //TABS
                SizedBox(
                  height: size.height*0.06,
                  width: size.width,
                  child: DecoratedBox(
                    decoration: const BoxDecoration(
                      color: Colors.transparent,
                      //color: Color.fromARGB(255, 105, 109, 179),
                    ),
                    child: TabBar(
                      controller: tabController,
                      indicatorColor: const Color.fromRGBO(250, 0, 159, 1),
                      onTap: (selectedTab) {
                        print("selectedTab: $selectedTab");
                      },
                      tabs: <Widget>[
                        Tab(
                          icon: Icon(Icons.person, 
                                    color: selectedTab == 0 ? 
                                    const Color.fromRGBO(250, 0, 159, 1) 
                                    : Colors.white),
                        ),
                        Tab(
                          icon: Icon(Icons.wallet, 
                                    color: selectedTab == 1 ? 
                                    const Color.fromRGBO(250, 0, 159, 1) 
                                    : Colors.white),
                        ),
                        Tab(
                          icon: Icon(Icons.people, 
                                    color: selectedTab == 2 ? 
                                    const Color.fromRGBO(250, 0, 159, 1) 
                                    : Colors.white),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: DecoratedBox(
                    decoration: const BoxDecoration(
                      color: Colors.transparent,
                    ),
                    child: TabBarView(
                      controller: tabController,
                      children: <Widget>[
                        //FORM1
                        SingleChildScrollView(
                          child: Column(
                            children: [
                              UserProfileTextButton(textLabel: 'Edit profile', view: const ProfileEdit(), icon: Icons.edit_note),
                              const UserProfileNotificationSwitch(),
                              UserProfileTextButton(textLabel: 'Security', view: const ProfileSecurity(), icon: Icons.security,),
                              UserProfileTextButton(textLabel: 'Change password', view: const ProfileChangePassword(), icon: Icons.key)
                            ],
                          )
                        ),
                        //FORM2
                        Padding(
                          padding: EdgeInsets.only(bottom: ratio*30),
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(vertical: 25),
                                  height: size.height*0.17,
                                  width: size.width,
                                  child: Column(
                                    children: [
                                      SizedBox(
                                        width: size.width,
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(right: 10),
                                              child: Icon(FontAwesomeIcons.scaleBalanced, color: Colors.white, size: ratio*40),
                                            ),
                                            Text('Balance', 
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: ratio*40,
                                                fontWeight: FontWeight.w200
                                              )
                                            )
                                          ],
                                        )
                                      ),
                                      Expanded(
                                        child: BlocBuilder<ProfileBloc, ProfileState>(
                                          builder: (context, state) {
                                            if(state is ProfileLoaded){
                                              return Text("\$${state.balance}", 
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: ratio*100,
                                                  fontWeight: FontWeight.w200
                                                )
                                              );
                                            }
                                            return const SizedBox();
                                          },
                                        )
                                      )
                                    ],
                                  ),
                                ),
                                TextButton(
                                  onPressed: () {
                                      Navigator.push(context, 
                                        MaterialPageRoute(builder: ((context) {
                                          return WalletDeposit();
                                        }))
                                      );
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.only(left: 10),
                                    height: size.height*0.06,
                                    width: size.width,
                                    child: Row(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(right: 10),
                                          child: Icon(Icons.money, color: Colors.white, size: ratio*40),
                                        ),
                                        SizedBox(
                                          width: size.width*0.75,
                                          child: Text('Deposit', 
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: ratio*40,
                                              fontWeight: FontWeight.w200
                                            )
                                          ),
                                        ),
                                        Expanded(
                                          child: Icon(Icons.chevron_right, color: Colors.white, size: ratio*40)
                                        )
                                      ],
                                    ),
                                  )
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.push(context, 
                                      MaterialPageRoute(builder: (context) {
                                        return const WalletWithdraw();
                                      })
                                    );
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.only(left: 10),
                                    height: size.height*0.06,
                                    width: size.width,
                                    child: Row(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(right: 10),
                                          child: Icon(Icons.wallet, color: Colors.white, size: ratio*40),
                                        ),
                                        SizedBox(
                                          width: size.width*0.75,
                                          child: Text('Withdraw', 
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: ratio*40,
                                              fontWeight: FontWeight.w200
                                            )
                                          ),
                                        ),
                                        Expanded(
                                          child: Icon(Icons.chevron_right, color: Colors.white, size: ratio*40)
                                        )
                                      ],
                                    ),
                                  )
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.push(context, 
                                      MaterialPageRoute(builder: (context) {
                                        return const WalletTransfer();
                                      })
                                    );
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.only(left: 10),
                                    height: size.height*0.06,
                                    width: size.width,
                                    child: Row(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(right: 10),
                                          child: Icon(Icons.currency_exchange, color: Colors.white, size: ratio*40),
                                        ),
                                        SizedBox(
                                          width: size.width*0.75,
                                          child: Text('Transfer', 
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: ratio*40,
                                              fontWeight: FontWeight.w200
                                            )
                                          ),
                                        ),
                                        Expanded(
                                          child: Icon(Icons.chevron_right, color: Colors.white, size: ratio*40)
                                        )
                                      ],
                                    ),
                                  )
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.push(context, 
                                      MaterialPageRoute(builder: (context) {
                                        return const WalletTransaction();
                                      })
                                    );
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.only(left: 10),
                                    height: size.height*0.06,
                                    width: size.width,
                                    child: Row(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(right: 10),
                                          child: Icon(FontAwesomeIcons.moneyBillTransfer, color: Colors.white, size: ratio*40),
                                        ),
                                        SizedBox(
                                          width: size.width*0.75,
                                          child: Text('Transactions', 
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: ratio*40,
                                              fontWeight: FontWeight.w200
                                            )
                                          ),
                                        ),
                                        Expanded(
                                          child: Icon(Icons.chevron_right, color: Colors.white, size: ratio*40)
                                        )
                                      ],
                                    ),
                                  )
                                ),
                              ],
                            ),
                          )
                        ),
                        //FORM3
                        SingleChildScrollView(
                          child: Column(
                            children: [
                              TextButton(
                                onPressed: () {
                                    
                                },
                                child: Container(
                                  padding: const EdgeInsets.only(left: 10),
                                  height: size.height*0.06,
                                  width: size.width,
                                  child: Row(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(right: 10),
                                        child: Icon(FontAwesomeIcons.users, color: Colors.white, size: ratio*40),
                                      ),
                                      SizedBox(
                                        width: size.width*0.75,
                                        child: Text('Find friend', 
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: ratio*40,
                                            fontWeight: FontWeight.w200
                                          )
                                        ),
                                      ),
                                      Expanded(
                                        child: Icon(Icons.chevron_right, color: Colors.white, size: ratio*40)
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 20),
                                height: size.height*0.1,
                                width: size.width,
                                child: Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(right: 10),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.all(Radius.circular(ratio*100)),
                                        child: Image.asset("lib/assets/images/section-bg.jpeg", height: ratio*100, width: ratio*100, fit: BoxFit.fill),
                                      ),
                                    ),
                                    Expanded(
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text('Nhu Nguyen', 
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: ratio*40,
                                              fontWeight: FontWeight.w200
                                            )
                                          ),
                                          TextButton(
                                            onPressed: (){

                                            }, 
                                            child: Container(
                                              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                                              color: const Color.fromRGBO(62, 29, 117, 1),
                                              child: Text('Unfriend', 
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: ratio*30,
                                                )
                                              ),
                                            )
                                          )
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          )
                        )
                      ],
                    )
                  ),
                )
              ],
            ),
          )
        )
      )
    );
  }
}

//text btn - form 1
class UserProfileTextButton extends StatefulWidget {
  UserProfileTextButton({Key? key, required this.textLabel, required this.view, required this.icon}):super(key: key);

  String textLabel;
  Widget view;
  IconData icon;

  @override
  State<UserProfileTextButton> createState() => _UserProfileTextButtonState();
}

class _UserProfileTextButtonState extends State<UserProfileTextButton> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double ratio = size.width / size.height;

    return TextButton(
      onPressed: () {
        Navigator.push(context,
          MaterialPageRoute(builder: (context) {
            return widget.view;
          }),
        );
      },
      
      child: Container(
        padding: const EdgeInsets.only(left: 10),
        height: size.height*0.06,
        width: size.width,
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 10),
              child: Icon(widget.icon, color: Colors.white, size: ratio*40),
            ),
            SizedBox(
              width: size.width*0.75,
              child: Text(widget.textLabel, 
                style: TextStyle(
                  color: Colors.white,
                  fontSize: ratio*40,
                  fontWeight: FontWeight.w200
                )
              ),
            ),
            Expanded(
              child: Icon(Icons.chevron_right, color: Colors.white, size: ratio*40)
            )
          ],
        ),
      )
    );
  }
}

//noti - form 1
class UserProfileNotificationSwitch extends StatefulWidget {
  const UserProfileNotificationSwitch({super.key});

  @override
  State<UserProfileNotificationSwitch> createState() => _UserProfileNotificationSwitchState();
}

class _UserProfileNotificationSwitchState extends State<UserProfileNotificationSwitch> {
  bool light = false;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double ratio = size.width / size.height;
    
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 17, vertical: 10),
      height: size.height*0.06,
      width: size.width,
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: Icon(Icons.notifications, color: Colors.white, size: ratio*40),
          ),
          SizedBox(
            width: size.width*0.75,
            child: Text('Notications',
              style: TextStyle(
                color: Colors.white,
                fontSize: ratio*40,
                fontWeight: FontWeight.w200
              )
            ),
          ),
          Expanded(
            child: Switch(
              value: light,
              activeColor: const Color.fromRGBO(250, 0, 159, 1),
              onChanged: (bool value) {
                setState(() {
                  print(value);
                  light = value;
                });
              },
            )
          )
        ],
      ),
    );
  }
}