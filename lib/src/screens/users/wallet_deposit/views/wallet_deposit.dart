import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WalletDeposit extends StatefulWidget {
  const WalletDeposit({super.key});

  @override
  State<WalletDeposit> createState() => _WalletDepositState();
}

class _WalletDepositState extends State<WalletDeposit> {
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
          title: Text('Deposit', 
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
                    DepositAmountInput(),
                    DepositPaymentMethodRadioGroup(),
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
                    child: Text('Proceed payment'.toUpperCase(),
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

//DepositAmountInput
class DepositAmountInput extends StatefulWidget {
  const DepositAmountInput({super.key});

  @override
  State<DepositAmountInput> createState() => _DepositAmountInputState();
}

class _DepositAmountInputState extends State<DepositAmountInput> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double ratio = size.width / size.height;

    return Padding(
      padding: const EdgeInsets.only(top: 40 , bottom: 40, left: 20, right: 20),
      child: TextField(
        key: const Key('WalletDeposit_amountField'),
        keyboardType: TextInputType.text,
        style: const TextStyle(color: Color.fromRGBO(255, 255, 255, 1)),
        decoration: InputDecoration(
          hintText: "Enter desired amount",
          hintStyle: TextStyle(color: Colors.white),
          labelText: 'Deposit amount',
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

//radios
class DepositPaymentMethodRadioGroup extends StatefulWidget {
  const DepositPaymentMethodRadioGroup({Key? key}):super(key: key);

  @override
  State<DepositPaymentMethodRadioGroup> createState() => _DepositPaymentMethodRadioGroupState();
}
enum PaymentMethods { vnpay, momo, bitcoin }

class _DepositPaymentMethodRadioGroupState extends State<DepositPaymentMethodRadioGroup> {
  PaymentMethods? _paymentMethod = PaymentMethods.vnpay;

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
            child: Text("Payment methods",
              style: TextStyle(
                fontFamily: "Play",
                fontSize: ratio * 35,
                color: Colors.white,
              )
            ),
          ),
          ListTile(
            tileColor: Colors.transparent,
            textColor: Colors.white,
            title: const Text('VNPay'),
            horizontalTitleGap: 0,
            leading: Radio<PaymentMethods>(
              fillColor: const MaterialStatePropertyAll(Colors.white),
              value: PaymentMethods.vnpay,
              groupValue: _paymentMethod,
              onChanged: (PaymentMethods? value) {
                setState(() {
                  _paymentMethod = value;
                });
              },
            ),
          ),
          ListTile(
            textColor: Colors.white,
            title: const Text('Momo'),
            horizontalTitleGap: 0,
            leading: Radio<PaymentMethods>(
              fillColor: const MaterialStatePropertyAll(Colors.white),
              value: PaymentMethods.momo,
              groupValue: _paymentMethod,
              onChanged: (PaymentMethods? value) {
                setState(() {
                  _paymentMethod = value;
                });
              },
            ),
          ),
          ListTile(
            textColor: Colors.white,
            title: const Text('Bitcoin'),
            horizontalTitleGap: 0,
            leading: Radio<PaymentMethods>(
              fillColor: const MaterialStatePropertyAll(Colors.white),
              value: PaymentMethods.bitcoin,
              groupValue: _paymentMethod,
              onChanged: (PaymentMethods? value) {
                setState(() {
                  _paymentMethod = value;
                });
              },
            ),
          )
        ],
      )
    );
  }
}
