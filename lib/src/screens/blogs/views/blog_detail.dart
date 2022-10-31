import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gamble/src/screens/blogs/bloc/blog_bloc.dart';
import 'package:gamble/src/screens/blogs/models/blog.dart';
import 'package:gamble/src/services/service.dart';
import 'package:http/http.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class BlogDetail extends StatefulWidget {
  const BlogDetail({Key? key, required this.blogId}) : super(key: key);

  final int blogId;

  @override
  State<BlogDetail> createState() => _BlogDetailState();
}

class _BlogDetailState extends State<BlogDetail> {

  @override
  Widget build(BuildContext context) {
    final blogId = widget.blogId;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: SafeArea(
      //   CustomScrollView(
      //   slivers: [
      //     SliverAppBar(
      //       expandedHeight: 300,
      //       flexibleSpace: FlexibleSpaceBar(
      //         background: Image.asset("lib/assets/images/h1.jpeg", width: double.maxFinite, fit: BoxFit.cover),
      //         collapseMode: CollapseMode.pin,
      //       ),
      //       floating: true,
      //     ),
          
      //   ],
      // )
        child: Scaffold(
          backgroundColor: const Color.fromARGB(255, 192, 162, 236),
          body: RepositoryProvider(
            create: (context) => BlogManagement(),
            child: BlocProvider(
              create: (context) => BlogBloc(RepositoryProvider.of<BlogManagement>(context))..add(BlogDetailInitial(blogId: blogId)),
              child: BlocBuilder<BlogBloc, BlogState>(
                builder: (context, state) {
                  if(state is BlogDetailInitialized){
                    return const Center(child: CircularProgressIndicator());
                  }
                  if(state is BlogDetailLoaded){
                    Blog blog = state.blog;
                    return BlogDetailBody(blog: blog);
                  }
                  return const SizedBox();
                }
              )
            )
          )
        )
      )
    );
  }
}

class BlogDetailBody extends StatefulWidget {
  BlogDetailBody({Key? key, required this.blog}):super(key: key);

  Blog blog;

  @override
  State<BlogDetailBody> createState() => _BlogDetailBodyState();
}

class _BlogDetailBodyState extends State<BlogDetailBody> {

  ScrollController scrollController = ScrollController();
  late BlogBloc blogBloc; 

  scrollListener() {
    double pos = scrollController.position.pixels;
    double screenWidth = MediaQuery.of(context).size.width;
    final blog = widget.blog;
    if(screenWidth / pos <= 1.15) {
      blogBloc.add(BlogDetailIconBackChanged(iconBackIsChanged: true));
    } else {
      blogBloc.add(BlogDetailIconBackChanged(iconBackIsChanged: false));
    }
  }

  Future<void> onRefresh() async {
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
    final blog = widget.blog;

    return Stack(
      children: [
        SizedBox.expand(
          child: Image.network(dotenv.env['HOST']!+blog.thumbnail.toString(), alignment: Alignment.topCenter, fit: BoxFit.cover)
        ),
        SingleChildScrollView(
          controller: scrollController,
          child: Container(
            margin: EdgeInsets.only(top: size.height*0.5),
            padding: EdgeInsets.only(bottom: ratio*70, left: ratio*50, right: ratio*50),
            alignment: Alignment.center,
            width: size.width,
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30)),
              color: Colors.white,
            ),
            child: Wrap(
              children: [
                Padding(
                  padding: EdgeInsets.only(top: ratio*60, bottom: ratio*30),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 5),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: Colors.amber,
                    ),
                    child: Text(blog.blogCateName.toString(),
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
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: ratio*30),
                      child: Text(blog.title.toString(),
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: ratio*40,
                          fontFamily: 'Play',
                          fontWeight: FontWeight.w600
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: ratio*30),
                      child: Text(blog.content.toString(),
                      textAlign: TextAlign.justify,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: ratio*40,
                          fontFamily: 'Play',
                        ),
                      ),
                    ),
                  ],
                )
              ],
            )
          ),
        ),
        Positioned(
          top: ratio*45,
          left: ratio*30,
          child: BlocBuilder<BlogBloc, BlogState>(
            builder: (context, state) {
              if(state is BlogDetailLoaded){
                return BlogDetailButtonBack(
                  backgroundColor: state.iconBackIsChanged ? 
                  const Color.fromRGBO(31, 6, 68, 0.3) : 
                  Colors.transparent
                );
              }
              return BlogDetailButtonBack(backgroundColor: Colors.transparent);
            },
          )
        ),
      ],
    );
  }
}

class BlogDetailButtonBack extends StatefulWidget {
  BlogDetailButtonBack({Key? key, this.backgroundColor}) : super(key: key);

  Color? backgroundColor;

  @override
  State<BlogDetailButtonBack> createState() => _BlogDetailButtonBackState();
}

class _BlogDetailButtonBackState extends State<BlogDetailButtonBack> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double ratio = size.width / size.height;
    Color? backgroundColor = widget.backgroundColor;

    return IconButton(
      onPressed: () {
        Navigator.pop(context);
      },
      icon: Container(
        width: double.maxFinite,
        height: double.maxFinite,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(ratio*30)),
          color: backgroundColor
        ),
        child: Icon(FontAwesomeIcons.chevronLeft, color: Colors.white, size: ratio*50)
      )
    );
  }
}