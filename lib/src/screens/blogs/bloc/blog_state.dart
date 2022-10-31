part of 'blog_bloc.dart';

class BlogState extends Equatable {
  BlogState();
  
  @override
  List<Object?> get props => [];
}

class BlogInitialized extends BlogState {}

class BlogLoaded extends BlogState {
  BlogLoaded({this.blogCates, this.latestBlogs});

  final List<BlogCateWithChildren>? blogCates;
  final List<Blog>? latestBlogs;

  @override
  List<Object> get props => [];
}

class BlogError extends BlogState {
  BlogError({required this.message});

  final String message;

  @override
  List<Object?> get props => [message];
}
// Blogs
//load blogs by cate
class BlogsInitialized extends BlogState {}

class BlogsLoadedByCate extends BlogState {
  BlogsLoadedByCate({
    this.blogs = const <Blog>[], 
    this.hasReachedMax = false
  });

  final List<Blog> blogs;
  final bool hasReachedMax;

  BlogsLoadedByCate copywith({List<Blog>? blogs, bool? hasReachedMax}){
    return BlogsLoadedByCate(
      blogs: blogs ?? this.blogs,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax
    );
  }

  @override
  List<Object?> get props => [blogs, hasReachedMax];
}

class BlogsError extends BlogState {
  BlogsError({required this.message});

  final String message;

  @override
  List<Object?> get props => [message];
}

//blog detail
class BlogDetailInitialized extends BlogState {}

class BlogDetailLoaded extends BlogState {
  BlogDetailLoaded({required this.blog, this.iconBackIsChanged = false});

  final Blog blog;
  bool iconBackIsChanged;

  @override
  BlogDetailLoaded copyWith({Blog? blog, bool? iconBackIsChanged}){
    return BlogDetailLoaded(
      blog: blog ?? this.blog,
      iconBackIsChanged: iconBackIsChanged ?? this.iconBackIsChanged
    );
  }

  @override
  List<Object?> get props => [blog, iconBackIsChanged];
}

class BlogDetailError extends BlogState {
  BlogDetailError({required this.message});

  final String message;

  @override
  List<Object?> get props => [message];
}

//search
class BlogSearchInitialized extends BlogState {}

class BlogSearchLoading extends BlogState {}

class BlogSearchNotFound extends BlogState {}

class BlogSearchLoaded extends BlogState {
  BlogSearchLoaded({this.blogSearchs = const <Blog>[], this.hasReachedMax = false, required this.search, required this.page});

  List<Blog> blogSearchs;
  bool hasReachedMax;
  String search;
  int page;

  BlogSearchLoaded copywith({List<Blog>? blogSearchs, bool? hasReachedMax, String? search, int? page}){
    return BlogSearchLoaded(
      blogSearchs: blogSearchs ?? this.blogSearchs,
      search: search ?? this.search,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      page: page ?? this.page
    );
  }

  @override
  List<Object> get props => [blogSearchs, search, hasReachedMax, page];
}