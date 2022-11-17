// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int activePage = 1;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double ratio = size.width / size.height;
    final PageController pageController = PageController(viewportFraction: 1);
    List<String> images = [
      "lib/assets/images/auth_background.jpeg",
      "lib/assets/images/xyz-bg.png",
      "lib/assets/images/h1.jpeg",
    ];

    final PageController blogController = PageController(viewportFraction: 0.45);

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        backgroundColor: const Color.fromRGBO(31, 6, 68, 1),
        body: SingleChildScrollView(
          child: Stack(
            children: <Widget>[
              Column(
                children: <Widget>[
                  //CAROUSEL
                  SizedBox(
                    height: size.height*0.25,
                    child: PageView.builder(
                      itemCount: images.length,
                      controller: pageController,
                      onPageChanged: (page) {
                        setState(() {
                          activePage = page;
                        });
                      },
                      itemBuilder: (context, pagePosition) {
                        return Image.asset(images[pagePosition], fit: BoxFit.cover);
                      }
                    ),
                  ),
                  //GAMES
                  SizedBox(
                    height: size.height*0.35,
                    width: size.width,
                    child: DecoratedBox(
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage("lib/assets/images/section-bg.jpeg"),
                          fit: BoxFit.cover
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(top: 30),
                            child: Text("The Games You Love",
                              style: TextStyle(
                                fontFamily: "Play",
                                fontSize: ratio * 22,
                                color: const Color.fromRGBO(250, 0, 159, 1),
                                fontWeight: FontWeight.w600
                              )
                            )
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 5),
                            child: Text("Play and win".toUpperCase(),
                              style: TextStyle(
                                fontFamily: "Play",
                                fontSize: ratio * 45,
                                color: const Color.fromRGBO(255, 255, 255, 1),
                                fontWeight: FontWeight.w600
                              )
                            ),
                          ),
                          Expanded(
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Image(
                                  image: const AssetImage("lib/assets/images/left-img.png"), 
                                  height: size.width*0.5,
                                ),
                                Image(
                                  image: const AssetImage("lib/assets/images/right-img.png"), 
                                  height: size.width*0.5,
                                )
                              ],
                            )
                          ),
                        ],
                      )
                    ),
                  ),
                  //HOT NEWS
                  SizedBox(
                    height: size.height*0.48,
                    width: size.width,
                    child: DecoratedBox(
                      decoration: const BoxDecoration(
                        color: Color.fromRGBO(31, 6, 68, 1),
                        image: DecorationImage(
                          image: AssetImage("lib/assets/images/ex-lottery-bg.jpeg"),
                          fit: BoxFit.contain,
                          alignment: Alignment.topCenter
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 30),
                            child: Text("Let's check out",
                              style: TextStyle(
                                fontFamily: "Play",
                                fontSize: ratio * 22,
                                color: const Color.fromRGBO(250, 0, 159, 1),
                                fontWeight: FontWeight.w600
                              )
                            )
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 5),
                            child: Text("Our hot news".toUpperCase(),
                              style: TextStyle(
                                fontFamily: "Play",
                                fontSize: ratio * 45,
                                color: const Color.fromRGBO(255, 255, 255, 1),
                                fontWeight: FontWeight.w600
                              )
                            ),
                          ),
                          Expanded(
                            child: PageView.builder(
                              padEnds: false,
                              itemCount: 3,
                              controller: blogController,
                              itemBuilder: (context, pagePosition) {
                                return Container(
                                  margin: const EdgeInsets.only(top:25, right: 15, left: 15, bottom: 40),
                                  decoration: const BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.all(Radius.circular(15))
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      ClipRRect(
                                        borderRadius: const BorderRadius.only(topLeft: Radius.circular(15), topRight: Radius.circular(15)),
                                        child: Image.asset(images[2], height: 160, fit: BoxFit.cover),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(10),
                                        child: Text("Lorem ipsum",
                                          textAlign: TextAlign.left,
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1,
                                          style: TextStyle(
                                            fontFamily: "Play",
                                            fontSize: ratio * 30,
                                            fontWeight: FontWeight.w600
                                          )
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(left: 10, right: 10),
                                        child: Text("Lorem ipsum lorem ipsum lorem ipsum lorem ipsum lorem ipsum lorem ipsum lorem ipsum",
                                          textAlign: TextAlign.justify,
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 3,
                                          style: TextStyle(
                                            fontFamily: "Play",
                                            fontSize: ratio * 22,
                                          )
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }
                            )
                          )
                        ],
                      )
                    )
                  ),
                  //CONTACT
                  SizedBox(
                    height: size.height*0.4,
                    width: size.width,
                    child: DecoratedBox(
                      decoration: const BoxDecoration(
                        color: Color.fromRGBO(31, 6, 68, 1),
                        image: DecorationImage(
                          image: AssetImage("lib/assets/images/cs-bg.png"),
                          fit: BoxFit.contain,
                          alignment: Alignment.topCenter
                        ),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 40),
                            child: Image.asset("lib/assets/images/cs-image.png", height: 220)
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Container(
                                  padding: EdgeInsets.only(top: 30, right: (ratio*110), left: 15),
                                  child:  Text("If You have any Questions".toUpperCase(),
                                    maxLines: 2,
                                    style: TextStyle(
                                      fontFamily: "Play",
                                      fontSize: ratio * 37,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600
                                    )
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.only(top: 5, right: 30, left: 15),
                                  child: Text("Our top priorities are to protect your privacy, provide secure transactions, and safeguard your data. When you're ready to play, registering an account is required so we know you're of legal age and so no one else can use your account.We answer the most commonly asked lotto questions",
                                    style: TextStyle(
                                      fontFamily: "Play",
                                      fontSize: ratio * 22,
                                      color: Colors.white,
                                    )
                                  ),
                                ),
                                Container(
                                  margin: const EdgeInsets.only(top: 10, left: 15),
                                  height: ratio * 70,
                                  decoration: BoxDecoration(
                                    border: Border.all(width: 3, color: const Color.fromRGBO(254, 160, 54, 1)),
                                    borderRadius: BorderRadius.circular(50)
                                  ),
                                  child: ElevatedButton(
                                    style: OutlinedButton.styleFrom(
                                      backgroundColor: Colors.transparent                                    
                                    ),
                                    key: const Key('Home_contactBtn'),
                                    onPressed: () {

                                    },
                                    child: Text('Contact us'.toUpperCase(),
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: ratio * 20,
                                        fontFamily: "Play"
                                      )
                                    ),
                                  ),
                                )
                              ]
                            ),
                          )
                        ],
                      )
                    )
                  )
                ],
              )
            ],
          )
        ),
      )
    );
  }
}