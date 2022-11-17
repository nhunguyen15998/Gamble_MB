import 'package:flutter/material.dart';
import 'package:equatable/equatable.dart';
import 'package:intl/intl.dart';

class VNPay extends Equatable {
  final int code;
  final String? message;
  final String data;

  const VNPay({
    required this.code,
    required this.message,
    required this.data
  });

  @override
  List<Object?> get props => [];

  factory VNPay.fromJson(Map<String, dynamic> json) {
    print(json['data']);
    return VNPay(
      code: json['code'],
      message: json['message'],
      data: json['data']
    );
  }

}