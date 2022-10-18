import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gamble/src/screens/users/profile/views/profile.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ProfileEdit extends StatefulWidget {
  const ProfileEdit({Key? key, required this.restorationId}) : super(key: key);

  final String? restorationId;

  @override
  State<ProfileEdit> createState() => _ProfileEditState();
}
enum SingingCharacter { male, female, other }

class _ProfileEditState extends State<ProfileEdit>  with TickerProviderStateMixin, RestorationMixin{
  SingingCharacter? _character = SingingCharacter.male;
  final birthController = TextEditingController();

  @override
  String? get restorationId => widget.restorationId;

  final RestorableDateTime _selectedDate =
      RestorableDateTime(DateTime.now().subtract(const Duration(days: 365*18)));
  late final RestorableRouteFuture<DateTime?> _restorableDatePickerRouteFuture =
      RestorableRouteFuture<DateTime?>(
    onComplete: _selectDate,
    onPresent: (NavigatorState navigator, Object? arguments) {
      return navigator.restorablePush(
        _datePickerRoute,
        arguments: _selectedDate.value.millisecondsSinceEpoch,
      );
    },
  );

  static Route<DateTime> _datePickerRoute(
    BuildContext context,
    Object? arguments,
  ) {
    return DialogRoute<DateTime>(
      context: context,
      builder: (BuildContext context) {
        return DatePickerDialog(
          restorationId: 'date_picker_dialog',
          initialEntryMode: DatePickerEntryMode.calendar,
          initialDate: DateTime.fromMillisecondsSinceEpoch(arguments! as int),
          firstDate: DateTime.now().subtract(const Duration(days: 365*100)),
          lastDate: DateTime.now().subtract(const Duration(days: 365*18)),
        );
      },
    );
  }

  @override
  void restoreState(RestorationBucket? oldBucket, bool initialRestore) {
    registerForRestoration(_selectedDate, 'selected_date');
    registerForRestoration(
        _restorableDatePickerRouteFuture, 'date_picker_route_future');
  }

  void _selectDate(DateTime? newSelectedDate) {
    if (newSelectedDate != null) {
      setState(() {
        _selectedDate.value = newSelectedDate;
        birthController.text = '${_selectedDate.value.day}/${_selectedDate.value.month}/${_selectedDate.value.year}';
      });
    }
  }

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
        body: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 20, bottom: 20, left: 20, right: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Profile picture',
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
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: Container(
                  margin: EdgeInsets.only(bottom: ratio),
                  child: ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(ratio*320)),
                    child: Image.asset("lib/assets/images/section-bg.jpeg", height: ratio*250, width: ratio*250, fit: BoxFit.cover),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20, bottom: 20, left: 20, right: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Cover photo',
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
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: Container(
                  margin: EdgeInsets.only(bottom: ratio),
                  child: ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(ratio*50)),
                    child: Image.asset("lib/assets/images/section-bg.jpeg", fit: BoxFit.cover),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 30, bottom: 20, left: 20, right: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Information',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: ratio*45,
                        fontFamily: 'Play',
                        fontWeight: FontWeight.bold
                      ),
                    ),
                    TextButton(
                      onPressed: () => {},
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
              Padding(
                padding: const EdgeInsets.only(bottom: 40, left: 20, right: 20),
                child: TextField(
                  key: const Key('ProfileForm_firstNameInput_firstNameField'),
                  keyboardType: TextInputType.text,
                  style: const TextStyle(color: Color.fromRGBO(255, 255, 255, 1)),
                  decoration: InputDecoration(
                    labelText: 'First name',
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
                  key: const Key('ProfileForm_lastNameInput_lastNameField'),
                  keyboardType: TextInputType.text,
                  style: const TextStyle(color: Color.fromRGBO(255, 255, 255, 1)),
                  decoration: InputDecoration(
                    labelText: 'Last name',
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
                  key: const Key('ProfileForm_phoneInput_phoneField'),
                  keyboardType: TextInputType.text,
                  style: const TextStyle(color: Color.fromRGBO(255, 255, 255, 1)),
                  decoration: InputDecoration(
                    labelText: 'Phone',
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
                  key: const Key('ProfileForm_emailInput_emailField'),
                  keyboardType: TextInputType.text,
                  style: const TextStyle(color: Color.fromRGBO(255, 255, 255, 1)),
                  decoration: InputDecoration(
                    labelText: 'Email',
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
                  controller: birthController,
                  key: const Key('ProfileForm_birthInput_birthField'),
                  keyboardType: TextInputType.text,
                  style: const TextStyle(color: Color.fromRGBO(255, 255, 255, 1)),
                  decoration: InputDecoration(
                    labelText: 'Birth',
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
                      height: ratio*18,
                      width: ratio*18,
                      decoration: BoxDecoration(
                        color: const Color.fromRGBO(250, 0, 159, 1),
                        border: Border.all(
                          color: const Color.fromRGBO(180, 67, 170, 1),
                        ),
                        borderRadius: const BorderRadius.all(Radius.circular(50)),
                      ),
                      child: IconButton(
                        icon: Icon(Icons.calendar_month, size: ratio*40, color: Colors.white),
                        onPressed: () {
                          _restorableDatePickerRouteFuture.present();
                        },
                      )
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
                padding: const EdgeInsets.only(bottom: 30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 30),
                      child: Text("Gender",
                        style: TextStyle(
                          fontFamily: "Play",
                          fontSize: ratio * 35,
                          color: Colors.white,
                        )
                      ),
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: ListTile(
                            textColor: Colors.white,
                            title: const Text('Male'),
                            horizontalTitleGap: 0,
                            leading: Radio<SingingCharacter>(
                              fillColor: const MaterialStatePropertyAll(Colors.white),
                              value: SingingCharacter.male,
                              groupValue: _character,
                              onChanged: (SingingCharacter? value) {
                                setState(() {
                                  _character = value;
                                });
                              },
                            ),
                          )
                        ),
                        Expanded(
                          child: ListTile(
                            textColor: Colors.white,
                            title: const Text('Female'),
                            horizontalTitleGap: 0,
                            leading: Radio<SingingCharacter>(
                              fillColor: const MaterialStatePropertyAll(Colors.white),
                              value: SingingCharacter.female,
                              groupValue: _character,
                              onChanged: (SingingCharacter? value) {
                                setState(() {
                                  _character = value;
                                });
                              },
                            ),
                          )
                        ),
                        Expanded(
                          flex: 1,
                          child: ListTile(
                            textColor: Colors.white,
                            title: const Text('Other'),
                            horizontalTitleGap: 0,
                            leading: Radio<SingingCharacter>(
                              fillColor: const MaterialStatePropertyAll(Colors.white),
                              value: SingingCharacter.other,
                              groupValue: _character,
                              onChanged: (SingingCharacter? value) {
                                setState(() {
                                  _character = value;
                                });
                              },
                            ),
                          )
                        )
                      ],
                    )
                  ],
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
                    key: const Key('ProfileForm_submitBtn'),
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
            ],
          ),
        ),
      ),
    );
  }
}