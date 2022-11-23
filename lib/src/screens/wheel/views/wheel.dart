import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_fortune_wheel/flutter_fortune_wheel.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gamble/src/screens/master/master.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gamble/src/screens/wheel/bloc/wheel_bloc.dart';
import 'package:gamble/src/screens/wheel/models/wheel_attributes.dart';
import 'package:gamble/src/services/wheel_service.dart';
import 'package:formz/formz.dart';
import 'package:gamble/src/utils/helpers.dart';

class Wheel extends StatefulWidget {
  const Wheel({Key? key}) : super(key: key);

  @override
  State<Wheel> createState() => _WheelState();
}

class _WheelState extends State<Wheel> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double ratio = size.width / size.height;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: SafeArea(
        child: RepositoryProvider(
          create: (context) => WheelManagement(),
          child: BlocProvider(
            create: (context) => WheelBloc(RepositoryProvider.of<WheelManagement>(context))..add(WheelInitial()),
            child: const WheelBody()
          ),
        )
      )
    );
  }
}

//body
class WheelBody extends StatefulWidget {
  const WheelBody({Key? key}):super(key: key);

  @override
  State<WheelBody> createState() => _WheelBodyState();
}

class _WheelBodyState extends State<WheelBody> {
  TextEditingController resultBalance = TextEditingController();
  TextEditingController betAmount = TextEditingController();
  late WheelBloc wheelBloc;
  StreamController<int> selected = StreamController<int>();
  bool isPartialBet = false;

  @override
  void initState() {
    super.initState();
    wheelBloc = context.read<WheelBloc>();
  }

  Future<void> _returnWheelResult(String betAmount, bool isPartialBet) async {
    final result = await wheelBloc.wheelService.returnWheelResult(betAmount, isPartialBet);
    var code = result['code'];
    var message = result['message'];
    var status = result['status'];
    var bal = result['balance'];
    var sm = result['sm'];
    var md = result['md'];
    var lg = result['lg'];
    var medium = result['medium'];
    var small = result['small'];
    var large = result['large'];
    var amount = result['amount'];
    if(code != 200){
      _showErrorMessage(message.toString());
    } else {
      // show result for 1st round
      setState(() { //spinning
        selected.add(sm); 
      });
      await Future.delayed(const Duration(seconds: 3));
      wheelBloc.add(WheelPaused(resultLabel: small, hasResult: true));
      // small == NEXT => redraw wheel => spinning => show result for 2nd round
      if(small.toString() == "NEXT"){
        await Future.delayed(const Duration(seconds: 1));
        wheelBloc.add(WheelBoardChanged(isNext: 1, hasResult: false, round: 'Round 2'));
        await Future.delayed(const Duration(seconds: 1));
        setState(() { //spinning
          selected.add(md);
        });
        await Future.delayed(const Duration(seconds: 3));
        wheelBloc.add(WheelPaused(resultLabel: medium, hasResult: true));
        // medium == NEXT => redraw wheel => spinning => show result for 3rd round
        if(medium.toString() == "NEXT"){
          wheelBloc.add(WheelBoardChanged(isNext: 2, hasResult: false, round: 'Round 3'));
          await Future.delayed(const Duration(seconds: 1));
          setState(() { //spinning
            selected.add(lg);
          });
          await Future.delayed(const Duration(seconds: 3));
          wheelBloc.add(WheelPaused(resultLabel: large, hasResult: true));
        } 
      }
      // show status + update balance
      wheelBloc.add(WheelBalanceAndStatusUpdated(resultStatus: message == "Drawn" ? message : message+" \$$amount", balance: bal)); 
      // redraw wheel
      await Future.delayed(const Duration(seconds: 3));
      wheelBloc.add(WheelRefreshed(resultStatus: '', hasResult: false, isNext: 0, round: 'Round 1'));
    }
    wheelBloc.add(WheelButtonsDisabled(isBtnDisabled: false));
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

  Future<void> _showWheelDialog(double ratio) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          content: Container(
            height: ratio*300,
            color: Color.fromARGB(34, 255, 255, 255),
            child: Column(
              children: [
                TextButton(
                  onPressed: () {
                  
                  }, 
                  child: Text('Music')
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.pop(context);
                  }, 
                  child: Text('Quit game')
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  }, 
                  child: Text('Cancel')
                )
              ],
            )
          )
        );
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
    resultBalance.dispose();
    betAmount.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double ratio = size.width / size.height;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        flexibleSpace: Center(
          child: Row(
            children: [
              Container(
                margin: EdgeInsets.only(left: ratio*20),
                width: size.width*0.4,
                height: ratio*70,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(ratio*50),
                  color: Color.fromARGB(255, 43, 5, 74),
                ),
                child: Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.all(ratio*5),
                      child: Image.asset('lib/assets/images/dollar.png')
                    ),
                    Expanded(
                      child: BlocBuilder<WheelBloc, WheelState>(
                        builder: (context, state) {
                          if(state is WheelInitialized){
                            var balance = state.balance;
                            return Padding(
                              padding: EdgeInsets.symmetric(horizontal: ratio*20),
                              child: Text("\$$balance",
                                maxLines: 1,
                                overflow: TextOverflow.clip,
                                textAlign: TextAlign.end,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: 'Play',
                                  fontSize: ratio*30
                                ),
                              )
                            );
                          }
                          return Container();
                        },
                      )
                    )
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: ratio*20),
                width: size.width*0.44,
                height: ratio*70,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(ratio*50),
                  color: Color.fromARGB(255, 43, 5, 74),
                ),
                child: Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.all(ratio*5),
                      child: Image.asset('lib/assets/images/dollar.png')
                    ),
                    Expanded(
                      child: BlocBuilder<WheelBloc, WheelState>(
                        builder: (context, state) {
                          if(state is WheelInitialized){
                            return Padding(
                              padding: const EdgeInsets.only(left: 5, right: 10),
                              child: TextField(
                                controller: betAmount,
                                textAlign: TextAlign.start,
                                keyboardType: TextInputType.number,
                                style: const TextStyle(color: Color.fromRGBO(255, 255, 255, 1)),
                                decoration: InputDecoration(
                                  hintStyle: const TextStyle(color: Colors.white),
                                  hintText: 'Enter amount',
                                  labelStyle: TextStyle(
                                    fontSize: ratio * 20,
                                    color: const Color.fromRGBO(255, 255, 255, 1),
                                    fontFamily: "Play"
                                  ),
                                  contentPadding: const EdgeInsets.only(left: 5, right: 5, bottom: 15),
                                  errorStyle: const TextStyle(color: Color.fromARGB(255, 195, 66, 66)),
                                  border: InputBorder.none
                                ),
                                onChanged: (value) {
                                  isPartialBet = true;
                                  context.read<WheelBloc>().add(AmountChanged(betAmount: value));
                                },
                              )
                            );
                          }
                          return const SizedBox();
                        },
                      )
                    ),
                  ],
                ),
              )
            ],
          )
        ),
        actions: [
          IconButton(
            onPressed: () {
              _showWheelDialog(ratio);
            },
            icon: Icon(Icons.settings),
          ),
        ],
        backgroundColor: Color.fromARGB(255, 177, 23, 130),
      ),
      body: SingleChildScrollView(
        child: DecoratedBox(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("lib/assets/images/coin_background.png"),
              fit: BoxFit.cover
            ),
          ),
          child: Container(
            width: size.width,
            height: size.height*0.91,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: [
                  Color.fromARGB(255, 73, 15, 117),
                  Color.fromARGB(223, 213, 161, 96),
                ],
              )
            ),
            child: DecoratedBox(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  alignment: Alignment.topCenter,
                  image: AssetImage('lib/assets/images/coin_background.png'),
                  fit: BoxFit.contain,
                  repeat: ImageRepeat.repeat
                ),
              ),
              child: Column(
                children: [
                  //status
                  SizedBox(
                    width: size.width,
                    height: size.height*0.2,
                    child: Center(
                      child: BlocBuilder<WheelBloc, WheelState>(
                        builder: (context, state) {
                          if(state is WheelInitialized){
                            var resultStatus = state.resultStatus;
                            print('resultStatus: $resultStatus');
                            var round = state.round;
                            return resultStatus != "" ? 
                              Text(resultStatus,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.greenAccent,
                                  fontFamily: 'Play',
                                  fontSize: ratio*100
                                ),
                              )
                              : Text(round,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Color.fromARGB(255, 65, 229, 224),
                                  fontFamily: 'Play',
                                  fontSize: ratio*80
                                ),
                              );
                          }
                          return Container();
                        }
                      )
                    ),
                  ),
                  SizedBox(
                    width: size.width*0.9,
                    height: size.height*0.5,
                    child: Stack(
                      children: [
                        //wheel
                        BlocBuilder<WheelBloc, WheelState>(
                          builder: (context, state) {
                            if(state is WheelInitialized){
                              var listA = state.listA;
                              var listB = state.listB;
                              var listC = state.listC;
                              return state.isNext == 0 ? 
                                    DrawFortuneWheel(list: listA, selectedItem: selected): 
                                    (state.isNext == 1 ?
                                    DrawFortuneWheel(list: listB, selectedItem: selected):
                                    DrawFortuneWheel(list: listC, selectedItem: selected));
                            }
                            return Container();
                          },
                        ),
                        //result label
                        Positioned(
                          left: ratio*295,
                          top: ratio*340,
                          child: BlocBuilder<WheelBloc, WheelState>(
                            builder: (context, state) {
                              if(state is WheelInitialized){
                                return ElevatedButton(
                                  style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all(Colors.amber),
                                    minimumSize: MaterialStateProperty.all(Size.square(ratio*150)),
                                    shape: MaterialStateProperty.resolveWith<OutlinedBorder>((_) {
                                      return RoundedRectangleBorder(borderRadius: BorderRadius.circular(50));
                                    })
                                  ),
                                  onPressed: () {},
                                  child: !state.hasResult ? 
                                    const Icon(FontAwesomeIcons.dollarSign): 
                                    Text(state.resultLabel,
                                      style: const TextStyle(
                                        color: Colors.black,
                                        fontFamily: 'Play',
                                      )
                                    ),
                                );
                              }  
                              return Container();
                            }
                          )
                        ),
                      ]
                    )
                  ),
                  //btns
                  Container(
                    height: size.height*0.2,
                    width: size.width,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        //insane bet button
                        BlocBuilder<WheelBloc, WheelState>(
                          builder: (context, state) {
                            if(state is WheelInitialized){
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 40, left: 20, right: 20),
                                child: SizedBox(
                                  width: ratio*300,
                                  height: ratio * 100,
                                  child: ElevatedButton(
                                    style: ButtonStyle(
                                        backgroundColor: MaterialStateProperty.all(
                                            Color.fromARGB(255, 43, 5, 74)),
                                        shape: MaterialStateProperty.all(RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(ratio * 50)))),
                                    onPressed: !state.isBtnDisabled ?
                                    () async {
                                      isPartialBet = false;
                                      var balance = state.balance;
                                      betAmount.text = '\$$balance';
                                      wheelBloc.add(WheelInsaneBetButtonClicked(betAmount: balance));
                                    } : null,
                                    child: Text('Insane bet'.toUpperCase(),
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
                            return Container();
                          },
                        ),
                        //partial bet btn
                        BlocBuilder<WheelBloc, WheelState>(
                          builder: (context, state) {
                            if(state is WheelInitialized){
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 40, left: 20, right: 20),
                                child: SizedBox(
                                  width: ratio*300,
                                  height: ratio * 100,
                                  child: ElevatedButton(
                                    style: ButtonStyle(
                                        backgroundColor: MaterialStateProperty.all(
                                            Color.fromARGB(255, 43, 5, 74)),
                                        shape: MaterialStateProperty.all(RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(ratio * 50)))),
                                    onPressed: !state.isBtnDisabled ?
                                    () async {
                                      wheelBloc.add(WheelButtonsDisabled(isBtnDisabled: true));
                                      await _returnWheelResult(state.betAmount, isPartialBet);
                                      betAmount.text = '';
                                    } : null,
                                    child: Text('Spin'.toUpperCase(),
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
                        )
                      ],
                    )
                  )
                ],
              )
            ),
          )
        )
      )
    );
  }

}

//wheel
class DrawFortuneWheel extends StatefulWidget {
  DrawFortuneWheel({Key? key, required this.list, required this.selectedItem}):super(key: key);

  List<WheelAttributes> list;
  StreamController<int> selectedItem;

  @override
  State<DrawFortuneWheel> createState() => _DrawFortuneWheelState();
}

class _DrawFortuneWheelState extends State<DrawFortuneWheel> {

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double ratio = size.width / size.height;
    List<WheelAttributes> list = widget.list;
    StreamController<int> selectedItem = widget.selectedItem;

    return FortuneWheel(
      animateFirst: false,
      duration: const Duration(seconds: 3),
      selected: selectedItem.stream,
      indicators: const <FortuneIndicator>[
        FortuneIndicator(
          alignment: Alignment.topCenter, // <-- changing the position of the indicator
          child: TriangleIndicator(
            color: Color.fromARGB(255, 218, 25, 150), // <-- changing the color of the indicator
          ),
        ),
      ],
      items: [
        for (var item in list)
          FortuneItem(
            child: Text(item.slice,
              style: TextStyle(
                fontFamily: "Play",
                fontWeight: FontWeight.bold,
                fontSize: 15,
                color: Color(item.textColor)
              )
            ),
            style: FortuneItemStyle(
              color: Color(item.color)
            )
          ),
      ],
    );
  }
}
