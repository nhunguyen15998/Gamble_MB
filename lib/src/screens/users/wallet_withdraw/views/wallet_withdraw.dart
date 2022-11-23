// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gamble/src/screens/master/master.dart';
import 'package:gamble/src/screens/users/password_required/views/password_required.dart';
import 'package:gamble/src/screens/users/transaction_results/views/transaction_result.dart';
import 'package:gamble/src/screens/users/wallet_withdraw/bloc/wallet_withdraw_bloc.dart';
import 'package:gamble/src/screens/users/wallet_withdraw/models/address.dart';
import 'package:gamble/src/services/transaction_service.dart';
import 'package:formz/formz.dart';
import 'package:gamble/src/utils/helpers.dart';
import 'package:intl/intl.dart';

class WalletWithdraw extends StatefulWidget {
  const WalletWithdraw({super.key});

  @override
  State<WalletWithdraw> createState() => _WalletWithdrawState();
}

class _WalletWithdrawState extends State<WalletWithdraw> with TickerProviderStateMixin {
  late TabController tabController;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double ratio = size.width / size.height;
    
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: RepositoryProvider(
        create:(context) => TransactionManagement(),
        child: BlocProvider(
          create: (context) => WalletWithdrawBloc(RepositoryProvider.of<TransactionManagement>(context))..add(WalletWithdrawBankInitial()),
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
              title: Text('Withdraw', 
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
            body: Column(
              children: [
                //TABS
                SizedBox(
                  child: DecoratedBox(
                    decoration: const BoxDecoration(
                      color: Colors.transparent,
                      // color: Color.fromARGB(255, 105, 109, 179),
                    ),
                    child: BlocBuilder<WalletWithdrawBloc, WalletWithdrawState>(
                      builder: (context, state) {
                        return TabBar(
                          controller: tabController,
                          indicatorColor: const Color.fromRGBO(250, 0, 159, 1),
                          onTap: (selectedTab){
                            print("selectedTab: $selectedTab");
                            selectedTab == 0 ? 
                              context.read<WalletWithdrawBloc>().add(WalletWithdrawBankInitial())
                            : context.read<WalletWithdrawBloc>().add(WalletWithdrawBitcoinInitial());
                          },
                          tabs: <Widget>[
                            Tab(
                              child: Text('Bank',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: 'Play',
                                  fontSize: ratio*35
                                ),
                              )
                            ),
                            Tab(
                              child: Text('Bitcoin',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: 'Play',
                                  fontSize: ratio*35
                                ),
                              )
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ),
                Expanded(
                  child: DecoratedBox(
                    decoration: const BoxDecoration(
                      color: Colors.transparent,
                    ),
                    child: TabBarView(
                      controller: tabController,
                      children: <Widget>[
                        //FORM1
                        BlocBuilder<WalletWithdrawBloc, WalletWithdrawState>(
                          builder: (context, state) {
                            if(state is WalletWithdrawBankInitialized){
                              WalletWithdrawBankInitialized walletWithdrawBank = state;
                              var calculatedAmount = NumberFormat.currency(customPattern: "#,###.#", decimalDigits: 3).format(walletWithdrawBank.tempBankBalance);
                              return SingleChildScrollView(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    WithdrawAccountNameInput(),
                                    WithdrawAccountNumberInput(),
                                    WithdrawBankInput(),
                                    WithdrawBankAmountInput(),
                                    WithdrawNotesInput(),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 20),
                                      child: Text('Exchange rate: 1 VND =  ${walletWithdrawBank.bankExRate} USD',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontFamily: 'Play',
                                          fontSize: ratio*25
                                        ),
                                      )
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 20, right: 20, top: 5, bottom: 20),
                                      child: Text('Remaining amount after withdraw proccess will be: \$$calculatedAmount',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontFamily: 'Play',
                                          fontSize: ratio*25
                                        ),
                                      )
                                    ),
                                    WithdrawBankProceedButton()
                                  ],
                                )
                              );
                            }
                            return const Center(child: CircularProgressIndicator());
                          }
                        ),
                        //FORM2
                        BlocBuilder<WalletWithdrawBloc, WalletWithdrawState>(
                          builder: (context, state) {
                            if(state is WalletWithdrawBitcoinInitialized){
                              WalletWithdrawBitcoinInitialized walletWithdrawBitcoin = state;
                              var calculatedAmount = NumberFormat.currency(customPattern: "#,###.#", decimalDigits: 3).format(walletWithdrawBitcoin.tempBitcoinBalance);
                              return SingleChildScrollView(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        SizedBox(
                                          width: size.width*0.85,
                                          child: WithdrawBitcoinAmountInput()
                                        ),
                                        Expanded(
                                          child: Padding(
                                            padding: const EdgeInsets.only(top: 40, bottom: 20, right: 20),
                                            child: Text('BTC', 
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontFamily: 'Play',
                                                fontSize: ratio*35
                                              )
                                            )
                                          )
                                        )
                                      ],
                                    ),
                                    WithdrawBitcoinAddressInput(),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 20),
                                      child: Text('Exchange rate: 1 VND =  ${walletWithdrawBitcoin.bitcoinExRate} USD',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontFamily: 'Play',
                                          fontSize: ratio*25
                                        ),
                                      )
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 20, right: 20, top: 5, bottom: 20),
                                      child: Text('Remaining amount after withdraw proccess will be: \$$calculatedAmount',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontFamily: 'Play',
                                          fontSize: ratio*25
                                        ),
                                      )
                                    ),
                                    WithdrawBitcoinProceedButton()
                                  ],
                                ),
                              );
                            }
                            return const Center(child: CircularProgressIndicator());
                          }
                        ),
                      ]
                    )
                  )
                ),
              ]
            )
          )
        )
      )
    );
  }
}

//WithdrawAccountNameInput
class WithdrawAccountNameInput extends StatefulWidget {
  const WithdrawAccountNameInput({super.key});

  @override
  State<WithdrawAccountNameInput> createState() => WithdrawAccountNameInputState();
}

class WithdrawAccountNameInputState extends State<WithdrawAccountNameInput> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double ratio = size.width / size.height;

    return BlocBuilder<WalletWithdrawBloc, WalletWithdrawState>(
      builder: (context, state) {
        if(state is WalletWithdrawBankInitialized){
          return Padding(
            padding: const EdgeInsets.only(top: 40, bottom: 20, left: 20, right: 20),
            child: TextField(
              key: const Key('WalletWithdraw_accountNameField'),
              keyboardType: TextInputType.text,
              style: const TextStyle(color: Color.fromRGBO(255, 255, 255, 1)),
              decoration: InputDecoration(
                hintText: "Enter account name",
                hintStyle: const TextStyle(color: Colors.white),
                labelText: 'Account name',
                labelStyle: TextStyle(
                  fontSize: ratio * 35,
                  color: const Color.fromRGBO(255, 255, 255, 1),
                  fontFamily: "Play"
                ),
                errorStyle: const TextStyle(color: Color.fromARGB(255, 195, 66, 66)),
                errorText: state.accountName.invalid ? 'Account name is required' : null,
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
              onChanged: (value) => context.read<WalletWithdrawBloc>().add(WalletWithdrawAccountNameChanged(accountName: value)),
            )
          );
        }
        return const SizedBox();
      },
    );
  }
}

//WithdrawAccountNumberInput
class WithdrawAccountNumberInput extends StatefulWidget {
  const WithdrawAccountNumberInput({super.key});

  @override
  State<WithdrawAccountNumberInput> createState() => _WithdrawAccountNumberInputState();
}

class _WithdrawAccountNumberInputState extends State<WithdrawAccountNumberInput> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double ratio = size.width / size.height;

    return BlocBuilder<WalletWithdrawBloc, WalletWithdrawState>(
      builder: (context, state) {
        if(state is WalletWithdrawBankInitialized){
          return Padding(
            padding: const EdgeInsets.only(top: 20, bottom: 20, left: 20, right: 20),
            child: TextField(
              key: const Key('WalletWithdraw_accountNumberField'),
              keyboardType: TextInputType.text,
              style: const TextStyle(color: Color.fromRGBO(255, 255, 255, 1)),
              decoration: InputDecoration(
                hintText: "Enter account number",
                hintStyle: const TextStyle(color: Colors.white),
                labelText: 'Account number',
                labelStyle: TextStyle(
                  fontSize: ratio * 35,
                  color: const Color.fromRGBO(255, 255, 255, 1),
                  fontFamily: "Play"
                ),
                errorStyle: const TextStyle(color: Color.fromARGB(255, 195, 66, 66)),
                errorText: state.accountNumber.invalid ? 'Account number is required' : null,
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
              onChanged: (value) => context.read<WalletWithdrawBloc>().add(WalletWithdrawAccountNumberChanged(accountNumber: value)),
            )
          );
        }
        return const SizedBox();
      },
    );
  }
}

//WithdrawBankInput
class WithdrawBankInput extends StatefulWidget {
  const WithdrawBankInput({super.key});

  @override
  State<WithdrawBankInput> createState() => _WithdrawBankInputState();
}

class _WithdrawBankInputState extends State<WithdrawBankInput> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double ratio = size.width / size.height;

    return BlocBuilder<WalletWithdrawBloc, WalletWithdrawState>(
      builder: (context, state) {
        if(state is WalletWithdrawBankInitialized){
          return Padding(
            padding: const EdgeInsets.only(top: 20, bottom: 20, left: 20, right: 20),
            child: TextField(
              key: const Key('WalletWithdraw_bankField'),
              keyboardType: TextInputType.text,
              style: const TextStyle(color: Color.fromRGBO(255, 255, 255, 1)),
              decoration: InputDecoration(
                hintText: "Enter bank",
                hintStyle: const TextStyle(color: Colors.white),
                labelText: 'Bank',
                labelStyle: TextStyle(
                  fontSize: ratio * 35,
                  color: const Color.fromRGBO(255, 255, 255, 1),
                  fontFamily: "Play"
                ),
                errorStyle: const TextStyle(color: Color.fromARGB(255, 195, 66, 66)),
                errorText: state.bank.invalid ? 'Bank is required' : null,
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
                color: Color.fromARGB(255, 195, 66, 66), width: 1)
                ),
                focusedErrorBorder: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(50)),
                borderSide: BorderSide(
                color: Color.fromRGBO(218, 62, 59, 1), width: 1)
                )
              ),
              onChanged: (value) => context.read<WalletWithdrawBloc>().add(WalletWithdrawBankChanged(bank: value)),
            )
          );
        }
        return const SizedBox();
      },
    );
  }
}

//WithdrawAmountInput
class WithdrawBankAmountInput extends StatefulWidget {
  const WithdrawBankAmountInput({super.key});

  @override
  State<WithdrawBankAmountInput> createState() => _WithdrawBankAmountInputState();
}

class _WithdrawBankAmountInputState extends State<WithdrawBankAmountInput> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double ratio = size.width / size.height;

    return BlocBuilder<WalletWithdrawBloc, WalletWithdrawState>(
      builder: (context, state) {
        if(state is WalletWithdrawBankInitialized){
          return Padding(
            padding: const EdgeInsets.only(top: 20, bottom: 20, left: 20, right: 20),
            child: Row(
              children: [
                Expanded(
                  flex: 6,
                  child: TextField(
                    key: const Key('WalletWithdraw_amountField'),
                    keyboardType: TextInputType.text,
                    style: const TextStyle(color: Color.fromRGBO(255, 255, 255, 1)),
                    decoration: InputDecoration(
                      hintText: "Enter desired amount",
                      hintStyle: const TextStyle(color: Colors.white),
                      labelText: 'Withdraw amount',
                      labelStyle: TextStyle(
                        fontSize: ratio * 35,
                        color: const Color.fromRGBO(255, 255, 255, 1),
                        fontFamily: "Play"
                      ),
                      errorStyle: const TextStyle(color: Color.fromARGB(255, 195, 66, 66)),
                      errorText: state.bankAmount.invalid ? 'Amount is required' : null,
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
                      color: Color.fromARGB(255, 195, 66, 66), width: 1)
                      ),
                      focusedErrorBorder: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(50)),
                      borderSide: BorderSide(
                      color: Color.fromRGBO(218, 62, 59, 1), width: 1)
                      )
                    ),
                    onChanged: (value) => context.read<WalletWithdrawBloc>().add(WalletWithdrawBankAmountChanged(bankAmount: value)),
                  )
                ),
                Expanded(
                  child: Text('VND',
                  textAlign: TextAlign.end,
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'Play',
                      fontSize: ratio*35
                    ),
                  )
                )
              ]
            )
          );
        }
        return const SizedBox();
      },
    );
  }
}

//WithdrawNotesInput
class WithdrawNotesInput extends StatefulWidget {
  const WithdrawNotesInput({super.key});

  @override
  State<WithdrawNotesInput> createState() => _WithdrawNotesInputState();
}

class _WithdrawNotesInputState extends State<WithdrawNotesInput> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double ratio = size.width / size.height;

    return BlocBuilder<WalletWithdrawBloc, WalletWithdrawState>(
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.only(top: 20, bottom: 20, left: 20, right: 20),
          child: TextField(
            key: const Key('WalletWithdraw_notesField'),
            maxLines: 4,
            keyboardType: TextInputType.text,
            style: const TextStyle(color: Color.fromRGBO(255, 255, 255, 1)),
            decoration: InputDecoration(
              hintText: "Enter notes",
              hintStyle: const TextStyle(color: Colors.white),
              alignLabelWithHint: true,
              label: Text('Notes',
                style: TextStyle(
                  fontSize: ratio * 35,
                  color: const Color.fromRGBO(255, 255, 255, 1),
                  fontFamily: "Play"
                )
              ),
              errorStyle: const TextStyle(color: Color.fromARGB(255, 195, 66, 66)),
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
            onChanged: (value) => context.read<WalletWithdrawBloc>().add(WalletWithdrawNoteChanged(note: value)),
          )
        );
      }
    );
  }
}

//WithdrawBankProceedButton
class WithdrawBankProceedButton extends StatefulWidget {
  const WithdrawBankProceedButton({super.key});

  @override
  State<WithdrawBankProceedButton> createState() => _WithdrawBankProceedButtonState();
}

class _WithdrawBankProceedButtonState extends State<WithdrawBankProceedButton> {
  late WalletWithdrawBloc walletWithdrawBloc;

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
    walletWithdrawBloc = context.read<WalletWithdrawBloc>();
  }
  
  Future<Map<String, dynamic>> _bankWithdraw(String withdrawBank, String path) async {
    walletWithdrawBloc.add(WalletWithdrawBankRequestSubmitted(isBtnDisabled: false));
    return await walletWithdrawBloc.transactionService.withdrawBank(withdrawBank, path);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double ratio = size.width / size.height;

    return BlocBuilder<WalletWithdrawBloc, WalletWithdrawState>(
      builder: (context, state) {
        if(state is WalletWithdrawBankInitialized){
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
                onPressed: state.status == FormzStatus.valid && !state.isBtnDisabled ?
                () {
                  walletWithdrawBloc.add(WalletWithdrawBankRequestSubmitted(isBtnDisabled: true));
                  WalletWithdrawBankInitialized walletWithdrawBank = state;
                  if(walletWithdrawBank.status.isValidated){      
                    Helpers.loadingAlert(context);
                    Future.delayed(const Duration(milliseconds: 500), () async {
                      Navigator.pop(context);
                      var withdrawBank = {
                        "account_name": walletWithdrawBank.accountName.value,
                        "account_number": walletWithdrawBank.accountNumber.value,
                        "bank": walletWithdrawBank.bank.value,
                        "bank_amount": walletWithdrawBank.bankAmount.value,
                        "notes": walletWithdrawBank.note
                      };
                      var withdraw = await _bankWithdraw(jsonEncode(withdrawBank), 'withdrawBankProccess');
                      var code = withdraw['code'];
                      var message = withdraw['message'];
                      var amount = withdraw['amount'];
                      if(code != 200 && amount != null){
                        _showErrorMessage(amount.toString());
                      } else if(code != 200 && message != null){
                        if(code == 406){
                            Navigator.push(context, 
                              MaterialPageRoute(builder: (context) {
                                return RequiredPassword(path: 'withdrawBankProccessWithPassword', data: withdrawBank, type: 'withdrawBank');
                              })
                            );
                          } else {
                            _showErrorMessage(message.toString());  
                          }
                      } else {
                        Navigator.push(context, 
                          MaterialPageRoute(builder: ((context) {
                            var textStyle = TextStyle(color: const Color.fromARGB(255, 32, 150, 36), fontFamily: 'Play', fontSize: ratio*40);
                            var image = Image.asset('lib/assets/images/successful-transaction.png', width: ratio*200);
                            if(code != 200){
                              textStyle = TextStyle(color: const Color.fromARGB(255, 195, 39, 39), fontFamily: 'Play', fontSize: ratio*40);
                              image = Image.asset('lib/assets/images/failed-transaction.png');
                            } 
                            return TransactionResult(text: message, textStyle: textStyle, image: image);
                          }))
                        );
                      }
                    });  
                  }
                } : null,
                child: Text('Request'.toUpperCase(),
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
        return const SizedBox();
      },
    );
  }
}
class LoadingWithdrawBankResult extends StatelessWidget {
  const LoadingWithdrawBankResult({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: CircularProgressIndicator());
  }
}

// ########################### BITCOIN #########################

//WithdrawAmountInput
class WithdrawBitcoinAmountInput extends StatefulWidget {
  WithdrawBitcoinAmountInput({Key? key}):super(key: key);

  @override
  State<WithdrawBitcoinAmountInput> createState() => _WithdrawBitcoinAmountInputState();
}

class _WithdrawBitcoinAmountInputState extends State<WithdrawBitcoinAmountInput> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double ratio = size.width / size.height;

    return BlocBuilder<WalletWithdrawBloc, WalletWithdrawState>(
      builder: (context, state) {
        if(state is WalletWithdrawBitcoinInitialized){
          return Padding(
            padding: const EdgeInsets.only(top: 40, bottom: 20, left: 20, right: 20),
            child: TextField(
              key: const Key('WalletWithdraw_amountBitcoinField'),
              keyboardType: TextInputType.number,
              style: const TextStyle(color: Color.fromRGBO(255, 255, 255, 1)),
              decoration: InputDecoration(
                hintText: "Enter desired amount",
                hintStyle: const TextStyle(color: Colors.white),
                labelText: 'Withdraw amount',
                labelStyle: TextStyle(
                  fontSize: ratio * 35,
                  color: const Color.fromRGBO(255, 255, 255, 1),
                  fontFamily: "Play"
                ),
                errorStyle: const TextStyle(color: Color.fromARGB(255, 195, 66, 66)),
                errorText: state.bitcoinAmount.invalid ? 'Amount is required' : null,
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
                color: Color.fromARGB(255, 195, 66, 66), width: 1)
                ),
                focusedErrorBorder: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(50)),
                borderSide: BorderSide(
                color: Color.fromRGBO(218, 62, 59, 1), width: 1)
                )
              ),
              onChanged: (value) => context.read<WalletWithdrawBloc>().add(WalletWithdrawBitcoinAmountChanged(bitcoinAmount: value)),
            )
          );
        }
        return const SizedBox();
      },
    );
  }
}

//WithdrawAmountInput
class WithdrawBitcoinAddressInput extends StatefulWidget {
  WithdrawBitcoinAddressInput({Key? key}):super(key: key);

  @override
  State<WithdrawBitcoinAddressInput> createState() => _WithdrawBitcoinAddressInputState();
}

class _WithdrawBitcoinAddressInputState extends State<WithdrawBitcoinAddressInput> {
  late WalletWithdrawBloc walletWithdrawBloc;
  late TextEditingController addressController;
  late String _address;

  @override
  void initState() {
    super.initState();
    addressController = TextEditingController();
    walletWithdrawBloc = context.read<WalletWithdrawBloc>();
  }

  Future<Map<String, dynamic>> _getBCAddress(){
    return walletWithdrawBloc.transactionService.getBCAddress();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double ratio = size.width / size.height;

    return BlocBuilder<WalletWithdrawBloc, WalletWithdrawState>(
      builder: (context, state) {
        if(state is WalletWithdrawBitcoinInitialized){
          return Padding(
            padding: const EdgeInsets.only(top: 20, bottom: 20, left: 20, right: 20),
            child: TextField(
              key: const Key('WalletWithdraw_addressBitcoinField'),
              controller: addressController,
              keyboardType: TextInputType.text,
              readOnly: true,
              style: const TextStyle(color: Color.fromRGBO(255, 255, 255, 1)),
              decoration: InputDecoration(
                labelText: 'Bitcoin address',
                labelStyle: TextStyle(
                  fontSize: ratio * 35,
                  color: const Color.fromRGBO(255, 255, 255, 1),
                  fontFamily: "Play"
                ),
                suffixIcon: IconButton(
                  onPressed: () async {
                    var result = await _getBCAddress();
                    var address = result['bcaddress'];
                    var transactionCode = result['transactionCode'];
                    addressController.value = TextEditingValue(text: address);
                    walletWithdrawBloc.add(WalletWithdrawAddressButtonClicked(address: address, transactionCode: transactionCode));
                  },
                  style: const ButtonStyle(
                    alignment: Alignment.centerRight
                  ),
                  icon: Image.asset('lib/assets/images/bitcoin.png')
                ),
                errorStyle: const TextStyle(color: Color.fromARGB(255, 195, 66, 66)),
                errorText: state.address.invalid ? 'Address is required' : null,
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
                color: Color.fromARGB(255, 195, 66, 66), width: 1)
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
        return Container();
      },
    );
  }
}

//WithdrawBitcoinProceedButton
class WithdrawBitcoinProceedButton extends StatefulWidget {
  const WithdrawBitcoinProceedButton({super.key});

  @override
  State<WithdrawBitcoinProceedButton> createState() => _WithdrawBitcoinProceedButtonState();
}

class _WithdrawBitcoinProceedButtonState extends State<WithdrawBitcoinProceedButton> {
  late WalletWithdrawBloc walletWithdrawBloc;

  @override
  void initState() {
    super.initState();
    walletWithdrawBloc = context.read<WalletWithdrawBloc>();
  }

  Future<Map<String, dynamic>> _bitcoinWithdraw(String withdrawBitcoin, String path) async {
    walletWithdrawBloc.add(WalletWithdrawBitcoinRequestSubmitted(isBtnDisabled: false));
    return await walletWithdrawBloc.transactionService.withdrawBitcoin(withdrawBitcoin, path);
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
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double ratio = size.width / size.height;
    
    return BlocBuilder<WalletWithdrawBloc, WalletWithdrawState>(
      builder: (context, state) {
        if(state is WalletWithdrawBitcoinInitialized){
          WalletWithdrawBitcoinInitialized walletWithdrawBitcoin = state;
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
                key: const Key('WithdrawForm_submitBitcoinBtn'),
                onPressed: walletWithdrawBitcoin.status == FormzStatus.valid && !walletWithdrawBitcoin.isBtnDisabled ?
                () {
                  walletWithdrawBloc.add(WalletWithdrawBitcoinRequestSubmitted(isBtnDisabled: true));
                  Helpers.loadingAlert(context);
                  Future.delayed(const Duration(milliseconds: 500), () async {
                    Navigator.pop(context);
                    var withdrawBitcoin = {
                      "bitcoin_amount": walletWithdrawBitcoin.bitcoinAmount.value,
                      "bcaddress": walletWithdrawBitcoin.address.value,
                      "transaction_code": walletWithdrawBitcoin.transactionCode
                    };
                    var result = await _bitcoinWithdraw(jsonEncode(withdrawBitcoin), 'withdrawBitcoinProccess');
                    var code = result['code'];
                    var message = result['message'];
                    var amount = result['amount'];
                    if(code != 200 && amount != null){
                      _showErrorMessage(amount.toString());
                    } else if(code != 200 && message != null){
                      if(code == 406){
                        Navigator.push(context, 
                          MaterialPageRoute(builder: (context) {
                            return RequiredPassword(path: 'withdrawBitcoinProccessWithPassword', data: withdrawBitcoin, type: 'withdrawBitcoin');
                          })
                        );
                      } else {
                        _showErrorMessage(message.toString());  
                      }
                    } else {
                      Navigator.push(context, 
                        MaterialPageRoute(builder: ((context) {
                          var textStyle = TextStyle(color: const Color.fromARGB(255, 32, 150, 36), fontFamily: 'Play', fontSize: ratio*40);
                          var image = Image.asset('lib/assets/images/successful-transaction.png', width: ratio*200);
                          if(code != 200){
                            textStyle = TextStyle(color: const Color.fromARGB(255, 195, 39, 39), fontFamily: 'Play', fontSize: ratio*40);
                            image = Image.asset('lib/assets/images/failed-transaction.png');
                          } 
                          return TransactionResult(text: message, textStyle: textStyle, image: image);
                        }))
                      );
                    }
                  });
                } : null,
                child: Text('Request'.toUpperCase(),
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
        return const SizedBox();
      },
    );
  }
}
