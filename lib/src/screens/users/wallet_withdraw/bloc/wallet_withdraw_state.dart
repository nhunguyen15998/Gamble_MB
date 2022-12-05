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
    this.isBtnDisabled = false,
    this.bankExRate = 0,
    this.bankBalance = 0,
    this.tempBankBalance = 0
  });

  FormzStatus status;
  AccountName accountName;
  AccountNumber accountNumber;
  Bank bank;
  BankAmount bankAmount;
  String note;
  bool isBtnDisabled;
  double bankExRate;
  double bankBalance;
  double tempBankBalance;

  WalletWithdrawBankInitialized copyWith({
    FormzStatus? status,
    AccountName? accountName,
    AccountNumber? accountNumber,
    Bank? bank,
    BankAmount? bankAmount,
    String? note,
    bool? isBtnDisabled,
    double? bankExRate,
    double? bankBalance,
    double? tempBankBalance
  }){
    return WalletWithdrawBankInitialized(
      status: status ?? this.status,
      accountName: accountName ?? this.accountName,
      accountNumber: accountNumber ?? this.accountNumber,
      bank: bank ?? this.bank,
      bankAmount: bankAmount ?? this.bankAmount,
      note: note ?? this.note,
      isBtnDisabled: isBtnDisabled ?? this.isBtnDisabled,
      bankExRate: bankExRate ?? this.bankExRate,
      bankBalance: bankBalance ?? this.bankBalance,
      tempBankBalance: tempBankBalance ?? this.tempBankBalance
    );
  }

  @override
  List<Object?> get props => [status, accountName, accountNumber, bank, bankAmount, 
                              note, isBtnDisabled, bankExRate, bankBalance, tempBankBalance];
}

class WalletWithdrawBitcoinInitialized extends WalletWithdrawState {
  WalletWithdrawBitcoinInitialized({
    this.status = FormzStatus.invalid,
    this.bitcoinAmount = const BitcoinAmount.pure(),
    this.address = const Address.pure(),
    this.isBtnDisabled = false,
    this.bitcoinExRate = 0,
    this.bitcoinBalance = 0,
    this.tempBitcoinBalance = 0,
  });

  FormzStatus status;
  BitcoinAmount bitcoinAmount;
  Address address;
  bool isBtnDisabled;
  double bitcoinExRate;
  double bitcoinBalance;
  double tempBitcoinBalance;

  WalletWithdrawBitcoinInitialized copyWith({
    FormzStatus? status,
    BitcoinAmount? bitcoinAmount,
    Address? address,
    bool? isBtnDisabled,
    double? bitcoinExRate,
    double? bitcoinBalance,
    double? tempBitcoinBalance,
  }){
    return WalletWithdrawBitcoinInitialized(
      status: status ?? this.status,
      bitcoinAmount: bitcoinAmount ?? this.bitcoinAmount,
      address: address ?? this.address,
      isBtnDisabled: isBtnDisabled ?? this.isBtnDisabled,
      bitcoinExRate: bitcoinExRate ?? this.bitcoinExRate,
      bitcoinBalance: bitcoinBalance ?? this.bitcoinBalance,
      tempBitcoinBalance: tempBitcoinBalance ?? this.tempBitcoinBalance
    );
  }

  @override
  List<Object?> get props => [status, bitcoinAmount, address,  
                              isBtnDisabled, bitcoinExRate, bitcoinBalance, tempBitcoinBalance];
}

