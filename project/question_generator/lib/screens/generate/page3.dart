import 'dart:ui';

import 'package:flutter/material.dart';
import 'dart:html' as html;

import 'package:question_generator/screens/homepage.dart';

class page_three extends StatefulWidget {
  String name;
  page_three({super.key, required this.name});

  @override
  State<page_three> createState() => _page_threeState();
}

class _page_threeState extends State<page_three> {
  void openURLInNewTab(String url) {
    // Use window.open to open the URL in a new tab
    html.window.open(url, '_blank');
  }

  _on_Press() {
    final url = 'http://127.0.0.1:8000/api/disp/project/question_generator/assets/papers/${widget.name}';
    openURLInNewTab(url);
  }

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
          children: [
            Expanded(
              flex: 1,
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
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
              ),
            ),
            Expanded(
              flex: 3,
              child: Stack(
                children: [
                  //bottom Sheet
                  ClipRRect(
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 7, sigmaY: 7),
                      child: Container(
                        height: height * 0.6,
                        width: height * 0.9,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.white.withOpacity(0.3),
                              Colors.white.withOpacity(0.3),
                            ],
                            begin: AlignmentDirectional.topStart,
                            end: AlignmentDirectional.bottomEnd,
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                        child: Container(),
                      ),
                    ),
                  ),
                  //column for all things
                  Container(
                    height: height * 0.6,
                    width: height * 0.9,
                    child: Column(
                      children: [
                        Expanded(
                          child: Center(
                            child: Text(
                              "Your Question Paper is Generated Successfully!",
                              style: TextStyle(
                                color: Color.fromARGB(255, 0, 0, 0),
                                fontSize: 24,
                                fontFamily: "Oswald",
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                height: 100,
                                width: height * 0.7,
                                decoration: BoxDecoration(
                                  color: Color.fromARGB(153, 255, 255, 255),
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        "Click here to view the Generated Question Paper",
                                        style: TextStyle(
                                          color: Color.fromARGB(255, 47, 90, 182),
                                          fontSize: 24,
                                          fontFamily: "Oswald",
                                        ),
                                      ),
                                      // ElevatedButton(
                                      //   onPressed: () {
                                      //     _on_Press();
                                      //   },
                                      //   child: Text("View Pdf"),
                                      // ),
                                      InkWell(
                                        onTap: () {
                                          _on_Press();
                                        },
                                        child: Container(
                                          height: 50,
                                          width: 120,
                                          decoration: BoxDecoration(
                                            color: Colors.black,
                                            borderRadius: BorderRadius.circular(5),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Row(
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Icon(
                                                  Icons.remove_red_eye_outlined,
                                                  color: Colors.blueAccent,
                                                ),
                                                Text(
                                                  "View Data",
                                                  style: TextStyle(
                                                    color: Colors.blueAccent,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Container(
                                height: 100,
                                width: height * 0.7,
                                decoration: BoxDecoration(
                                  color: Color.fromARGB(153, 255, 255, 255),
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        "Click here to Create New Question Paper",
                                        style: TextStyle(
                                          color: Color.fromARGB(255, 47, 90, 182),
                                          fontSize: 24,
                                          fontFamily: "Oswald",
                                        ),
                                      ),
                                      // ElevatedButton(
                                      //   onPressed: () {
                                      //     _on_Press();
                                      //   },
                                      //   child: Text("View Pdf"),
                                      // ),
                                      InkWell(
                                        onTap: () {
                                          Navigator.of(context).pushReplacement(
                                            MaterialPageRoute(
                                              builder: (context) => HomePage(),
                                            ),
                                          );
                                        },
                                        child: Container(
                                          height: 50,
                                          width: 120,
                                          decoration: BoxDecoration(
                                            color: Colors.black,
                                            borderRadius: BorderRadius.circular(5),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Row(
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Icon(
                                                  Icons.refresh_rounded,
                                                  color: Colors.blueAccent,
                                                ),
                                                Text(
                                                  "Create New",
                                                  style: TextStyle(
                                                    color: Colors.blueAccent,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
