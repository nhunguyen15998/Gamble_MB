import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:gamble/src/screens/users/password_required/views/password_required.dart';
import 'package:gamble/src/screens/users/profile_security/bloc/profile_security_bloc.dart';
import 'package:gamble/src/screens/users/transaction_results/views/transaction_result.dart';
import 'package:gamble/src/services/settings_service.dart';
import 'package:gamble/src/utils/helpers.dart';

class ProfileSecurity extends StatefulWidget {
  const ProfileSecurity({super.key});

  @override
  State<ProfileSecurity> createState() => _ProfileSecurityState();
}

class _ProfileSecurityState extends State<ProfileSecurity> {

  void _showMessage(String message, Icon icon) {
    showDialog<void>(
      context: context,
      barrierDismissible: false, 
      builder: (BuildContext context) {
        return AlertDialog(
          icon: icon,
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double ratio = size.width / size.height;
    
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: RepositoryProvider(
        create: (context) => SettingsManagement(),
        child: BlocProvider(
          create: (context) => ProfileSecurityBloc(RepositoryProvider.of<SettingsManagement>(context))..add(ProfileSecurityInitial()),
          child: BlocBuilder<ProfileSecurityBloc, ProfileSecurityState>(
            builder: (context, state) {
              if(state is ProfileSecurityInitialized && state.code == 406){
                var config = {
                  "withdraw_password": state.isWithdrawOn ? "1" : "0",
                  "transfer_password": state.isTransferOn ? "1" : "0",
                  "setting_password": state.isUpdateSettingOn ? "1" : "0",
                };
                return RequiredPassword(path: 'user/configs/updateWithPassword', data: config, type: 'updateSecurity');
              } 
              if(state is ProfileSecurityInitialized && state.code == 200){
                var textStyle = TextStyle(color: const Color.fromARGB(255, 32, 150, 36), fontFamily: 'Play', fontSize: ratio*40);
                var image = Image.asset('lib/assets/images/successful-transaction.png', width: ratio*200);
                return TransactionResult(text: state.message, textStyle: textStyle, image: image);
              }
              return Scaffold(
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
                  child: BlocBuilder<ProfileSecurityBloc, ProfileSecurityState>(
                    builder: (context, state) {
                      if(state is ProfileSecurityInitialized){
                        ProfileSecurityInitialized profileSecurityInitialized = state;
                        return Column(
                          children: [
                            SizedBox(
                              height: size.height*0.75,
                              child: SingleChildScrollView(
                                child: Column(
                                  children: [ 
                                    Padding(
                                      padding: const EdgeInsets.only(top: 20, bottom: 40, left: 20, right: 20),
                                      child: Row(
                                        children: [
                                          Container(
                                            width: size.width*0.78,
                                            margin: EdgeInsets.only(right: ratio*50),
                                            child: Text('Required current password whenever performing withdrawal process',
                                              maxLines: 3,
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: ratio*35
                                              ),
                                            )
                                          ),
                                          Expanded(
                                            child: Switch(
                                              value: profileSecurityInitialized.isWithdrawOn,
                                              activeColor: Colors.red,
                                              onChanged: (bool value) {
                                                context.read<ProfileSecurityBloc>().add(WithdrawPasswordSettingChanged(isWithdrawOn: value));
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
                                            child: Text('Required current password whenever performing transfer process',
                                              maxLines: 3,
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: ratio*35
                                              ),
                                            )
                                          ),
                                          Expanded(
                                            child: Switch(
                                              value: profileSecurityInitialized.isTransferOn,
                                              activeColor: Colors.red,
                                              onChanged: (bool value) {
                                                context.read<ProfileSecurityBloc>().add(TransferPasswordSettingChanged(isTransferOn: value));
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
                                            child: Text('Required current password whenever updating security settings',
                                              maxLines: 3,
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: ratio*35
                                              ),
                                            )
                                          ),
                                          Expanded(
                                            child: Switch(
                                              value: profileSecurityInitialized.isUpdateSettingOn,
                                              activeColor: Colors.red,
                                              onChanged: (bool value) {
                                                context.read<ProfileSecurityBloc>().add(UpdateSettingPasswordSettingChanged(isUpdateSettingOn: value));
                                              },
                                            )
                                          )
                                        ],
                                      )
                                    ),
                                  ]
                                )
                              )
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 25, bottom: 40, left: 20, right: 20),
                              child: SizedBox(
                                width: double.infinity,
                                height: ratio * 100,
                                child: ElevatedButton(
                                  style: ButtonStyle(
                                      backgroundColor: MaterialStateProperty.all(
                                          Color.fromARGB(255, 250, 137, 0)),
                                      shape: MaterialStateProperty.all(RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(ratio * 50)))),
                                  onPressed: !state.isBtnDisabled ?
                                  () {
                                    context.read<ProfileSecurityBloc>().add(ProfileSecurityBtnSaveClicked(isBtnDisabled: true));
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
                        );
                      }
                      return const Center(child: CircularProgressIndicator());
                    },
                  )
                )
              );
            }
          )
        ),
      )
    );
  }
}