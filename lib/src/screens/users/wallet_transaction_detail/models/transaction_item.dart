import 'package:flutter/material.dart';
import 'package:equatable/equatable.dart';
import 'package:intl/intl.dart';

class TransactionItemDetail extends Equatable {
  final int id;
  final String code;
  final String amount;
  final int type;
  final int method;
  final String? note;
  final int sender;
  final int? receiver;
  final String createdAt;
  final int status;
  final String senderName;
  final String? receiverName;
  final String? bcaddress;
  final String? accountName;
  final String? accountNumber;
  final String? bank;

  const TransactionItemDetail({
    required this.id,
    required this.code,
    required this.amount,
    required this.type,
    required this.method,
    required this.note,
    required this.sender,
    required this.receiver,
    required this.createdAt,
    required this.status,
    required this.senderName,
    required this.receiverName,
    required this.bcaddress,
    required this.accountName,
    required this.accountNumber,
    required this.bank
  });

  @override
  List<Object?> get props => [];

  factory TransactionItemDetail.fromJson(Map<String, dynamic> json) {
    return TransactionItemDetail(
      id: json['transaction_id'],
      code: json['code'],
      type: json['type'],
      method: json['method'],
      sender: json['sender'],
      receiver: json['receiver'],
      createdAt: DateFormat("dd/MM/yyyy - HH:MM:ss").format(DateTime.parse(json['transaction_created_at'])).toString(),
      status: json['transaction_status'],
      amount: NumberFormat.currency(customPattern: "#,###.", decimalDigits: 4).format(json['amount']),
      senderName: json['sender_first_name'] != null && json['sender_last_name'] != null ? json['sender_first_name']+" "+json['sender_last_name'] : null,
      receiverName: json['receiver_first_name'] != null && json['receiver_last_name'] != null ? json['receiver_first_name']+" "+json['receiver_last_name'] : null,
      bcaddress: json['bcaddress'],
      accountName: json['account_name'],
      accountNumber: json['account_number'],
      bank: json['bank'],
      note: json['note']
    );
  }

}