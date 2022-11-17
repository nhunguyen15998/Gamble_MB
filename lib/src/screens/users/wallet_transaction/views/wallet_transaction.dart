import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gamble/src/screens/users/wallet_transaction/bloc/wallet_transaction_bloc.dart';
import 'package:gamble/src/screens/users/wallet_transaction/wallet_transaction.dart';
import 'package:gamble/src/screens/users/wallet_transaction_detail/views/wallet_transaction_detail.dart';
import 'package:gamble/src/services/transaction_service.dart';
import 'package:gamble/src/utils/helpers.dart';

class WalletTransaction extends StatefulWidget {
  const WalletTransaction({super.key});

  @override
  State<WalletTransaction> createState() => _WalletTransactionState();
}

class _WalletTransactionState extends State<WalletTransaction> {
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
          title: Text('Transactions', 
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
        body: RepositoryProvider(
          create:(context) => TransactionManagement(),
          child: BlocProvider(
            create: (context) => WalletTransactionBloc(RepositoryProvider.of<TransactionManagement>(context))..add(WalletTransactionInitial(page: 1)),
            child: TransactionList(),
          )
        )
      )
    );
  }
}

class TransactionList extends StatefulWidget {
  const TransactionList({super.key});

  @override
  State<TransactionList> createState() => _TransactionListState();
}

class _TransactionListState extends State<TransactionList> {
  ScrollController scrollController = ScrollController();
  late WalletTransactionBloc walletTransactionBloc; 
  int page = 1;

  scrollListener() {
    double pos = scrollController.position.pixels;
    double maxScrollExtent = scrollController.position.maxScrollExtent;
    if(pos == maxScrollExtent) {
     page++;
     walletTransactionBloc.add(WalletTransactionInitial(page: page));
    } 
  }

  Future<void> onRefresh() async {
    page = 1;
    walletTransactionBloc.add(WalletTransactionInitial(page: page));
  }

  @override
  void initState() {
    super.initState();
    scrollController.addListener(scrollListener);
    walletTransactionBloc = context.read<WalletTransactionBloc>(); 
  }
  
  @override
  void dispose() {
    super.dispose();
    scrollController.dispose();
  }

  Widget getImage(TransactionListItem transactionListItem, double width){
    if(transactionListItem.type == TransactionType.withdrawed.index){
      return Image.asset(Helpers.toWithdrawMethod(transactionListItem.method), width: width);
    }
    return Image.asset(Helpers.toMethod(transactionListItem.method), width: width);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double ratio = size.width / size.height;

    return BlocBuilder<WalletTransactionBloc, WalletTransactionState>(
      builder: (context, state) {
        if(state is WalletTransactionInitialized){
          return const Center(child: CircularProgressIndicator());
        }
        if(state is WalletTransactionNotFound){
          return const Center(child: Text('Not found'));
        }
        if(state is WalletTransactionLoaded){
          List<TransactionListItem> transactionList = state.transactionList;
          return RefreshIndicator(
            onRefresh: onRefresh,
            child: ListView.separated(
              controller: scrollController,
              itemCount: state.hasReachedMax ? transactionList.length : transactionList.length + 1,
              padding: const EdgeInsets.symmetric(vertical: 30),
              separatorBuilder: (context, index) => const Divider(color: Colors.transparent),
              itemBuilder: (context, index) {
                if(index >= transactionList.length){
                  return Container(
                    padding: EdgeInsets.only(bottom: ratio*20),
                    alignment: Alignment.center,
                    child: const Center(
                      child: CircularProgressIndicator()
                    ),
                  );
                }
                TransactionListItem transactionListItem = transactionList[index];
                return ListTile(
                  title: GestureDetector(
                    onTap: () {
                      Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                          var id = transactionListItem.id;
                          return WalletTransactionDetail(transactionId: id);
                        }),
                      );
                    },
                    child: Container(
                      width: size.width,
                      decoration: BoxDecoration(
                        color: Color.fromARGB(255, 198, 176, 235),
                        borderRadius: BorderRadius.circular(ratio*10)
                      ),
                      child: Row(
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: ratio*20),
                            child: Center(
                              child: getImage(transactionListItem, ratio*100)
                              //child: Image.asset(Helpers.toMethod(transactionListItem.method), width: ratio*100)
                            )
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(vertical: ratio*45),
                            width: size.width*0.5,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('#${transactionListItem.code}',
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: ratio*37,
                                    fontWeight: FontWeight.w600
                                  ),
                                ),
                                Text(transactionListItem.createdAt,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                  style: const TextStyle(
                                    color: Colors.black87,
                                  ),
                                ),
                                Text('${transactionListItem.name} ${Helpers.toType(transactionListItem.type)} ${transactionListItem.receiverName != null ? 'to ${transactionListItem.receiverName}' : ''} ${Helpers.toStatus(transactionListItem.status)}',
                                  overflow: TextOverflow.visible,
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                    color: Colors.black87,
                                    fontFamily: 'Play',
                                    fontSize: ratio*30
                                  ),
                                ),
                              ],
                            )
                          ),
                          Expanded(
                            child: Center(child: Text('${transactionListItem.type == 0 || transactionListItem.receiver == transactionListItem.userId? 
                                                        '+' : '-'}\$${transactionListItem.amount}'))
                          )
                        ],
                      )
                    )
                  )
                );
              },
            )
          );
        }
        return const SizedBox();
      },
    );
  }
}


