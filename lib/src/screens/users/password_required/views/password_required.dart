import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gamble/src/screens/users/password_required/bloc/password_required_bloc.dart';
import 'package:gamble/src/screens/users/profile_change_password/bloc/profile_change_password_bloc.dart';
import 'package:gamble/src/screens/users/transaction_results/views/transaction_result.dart';
import 'package:gamble/src/services/profile_service.dart';
import 'package:formz/formz.dart';
import 'package:gamble/src/services/settings_service.dart';
import 'package:gamble/src/services/transaction_service.dart';
import 'package:gamble/src/utils/helpers.dart';
import 'package:http/http.dart';

class RequiredPassword extends StatefulWidget {
  RequiredPassword({Key? key, required this.path, this.data = const <String, String>{}, required this.type}):super(key: key);
  String path;
  Map<String, String> data;
  String type;
  @override
  State<RequiredPassword> createState() => _RequiredPasswordState();
}

class _RequiredPasswordState extends State<RequiredPassword> {

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double ratio = size.width / size.height;
    String path = widget.path;
    String type = widget.type;
    final data = widget.data;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: RepositoryProvider(
        create: (context) {
          final transactionService = RepositoryProvider.of<TransactionManagement>(context);
          final settingService = RepositoryProvider.of<SettingsManagement>(context);
          PasswordRequiredBloc(transactionService, settingService);
        },
        child: BlocProvider<PasswordRequiredBloc>(
          create: (context) {
            final transactionService = TransactionManagement();
            final settingService = SettingsManagement();
            var transactionBloc = PasswordRequiredBloc(transactionService, settingService);
            transactionBloc.add(PasswordRequiredInitialized(path: path, data: data, type: type));
            return transactionBloc;
          },
          child: BlocBuilder<PasswordRequiredBloc, PasswordRequiredState>(
            builder: (context, state) {
              if(state.status == FormzStatus.submissionSuccess){
                var textStyle = TextStyle(color: const Color.fromARGB(255, 32, 150, 36), fontFamily: 'Play', fontSize: ratio*40);
                var image = Image.asset('lib/assets/images/successful-transaction.png', width: ratio*200);
                var message = state.type == 'transfer' ? state.message+state.receiverPhone : state.message;
                if(state.code != 200){
                  textStyle = TextStyle(color: const Color.fromARGB(255, 195, 39, 39), fontFamily: 'Play', fontSize: ratio*40);
                  image = Image.asset('lib/assets/images/failed-transaction.png');
                } 
                return TransactionResult(text: message, textStyle: textStyle, image: image);
              }
              return RequiredPasswordBody(path: path, data: data);
            },
          )
        ),
      )
    );
  }
}

//password required body
class RequiredPasswordBody extends StatelessWidget {
  RequiredPasswordBody({Key? key, required this.path, this.data = const <String, String>{}});
  String path;
  Map<String, dynamic> data;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double ratio = size.width / size.height;

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
        title: Text('Password Verification', 
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
        child:  BlocBuilder<PasswordRequiredBloc, PasswordRequiredState>(
          builder: (context, state) {
            Widget widget = const SizedBox();
            if(state.status == FormzStatus.submissionInProgress){
              widget = const Center(child: CircularProgressIndicator());
            }
            if(state.status == FormzStatus.submissionFailure){
              widget = AlertDialog(
                icon: state.code == 200 ? 
                        const Icon(Icons.check_circle): const Icon(Icons.error_outline_rounded),
                content: Text(state.message),
                actions: <Widget>[
                  TextButton(
                    child: const Text('OK'),
                    onPressed: () {
                      context.read<PasswordRequiredBloc>().add(PasswordRequiredAlertBtnOKClicked());
                    },
                  ),
                ],
              );
            }
            return Stack(
              children: [
                Column(
                  children: [
                    Padding(padding: EdgeInsets.only(top: ratio*50),
                      child: Text('Please fill in your current password to continue',
                        style: TextStyle(
                          fontFamily: 'Play',
                          fontSize: ratio*35,
                          color: Colors.white
                        ),
                      )
                    ),
                    RequiredPasswordInput(),
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
                          onPressed: state.status == FormzStatus.valid ?
                          () {
                            context.read<PasswordRequiredBloc>().add(PasswordRequiredBtnContinueClicked(isBtnDisabled: true));
                          } : null,
                          child: Text('Continue'.toUpperCase(),
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
                state.status == FormzStatus.submissionInProgress || state.status == FormzStatus.submissionFailure ?
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
    );
  }
}

//password field
class RequiredPasswordInput extends StatefulWidget {
  RequiredPasswordInput({Key? key}):super(key: key);

  @override
  State<RequiredPasswordInput> createState() => _RequiredPasswordInputState();
}

class _RequiredPasswordInputState extends State<RequiredPasswordInput> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double ratio = size.width / size.height;

    return BlocBuilder<PasswordRequiredBloc, PasswordRequiredState>(
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.only(top: 20 , bottom: 40, left: 20, right: 20),
          child: TextField(
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
              errorText: state.password.invalid ? "Current password is required" : null,
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
            onChanged: (value) => context.read<PasswordRequiredBloc>().add(PasswordRequiredPasswordInputChanged(password: value)),
          )
        );
      }
    );
  }
}
