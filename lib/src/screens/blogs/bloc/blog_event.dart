part of 'blog_bloc.dart';

abstract class BlogEvent extends Equatable {
  const BlogEvent();

  @override
  List<Object> get props => [];
}

//Fired when the tab blog is loaded
class BlogInitial extends BlogEvent {}

//Fired when search input changed

//Fired when sorting by date

//blogs by cate - fetch
class BlogsInitial extends BlogEvent {
  BlogsInitial({required this.cateId, this.page = 1});

  final int cateId;
  int page;

  @override
  List<Object> get props => [cateId, page];
}

class BlogsFetched extends BlogEvent {
  BlogsFetched({required this.cateId, this.page = 1, this.hasReachedMax = false});

  final int cateId;
  int page;
  bool hasReachedMax;

  @override
  List<Object> get props => [cateId, page, hasReachedMax];
}

//blog detail
class BlogDetailInitial extends BlogEvent {
  const BlogDetailInitial({required this.blogId});

  final int blogId;

  @override
  List<Object> get props => [blogId];
}

class BlogDetailIconBackChanged extends BlogEvent {
  BlogDetailIconBackChanged({this.blog, required this.iconBackIsChanged});

  Blog? blog;
  bool iconBackIsChanged;

  @override
  List<Object> get props => [];
}

//search
class BlogSearchInitial extends BlogEvent {}

class BlogSearchChanged extends BlogEvent {
  BlogSearchChanged({this.search, required this.page});

  String? search;
  int page;

  @override
  List<Object> get props => [];
}