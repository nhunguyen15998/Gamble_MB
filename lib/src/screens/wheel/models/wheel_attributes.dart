import 'package:flutter/material.dart';
import 'package:equatable/equatable.dart';
import 'package:intl/intl.dart';

class WheelAttributes extends Equatable {
  String slice;
  int color;
  int textColor;

  WheelAttributes({
    required this.slice,
    required this.color,
    required this.textColor,
  });

  @override
  List<Object?> get props => [slice, color, textColor];

  factory WheelAttributes.fromJson(Map<String, dynamic> json, int num, int index) {
    return WheelAttributes(
      slice: json['slices$num'][index].toString(),
      color: int.parse(json['colors$num'][index].toString().replaceAll("#", "0xff")),
      textColor: int.parse(json['textColors$num'][index].toString().replaceAll("#", "0xff")),
    );
  }
  
}