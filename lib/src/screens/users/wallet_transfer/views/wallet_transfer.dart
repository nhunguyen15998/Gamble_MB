// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:gamble/src/screens/users/password_required/views/password_required.dart';
import 'package:gamble/src/screens/users/transaction_results/views/transaction_result.dart';
import 'package:gamble/src/screens/users/wallet_transfer/bloc/wallet_transfer_bloc.dart';
import 'package:gamble/src/services/transaction_service.dart';
import 'package:gamble/src/utils/helpers.dart';

class WalletTransfer extends StatefulWidget {
  const WalletTransfer({super.key});

  @override
  State<WalletTransfer> createState() => _WalletTransferState();
}

class _WalletTransferState extends State<WalletTransfer> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double ratio = size.width / size.height;
    
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: RepositoryProvider(
        create: (context) => TransactionManagement(),
        child: BlocProvider(
          create: (context) => WalletTransferBloc(RepositoryProvider.of<TransactionManagement>(context))..add(WalletTransferInitial()),
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
              title: Text('Transfer', 
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
            body: const TransferBody()
          ),
        ),
      )
    );
  }
}

//body
class TransferBody extends StatefulWidget {
  const TransferBody({super.key});

  @override
  State<TransferBody> createState() => _TransferBodyState();
}

class _TransferBodyState extends State<TransferBody> {
  late WalletTransferBloc walletTransferBloc;
  
  Future<Map<String, dynamic>> tranferProccess(String transfer, String path) async {
    walletTransferBloc.add(TransferBtnClicked(isBtnDisabled: false));
    return await walletTransferBloc.transactionService.transfer(transfer, path);
  }

  Future<void> _showErrorMessage(String err) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Error'),
          content: Text(err),
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
  void initState() {
    super.initState();
    walletTransferBloc = context.read<WalletTransferBloc>();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double ratio = size.width / size.height;

    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            height: size.height*0.8,
            width: size.width,
            child: Column(
              children: const [
                TransferPhoneInput(),
                TransferAmountInput(),
                TransferNoteInput()
              ],
            )
          ),
          BlocBuilder<WalletTransferBloc, WalletTransferState>(
            builder: (context, state) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 40, left: 20, right: 20),
                child: SizedBox(
                  width: double.infinity,
                  height: ratio * 100,
                  child: ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(
                            Color.fromARGB(255, 250, 137, 0)),
                        shape: MaterialStateProperty.all(RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(ratio * 50)))),
                    key: const Key('ProfileForm_submitBtn'),
                    onPressed: state.status == FormzStatus.valid && !state.isBtnDisabled ?
                    () {
                      walletTransferBloc.add(TransferBtnClicked(isBtnDisabled: true));
                      final phone = state.phone.value;
                      final amount = state.amount.value;
                      final note = state.note;
                      final transfer = {
                        "phone":phone,
                        "amount":amount,
                        "notes":note
                      };
                      Helpers.loadingAlert(context);
                      Future.delayed(const Duration(milliseconds: 500), () async {
                        Navigator.pop(context);
                        final result = await tranferProccess(jsonEncode(transfer), 'transferProccess');
                        var code = result['code'];
                        var resultPhone = result['phone'];
                        var resultamount = result['amount'];
                        var message = result['message'];
                        if(code != 200 && resultamount != null){
                          _showErrorMessage(resultamount.toString());
                        } else if(code != 200 && message != null){
                          if(code == 406){
                            Navigator.push(context, 
                              MaterialPageRoute(builder: (context) {
                                return RequiredPassword(path: 'transferProccessWithPassword', data: transfer, type: 'transfer');
                              })
                            );
                          } else {
                            _showErrorMessage(message.toString());  
                          }
                        } else if(code != 200 && resultPhone != null){
                          _showErrorMessage(resultPhone.toString());
                        } else {
                          Navigator.push(context, 
                            MaterialPageRoute(builder: ((context) {
                              var textStyle = TextStyle(color: const Color.fromARGB(255, 32, 150, 36), fontFamily: 'Play', fontSize: ratio*40);
                              var image = Image.asset('lib/assets/images/successful-transaction.png', width: ratio*200);
                              if(code != 200){
                                textStyle = TextStyle(color: const Color.fromARGB(255, 195, 39, 39), fontFamily: 'Play', fontSize: ratio*40);
                                image = Image.asset('lib/assets/images/failed-transaction.png');
                              } 
                              return TransactionResult(text: message+phone, textStyle: textStyle, image: image);
                            }))
                          );
                        }
                      });
                    } : null,
                    child: Text('Transfer'.toUpperCase(),
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: ratio * 40,
                        fontFamily: "Play"
                      )
                    ),
                  )
                )
              );
            },
          )
        ]
      )
    );
  }
}

//TransferPhoneInput
class TransferPhoneInput extends StatefulWidget {
  const TransferPhoneInput({super.key});

  @override
  State<TransferPhoneInput> createState() => _TransferPhoneInputState();
}

class _TransferPhoneInputState extends State<TransferPhoneInput> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double ratio = size.width / size.height;

    return BlocBuilder<WalletTransferBloc, WalletTransferState>(
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.only(top: 40 , bottom: 20, left: 20, right: 20),
          child: TextField(
            key: const Key('WalletTransfer_phoneField'),
            keyboardType: TextInputType.text,
            style: const TextStyle(color: Color.fromRGBO(255, 255, 255, 1)),
            decoration: InputDecoration(
              hintText: "Enter receiver phone",
              hintStyle: TextStyle(color: Colors.white),
              labelText: 'Phone',
              labelStyle: TextStyle(
                fontSize: ratio * 35,
                color: const Color.fromRGBO(255, 255, 255, 1),
                fontFamily: "Play"
              ),
              errorStyle: const TextStyle(color: Color.fromARGB(255, 195, 66, 66)),
              errorText: state.phone.invalid ? "Phone is required" : null,
              contentPadding: EdgeInsets.all(ratio*30),
              filled: true,
              fillColor: Colors.white.withOpacity(0.2),
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
            onChanged: (value) => context.read<WalletTransferBloc>().add(TransferPhoneChanged(phone: value)),
          )
        );
      },
    );
  }
}

//TransferAmountInput
class TransferAmountInput extends StatefulWidget {
  const TransferAmountInput({super.key});

  @override
  State<TransferAmountInput> createState() => _TransferAmountInputState();
}

class _TransferAmountInputState extends State<TransferAmountInput> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double ratio = size.width / size.height;

    return BlocBuilder<WalletTransferBloc, WalletTransferState>(
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.only(top: 20 , bottom: 20, left: 20, right: 20),
          child: TextField(
            key: const Key('WalletTransfer_amountField'),
            keyboardType: TextInputType.text,
            style: const TextStyle(color: Color.fromRGBO(255, 255, 255, 1)),
            decoration: InputDecoration(
              hintText: "Enter desired amount",
              hintStyle: TextStyle(color: Colors.white),
              labelText: 'Transfer amount',
              labelStyle: TextStyle(
                fontSize: ratio * 35,
                color: const Color.fromRGBO(255, 255, 255, 1),
                fontFamily: "Play"
              ),
              errorStyle: const TextStyle(color: Color.fromARGB(255, 195, 66, 66)),
              errorText: state.amount.invalid ? "Amount is required" : null,
              contentPadding: EdgeInsets.all(ratio*30),
              filled: true,
              fillColor: Colors.white.withOpacity(0.2),
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
            onChanged: (value) => context.read<WalletTransferBloc>().add(TransferAmountChanged(amount: value)),
          )
        );
      },
    );
  }
}

//TransferNoteInput
class TransferNoteInput extends StatefulWidget {
  const TransferNoteInput({super.key});

  @override
  State<TransferNoteInput> createState() => _TransferNoteInputState();
}

class _TransferNoteInputState extends State<TransferNoteInput> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double ratio = size.width / size.height;

    return BlocBuilder<WalletTransferBloc, WalletTransferState>(
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.only(top: 20 , bottom: 40, left: 20, right: 20),
          child: TextField(
            key: const Key('WalletTransfer_noteField'),
            keyboardType: TextInputType.text,
            maxLines: 4,
            style: const TextStyle(color: Color.fromRGBO(255, 255, 255, 1)),
            decoration: InputDecoration(
              hintText: "Enter notes",
              hintStyle: TextStyle(color: Colors.white),
              alignLabelWithHint: true,
              labelText: 'Notes',
              labelStyle: TextStyle(
                fontSize: ratio * 35,
                color: const Color.fromRGBO(255, 255, 255, 1),
                fontFamily: "Play"
              ),
              errorStyle: const TextStyle(color: Color.fromRGBO(255, 255, 255, 1)),
              contentPadding: EdgeInsets.all(ratio*30),
              filled: true,
              fillColor: Colors.white.withOpacity(0.2),
              focusedBorder: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(20)),
                borderSide: BorderSide(color: Color.fromRGBO(250, 0, 159, 1), width: 1)
              ),
              enabledBorder: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(20)),
                borderSide: BorderSide(
                color: Color.fromRGBO(210, 213, 252, 1), width: 1)
              ),
              errorBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(20)),
              borderSide: BorderSide(
              color: Color.fromRGBO(218, 62, 59, 1), width: 1)
              ),
              focusedErrorBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(20)),
              borderSide: BorderSide(
              color: Color.fromRGBO(218, 62, 59, 1), width: 1)
              )
            ),
            onChanged: (value) => context.read<WalletTransferBloc>().add(TransferNoteChanged(note: value)),
          )
        );
      },
    );
  }
}
