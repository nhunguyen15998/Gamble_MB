import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
                child: TabBar(
                  controller: tabController,
                  indicatorColor: const Color.fromRGBO(250, 0, 159, 1),
                  onTap: (selectedTab){
                    print("selectedTab: $selectedTab");
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
                    SingleChildScrollView(
                      child: Column(
                        children: [
                          SizedBox(
                            height: size.height*0.72,
                            width: size.width,
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
                                  child: Text('Exchange rate: 1 VND =  USD',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontFamily: 'Play',
                                      fontSize: ratio*25
                                    ),
                                  )
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                                  child: Text('Remaining amount after withdraw proccess will be: \$221',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontFamily: 'Play',
                                      fontSize: ratio*25
                                    ),
                                  )
                                )
                              ]
                            )
                          ),
                          WithdrawBankProceedButton()
                        ],
                      ),
                    ),
                    //FORM2
                    SingleChildScrollView(
                      child: Column(
                        children: [
                          SizedBox(
                            height: size.height*0.72,
                            width: size.width,
                            child: Column(
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
                              ],
                            )
                          ),
                          WithdrawBitcoinProceedButton()
                        ],
                      ),
                    ),
                  ]
                )
              )
            ),
          ]
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

    return Padding(
      padding: const EdgeInsets.only(top: 20, bottom: 20, left: 20, right: 20),
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

//WithdrawBankProceedButton
class WithdrawBankProceedButton extends StatefulWidget {
  const WithdrawBankProceedButton({super.key});

  @override
  State<WithdrawBankProceedButton> createState() => _WithdrawBankProceedButtonState();
}

class _WithdrawBankProceedButtonState extends State<WithdrawBankProceedButton> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double ratio = size.width / size.height;

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
          onPressed: () {},
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

    return Padding(
      padding: const EdgeInsets.only(top: 40, bottom: 20, left: 20, right: 20),
      child: TextField(
        key: const Key('WalletWithdraw_amountBitcoinField'),
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

//WithdrawAmountInput
class WithdrawBitcoinAddressInput extends StatefulWidget {
  WithdrawBitcoinAddressInput({Key? key}):super(key: key);

  @override
  State<WithdrawBitcoinAddressInput> createState() => _WithdrawBitcoinAddressInputState();
}

class _WithdrawBitcoinAddressInputState extends State<WithdrawBitcoinAddressInput> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double ratio = size.width / size.height;

    return Padding(
      padding: const EdgeInsets.only(top: 20, bottom: 20, left: 20, right: 20),
      child: TextField(
        key: const Key('WalletWithdraw_addressBitcoinField'),
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
            onPressed: (){},
            style: const ButtonStyle(
              alignment: Alignment.centerRight
            ),
            icon: Image.asset('lib/assets/images/bitcoin.png')
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

//WithdrawBitcoinProceedButton
class WithdrawBitcoinProceedButton extends StatefulWidget {
  const WithdrawBitcoinProceedButton({super.key});

  @override
  State<WithdrawBitcoinProceedButton> createState() => _WithdrawBitcoinProceedButtonState();
}

class _WithdrawBitcoinProceedButtonState extends State<WithdrawBitcoinProceedButton> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double ratio = size.width / size.height;
    
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
          onPressed: () {},
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
}
