import 'package:flutter/material.dart';
import 'package:equatable/equatable.dart';

class BlogCate extends Equatable {
  final int id;
  final String name;
  final String urlSlug;
  final String createdAt;
  final int status;

  const BlogCate({
    required this.id,
    required this.name,
    required this.urlSlug,
    required this.createdAt,
    required this.status,
  });

  @override
  List<Object?> get props => [id, name, urlSlug, createdAt, status];

  factory BlogCate.fromJson(Map<String, dynamic> json) {
    return BlogCate(
      id: json['id'],
      name: json['name'],
      createdAt: json['created_at'],
      status: json['status'],
      urlSlug: json['url_slug'],
    );
  }
}