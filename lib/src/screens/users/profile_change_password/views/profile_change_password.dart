import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gamble/src/screens/users/profile_change_password/bloc/profile_change_password_bloc.dart';
import 'package:gamble/src/services/profile_service.dart';
import 'package:formz/formz.dart';
import 'package:gamble/src/utils/helpers.dart';
import 'package:http/http.dart';

class ProfileChangePassword extends StatefulWidget {
  const ProfileChangePassword({super.key});

  @override
  State<ProfileChangePassword> createState() => _ProfileChangePasswordState();
}

class _ProfileChangePasswordState extends State<ProfileChangePassword> {
  TextEditingController oldPasswordController = TextEditingController();
  TextEditingController newPasswordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double ratio = size.width / size.height;
    
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: RepositoryProvider(
        create: (context) => ProfileManagement(),
        child: BlocProvider(
          create: (context) => ProfileChangePasswordBloc(RepositoryProvider.of<ProfileManagement>(context))..add(ProfileChangePasswordEvent()),
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
              child: BlocBuilder<ProfileChangePasswordBloc, ProfileChangePasswordState>(
                builder: (context, state) {
                  Widget widget = const SizedBox();
                  if(state is ProfileChangePasswordLoading){
                    widget = const Center(child: CircularProgressIndicator());
                  }
                  if(state is ProfileChangePasswordLoaded){
                    ProfileChangePasswordLoaded profileChangePasswordLoaded = state;
                    widget = AlertDialog(
                      icon: profileChangePasswordLoaded.code == 200 ? 
                              const Icon(Icons.check_circle): const Icon(Icons.error_outline_rounded),
                      content: Text(profileChangePasswordLoaded.message),
                      actions: <Widget>[
                        TextButton(
                          child: const Text('OK'),
                          onPressed: () {
                            context.read<ProfileChangePasswordBloc>().add(ProfileAlertBtnOKClicked());
                            oldPasswordController.text = "";
                            newPasswordController.text = "";
                            confirmPasswordController.text = "";
                          },
                        ),
                      ],
                    );
                  }
                  return Stack(
                    children: [
                      Column(
                        children: [
                          ChangePasswordOldPasswordInput(textEditingController: oldPasswordController),
                          ChangePasswordNewPasswordInput(textEditingController: newPasswordController,),
                          ChangePasswordConfimationPasswordInput(textEditingController: confirmPasswordController,),
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
                                onPressed: state.status == FormzStatus.valid ?
                                () {
                                  context.read<ProfileChangePasswordBloc>().add(ProfileBtnChangePasswordClicked());
                                } : null,
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
                      ),
                      state is ProfileChangePasswordLoaded || state is ProfileChangePasswordLoading?
                      Positioned(
                        child: Container(
                          width: size.width,
                          height: size.height,
                          //color: const Color.fromARGB(0, 31, 6, 68),
                          child: Center(
                            child: widget
                          ),
                        )
                      ) : const SizedBox() 
                    ]
                  );
                }
              )
            )
          )
        ),
      )
    );
  }
}

//old
class ChangePasswordOldPasswordInput extends StatefulWidget {
  ChangePasswordOldPasswordInput({Key? key, required this.textEditingController}):super(key: key);

  TextEditingController textEditingController;

  @override
  State<ChangePasswordOldPasswordInput> createState() => _ChangePasswordOldPasswordInputState();
}

class _ChangePasswordOldPasswordInputState extends State<ChangePasswordOldPasswordInput> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double ratio = size.width / size.height;
    TextEditingController textEditingController = widget.textEditingController;

    return BlocBuilder<ProfileChangePasswordBloc, ProfileChangePasswordState>(
      buildWhen: (previous, current) =>
        previous.oldPassword != current.oldPassword,// ||previous.showPassword != current.showPassword,
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.only(top: 40 , bottom: 40, left: 20, right: 20),
          child: TextField(
            controller: textEditingController,
            key: const Key('ProfileChangePassword_currentPasswordField'),
            keyboardType: TextInputType.text,
            obscureText: true,
            style: const TextStyle(color: Color.fromRGBO(255, 255, 255, 1)),
            decoration: InputDecoration(
              labelText: 'Current password',
              labelStyle: TextStyle(
                fontSize: ratio * 35,
                color: const Color.fromRGBO(255, 255, 255, 1),
                fontFamily: "Play"
              ),
              errorStyle: const TextStyle(color: Color.fromRGBO(255, 255, 255, 1)),
              errorText: state.oldPassword.invalid ? "Current password is required" : null,
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
            onChanged: (value) => context.read<ProfileChangePasswordBloc>().add(ProfileOldPasswordChanged(password: value)),
          )
        );
      }
    );
  }
}

//new 
class ChangePasswordNewPasswordInput extends StatefulWidget {
  ChangePasswordNewPasswordInput({Key? key, required this.textEditingController}):super(key: key);

  TextEditingController textEditingController;

  @override
  State<ChangePasswordNewPasswordInput> createState() => _ChangePasswordNewPasswordInputState();
}

class _ChangePasswordNewPasswordInputState extends State<ChangePasswordNewPasswordInput> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double ratio = size.width / size.height;
    TextEditingController textEditingController = widget.textEditingController;

    return BlocBuilder<ProfileChangePasswordBloc, ProfileChangePasswordState>(
      buildWhen: (previous, current) =>
        previous.newPassword != current.newPassword,// ||previous.showPassword != current.showPassword,
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 40, left: 20, right: 20),
          child: TextField(
            controller: textEditingController,
            key: const Key('ProfileChangePassword_newPasswordField'),
            keyboardType: TextInputType.text,
            obscureText: true,
            style: const TextStyle(color: Color.fromRGBO(255, 255, 255, 1)),
            decoration: InputDecoration(
              labelText: 'New password',
              labelStyle: TextStyle(
                fontSize: ratio * 35,
                color: const Color.fromRGBO(255, 255, 255, 1),
                fontFamily: "Play"
              ),
              errorStyle: const TextStyle(color: Color.fromRGBO(255, 255, 255, 1)),
              errorText: state.newPassword.invalid ? "New password is required" : null,
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
            onChanged: (value) => context.read<ProfileChangePasswordBloc>().add(ProfileNewPasswordChanged(password: value)),
          )
        );
      }
    );
  }
}

//confirm
class ChangePasswordConfimationPasswordInput extends StatefulWidget {
  ChangePasswordConfimationPasswordInput({Key? key, required this.textEditingController}):super(key: key);

  TextEditingController textEditingController;

  @override
  State<ChangePasswordConfimationPasswordInput> createState() => _ChangePasswordConfimationPasswordInputState();
}

class _ChangePasswordConfimationPasswordInputState extends State<ChangePasswordConfimationPasswordInput> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double ratio = size.width / size.height;
    TextEditingController textEditingController = widget.textEditingController;

    return BlocBuilder<ProfileChangePasswordBloc, ProfileChangePasswordState>(
      buildWhen: (previous, current) =>
        previous.confirmNewPassword != current.confirmNewPassword,// ||previous.showPassword != current.showPassword,
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 40, left: 20, right: 20),
          child: TextField(
            controller: textEditingController,
            key: const Key('ProfileChangePassword_confirmedNewPasswordField'),
            keyboardType: TextInputType.text,
            obscureText: true,
            style: const TextStyle(color: Color.fromRGBO(255, 255, 255, 1)),
            decoration: InputDecoration(
              labelText: 'Confirmation password',
              labelStyle: TextStyle(
                fontSize: ratio * 35,
                color: const Color.fromRGBO(255, 255, 255, 1),
                fontFamily: "Play"
              ),
              errorStyle: const TextStyle(color: Color.fromRGBO(255, 255, 255, 1)),
              errorText: state.confirmNewPassword.invalid ? "Confirmation password is required" : null,
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
            onChanged: (value) => context.read<ProfileChangePasswordBloc>().add(ProfileConfirmNewPasswordChanged(password: value)),
          )
        );
      }
    );
  }
}