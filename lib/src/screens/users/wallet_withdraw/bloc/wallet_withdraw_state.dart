part of 'wallet_withdraw_bloc.dart';

class WalletWithdrawState extends Equatable{
  const WalletWithdrawState();
  
  @override
  List<Object?> get props => [];
}

class WalletWithdrawBankInitialized extends WalletWithdrawState {
  WalletWithdrawBankInitialized({
    this.status = FormzStatus.invalid,
    this.accountName = const AccountName.pure(),
    this.accountNumber = const AccountNumber.pure(),
    this.bank = const Bank.pure(),
    this.bankAmount = const BankAmount.pure(),
    this.note = '',
  });

  FormzStatus status;
  AccountName accountName;
  AccountNumber accountNumber;
  Bank bank;
  BankAmount bankAmount;
  String note;

  WalletWithdrawBankInitialized copyWith({
    FormzStatus? status,
    AccountName? accountName,
    AccountNumber? accountNumber,
    Bank? bank,
    BankAmount? bankAmount,
    String? note
  }){
    return WalletWithdrawBankInitialized(
      status: status ?? this.status,
      accountName: accountName ?? this.accountName,
      accountNumber: accountNumber ?? this.accountNumber,
      bank: bank ?? this.bank,
      bankAmount: bankAmount ?? this.bankAmount,
      note: note ?? this.note
    );
  }

  @override
  List<Object?> get props => [status, accountName, accountNumber, bank, bankAmount, note];
}

class WalletWithdrawBitcoinInitialized extends WalletWithdrawState {
  WalletWithdrawBitcoinInitialized({
    this.status = FormzStatus.invalid,
    this.bitcoinAmount = const BitcoinAmount.pure(),
    this.address = const Address.pure(),
    this.transactionCode = '',
  });

  FormzStatus status;
  BitcoinAmount bitcoinAmount;
  Address address;
  String transactionCode;

  WalletWithdrawBitcoinInitialized copyWith({
    FormzStatus? status,
    BitcoinAmount? bitcoinAmount,
    Address? address,
    String? transactionCode
  }){
    return WalletWithdrawBitcoinInitialized(
      status: status ?? this.status,
      bitcoinAmount: bitcoinAmount ?? this.bitcoinAmount,
      address: address ?? this.address,
      transactionCode: transactionCode ?? this.transactionCode
    );
  }

  @override
  List<Object?> get props => [status, bitcoinAmount, address, transactionCode];
}

