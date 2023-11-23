import 'dart:developer';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:question_generator/screens/generate/page1.dart';
import 'package:question_generator/screens/history/history.dart';
import 'package:question_generator/screens/settings/settings.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Color color_first = Color.fromARGB(255, 212, 205, 205).withOpacity(0.3);
  Color color_second = Color.fromARGB(255, 194, 186, 186).withOpacity(0.3);
  int hoverIndex = -1;
  dynamic _onHover(index) {
    hoverIndex = index;
    setState(() {
      color_first = Color.fromARGB(255, 161, 153, 153).withOpacity(0.3);
      color_second = Color.fromARGB(255, 167, 157, 157).withOpacity(0.3);
    });
  }

  dynamic _onExit(index) {
    setState(() {
      hoverIndex = -1;
      color_first = Color.fromARGB(255, 212, 205, 205).withOpacity(0.3);
      color_second = Color.fromARGB(255, 194, 186, 186).withOpacity(0.3);
    });
  }

  List title = [
    "Generate New",
    "View History",
    // "Settings"
  ];

  List subtitle = [
    "Just Uplaod your pdf to the Ai and it will auto generate a question paper where you can finilize the question paper.",
    "View all previous ai generated Questions that you generated also you can eddit them and regenerate new.",
    // "You can customize different kind of settings different kind of behavious modify logo and title and try new things."
  ];

  List navigate = [
    page_one(),
    History(),
    // Settings(),
  ];

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.sizeOf(context).height;
    var width = MediaQuery.sizeOf(context).width;
    return Scaffold(
      body: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          color: Colors.black,
          image: DecorationImage(
            opacity: 0.6,
            fit: BoxFit.cover,
            image: AssetImage("assets/images/homebg.png"),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20.0),
              child: Container(
                child: Text(
                  "Paper Generator",
                  style: TextStyle(
                    // color: Color.fromARGB(255, 0, 0, 0),
                    color: Colors.white,
                    fontSize: width * 0.028,
                    fontFamily: "Oswald",
                  ),
                ),
              ),
            ),
            SizedBox(
              height: height * 0.5,
              width: width * 0.42,
              child: ListView.builder(
                  itemCount: 2,
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: MouseRegion(
                        cursor: SystemMouseCursors.click,
                        onHover: (PointerHoverEvent event) {
                          _onHover(index);
                        },
                        onExit: (PointerExitEvent event) {
                          _onExit(index);
                        },
                        child: GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(builder: (context) => navigate[index]),
                            );
                          },
                          child: ClipRRect(
                            child: BackdropFilter(
                              filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
                              child: Container(
                                height: height * 0.5,
                                width: width * 0.2,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      hoverIndex == index ? color_first : Color.fromARGB(255, 212, 205, 205).withOpacity(0.3),
                                      hoverIndex == index ? color_second : Color.fromARGB(255, 194, 186, 186).withOpacity(0.3)
                                    ],
                                    begin: AlignmentDirectional.topStart,
                                    end: AlignmentDirectional.bottomEnd,
                                  ),
                                  borderRadius: BorderRadius.all(Radius.circular(10)),
                                ),
                                child: Container(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: Row(
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              title[index],
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: width * 0.015,
                                                fontFamily: "Oswald",
                                              ),
                                            ),
                                            Icon(
                                              Icons.arrow_forward_ios_rounded,
                                              size: width * 0.015,
                                              color: Colors.white,
                                            ),
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(15.0),
                                        child: Text(
                                          textAlign: TextAlign.justify,
                                          subtitle[index].toString(),
                                          style: TextStyle(
                                            color: Colors.white,
                                            // fontSize: width * 0.01,
                                            // fontFamily: "Oswald",
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                    // view previous papers

                    //settings
                  }),
            )
          ],
        ),
      ),
    );
  }
}
