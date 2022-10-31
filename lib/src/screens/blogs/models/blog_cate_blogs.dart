import 'package:flutter/material.dart';
import 'package:equatable/equatable.dart';
import 'package:gamble/src/screens/blogs/models/blog.dart';

class BlogCateWithChildren extends Equatable {
  final String cateId;
  final String cateName;
  final List<Blog> blogs;

  const BlogCateWithChildren({
    required this.cateId,
    required this.cateName,
    required this.blogs
  });

  @override
  List<Object?> get props => [];

  factory BlogCateWithChildren.fromJson(Map<String, dynamic> json) {
    return BlogCateWithChildren(
      cateId: json['cateId'],
      cateName: json['cateName'],
      blogs: json['blogs']
    );
  }
}