import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ProfileChangePassword extends StatefulWidget {
  const ProfileChangePassword({super.key});

  @override
  State<ProfileChangePassword> createState() => _ProfileChangePasswordState();
}

class _ProfileChangePasswordState extends State<ProfileChangePassword> {
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
          title: Text('Change password', 
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
                child: TextField(
                  key: const Key('ProfileChangePassword_currentPasswordField'),
                  keyboardType: TextInputType.text,
                  style: const TextStyle(color: Color.fromRGBO(255, 255, 255, 1)),
                  decoration: InputDecoration(
                    labelText: 'Current password',
                    labelStyle: TextStyle(
                      fontSize: ratio * 35,
                      color: const Color.fromRGBO(255, 255, 255, 1),
                      fontFamily: "Play"
                    ),
                    errorStyle: const TextStyle(color: Color.fromRGBO(255, 255, 255, 1)),
                    contentPadding: const EdgeInsets.all(0),
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.2),
                    prefixIcon: Container(
                      margin: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: const Color.fromRGBO(250, 0, 159, 1),
                        border: Border.all(
                          color: const Color.fromRGBO(180, 67, 170, 1),
                        ),
                        borderRadius: const BorderRadius.all(Radius.circular(50)),
                      ),
                      child: Icon(Icons.abc, size: ratio*40, color: Colors.white)
                    ),
                    focusedBorder: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(50)),
                      borderSide: BorderSide(color: Color.fromRGBO(250, 0, 159, 1), width: 1)
                    ),
                    enabledBorder: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(50)),
                      borderSide: BorderSide(
                      color: Color.fromRGBO(210, 213, 252, 1), width: 1)
                    ),
                    errorBorder: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(50)),
                    borderSide: BorderSide(
                    color: Color.fromRGBO(218, 62, 59, 1), width: 1)
                    ),
                    focusedErrorBorder: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(50)),
                    borderSide: BorderSide(
                    color: Color.fromRGBO(218, 62, 59, 1), width: 1)
                    )
                  )
                )
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 40, left: 20, right: 20),
                child: TextField(
                  key: const Key('ProfileChangePassword_newPasswordField'),
                  keyboardType: TextInputType.text,
                  style: const TextStyle(color: Color.fromRGBO(255, 255, 255, 1)),
                  decoration: InputDecoration(
                    labelText: 'New password',
                    labelStyle: TextStyle(
                      fontSize: ratio * 35,
                      color: const Color.fromRGBO(255, 255, 255, 1),
                      fontFamily: "Play"
                    ),
                    errorStyle: const TextStyle(color: Color.fromRGBO(255, 255, 255, 1)),
                    contentPadding: const EdgeInsets.all(0),
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.2),
                    prefixIcon: Container(
                      margin: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: const Color.fromRGBO(250, 0, 159, 1),
                        border: Border.all(
                          color: const Color.fromRGBO(180, 67, 170, 1),
                        ),
                        borderRadius: const BorderRadius.all(Radius.circular(50)),
                      ),
                      child: Icon(Icons.abc, size: ratio*40, color: Colors.white)
                    ),
                    focusedBorder: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(50)),
                      borderSide: BorderSide(color: Color.fromRGBO(250, 0, 159, 1), width: 1)
                    ),
                    enabledBorder: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(50)),
                      borderSide: BorderSide(
                      color: Color.fromRGBO(210, 213, 252, 1), width: 1)
                    ),
                    errorBorder: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(50)),
                    borderSide: BorderSide(
                    color: Color.fromRGBO(218, 62, 59, 1), width: 1)
                    ),
                    focusedErrorBorder: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(50)),
                    borderSide: BorderSide(
                    color: Color.fromRGBO(218, 62, 59, 1), width: 1)
                    )
                  )
                )
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 40, left: 20, right: 20),
                child: TextField(
                  key: const Key('ProfileChangePassword_confirmedNewPasswordField'),
                  keyboardType: TextInputType.text,
                  style: const TextStyle(color: Color.fromRGBO(255, 255, 255, 1)),
                  decoration: InputDecoration(
                    labelText: 'Confirmation password',
                    labelStyle: TextStyle(
                      fontSize: ratio * 35,
                      color: const Color.fromRGBO(255, 255, 255, 1),
                      fontFamily: "Play"
                    ),
                    errorStyle: const TextStyle(color: Color.fromRGBO(255, 255, 255, 1)),
                    contentPadding: const EdgeInsets.all(0),
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.2),
                    prefixIcon: Container(
                      margin: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: const Color.fromRGBO(250, 0, 159, 1),
                        border: Border.all(
                          color: const Color.fromRGBO(180, 67, 170, 1),
                        ),
                        borderRadius: const BorderRadius.all(Radius.circular(50)),
                      ),
                      child: Icon(Icons.abc, size: ratio*40, color: Colors.white)
                    ),
                    focusedBorder: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(50)),
                      borderSide: BorderSide(color: Color.fromRGBO(250, 0, 159, 1), width: 1)
                    ),
                    enabledBorder: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(50)),
                      borderSide: BorderSide(
                      color: Color.fromRGBO(210, 213, 252, 1), width: 1)
                    ),
                    errorBorder: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(50)),
                    borderSide: BorderSide(
                    color: Color.fromRGBO(218, 62, 59, 1), width: 1)
                    ),
                    focusedErrorBorder: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(50)),
                    borderSide: BorderSide(
                    color: Color.fromRGBO(218, 62, 59, 1), width: 1)
                    )
                  )
                )
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 40, left: 20, right: 20),
                child: SizedBox(
                  width: double.infinity,
                  height: ratio * 100,
                  child: ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(
                            const Color.fromRGBO(250, 0, 159, 1)),
                        shape: MaterialStateProperty.all(RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(ratio * 50)))),
                    key: const Key('ProfileChangePassword_saveBtn'),
                    onPressed: () {},
                    child: Text('Save'.toUpperCase(),
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: ratio * 40,
                        fontFamily: "Play"
                      )
                    ),
                  )
                )
              )
            ]
          )
        )
      )
    );
  }
}