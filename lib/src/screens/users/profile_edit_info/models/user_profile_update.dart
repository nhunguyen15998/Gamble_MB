import 'package:flutter/material.dart';
import 'package:equatable/equatable.dart';
import 'package:intl/intl.dart';

class ProfileUpdate extends Equatable {
  final String email;
  final String firstName;  
  final String lastName;
  final String birth;
  final int gender;

  const ProfileUpdate({
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.birth,
    required this.gender
  });

  @override
  List<Object?> get props => [];

  factory ProfileUpdate.fromJson(Map<String, dynamic> json) {
    return ProfileUpdate(
      email: json['email'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      birth: DateFormat("dd/MM/yyyy").format(DateTime.parse(json['birth'])).toString(),
      gender: json['gender']
    );
  }

}