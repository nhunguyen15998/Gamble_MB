import 'package:flutter/material.dart';
import 'package:equatable/equatable.dart';
import 'package:intl/intl.dart';

class TransactionListItem extends Equatable {
  final int id;
  final int? userId;
  final String code;
  final String amount;
  final int type;
  final int method;
  final int sender;
  final int? receiver;
  final String createdAt;
  final int status;
  final String name;
  final String? receiverName;

  const TransactionListItem({
    required this.id,
    required this.userId,
    required this.code,
    required this.amount,
    required this.type,
    required this.method,
    required this.sender,
    required this.receiver,
    required this.createdAt,
    required this.status,
    required this.name,
    required this.receiverName
  });

  @override
  List<Object?> get props => [];

  factory TransactionListItem.fromJson(Map<String, dynamic> json) {
    return TransactionListItem(
      id: json['transaction_id'],
      userId: json['user_id'],
      code: json['code'],
      type: json['type'],
      method: json['method'],
      sender: json['sender'],
      receiver: json['receiver'],
      createdAt: DateFormat("dd/MM/yyyy").format(DateTime.parse(json['transaction_created_at'])).toString(),
      status: json['transaction_status'],
      amount: NumberFormat.currency(customPattern: "#,###.", decimalDigits: 7).format(json['transaction_status'] == 0 ? json['amount'] : json['received_amount']),
      name: json['first_name']+" "+json['last_name'],
      receiverName: json['receiver_first_name'] != null && json['receiver_last_name'] != null ? json['receiver_first_name']+" "+json['receiver_last_name'] : null,
    );
  }

}