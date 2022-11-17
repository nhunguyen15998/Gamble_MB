import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gamble/src/screens/master/views/master.dart';
import 'package:gamble/src/screens/users/wallet_deposit/wallet_deposit.dart';
import 'package:gamble/src/screens/users/wallet_withdraw/bloc/wallet_withdraw_bloc.dart';
import 'package:gamble/src/services/transaction_service.dart';

class TransactionResult extends StatefulWidget {
  TransactionResult({Key? key, required this.text, this.textStyle, this.image}):super(key: key);

  String text;
  TextStyle? textStyle;
  Image? image;

  @override
  State<TransactionResult> createState() => _TransactionResultState();
}

class _TransactionResultState extends State<TransactionResult> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double ratio = size.width / size.height;
    
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: SafeArea(
        child: Scaffold(
          body: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  height: size.height*0.86,
                  width: size.width,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      widget.image ?? const SizedBox(),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: ratio*50, vertical: ratio*30),
                        child: Text(widget.text, style: widget.textStyle ?? const TextStyle(color: Colors.black))
                      )
                    ]
                  )
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  child: SizedBox(
                    width: double.infinity,
                    height: ratio * 100,
                    child: ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(Color.fromARGB(255, 52, 5, 97)),
                          shape: MaterialStateProperty.all(RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(ratio * 50)))),
                      key: const Key('ProfileForm_submitBtn'),
                      onPressed: () {
                        Navigator.push(context, 
                          MaterialPageRoute(builder: ((context) {
                            return const Master(index: 0);
                          }))
                        );
                      },
                      child: Text('Home'.toUpperCase(),
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
      )
    );
  }
}



