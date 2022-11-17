import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gamble/src/screens/users/profile_edit_info/bloc/profile_edit_info_bloc.dart';
import 'package:gamble/src/screens/users/profile_edit_info/profile_edit_info.dart';
import 'package:gamble/src/screens/users/signup/models/first_name.dart';
import 'package:gamble/src/screens/users/signup/models/last_name.dart';
import 'package:gamble/src/services/profile_service.dart';
import 'package:formz/formz.dart';
import 'package:intl/intl.dart';

class ProfileEditInfo extends StatefulWidget {
  const ProfileEditInfo({super.key});

  @override
  State<ProfileEditInfo> createState() => _ProfileEditInfoState();
}

class _ProfileEditInfoState extends State<ProfileEditInfo>{

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double ratio = size.width / size.height;
    
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: RepositoryProvider(
        create: (context) => ProfileManagement(),
        child: BlocProvider(
          create: (context) => ProfileEditInfoBloc(RepositoryProvider.of<ProfileManagement>(context))..add(ProfileEditInfoInitial()),
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
            body: SingleChildScrollView(
              child: BlocBuilder<ProfileEditInfoBloc, ProfileEditInfoState>(
                builder: (context, state) {
                  if(state is ProfileEditInfoInitialized){
                    return const Center(child: CircularProgressIndicator());
                  }
                  if(state is ProfileEditInfoLoaded){
                    var profileEditInfoLoaded = state;
                    var firstName = profileEditInfoLoaded.firstNameLoaded;
                    var lastName = profileEditInfoLoaded.lastNameLoaded;
                    var phone = profileEditInfoLoaded.phoneLoaded;
                    var email = profileEditInfoLoaded.emailLoaded;
                    var birth = profileEditInfoLoaded.birthLoaded;
                    var gender = profileEditInfoLoaded.genderLoaded;
                    return Padding(
                      padding: EdgeInsets.symmetric(vertical: ratio*90),
                      child: Column(
                        children: [
                          ProfileEditInfoFirstNameInput(firstName: firstName, error: state.firstName.invalid ? 'First name is required' : null),
                          ProfileEditInfoLastNameInput(lastName: lastName, error: state.lastName.invalid ? 'Last name is required' : null),
                          ProfileEditInfoPhoneInput(phone: phone),
                          ProfileEditInfoEmailInput(email: email, error: state.email.invalid ? 'Email is required' : null),
                          ProfileEditInfoBirthInput(birth: birth),
                          ProfileEditInfoGenderRadioGroup(gender: gender),
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
                                onPressed: state.status == FormzStatus.valid ?
                                  () {
                                    context.read<ProfileEditInfoBloc>().add(const ProfileEditInfoSaveBtnClicked());
                                  }
                                  : null,
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
                    );
                  }
                  return const SizedBox();
                },
              )
            )
          ),
        ),
      )
    );
  }
}

//ProfileEditInfoFirstNameInput
class ProfileEditInfoFirstNameInput extends StatefulWidget {
  ProfileEditInfoFirstNameInput({Key? key, required this.firstName, this.error}):super(key: key);

  String firstName;
  String? error;

  @override
  State<ProfileEditInfoFirstNameInput> createState() => _ProfileEditInfoFirstNameInputState();
}

class _ProfileEditInfoFirstNameInputState extends State<ProfileEditInfoFirstNameInput> {
  final firstNameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    firstNameController.text = widget.firstName;
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double ratio = size.width / size.height;

    return Padding(
      padding: const EdgeInsets.only(bottom: 40, left: 20, right: 20),
      child: 
      TextField(
        controller: firstNameController,
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
          errorText: widget.error,
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
        ),
        onChanged: (value) => context.read<ProfileEditInfoBloc>().add(ProfileEditInfoFirstNameChanged(firstName: value)),
      )
    );
  }
}

//ProfileEditInfoLastNameInput
class ProfileEditInfoLastNameInput extends StatefulWidget {
  ProfileEditInfoLastNameInput({Key? key, required this.lastName, this.error}):super(key: key);

  String lastName;
  String? error;

  @override
  State<ProfileEditInfoLastNameInput> createState() => _ProfileEditInfoLastNameInputState();
}

class _ProfileEditInfoLastNameInputState extends State<ProfileEditInfoLastNameInput> {
  final lastNameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    lastNameController.text = widget.lastName;
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double ratio = size.width / size.height;

    return Padding(
      padding: const EdgeInsets.only(bottom: 40, left: 20, right: 20),
      child: TextField(
        controller: lastNameController,
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
          errorText: widget.error,
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
        ),
        onChanged: (value) => context.read<ProfileEditInfoBloc>().add(ProfileEditInfoLastNameChanged(lastName: value)),
      )
    );
  }
}

//ProfileEditInfoPhoneInput
class ProfileEditInfoPhoneInput extends StatefulWidget {
  ProfileEditInfoPhoneInput({Key? key, required this.phone}):super(key:key);

  String phone;

  @override
  State<ProfileEditInfoPhoneInput> createState() => _ProfileEditInfoPhoneInputState();
}

class _ProfileEditInfoPhoneInputState extends State<ProfileEditInfoPhoneInput> {
  final phoneController = TextEditingController();

  @override
  void initState() {
    super.initState();
    phoneController.text = widget.phone;
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double ratio = size.width / size.height;

    return Padding(
      padding: const EdgeInsets.only(bottom: 40, left: 20, right: 20),
      child: TextField(
        controller: phoneController,
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
    );
  }
}

//ProfileEditInfoEmailInput
class ProfileEditInfoEmailInput extends StatefulWidget {
  ProfileEditInfoEmailInput({Key? key, required this.email, this.error}):super(key: key);

  String email;
  String? error;

  @override
  State<ProfileEditInfoEmailInput> createState() => _ProfileEditInfoEmailInputState();
}

class _ProfileEditInfoEmailInputState extends State<ProfileEditInfoEmailInput> {
  final emailController = TextEditingController();

  @override
  void initState() {
    super.initState();
    emailController.text = widget.email;
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double ratio = size.width / size.height;

    return Padding(
      padding: const EdgeInsets.only(bottom: 40, left: 20, right: 20),
      child: TextField(
        controller: emailController,
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
          errorText: widget.error,
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
        ),
        onChanged: (value) => context.read<ProfileEditInfoBloc>().add(ProfileEditInfoEmailChanged(email: value)),
      )
    );
  }
}

//ProfileEditInfoBirthInput
class ProfileEditInfoBirthInput extends StatefulWidget {
  ProfileEditInfoBirthInput({Key? key, this.restorationId, required this.birth}):super(key:key);

  final String? restorationId;
  String birth;

  @override
  State<ProfileEditInfoBirthInput> createState() => _ProfileEditInfoBirthInputState();
}

class _ProfileEditInfoBirthInputState extends State<ProfileEditInfoBirthInput> with RestorationMixin {
  final birthController = TextEditingController();
  late ProfileEditInfoBloc profileEditInfoBloc; 

  @override
  void initState() {
    super.initState();
    birthController.text = widget.birth;
    profileEditInfoBloc = context.read<ProfileEditInfoBloc>(); 
  }

  @override
  String? get restorationId => widget.restorationId;

  final RestorableDateTime _selectedDate = RestorableDateTime(DateTime.now().subtract(const Duration(days: 365*18)));

  static Route<DateTime> _datePickerRoute(BuildContext context, Object? arguments) {
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
    registerForRestoration(_restorableDatePickerRouteFuture, 'date_picker_route_future');
  }

  void _selectDate(DateTime? newSelectedDate) {
    if (newSelectedDate != null) {
      setState(() {
        _selectedDate.value = newSelectedDate;
        birthController.text = '${_selectedDate.value.day}/${_selectedDate.value.month}/${_selectedDate.value.year}';
        var birth = DateFormat("dd/MM/yyyy").format(DateTime.parse(newSelectedDate.toString()));
        profileEditInfoBloc.add(ProfileEditInfoBirthChanged(birth: birth));
      });
    }
  }

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

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double ratio = size.width / size.height;

    return Padding(
      padding: const EdgeInsets.only(bottom: 40, left: 20, right: 20),
      child: TextField(
        controller: birthController,
        key: const Key('ProfileForm_birthInput_birthField'),
        keyboardType: TextInputType.text,
        style: const TextStyle(color: Color.fromRGBO(255, 255, 255, 1)),
        readOnly: true,
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
        ),
      )
    );
  }
}

//ProfileEditInfoGenderRadioGroup
class ProfileEditInfoGenderRadioGroup extends StatefulWidget {
  ProfileEditInfoGenderRadioGroup({Key? key, required this.gender}):super(key: key);

  int gender;

  @override
  State<ProfileEditInfoGenderRadioGroup> createState() => _ProfileEditInfoGenderRadioGroupState();
}
enum Genders { male, female, other }

class _ProfileEditInfoGenderRadioGroupState extends State<ProfileEditInfoGenderRadioGroup> {
  Genders? _character = Genders.male;
  
  Genders toGender(){
    var gender = widget.gender;
    Genders loadedGender = Genders.male;
    switch (gender) {
      case 0:
        break;
      case 1:
        loadedGender = Genders.female;
        break;
      case 2:
        loadedGender = Genders.other;
        break;
    }
    return loadedGender;
  }

  @override
  void initState() {
    super.initState();
    _character = toGender();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double ratio = size.width / size.height;

    return Padding(
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
                  leading: Radio<Genders>(
                    fillColor: const MaterialStatePropertyAll(Colors.white),
                    value: Genders.male,
                    groupValue: _character,
                    onChanged: (Genders? value) {
                      setState(() {
                        _character = value;
                      });
                      context.read<ProfileEditInfoBloc>().add(ProfileEditInfoGenderChanged(gender: _character!.index));
                    },
                  ),
                )
              ),
              Expanded(
                child: ListTile(
                  textColor: Colors.white,
                  title: const Text('Female'),
                  horizontalTitleGap: 0,
                  leading: Radio<Genders>(
                    fillColor: const MaterialStatePropertyAll(Colors.white),
                    value: Genders.female,
                    groupValue: _character,
                    onChanged: (Genders? value) {
                      setState(() {
                        _character = value;
                      });
                      context.read<ProfileEditInfoBloc>().add(ProfileEditInfoGenderChanged(gender: _character!.index));
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
                  leading: Radio<Genders>(
                    fillColor: const MaterialStatePropertyAll(Colors.white),
                    value: Genders.other,
                    groupValue: _character,
                    onChanged: (Genders? value) {
                      setState(() {
                        _character = value;
                      });
                      context.read<ProfileEditInfoBloc>().add(ProfileEditInfoGenderChanged(gender: _character!.index));
                    },
                  ),
                )
              )
            ],
          )
        ],
      )
    );
  }
}
