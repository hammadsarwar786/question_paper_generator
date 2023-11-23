import 'package:flutter/material.dart';
import 'package:question_generator/login.dart';
import 'package:question_generator/screens/generate/page1.dart';
import 'package:question_generator/screens/generate/page2.dart';
import 'package:question_generator/screens/generate/page3.dart';
import 'package:question_generator/screens/history/history.dart';
import 'package:question_generator/screens/homepage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Paper Generator',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: "Oswald",
        colorScheme: ColorScheme.fromSeed(seedColor: Color.fromARGB(255, 14, 57, 201)),
        useMaterial3: true,
      ),
      home: login(),
      // home: HomePage(),
    );
  }
}
