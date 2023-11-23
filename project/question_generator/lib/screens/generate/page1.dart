import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import "package:http/http.dart" as http;
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:question_generator/screens/generate/page2.dart';

class page_one extends StatefulWidget {
  const page_one({super.key});

  @override
  State<page_one> createState() => _page_oneState();
}

class _page_oneState extends State<page_one> {
  TextEditingController date = TextEditingController();
  List questions = [];
  List pdf_names = [];
  int pdf_count = 1;

  TextEditingController title = TextEditingController();
  TextEditingController dep = TextEditingController();
  TextEditingController class_name = TextEditingController();
  TextEditingController exam_type = TextEditingController();
  TextEditingController time = TextEditingController();
  TextEditingController question_number = TextEditingController();
  TextEditingController note = TextEditingController();

  _next() {
    if (title.text.isEmpty ||
        dep.text.isEmpty ||
        class_name.text.isEmpty ||
        exam_type.text.isEmpty ||
        time.text.isEmpty ||
        question_number.text.isEmpty ||
        note.text.isEmpty ||
        questions.isEmpty ||
        date.text.isEmpty) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog(
            title: Text('Please fill all fields'),
            children: <Widget>[
              SimpleDialogOption(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    } else {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => page_two(
            title: title.text,
            dep: dep.text,
            class_name: class_name.text,
            exam_type: exam_type.text,
            time: time.text,
            paper_date: date.text,
            q_number: question_number.text,
            note: note.text,
            questions: questions,
          ),
        ),
      );
    }
  }

  _picdate() async {
    DateTime? pickedDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(1950),
        //DateTime.now() - not to allow to choose before today.
        lastDate: DateTime(2100));

    if (pickedDate != null) {
      print(pickedDate); //pickedDate output format => 2021-03-10 00:00:00.000
      String formattedDate = DateFormat('yyyy/MM/dd').format(pickedDate);
      print(formattedDate); //formatted date output using intl package =>  2021-03-16
      setState(() {
        date.text = formattedDate; //set output date to TextField value.
      });
    } else {}
  }

  Future<void> _uploadPDF() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result != null) {
      Uint8List uploadfile = result.files.single.bytes!;

      String filename = result.files.single.name;
      // await api(uploadfile, filename);
      var resp = await api(uploadfile, filename);
      log("${resp}");
      setState(() {
        pdf_names.add(filename);
        questions.addAll(resp["questions"]);
        pdf_count += 1;
      });
    } else {
      // User canceled the picker
    }
  }

  Future api(Uint8List pdfData, String pdfName) async {
    final requestData = {
      "name": pdfName,
      "data": pdfData.toList(),
      // Convert Uint8List to List<int>
    };

    final response = await http.post(
      Uri.parse('http://127.0.0.1:8000/api/upload'),
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
    var height = MediaQuery.sizeOf(context).height;
    var width = MediaQuery.sizeOf(context).width;
    return Scaffold(
      body: Column(
        // mainAxisAlignment: MainAxisAlignment.center,
        // crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Container(
              child: Center(
                child: Text(
                  "Paper Generator Step 1",
                  style: TextStyle(fontSize: 22, color: const Color.fromARGB(255, 28, 146, 243), fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
          Expanded(
            flex: 4,
            child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Container(
                  width: 1000,
                  // color: Colors.blue,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("1. Subject Title", style: TextStyle(fontSize: 18)),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8),
                        child: TextFormField(
                          controller: title,
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
                      Text("2. Department Name", style: TextStyle(fontSize: 18)),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8),
                        child: TextFormField(
                          controller: dep,
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
                      Text("3. Semester", style: TextStyle(fontSize: 18)),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8),
                        child: TextFormField(
                          controller: class_name,
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
                      Text("4. Examination Type", style: TextStyle(fontSize: 18)),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8),
                        child: TextFormField(
                          controller: exam_type,
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
                      Text("5. Time (mins)", style: TextStyle(fontSize: 18)),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8),
                        child: TextFormField(
                          controller: time,
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
                      Text("6. Paper Date", style: TextStyle(fontSize: 18)),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8),
                        child: TextFormField(
                          controller: date,
                          onTap: _picdate,
                          style: TextStyle(
                            color: Colors.black,
                          ),
                          readOnly: true,
                          decoration: InputDecoration(
                            filled: true,
                            suffixIcon: Icon(
                              Icons.calendar_month,
                              color: Colors.black,
                            ),
                            // labelText: "Date Of Birth",
                            labelStyle: TextStyle(
                              color: Colors.black,
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0),
                              borderSide: BorderSide(
                                color: Colors.black,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0),
                              borderSide: BorderSide(
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Text("7. How Many Question (number)", style: TextStyle(fontSize: 18)),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8),
                        child: TextFormField(
                          controller: question_number,
                          keyboardType: TextInputType.number,
                          inputFormatters: <TextInputFormatter>[
                            // for below version 2 use this
                            FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                            // for version 2 and greater youcan also use this
                            FilteringTextInputFormatter.digitsOnly
                          ],
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
                      Text("8. Paper Note", style: TextStyle(fontSize: 18)),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8),
                        child: TextFormField(
                          controller: note,
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
                      Text("9. Upload Document (pdf)", style: TextStyle(fontSize: 18)),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8),
                        child: Row(
                          children: [
                            SizedBox(
                              height: 100,
                              child: ListView.builder(
                                shrinkWrap: true,
                                itemCount: pdf_names.length + 1,
                                scrollDirection: Axis.horizontal,
                                itemBuilder: (context, index) {
                                  log("$pdf_names");
                                  if (index < pdf_names.length) {
                                    return Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Container(
                                        height: 50,
                                        // width: 100,
                                        decoration: BoxDecoration(color: Color.fromARGB(255, 235, 229, 229), borderRadius: BorderRadius.circular(10)),
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Row(
                                            children: [
                                              Icon(
                                                Icons.picture_as_pdf_rounded,
                                                color: Colors.red,
                                              ),
                                              SizedBox(
                                                width: 4,
                                              ),
                                              FittedBox(fit: BoxFit.scaleDown, child: Text("${pdf_names[index]}")),
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  }
                                  return Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: MouseRegion(
                                      cursor: SystemMouseCursors.click,
                                      child: InkWell(
                                        onTap: () async {
                                          await _uploadPDF();
                                        },
                                        child: Container(
                                          height: 100,
                                          width: 100,
                                          color: const Color.fromARGB(255, 194, 192, 192),
                                          child: Center(
                                            child: Icon(Icons.add),
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
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
                  onTap: () {
                    _next();
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
