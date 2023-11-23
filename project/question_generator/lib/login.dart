import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:question_generator/screens/homepage.dart';


class login extends StatefulWidget {
  const login({super.key});

  @override
  State<login> createState() => _loginState();
}

class _loginState extends State<login> {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

  _login() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => HomePage(),
      ),
    );
    // if (email.text == "hammad@admin.com" && password.text == "1234") {
    //   Navigator.of(context).pushReplacement(
    //     MaterialPageRoute(
    //       builder: (context) => Register_Form(),
    //     ),
    //   );
    // } else {
    //   showDialog(
    //     context: context,
    //     builder: (context) {
    //       return AlertDialog(
    //         title: Text(
    //           "Message",
    //         ),
    //         content: Text("Email or Password is Wrong!"),
    //       );
    //     },
    //     );
    // }
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
            fit: BoxFit.cover,
            opacity: 0.3,
            image: AssetImage(
              "assets/images/bg.jpg",
            ),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Stack(
              children: [
                //bottom Sheet
                ClipRRect(
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 7, sigmaY: 7),
                    child: Container(
                      height: height * 0.5,
                      width: height * 0.5,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.white.withOpacity(0.5),
                            Colors.white.withOpacity(0.5),
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
                  height: height * 0.5,
                  width: height * 0.5,
                  child: Column(
                    children: [
                      Expanded(
                        child: Center(
                          child: Text(
                            "Paper Generator",
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
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8),
                              child: TextFormField(
                                controller: email,
                                style: TextStyle(color: Colors.black),
                                decoration: InputDecoration(
                                  suffixIcon: Icon(Icons.email_outlined, color: Colors.black),
                                  hintText: "Email",
                                  hintStyle: TextStyle(color: Colors.black),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5.0),
                                    borderSide: BorderSide(color: Colors.black),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5.0),
                                    borderSide: BorderSide(color: Colors.white),
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8),
                              child: TextFormField(
                                controller: password,
                                style: TextStyle(color: Colors.black),
                                decoration: InputDecoration(
                                  suffixIcon: Icon(Icons.remove_red_eye, color: Colors.black),
                                  hintText: "Password",
                                  hintStyle: TextStyle(color: Colors.black),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5.0),
                                    borderSide: BorderSide(color: Colors.black),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5.0),
                                    borderSide: BorderSide(color: Colors.white),
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: InkWell(
                                onTap: _login,
                                child: Container(
                                  height: height * 0.050,
                                  width: width * 0.070,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "Log In",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(width: 5),
                                      Icon(Icons.login_outlined),
                                    ],
                                  ),
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
          
          ],
        ),
      ),
    );
  }
}
