import 'dart:convert';
import 'dart:math';
import 'dart:developer' as dev;
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:question_generator/screens/generate/page3.dart';

class page_two extends StatefulWidget {
  String title;
  String dep;
  String class_name;
  String exam_type;
  String time;
  String paper_date;
  String q_number;
  String note;
  List questions;

  page_two(
      {required this.title,
      required this.dep,
      required this.class_name,
      required this.exam_type,
      required this.time,
      required this.paper_date,
      required this.q_number,
      required this.note,
      required this.questions,
      super.key});

  @override
  State<page_two> createState() => _page_twoState(
        this.title,
        this.dep,
        this.class_name,
        this.exam_type,
        this.time,
        this.paper_date,
        this.q_number,
        this.note,
        this.questions,
      );
}

class _page_twoState extends State<page_two> {
  late String title;
  late String dep;
  late String class_name;
  late String exam_type;
  late String time;
  late String paper_date;
  late String q_number;
  late String note;
  late List questions;
  _page_twoState(
    this.title,
    this.dep,
    this.class_name,
    this.exam_type,
    this.time,
    this.paper_date,
    this.q_number,
    this.note,
    this.questions,
  );
// https://pspdfkit.com/blog/2019/opening-a-pdf-in-flutter/

  _eidt(index, question) {
    TextEditingController question_controller = TextEditingController();
    setState(() {
      question_controller.text = question;
    });

    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Eddit Question"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8),
                  child: TextFormField(
                    maxLines: 4,
                    keyboardType: TextInputType.multiline, // Add this line

                    controller: question_controller,
                    style: TextStyle(color: Colors.black),
                    decoration: InputDecoration(
                      // hintText: "Email",'

                      hintStyle: TextStyle(color: Colors.black),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0),
                        borderSide: BorderSide(color: Colors.black),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0),
                        borderSide: BorderSide(color: Colors.black),
                      ),
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: Container(
                        height: 50,
                        width: 100,
                        color: Colors.red,
                        child: Center(child: Text("Cancel")),
                      ),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    InkWell(
                      onTap: () {
                        setState(() {
                          questions[index] = question_controller.text;
                        });
                        Navigator.of(context).pop();
                      },
                      child: Container(
                        height: 50,
                        width: 100,
                        color: Colors.green,
                        child: Center(child: Text("Save")),
                      ),
                    )
                  ],
                )
              ],
            ),
          );
        });
  }

  List<Map<String, dynamic>> generateQuestions(List<dynamic> questionList, int number) {
    final List<Map<String, dynamic>> result = [];
    final random = Random();
    int questionCount = 0;

    while (questionCount <= number || questionList.isNotEmpty) {
      final numberOfQuestions = random.nextInt(2) + 1; // Randomly choose 1 or 2 questions
      final generatedQuestions = <String>[];

      for (var j = 0; j < numberOfQuestions; j++) {
        if (questionList.isEmpty) {
          break; // Stop generating if there are no more questions in the list
        }
        final randomIndex = random.nextInt(questionList.length);
        final question = questionList[randomIndex];
        questionList.removeAt(randomIndex);
        generatedQuestions.add(question);
      }

      result.add({
        "number": generatedQuestions.length,
        "question": generatedQuestions,
      });

      questionCount += 1;
    }

    return result;
  }

  Future post_data(questions) async {
    final requestData = {
      "qty": int.parse(q_number), //
      "pdf": questions, //
      "title": title, //
      "dep": dep,
      "class_name": class_name, //
      "type": exam_type, //
      "time": time, //
      "date": paper_date, //
      "note": note, //

      // Convert Uint8List to List<int>
    };

    final response = await http.post(
      Uri.parse('http://127.0.0.1:8000/api/paper'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: jsonEncode(requestData),
    );

    if (response.statusCode == 200) {
      // Successful upload
      var resp = jsonDecode(response.body);
      return resp;
    } else {
      // Handle errors
      print('Error: ${response.reasonPhrase}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(onPressed: () {
        generateQuestions(questions, int.parse(q_number));
      }),
      body: Column(
        // mainAxisAlignment: MainAxisAlignment.center,
        // crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Container(
              child: Center(
                child: Text(
                  "Step 2",
                  style: TextStyle(fontSize: 22, color: Colors.blue, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
          Expanded(
            flex: 4,
            child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 100.0),
                child: Column(
                  // Wrap the Expanded widget with a Column
                  crossAxisAlignment: CrossAxisAlignment.stretch, // Make the Column stretch to full width
                  children: [
                    ListView.builder(
                      shrinkWrap: true, // Allow the ListView to occupy only the space it needs
                      itemCount: 20,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            height: 100,
                            width: 100,
                            decoration: BoxDecoration(
                              color: Color.fromARGB(255, 247, 243, 243),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Flexible(
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          "Q${index + 1} : ${questions[index]}",
                                        ),
                                      ),
                                    ),
                                    Container(
                                      width: 100,
                                      height: 100,
                                      child: Container(
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            InkWell(
                                              onTap: () {
                                                _eidt(index, questions[index].toString());
                                              },
                                              child: Icon(
                                                Icons.mode_edit_outline_outlined,
                                                color: Colors.black,
                                              ),
                                            ),
                                            // Icon(
                                            //   Icons.refresh_outlined,
                                            //   color: Colors.green,
                                            // ),
                                            InkWell(
                                              onTap: () {
                                                if (questions.length > 20) {
                                                  setState(() {
                                                    questions.removeAt(index);
                                                  });
                                                } else {
                                                  showDialog(
                                                      context: context,
                                                      builder: (context) {
                                                        return AlertDialog(
                                                          title: Text("Message"),
                                                          content: Text("You are out of questions now please go back and re generate"),
                                                        );
                                                      });
                                                }
                                              },
                                              child: Icon(
                                                Icons.remove_circle,
                                                color: Colors.red,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                InkWell(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: Container(
                    height: 50,
                    width: 100,
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 137, 137, 138).withOpacity(0.7),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(Icons.arrow_back_ios_new_rounded),
                        SizedBox(
                          width: 5,
                        ),
                        Text('BACK')
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                InkWell(
                  onTap: () async {
                    var list = await generateQuestions(questions, int.parse(q_number));
                    var resp = await post_data(list);
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (contect) => page_three(name: resp["message"].toString()),
                      ),
                    );
                  },
                  child: Container(
                    height: 50,
                    width: 100,
                    decoration: BoxDecoration(
                      color: Colors.blue.withOpacity(0.7),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text('NEXT'),
                        SizedBox(
                          width: 5,
                        ),
                        Icon(Icons.arrow_forward_ios_outlined),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
