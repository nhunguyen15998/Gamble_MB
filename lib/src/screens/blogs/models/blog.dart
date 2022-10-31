import 'package:flutter/material.dart';
import 'package:equatable/equatable.dart';
import 'package:intl/intl.dart';

class Blog extends Equatable {
  final int id;
  final String? title;
  final String? content;
  final int? blogCateId;  
  final int? authorId;
  final String? blogCateName;
  final String? authorName;
  final String? thumbnail;
  final String? description;
  final String? urlSlug;
  final String? cateSlug;
  final int? cateStatus;
  final String? createdAt;
  final int? status;  

  const Blog({
    required this.id,
    required this.title,
    required this.content,
    required this.blogCateId,
    required this.authorId,
    required this.blogCateName,
    required this.authorName,
    required this.thumbnail,
    required this.description,
    required this.urlSlug,
    required this.cateSlug,
    required this.cateStatus,
    required this.createdAt,
    required this.status,
  });

  @override
  List<Object?> get props => [];

  factory Blog.fromJson(Map<String, dynamic> json) {
    return Blog(
      id: json['id'],
      title: json['title'],
      content: json['content'],
      blogCateId: json['blog_cate_id'],
      authorId: json['author_id'],
      blogCateName: json['blog_cate_name'],
      authorName: json['author_name'],
      createdAt: DateFormat("dd/MM/yyyy").format(DateTime.parse(json['created_at'])).toString(),
      status: json['status'],
      description: json['description'],
      thumbnail: json['thumbnail'],
      urlSlug: json['url_slug'],
      cateSlug: json['cate_slug'],
      cateStatus: json['cate_status']
    );
  }

}