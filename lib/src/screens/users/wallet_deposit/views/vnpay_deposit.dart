// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gamble/src/screens/users/transaction_results/views/transaction_result.dart';
import 'package:gamble/src/screens/users/wallet_deposit/wallet_deposit.dart';
import 'package:gamble/src/services/transaction_service.dart';
import 'package:formz/formz.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

class VNPayDeposit extends StatefulWidget {
  VNPayDeposit({Key? key, required this.url}):super(key: key);

  Uri? url;

  @override
  State<VNPayDeposit> createState() => _VNPayDepositState();
}

class _VNPayDepositState extends State<VNPayDeposit> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double ratio = size.width / size.height;
    final url = widget.url;
    
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
              title: Text('VNPay', 
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
            body: WebViewVNPay(url: url)
          )
        )
      )
    );
  }
}
 class WebViewVNPay extends StatefulWidget {
  WebViewVNPay({Key? key, required this.url}):super(key: key);

  Uri? url;

  @override
  State<WebViewVNPay> createState() => _WebViewVNPayState();
}

class _WebViewVNPayState extends State<WebViewVNPay> {

  late WalletDepositBloc walletDepositBloc;

  @override
  void initState() {
    super.initState();
    walletDepositBloc = context.read<WalletDepositBloc>();
  }
  
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double ratio = size.width / size.height;
    final url = widget.url;

    return WebView(
      initialUrl: url.toString(),
      javascriptMode: JavascriptMode.unrestricted,
      navigationDelegate: (action) async {
        if (action.url.contains('api/proceed/transaction')) {
          var url = action.url.substring(action.url.indexOf('api'), action.url.length);
          //https://sandbox.vnpayment.vn/paymentv2/Ncb/Transaction/api/proceed/transaction?vnp_Amount=12300000&vnp_BankCode=NCB&vnp_BankTranNo=VNP13874475&vnp_CardType=ATM&vnp_OrderInfo=TransactionTest&vnp_PayDate=20221109161812&vnp_ResponseCode=00&vnp_TmnCode=P5FNXKXA&vnp_TransactionNo=13874475&vnp_TransactionStatus=00&vnp_TxnRef=725ef496df3b4f4&vnp_SecureHash=e0a7ea81b8433fc7b7354575202c026d8e0092127bc3f6e63134b94bb70dc5d67ff617d8db2c51e1699d70d363dd90adc14d0e36a01cbaa17416ea68146d1469
          var result = await walletDepositBloc.transactionService.returnVNPayDespositResult(url);
          var message = result['message'];
          var code = result['code'];
          var textStyle = TextStyle(color: const Color.fromARGB(255, 32, 150, 36), fontFamily: 'Play', fontSize: ratio*40);
          var image = Image.asset('lib/assets/images/successful-transaction.png', width: ratio*200);
          if(code != 200){
            textStyle = TextStyle(color: const Color.fromARGB(255, 195, 39, 39), fontFamily: 'Play', fontSize: ratio*40);
            image = Image.asset('lib/assets/images/failed-transaction.png');
          } 
          Navigator.pop(context); // Close current window
          Navigator.push(context, 
            MaterialPageRoute(builder: ((context) {
              return TransactionResult(text: message, textStyle: textStyle, image: image);
            }))
          );
          return NavigationDecision.navigate; // Prevent opening url
        } 
        return NavigationDecision.navigate; // Default decision
      },
    );
  }
}
