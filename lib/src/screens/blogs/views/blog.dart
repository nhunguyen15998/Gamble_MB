import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gamble/src/screens/blogs/blog.dart';
import 'package:gamble/src/screens/blogs/models/blog.dart';
import 'package:gamble/src/screens/blogs/views/blog_detail.dart';
import 'package:gamble/src/screens/blogs/views/blog_search.dart';
import 'package:gamble/src/screens/blogs/views/blogs_by_cate.dart';
import 'package:gamble/src/screens/users/signin/signin.dart';
import 'package:gamble/src/services/blog_service.dart';
import 'package:http/http.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Blogs extends StatefulWidget {
  const Blogs({Key? key}) : super(key: key);

  @override
  State<Blogs> createState() => _BlogsState();
}

class _BlogsState extends State<Blogs> with TickerProviderStateMixin{
  
  final PageController cateController = PageController(viewportFraction: 0.2);
  late TabController tabController;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double ratio = size.width / size.height;

    int selectedTab = 0;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: RepositoryProvider(
        create: (context) => BlogManagement(),
        child: BlocProvider(
          create: (context) => BlogBloc(RepositoryProvider.of<BlogManagement>(context))..add(BlogInitial()),
          child: Scaffold(
            backgroundColor: const Color.fromARGB(255, 236, 238, 250),
            body: Padding(
              padding: EdgeInsets.only(bottom: ratio*30),
              child: Column(
                children: [
                  SizedBox(
                    height: size.height*0.44,
                    width: size.width,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                          child: Text('Breaking News',
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style: TextStyle(
                              color: const Color.fromRGBO(31, 6, 68, 1),
                              fontSize: ratio*70,
                              fontFamily: 'Play',
                              fontWeight: FontWeight.w600
                            ),
                          ),
                        ),
                        Expanded(
                          child: BlocBuilder<BlogBloc, BlogState>(
                            builder: (context, state) {
                              if(state is BlogLoaded){
                                var latestBlogs = state.latestBlogs;
                                return BlogBreakingNewsItem(latestBlog: latestBlogs!);
                              } else {
                                return Center(
                                  child: CircularProgressIndicator(
                                    value: ratio*40,
                                    color: Colors.amber,
                                  )
                                );
                              }
                            },
                          )
                        )
                      ],
                    )
                  ),
                  // tab
                  Container(
                    margin: const EdgeInsets.only(top: 15),
                    width: size.width,
                    child: BlocBuilder<BlogBloc, BlogState>(
                      builder: (context, state) {
                        if(state is BlogLoaded){
                          var cates = state.blogCates;
                          tabController = TabController(length: cates!.length, vsync: this);
                          return TabBar(
                            controller: tabController,
                            indicatorWeight: ratio*5,
                            indicatorColor: const Color.fromRGBO(31, 6, 68, 1),
                            indicatorSize: TabBarIndicatorSize.label,
                            isScrollable: true,
                            tabs: cates!.map((e) => Tab(
                                icon: Text(e.cateName, 
                                  style: TextStyle(
                                    color: const Color.fromRGBO(31, 6, 68, 1),
                                    fontFamily: 'Play',
                                    fontSize: ratio*30,
                                    fontWeight: FontWeight.w600
                                  ),
                                ),
                              )
                            ).toList()
                          );
                        } else {
                          return Center(
                              child: CircularProgressIndicator(
                              value: ratio*40,
                              color: Colors.amber,
                            )
                          );
                        }
                      },
                    )
                  ),
                  //list blog
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.only(top: ratio*30),
                      child: BlocBuilder<BlogBloc, BlogState>(
                        builder: (context, state) {
                          if(state is BlogLoaded){
                            var blogs = state.blogCates; 
                            return TabBarView(
                              controller: tabController,
                              children: blogs!.map((e) => BlogList(blogs: e.blogs, cateId: int.parse(e.cateId))).toList()
                            );
                          } 
                          return const SizedBox();
                        },
                      )
                    )
                  )
                ],
              )
            )
          )
        )
      )
    );
  }
}

//blog list
class BlogList extends StatelessWidget {
  const BlogList({Key? key, required this.blogs, required this.cateId}) : super(key: key);

  final List<Blog> blogs;
  final int cateId;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double ratio = size.width / size.height;
    
    return SingleChildScrollView(
      child: Column(
        children: [
          ListView.separated(
            itemCount: blogs.length,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            separatorBuilder: (context, index) => Divider(
              indent: ratio*30,
              endIndent: ratio*30,
              thickness: ratio*0.5,
              color: index == blogs.length - 1 ? Colors.transparent : Colors.black87,
            ),
            itemBuilder: (context, index) {
              Blog blog = blogs[index];
              return BlogItem(blog: blog);
            }
          ),
          (blogs.length == 3 ? 
          BlocBuilder<BlogBloc, BlogState>(
            builder: (context, state) {
              return TextButton(
                onPressed: () {
                  Navigator.push(context,
                    MaterialPageRoute(builder: (context) {
                      return BlogsByCate(cateId: cateId);
                    }),
                  );
                }, 
                child: Text('View more'.toUpperCase(),
                  style: TextStyle(
                    fontFamily: 'Play',
                    fontSize: ratio*35,
                    color: const Color.fromRGBO(31, 6, 68, 1),
                  )
                )
              );
            },
          )
          : const SizedBox())
        ],
      )
    );
  }
}

class BlogItem extends StatefulWidget {
  BlogItem({Key? key, required this.blog}): super(key: key);

  Blog blog;

  @override
  State<BlogItem> createState() => _BlogItemState();
}

class _BlogItemState extends State<BlogItem> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double ratio = size.width / size.height;
    Blog blog = widget.blog;

    return GestureDetector(
      onTap: (() {
        Navigator.push(context,
          MaterialPageRoute(builder: (context) {
            return BlogDetail(blogId: blog.id);
          }),
        );
      }),
      child: ListTile(
        title: Container(
          padding: EdgeInsets.symmetric(vertical: ratio*20),
          width: size.width,
          height: size.height*0.2,
          decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(ratio*10)
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: size.width*0.65,
                child: Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 5),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: Colors.amber,
                        ),
                        child: Text(blog.blogCateName!,
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style: TextStyle(
                            color: Colors.black,
                            fontFamily: 'Play',
                            fontSize: ratio*30
                          ),
                        )
                      ),
                      Text(blog.description!,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: ratio*40,
                          fontFamily: 'Play',
                          fontWeight: FontWeight.w600
                        ),
                      ),
                      Text(blog.createdAt!,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: const TextStyle(
                          color: Colors.black,
                          fontFamily: 'Play',
                        ),
                      ),
                    ],
                  )
                ),
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: ratio*10),
                  child: ClipRRect(
                    borderRadius: const BorderRadius.all(Radius.circular(15)),
                    child: Image.network(dotenv.env['HOST']!+blog.thumbnail!, height: size.height*0.25, fit: BoxFit.cover),
                  )
                )
              ), 
            ],
          )
        )
      )
    );
  }
}

//breaking news 
class BlogBreakingNewsItem extends StatefulWidget {
  BlogBreakingNewsItem({Key? key, required this.latestBlog}):super(key: key);

  List<Blog> latestBlog;

  @override
  State<BlogBreakingNewsItem> createState() => _BlogBreakingNewsItemState();
}

class _BlogBreakingNewsItemState extends State<BlogBreakingNewsItem> with SingleTickerProviderStateMixin {
  int _currentPage = 0;
  late Timer _timer;
  
  final PageController pageController = PageController(initialPage: 0, viewportFraction: 1);

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 5), (Timer timer) {
      if (_currentPage < 2) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }

      pageController.animateToPage(
        _currentPage,
        duration: const Duration(milliseconds: 350),
        curve: Curves.decelerate,
      );
    });
  }

  @override
  void dispose() {
    super.dispose();
    _timer.cancel();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double ratio = size.width / size.height;
    List<Blog> latestBlogs = widget.latestBlog;

    return PageView.builder(
      padEnds: false,
      itemCount: latestBlogs!.length,
      controller: pageController,
      itemBuilder: (context, pagePosition) {
        return GestureDetector(
          onTap: (() {
            Navigator.push(context,
              MaterialPageRoute(builder: (context) {
                return BlogDetail(blogId: latestBlogs[pagePosition].id);
              }),
            );
          }),
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.all(Radius.circular(15)),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  blurRadius: 2,
                  offset: const Offset(0, 0), 
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: size.height*0.2,
                  width: size.width-40,
                  child: ClipRRect(
                    borderRadius: const BorderRadius.all(Radius.circular(15)),
                    child: Image.network(dotenv.env['HOST']!+latestBlogs[pagePosition].thumbnail!, fit: BoxFit.cover),
                  )
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Text(latestBlogs[pagePosition].title!,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                    textAlign: TextAlign.justify,
                    style: TextStyle(
                      color: const Color.fromRGBO(31, 6, 68, 1),
                      fontSize: ratio*40,
                      fontFamily: 'Play',
                      fontWeight: FontWeight.w600
                    ),
                  )
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 5),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: Colors.amber,
                        ),
                        child: Text(latestBlogs[pagePosition].blogCateName!,
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style: TextStyle(
                            color: Colors.black,
                            fontFamily: 'Play',
                            fontSize: ratio*30
                          ),
                        )
                      )
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      child: Text(latestBlogs[pagePosition].createdAt!.toString(),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        textAlign: TextAlign.justify,
                        style: TextStyle(
                          color: const Color.fromRGBO(31, 6, 68, 1),
                          fontSize: ratio*30,
                          fontFamily: 'Play',
                        ),
                      )
                    ),
                  ],
                )
              ],
            ),
          )
        );
      }
    );
    
  }
}

//search
class BlogSearchIconButton extends StatefulWidget {
  const BlogSearchIconButton({super.key});

  @override
  State<BlogSearchIconButton> createState() => _BlogSearchIconButtonState();
}

class _BlogSearchIconButtonState extends State<BlogSearchIconButton> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double ratio = size.width / size.height;

    return IconButton(
      focusColor: const Color.fromRGBO(250, 0, 159, 1),
      icon: const Icon(Icons.search),
      onPressed: () {
        Navigator.push(context,
          MaterialPageRoute(builder: (context) {
            return BlogSearch();
          }),
        );
      },
    );
  }
}