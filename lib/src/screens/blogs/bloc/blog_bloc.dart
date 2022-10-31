import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:gamble/src/screens/blogs/models/blog.dart';
import 'package:gamble/src/screens/blogs/models/blog_cate.dart';
import 'package:gamble/src/screens/blogs/models/blog_cate_blogs.dart';
import 'package:gamble/src/services/blog_service.dart';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

part 'blog_event.dart';
part 'blog_state.dart';

class BlogBloc extends Bloc<BlogEvent, BlogState> {
  final BlogService blogService;

  BlogBloc(this.blogService) : super(BlogState()) {
    on<BlogInitial>(_mapBlogInitialToState);
    on<BlogsInitial>(_mapBlogsFetchedToState);
    on<BlogDetailInitial>(_mapBlogDetailInitialToState);
    on<BlogDetailIconBackChanged>(_mapBlogDetailIconBackChangedToState);
    on<BlogSearchInitial>(_mapBlogSearchInitialToState);
    on<BlogSearchChanged>(_mapBlogSearchChangedToState);
  }

  Future<void> _mapBlogInitialToState(BlogInitial event, Emitter<BlogState> emit) async {
    emit(BlogInitialized());
    try {
      //latest blogs
      final latestBlogs = await blogService.getLatestBlogs();
      //cates
      final cates = await blogService.getBlogCatesAndRelatedBlogs();
      if (latestBlogs.isNotEmpty && cates.isNotEmpty) {
        emit(BlogLoaded(latestBlogs: latestBlogs, blogCates: cates));
      }
    } catch (e) {
      print(e);
      emit(BlogError(message: e.toString()));
    }
  }

  //blog list
  Future<void> _mapBlogsFetchedToState(BlogsInitial event, Emitter<BlogState> emit) async {
    List<Blog> blogs;
    try {
      final cateId = event.cateId;
      final page = event.page;
      if(page == 1){
        emit(BlogsInitialized());
        blogs = await blogService.getBlogsByCates(cateId, 1);
        emit(BlogsLoadedByCate(blogs: blogs));
      } else {
        BlogsLoadedByCate blogsLoadedByCate = state as BlogsLoadedByCate;
        blogs = await blogService.getBlogsByCates(cateId, page);
        emit(blogs.isEmpty ? 
             blogsLoadedByCate.copywith(hasReachedMax: true) : 
             blogsLoadedByCate.copywith(blogs: blogsLoadedByCate.blogs + blogs));
      }
    } catch (e) {
      print(e);
      emit(BlogsError(message: e.toString()));
    }
  }

  //blog detail
  Future<void> _mapBlogDetailInitialToState(BlogDetailInitial event, Emitter<BlogState> emit) async {
    emit(BlogDetailInitialized());
    try {
      final blogId = event.blogId;
      Blog? blog = await blogService.getBlogById(blogId); 
      if(blog != null){
        emit(BlogDetailLoaded(blog: blog));
      }
    } catch (e) {
      print(e);
      emit(BlogDetailError(message: e.toString()));
    }
  }

  void _mapBlogDetailIconBackChangedToState(BlogDetailIconBackChanged event, Emitter<BlogState> emit) async {
    final iconBackIsChanged = event.iconBackIsChanged;
    if(state is BlogDetailLoaded){
      BlogDetailLoaded blogDetailLoaded = state as BlogDetailLoaded;
      emit(blogDetailLoaded.copyWith(iconBackIsChanged: iconBackIsChanged));
    }
  }

  //search
  void _mapBlogSearchInitialToState(BlogSearchInitial event, Emitter<BlogState> emit) async {}
  
  Future<void> _mapBlogSearchChangedToState(BlogSearchChanged event, Emitter<BlogState> emit) async {
    List<Blog> blogs;
    try {
      final page = event.page;
      final search = event.search;
      print(state);
      if(search!.isEmpty){
        emit(BlogSearchInitialized());
      }
      if(search.isNotEmpty && page == 1){
        emit(BlogSearchLoading());
        // await Future.delayed(const Duration(seconds: 2));
        blogs = await blogService.searchBlog(search, page);
        emit(blogs.isEmpty ? 
             BlogSearchNotFound() : 
             BlogSearchLoaded(blogSearchs: blogs, search: search, page: page));
      } 
      if(search.isNotEmpty && page != 1){
        BlogSearchLoaded blogSearchLoaded = state as BlogSearchLoaded;
        blogs = await blogService.searchBlog(search, page);
        emit(blogs.isEmpty ? 
             blogSearchLoaded.copywith(hasReachedMax: true, search: search) : 
             blogSearchLoaded.copywith(blogSearchs: blogSearchLoaded.blogSearchs + blogs, search: search, page: page));
      }
      print(state);
    } catch (e) {
      print(e);
    }
  }

}
