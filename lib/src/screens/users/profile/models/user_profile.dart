import 'package:flutter/material.dart';
import 'package:equatable/equatable.dart';
import 'package:intl/intl.dart';

class Profile extends Equatable {
  final int id;
  final String phone;
  final String email;
  final String firstName;  
  final String lastName;
  final String birth;
  final int gender;
  final String thumbnail;
  final String wallpaper;
  final String createdAt;
  final int status; 
  final String balance; 

  const Profile({
    required this.id,
    required this.phone,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.birth,
    required this.gender,
    required this.thumbnail,
    required this.wallpaper,
    required this.createdAt,
    required this.status,
    required this.balance
  });

  @override
  List<Object?> get props => [];

  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
      id: json['id'],
      phone: json['phone'],
      email: json['email'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      birth: DateFormat("dd/MM/yyyy").format(DateTime.parse(json['birth'])).toString(),
      gender: json['gender'],
      createdAt: DateFormat("dd/MM/yyyy").format(DateTime.parse(json['created_at'])).toString(),
      status: json['status'],
      wallpaper: json['wallpaper'],
      thumbnail: json['thumbnail'],
      balance: NumberFormat.currency(customPattern: "#,###.", decimalDigits: 4).format(json['cur_amount'])
    );
  }

}