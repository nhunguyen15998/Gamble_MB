import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ProfileSecurity extends StatefulWidget {
  const ProfileSecurity({super.key});

  @override
  State<ProfileSecurity> createState() => _ProfileSecurityState();
}

class _ProfileSecurityState extends State<ProfileSecurity> {
  bool light = false;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double ratio = size.width / size.height;
    
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
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
          title: Text('Security', 
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'Play',
              fontSize: ratio*40
            ),
          ),
          backgroundColor: const Color.fromRGBO(31, 6, 68, 1),
          shadowColor: Colors.transparent,
        ),
        backgroundColor: const Color.fromRGBO(31, 6, 68, 1),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 40 , bottom: 40, left: 20, right: 20),
                child: Row(
                  children: [
                    Container(
                      width: size.width*0.78,
                      margin: EdgeInsets.only(right: ratio*50),
                      child: Text('Required password whenever performing withdraw process',
                        maxLines: 3,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: ratio*35
                        ),
                      )
                    ),
                    Expanded(
                      child: Switch(
                        // This bool value toggles the switch.
                        value: light,
                        activeColor: Colors.red,
                        onChanged: (bool value) {
                          // This is called when the user toggles the switch.
                          setState(() {
                            light = value;
                          });
                        },
                      )
                    )
                  ],
                )
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 40, left: 20, right: 20),
                child: Row(
                  children: [
                    Container(
                      width: size.width*0.78,
                      margin: EdgeInsets.only(right: ratio*50),
                      child: Text('Required password whenever performing withdraw process',
                        maxLines: 3,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: ratio*35
                        ),
                      )
                    ),
                    Expanded(
                      child: Switch(
                        // This bool value toggles the switch.
                        value: light,
                        activeColor: Colors.red,
                        onChanged: (bool value) {
                          // This is called when the user toggles the switch.
                          setState(() {
                            light = value;
                          });
                        },
                      )
                    )
                  ],
                )
              ),Padding(
                padding: const EdgeInsets.only(bottom: 40, left: 20, right: 20),
                child: Row(
                  children: [
                    Container(
                      width: size.width*0.78,
                      margin: EdgeInsets.only(right: ratio*50),
                      child: Text('Required password whenever performing withdraw process',
                        maxLines: 3,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: ratio*35
                        ),
                      )
                    ),
                    Expanded(
                      child: Switch(
                        // This bool value toggles the switch.
                        value: light,
                        activeColor: Colors.red,
                        onChanged: (bool value) {
                          // This is called when the user toggles the switch.
                          setState(() {
                            light = value;
                          });
                        },
                      )
                    )
                  ],
                )
              ),
            ]
          )
        )
      )
    );
  }
}