import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
        body: 
        SingleChildScrollView(
          child: 
          Column(
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
              Padding(
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
                    onPressed: () {},
                    child: Text('Transfer'.toUpperCase(),
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
          errorStyle: const TextStyle(color: Color.fromRGBO(255, 255, 255, 1)),
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
        )
      )
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
          errorStyle: const TextStyle(color: Color.fromRGBO(255, 255, 255, 1)),
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
        )
      )
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
        )
      )
    );
  }
}
