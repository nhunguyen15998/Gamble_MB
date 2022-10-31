import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart';

class Games extends StatefulWidget {
  const Games({super.key});

  @override
  State<Games> createState() => _GamesState();
}

class _GamesState extends State<Games> {
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

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        backgroundColor: const Color.fromRGBO(31, 6, 68, 1),
        body: SingleChildScrollView(
          child: Stack(
            children: [
              Container(
                height: size.height*0.85,
                width: size.width,
                color: Colors.transparent,
              ),
              Positioned(
                child: Image.asset("lib/assets/images/games.png", height: 250, fit: BoxFit.fitHeight),
              ),
              Center(
                heightFactor: ratio*6.6,
                child: Image.asset("lib/assets/images/top-icon.png", height: 80)
              ),
              Positioned(
                top: ratio*400,
                child: Container(
                  alignment: Alignment.center,
                  height: size.height*0.53,
                  width: size.width,
                  color: Colors.transparent,
                  child: PageView.builder(
                    padEnds: false,
                    itemCount: 3,
                    controller: pageController,
                    itemBuilder: (context, pagePosition) {
                      return Container(
                        margin: const EdgeInsets.symmetric(horizontal: 40),
                        decoration: const BoxDecoration(
                          color: Color.fromRGBO(255, 255, 255, 0.08),
                          borderRadius: BorderRadius.all(Radius.circular(15))
                        ),
                        child: Column(
                          children: [
                            ClipRRect(
                              borderRadius: const BorderRadius.only(topLeft: Radius.circular(15), topRight: Radius.circular(15)),
                              child: Image.asset(images[0], height: size.height*0.25, fit: BoxFit.cover),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(20),
                              child: Text("Fortune Wheel",
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                style: TextStyle(
                                  fontFamily: "Play",
                                  fontSize: ratio * 50,
                                  color: Colors.white70,
                                  fontWeight: FontWeight.w500
                                )
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 30),
                              child: Text("Lorem ipsum lorem ipsum lorem ipsum lorem ipsum lorem ipsum lorem ipsum lorem ipsum lorem ipsum lorem ipsum lorem ipsum lorem ipsum lorem ipsum lorem ipsum lorem ipsum lorem ipsum lorem ipsum lorem ipsum lorem ipsum lorem ipsum lorem ipsum lorem ipsum lorem ipsum lorem ipsum lorem ipsum lorem ipsum",
                                textAlign: TextAlign.justify,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 4,
                                style: TextStyle(
                                  fontFamily: "Play",
                                  color: Colors.white,
                                  fontSize: ratio * 30,
                                )
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 25),
                              child: Container(
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
                                  child: Text('Play'.toUpperCase(),
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: ratio * 30,
                                      fontFamily: "Play"
                                    )
                                  ),
                                ),
                              )
                            ),
                          ],
                        ),
                      );
                    }
                  )
                ),
              )
            ],
          )
        )
      )
    );
  }
}