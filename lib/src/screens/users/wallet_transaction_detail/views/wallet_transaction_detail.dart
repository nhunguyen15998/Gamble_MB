import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gamble/src/screens/users/wallet_transaction_detail/bloc/wallet_transaction_detail_bloc.dart';
import 'package:gamble/src/screens/users/wallet_transaction_detail/wallet_transaction_detail.dart';
import 'package:gamble/src/services/transaction_service.dart';
import 'package:gamble/src/utils/helpers.dart';

class WalletTransactionDetail extends StatefulWidget {
  WalletTransactionDetail({Key? key, required this.transactionId}):super(key: key);

  int transactionId;
  
  @override
  State<WalletTransactionDetail> createState() => _WalletTransactionDetailState();
}

class _WalletTransactionDetailState extends State<WalletTransactionDetail> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double ratio = size.width / size.height;
    int transactionId = widget.transactionId;
    
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: RepositoryProvider(
        create: (context) => TransactionManagement(),
        child: BlocProvider(
          create: (context) => WalletTransactionDetailBloc(RepositoryProvider.of<TransactionManagement>(context))..add(WalletTransactionDetailInitial(transactionId: transactionId)),
          child: Scaffold(
            appBar: AppBar(
              leading: IconButton(
                focusColor: const Color.fromRGBO(250, 0, 159, 1),
                icon: const Icon(FontAwesomeIcons.chevronLeft, color: Colors.white),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              centerTitle: true,
              title: Text('Transaction detail', 
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
            backgroundColor: Colors.white,
            body: BlocBuilder<WalletTransactionDetailBloc, WalletTransactionDetailState>(
              builder: (context, state) {
                if(state is WalletTransactionDetailInitialized){
                  return const Center(child: CircularProgressIndicator());
                }
                if(state is WalletTransactionDetailLoaded){
                  return const TransactionDetailBody();
                }
                return const SizedBox();
              },
            )
          )
        )
      )
    );
  }
}

//deposit
class TransactionDetailBody extends StatefulWidget {
  const TransactionDetailBody({super.key});

  @override
  State<TransactionDetailBody> createState() => _TransactionDetailBodyState();
}

class _TransactionDetailBodyState extends State<TransactionDetailBody> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double ratio = size.width / size.height;

    return BlocBuilder<WalletTransactionDetailBloc, WalletTransactionDetailState>(
      builder: (context, state) {
        TransactionItemDetail item = (state as WalletTransactionDetailLoaded).transactionItemDetail;
        return SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 40, left: 20, right: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(Helpers.toStatus(item.status),
                      style: TextStyle(
                        fontFamily: 'Play', 
                        fontSize: ratio*35,
                        color: Colors.green,
                        fontWeight: FontWeight.w600
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: ratio*20),
                      child: Text("${Helpers.toType(item.type).toUpperCase()} \$${item.amount}",
                        style: TextStyle(
                          fontFamily: 'Play', 
                          fontSize: ratio*55,
                          color: Colors.black,
                          fontWeight: FontWeight.w600
                        ),
                      )
                    )
                  ],
                )
              ),
              Padding(
                padding: const EdgeInsets.only(top: 40, bottom: 15, left: 20, right: 20),
                child: SizedBox(
                  height: ratio*50,
                  width: double.infinity,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Transaction code',
                        style: TextStyle(
                          fontFamily: 'Play', 
                          fontSize: ratio*35,
                          color: Colors.black
                        ),
                      ),
                      Text('#${item.code}',
                        style: TextStyle(
                          fontFamily: 'Play', 
                          fontSize: ratio*35,
                          color: Colors.black
                        ),
                      )
                    ],
                  )
                )
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 15, left: 20, right: 20),
                child: SizedBox(
                  height: ratio*50,
                  width: double.infinity,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Amount',
                        style: TextStyle(
                          fontFamily: 'Play', 
                          fontSize: ratio*35,
                          color: Colors.black
                        ),
                      ),
                      Text('\$${item.amount}',
                        style: TextStyle(
                          fontFamily: 'Play', 
                          fontSize: ratio*35,
                          color: Colors.black
                        ),
                      )
                    ],
                  )
                )
              ),
              item.type != TransactionType.transferred.index ? 
              Padding(
                padding: const EdgeInsets.only(bottom: 15, left: 20, right: 20),
                child: SizedBox(
                  height: ratio*50,
                  width: double.infinity,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Method',
                        style: TextStyle(
                          fontFamily: 'Play', 
                          fontSize: ratio*35,
                          color: Colors.black
                        ),
                      ),
                      if(item.type == TransactionType.withdrawed.index && item.method != TransactionWithdrawMethod.bank.index)...[
                        Image.asset(Helpers.toWithdrawMethod(item.method))
                      ] else if(item.type == TransactionType.withdrawed.index && item.method == TransactionWithdrawMethod.bank.index)...[
                        Text('Bank', style: TextStyle(fontFamily: 'Play', fontSize: ratio*35))
                      ] else ...[
                        Image.asset(Helpers.toMethod(item.method))
                      ]
                    ],
                  )
                )
              ) : const SizedBox(),
              item.note != null ? 
              Padding(
                padding: const EdgeInsets.only(bottom: 15, left: 20, right: 20),
                child: SizedBox(
                  height: ratio*50,
                  width: double.infinity,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Note',
                        style: TextStyle(
                          fontFamily: 'Play', 
                          fontSize: ratio*35,
                          color: Colors.black
                        ),
                      ),
                      Text('${item.note}',
                        style: TextStyle(
                          fontFamily: 'Play', 
                          fontSize: ratio*35,
                          color: Colors.black
                        ),
                      )
                    ],
                  )
                )
              ): const SizedBox(),
              Padding(
                padding: const EdgeInsets.only(bottom: 15, left: 20, right: 20),
                child: SizedBox(
                  height: ratio*50,
                  width: double.infinity,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Date created',
                        style: TextStyle(
                          fontFamily: 'Play', 
                          fontSize: ratio*35,
                          color: Colors.black
                        ),
                      ),
                      Text(item.createdAt,
                        style: TextStyle(
                          fontFamily: 'Play', 
                          fontSize: ratio*35,
                          color: Colors.black
                        ),
                      )
                    ],
                  )
                )
              ),
              item.bcaddress != null ?
              Padding(
                padding: const EdgeInsets.only(bottom: 15, left: 20, right: 20),
                child: SizedBox(
                  height: ratio*50,
                  width: double.infinity,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Address',
                        style: TextStyle(
                          fontFamily: 'Play', 
                          fontSize: ratio*35,
                          color: Colors.black
                        ),
                      ),
                      Text('${item.bcaddress}',
                        style: TextStyle(
                          fontFamily: 'Play', 
                          fontSize: ratio*35,
                          color: Colors.black
                        ),
                      )
                    ],
                  )
                )
              ): const SizedBox(),
              item.accountName != null ?
              Padding(
                padding: const EdgeInsets.only(bottom: 15, left: 20, right: 20),
                child: SizedBox(
                  height: ratio*50,
                  width: double.infinity,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Account name',
                        style: TextStyle(
                          fontFamily: 'Play', 
                          fontSize: ratio*35,
                          color: Colors.black
                        ),
                      ),
                      Text('${item.accountName}',
                        style: TextStyle(
                          fontFamily: 'Play', 
                          fontSize: ratio*35,
                          color: Colors.black
                        ),
                      )
                    ],
                  )
                )
              ) : const SizedBox(),
              item.accountNumber != null ?
              Padding(
                padding: const EdgeInsets.only(bottom: 15, left: 20, right: 20),
                child: SizedBox(
                  height: ratio*50,
                  width: double.infinity,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Account number',
                        style: TextStyle(
                          fontFamily: 'Play', 
                          fontSize: ratio*35,
                          color: Colors.black
                        ),
                      ),
                      Text('${item.accountNumber}',
                        style: TextStyle(
                          fontFamily: 'Play', 
                          fontSize: ratio*35,
                          color: Colors.black
                        ),
                      )
                    ],
                  )
                )
              ) : const SizedBox(),
              item.bank != null ?
              Padding(
                padding: const EdgeInsets.only(bottom: 15, left: 20, right: 20),
                child: SizedBox(
                  height: ratio*50,
                  width: double.infinity,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Bank',
                        style: TextStyle(
                          fontFamily: 'Play', 
                          fontSize: ratio*35,
                          color: Colors.black
                        ),
                      ),
                      Text('${item.bank}',
                        style: TextStyle(
                          fontFamily: 'Play', 
                          fontSize: ratio*35,
                          color: Colors.black
                        ),
                      )
                    ],
                  )
                )
              ) : const SizedBox(),
              item.type == TransactionType.transferred.index ?
              Padding(
                padding: const EdgeInsets.only(bottom: 15, left: 20, right: 20),
                child: SizedBox(
                  height: ratio*50,
                  width: double.infinity,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Sender',
                        style: TextStyle(
                          fontFamily: 'Play', 
                          fontSize: ratio*35,
                          color: Colors.black
                        ),
                      ),
                      Text(item.senderName,
                        style: TextStyle(
                          fontFamily: 'Play', 
                          fontSize: ratio*35,
                          color: Colors.black
                        ),
                      )
                    ],
                  )
                )
              ) : const SizedBox(),
              item.type == TransactionType.transferred.index ?
              Padding(
                padding: const EdgeInsets.only(bottom: 15, left: 20, right: 20),
                child: SizedBox(
                  height: ratio*50,
                  width: double.infinity,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Receiver',
                        style: TextStyle(
                          fontFamily: 'Play', 
                          fontSize: ratio*35,
                          color: Colors.black
                        ),
                      ),
                      Text('${item.receiverName}',
                        style: TextStyle(
                          fontFamily: 'Play', 
                          fontSize: ratio*35,
                          color: Colors.black
                        ),
                      )
                    ],
                  )
                )
              ) : const SizedBox(),
            ],
          ),
        );
      },
    );
  }
}

