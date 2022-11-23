import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gamble/src/screens/users/wallet_deposit/views/vnpay_deposit.dart';
import 'package:gamble/src/screens/users/wallet_deposit/wallet_deposit.dart';
import 'package:gamble/src/services/transaction_service.dart';
import 'package:formz/formz.dart';
import 'package:gamble/src/utils/helpers.dart';
import 'package:url_launcher/url_launcher.dart';

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
      child: RepositoryProvider(
        create: (context) => TransactionManagement(),
        child: BlocProvider(
          create: (context) => WalletDepositBloc(RepositoryProvider.of<TransactionManagement>(context))..add(WalletDepositInitial()),
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
                  const DepositSubmitButton()
                ]
              )
            )
          )
        ),
      )
    );
  }
}

//deposit button
class DepositSubmitButton extends StatefulWidget {
  const DepositSubmitButton({super.key});

  @override
  State<DepositSubmitButton> createState() => _DepositSubmitButtonState();
}

class _DepositSubmitButtonState extends State<DepositSubmitButton> {
  late WalletDepositBloc walletDepositBloc;
  bool isClicked = false;

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
    walletDepositBloc = context.read<WalletDepositBloc>();
  }
  
  Future<VNPay?> _vnpayDepositWebView(String amount, int method) async {
    walletDepositBloc.add(WalletDepositSubmitted(isBtnDisabled: false));
    return await walletDepositBloc.transactionService.depositVNPay(amount, method);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double ratio = size.width / size.height;

    return BlocBuilder<WalletDepositBloc, WalletDepositState>(
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
              key: const Key('WalletDeposit_submitBtn'),
              onPressed: state.status == FormzStatus.valid ?
                () async {
                  switch (state.method) {
                    case 0:
                      //9704198526191432198
                      walletDepositBloc.add(WalletDepositSubmitted(isBtnDisabled: true));
                      Helpers.loadingAlert(context);
                      Future.delayed(const Duration(milliseconds: 500), () async {
                        Navigator.pop(context);
                        var vnpay = await _vnpayDepositWebView(state.amount.value, state.method);
                        if(vnpay!.code != 200 && vnpay.amount != null){
                          _showErrorMessage(vnpay.amount.toString());
                        } else {
                        // ignore: use_build_context_synchronously
                          Navigator.push(context, 
                            MaterialPageRoute(builder: ((context) {
                              return VNPayDeposit(url: Uri.parse(vnpay.data.toString()));
                            }))
                          );
                        }
                      });
                      break;
                    case 1:
                      print('hehe: ${state.method}');
                      if (!await launchUrl(
                        Uri.parse("https://google.com/"),
                        mode: LaunchMode.externalNonBrowserApplication,
                        webViewConfiguration: const WebViewConfiguration(
                            headers: <String, String>{'my_header_key': 'my_header_value'}),
                      )) {
                        throw 'Could not launch';
                      }
                      break;
                    case 2:
                      print('hehe: ${state.method}');

                      break;
                  }
                  
                } 
                : null,
              child: Text('Deposit'.toUpperCase(),
                style: TextStyle(
                  color: Colors.white,
                  fontSize: ratio * 40,
                  fontFamily: "Play"
                )
              ),
            )
          )
        );
      }
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

    return BlocBuilder<WalletDepositBloc, WalletDepositState>(
      builder: (context, state) {
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
              errorStyle: const TextStyle(color: Color.fromARGB(255, 195, 66, 66)),
              errorText: state.amount.invalid ? 'Amount is required' : null,
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
            onChanged: (amount) => context.read<WalletDepositBloc>().add(WalletDepositAmountChanged(amount)),
          )
        );
      },
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

    return BlocBuilder<WalletDepositBloc, WalletDepositState>(
      builder: (context, state) {
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
                    context.read<WalletDepositBloc>().add(WalletDepositMethodChanged(_paymentMethod!.index));
                  },
                ),
              ),
              // ListTile(
              //   textColor: Colors.white,
              //   title: const Text('Momo'),
              //   horizontalTitleGap: 0,
              //   leading: Radio<PaymentMethods>(
              //     fillColor: const MaterialStatePropertyAll(Colors.white),
              //     value: PaymentMethods.momo,
              //     groupValue: _paymentMethod,
              //     onChanged: (PaymentMethods? value) {
              //       setState(() {
              //         _paymentMethod = value;
              //       });
              //       context.read<WalletDepositBloc>().add(WalletDepositMethodChanged(_paymentMethod!.index));
              //     },
              //   ),
              // ),
              // ListTile(
              //   textColor: Colors.white,
              //   title: const Text('Bitcoin'),
              //   horizontalTitleGap: 0,
              //   leading: Radio<PaymentMethods>(
              //     fillColor: const MaterialStatePropertyAll(Colors.white),
              //     value: PaymentMethods.bitcoin,
              //     groupValue: _paymentMethod,
              //     onChanged: (PaymentMethods? value) {
              //       setState(() {
              //         _paymentMethod = value;
              //       });
              //       context.read<WalletDepositBloc>().add(WalletDepositMethodChanged(_paymentMethod!.index));
              //     },
              //   ),
              // )
            ],
          )
        );
      }
    );
  }
}
