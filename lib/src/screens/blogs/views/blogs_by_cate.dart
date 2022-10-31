import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gamble/src/screens/blogs/blog.dart';
import 'package:gamble/src/screens/blogs/views/blog_detail.dart';
import 'package:gamble/src/screens/master/master.dart';
import 'package:gamble/src/services/blog_service.dart';
import 'package:http/http.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BlogsByCate extends StatefulWidget {
  const BlogsByCate({Key? key, required this.cateId}) : super(key:key);

  final int cateId;

  @override
  State<BlogsByCate> createState() => _BlogsByCateState();
}

class _BlogsByCateState extends State<BlogsByCate> {

  @override
  Widget build(BuildContext context) {
    final cateId = widget.cateId;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: RepositoryProvider(
        create: (context) => BlogManagement(),
        child: BlocProvider(
          create: (context) => BlogBloc(RepositoryProvider.of<BlogManagement>(context))..add(BlogsInitial(cateId: cateId)),
          child: BlogsBody(cateId: cateId)
        )
      )
    );
  }
}

class BlogsBody extends StatefulWidget {
  const BlogsBody({Key? key, required this.cateId}) : super(key: key);

  final int cateId;

  @override
  State<BlogsBody> createState() => _BlogsBodyState();
}

class _BlogsBodyState extends State<BlogsBody> {

  ScrollController scrollController = ScrollController();
  late BlogBloc blogBloc; 
  int page = 1;

  scrollListener() {
    final cateId = widget.cateId;
    double pos = scrollController.position.pixels;
    double maxScrollExtent = scrollController.position.maxScrollExtent;
    if(pos == maxScrollExtent) {
     page++;
     blogBloc.add(BlogsInitial(cateId: cateId, page: page));
    } 
  }

  Future<void> onRefresh() async {
    final cateId = widget.cateId;
    page = 1;
    blogBloc.add(BlogsInitial(cateId: cateId, page: page));
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

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          focusColor: const Color.fromRGBO(250, 0, 159, 1),
          icon: const Icon(FontAwesomeIcons.chevronLeft),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: BlocBuilder<BlogBloc, BlogState>(
          builder: (context, state) {
            if(state is BlogsLoadedByCate){
              return Text(state.blogs[0].blogCateName.toString());
            }
            return const SizedBox();
          },
        ),
        backgroundColor: const Color.fromRGBO(62, 29, 117, 1),
        actions: <Widget>[
          IconButton(
            focusColor: const Color.fromRGBO(250, 0, 159, 1),
            icon: const Icon(FontAwesomeIcons.bell),
            onPressed: () {
              
            },
          ),
        ],
      ),
      backgroundColor: const Color.fromARGB(255, 192, 162, 236),
      body: 
      BlocBuilder<BlogBloc, BlogState>(
        builder: (context, state) {
          if(state is BlogsInitialized){
            return const Center(child: CircularProgressIndicator());
          }
          if(state is BlogsLoadedByCate){
            List<Blog> blogs = state.blogs;
            return RefreshIndicator(
              onRefresh: onRefresh,
              child: ListView.separated(
                controller: scrollController,
                itemCount: state.hasReachedMax ? blogs.length : blogs.length+1,
                shrinkWrap: true,
                separatorBuilder: (context, index) => Divider(
                  indent: ratio*30,
                  endIndent: ratio*30,
                  thickness: ratio*0.5,
                  color: Colors.black87,
                ),
                itemBuilder: (context, index) {
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
        },
      )
    );
  }
}