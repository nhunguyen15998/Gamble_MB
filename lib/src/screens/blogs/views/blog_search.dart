import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gamble/src/screens/blogs/bloc/blog_bloc.dart';
import 'package:gamble/src/screens/blogs/models/blog.dart';
import 'package:gamble/src/screens/blogs/views/blog_detail.dart';
import 'package:gamble/src/services/service.dart';
import 'package:http/http.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class BlogSearch extends StatefulWidget {
  const BlogSearch({Key? key}) : super(key: key);

  @override
  State<BlogSearch> createState() => _BlogSearchState();
}

class _BlogSearchState extends State<BlogSearch> {
  int page = 1;
  String search = "";

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double ratio = size.width / size.height;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: SafeArea(
        child: RepositoryProvider(
          create: (context) => BlogManagement(),
          child: BlocProvider(
            create: (context) => BlogBloc(RepositoryProvider.of<BlogManagement>(context))..add(BlogSearchInitial()),
            child: BlocBuilder<BlogBloc, BlogState>(
              builder: (context, state) {
                if(state is BlogSearchLoaded){
                  search = state.search;
                  page = state.page;
                }
                return Scaffold(
                  appBar: AppBar(
                    leading: IconButton(
                      focusColor: const Color.fromRGBO(250, 0, 159, 1),
                      icon: const Icon(FontAwesomeIcons.chevronLeft),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                    flexibleSpace: BlogSearchInput(),
                    backgroundColor: const Color.fromRGBO(62, 29, 117, 1),
                  ),
                  backgroundColor: const Color.fromARGB(255, 192, 162, 236),
                  body: BlogSearchBody(search: search, page: page)
                );
              }
            )
          )
        )
      )
    );
  }
}

//search input
class BlogSearchInput extends StatefulWidget {
  BlogSearchInput({Key? key}):super(key:key);

  @override
  State<BlogSearchInput> createState() => _BlogSearchInputState();
}

class _BlogSearchInputState extends State<BlogSearchInput> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double ratio = size.width / size.height;

    return Center(
      child: Container(
        margin: EdgeInsets.only(left: ratio*110, right: ratio*30),
        height: ratio*80,
        child: TextField(
          key: const Key('BlogSearch_searchField'),
          style: const TextStyle(color: Color.fromRGBO(255, 255, 255, 1)),
          decoration: InputDecoration(
            hintText: 'Search',
            hintStyle: const TextStyle(color: Colors.white),
            contentPadding: EdgeInsets.symmetric(horizontal: ratio*30),
            filled: true,
            fillColor: Colors.white.withOpacity(0.2),
            border: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(50)),
              borderSide: BorderSide(color: Color.fromRGBO(210, 213, 252, 1), width: 1)
            ),
            focusedErrorBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(50)),
              borderSide: BorderSide(color: Color.fromRGBO(218, 62, 59, 1), width: 1)
            )
          ),
          onChanged: (value) {

            context.read<BlogBloc>().add(BlogSearchChanged(search: value, page: 1));
          },
        )
      )
    );
  }
}

//search body
class BlogSearchBody extends StatefulWidget {
  BlogSearchBody({Key? key, required this.search, required this.page}):super(key: key);

  int page;
  String search;

  @override
  State<BlogSearchBody> createState() => _BlogSearchBodyState();
}

class _BlogSearchBodyState extends State<BlogSearchBody> {

  ScrollController scrollController = ScrollController();
  late BlogBloc blogBloc; 

  scrollListener() {
    int page = widget.page;
    double pos = scrollController.position.pixels;
    double maxScrollExtent = scrollController.position.maxScrollExtent;
    if(pos == maxScrollExtent) {
     page++;
     print("page: $page");
     blogBloc.add(BlogSearchChanged(search: widget.search, page: page));
    } 
  }

  Future<void> onRefresh() async {
    int page = widget.page;
    page = 1;
    blogBloc.add(BlogSearchChanged(search: widget.search, page: page));
  }

  @override
  void initState() {
    super.initState();
    scrollController.addListener(scrollListener);
    blogBloc = context.read<BlogBloc>(); 
  }
  
  @override
  void dispose() {
    super.dispose();
    scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double ratio = size.width / size.height;

    return BlocBuilder<BlogBloc, BlogState>(
      builder: (context, state) {
        if(state is BlogSearchLoading){
          return const Center(child: CircularProgressIndicator());
        }
        if(state is BlogSearchNotFound){
          return const Center(child: Text('Not found'));
        }
        if(state is BlogSearchLoaded){
          List<Blog> blogs = state.blogSearchs;
          print(blogs);
          String search = state.search;
          bool hasReachedMax = state.hasReachedMax;
          print("here");
          return RefreshIndicator(
            onRefresh: onRefresh,
            child: ListView.separated(
              controller: scrollController,
              itemCount: hasReachedMax ? blogs.length : blogs.length+1,
              shrinkWrap: true,
              separatorBuilder: (context, index) => Divider(
                indent: ratio*30,
                endIndent: ratio*30,
                thickness: ratio*0.5,
                color: Colors.black87,
              ),
              itemBuilder: (context, index) {
                if(blogs.isEmpty){
                  return const SizedBox();
                }
                if(index >= blogs.length){
                  return Container(
                    padding: EdgeInsets.only(bottom: ratio*20),
                    alignment: Alignment.center,
                    child: const Center(
                      child: CircularProgressIndicator()
                    ),
                  );
                }
                Blog blog = blogs[index];
                return ListTile(
                  title: GestureDetector(
                    onTap: () {
                      Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                          return BlogDetail(blogId: blog.id);
                        }),
                      );
                    },
                    child: Container(
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
                                    child: Text(blog.blogCateName!+blog.id.toString(),
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
                                  Text(blog.title!,
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
            )
          );
        }
        return const SizedBox();
      }
    );
  }
}
