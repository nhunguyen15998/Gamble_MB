import 'dart:convert';
import 'dart:io';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:gamble/src/screens/blogs/models/blog.dart';
import 'package:gamble/src/screens/blogs/models/blog_cate_blogs.dart';
import 'package:http/http.dart' as http;

abstract class BlogService {
  Future<List<Blog>> getLatestBlogs();
  Future<List<BlogCateWithChildren>> getBlogCatesAndRelatedBlogs();
  Future<List<Blog>> getBlogsByCates(int cateId, int page);
  Future<Blog?> getBlogById(int blogId);
  Future<List<Blog>> searchBlog(String search, int page);
}

class BlogManagement extends BlogService {
  final headers = {
    HttpHeaders.contentTypeHeader: 'application/json',
    "auth": dotenv.env['TOKEN'].toString()
  };

  @override
  Future<List<Blog>> getLatestBlogs() async {
    //final response = await http.get(Uri.parse("${dotenv.env['HOST']!}api/article/latest-blogs?limit=$param"));
    final response = await http.get(Uri.parse("${dotenv.env['HOST']!}api/article/latest-blogs"), headers: headers);
    if (response.statusCode == 200) {
      List<Blog> list = <Blog>[];
      for (var item in jsonDecode(response.body)) {
        list.add(Blog.fromJson(item));
      }
      return list;
    } else {
      throw Exception('Failed');
    }
  }

  @override
  Future<List<BlogCateWithChildren>> getBlogCatesAndRelatedBlogs() async {
    var list = <BlogCateWithChildren>[];
    try {
      final response = await http.get(Uri.parse("${dotenv.env['HOST']!}api/article/cates/blogs"), headers: headers);
      if (response.statusCode == 200) {
        for (var item in jsonDecode(response.body)){
          var blogs = <Blog>[];
          List<dynamic> convertedBlog = item['blogs'];
          for(var blog in convertedBlog){
            blogs.add(Blog.fromJson(blog));
          }
          var blogCate = BlogCateWithChildren(cateId: item['cateId'], cateName: item['cateName'], blogs: blogs);
          list.add(blogCate);
        }
      } else {
        throw Exception('Failed');
      }
    } catch (e) {
      print(e);
    }
    return list;
  }

  @override
  Future<List<Blog>> getBlogsByCates(int cateId, int page) async {
    final response = await http.get(Uri.parse("${dotenv.env['HOST']!}api/articles?cateId=$cateId&page=$page"), headers: headers);
    if (response.statusCode == 200) {
      List<Blog> list = <Blog>[];
      for (var item in jsonDecode(response.body)) {
        list.add(Blog.fromJson(item));
      }
      return list;
    } else {
      throw Exception('Failed');
    }
  }

  @override
  Future<Blog?> getBlogById(int blogId) async{
    try {
      final response = await http.get(Uri.parse("${dotenv.env['HOST']!}api/articles/detail?blogId=$blogId"), headers: headers);
      if (response.statusCode == 200) {
        return Blog.fromJson(jsonDecode(response.body));
      } else {
          throw Exception('Failed');
      }
    } catch (e) {
      print(e);
      return null;
    }
  }

  @override
  Future<List<Blog>> searchBlog(String search, int page) async {
    List<Blog> blogs = <Blog>[];
    try {
      if(search.isEmpty) return blogs;
      final response = await http.get(Uri.parse("${dotenv.env['HOST']!}api/articles/search-results?search=$search&page=$page"), headers: headers);
      if (response.statusCode == 200) {
        for(var item in jsonDecode(response.body)){
          blogs.add(Blog.fromJson(item));
        }
      } else {
        throw Exception('Failed');
      }
    } catch (e) {
      print(e);
    }
    return blogs;
  }

}
