import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:html' as html;
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class History extends StatefulWidget {
  const History({super.key});

  @override
  State<History> createState() => _HistoryState();
}

class _HistoryState extends State<History> {
  List<String> pdfPaths = [];
  void openURLInNewTab(String url) {
    // Use window.open to open the URL in a new tab
    html.window.open(url, '_blank');
  }

  _on_Press(path) {
    final url = 'http://127.0.0.1:8000/api/disp/project/question_generator/assets/papers/${path}';
    openURLInNewTab(url);
  }

  @override
  void initState() {
    fetch_path();

    super.initState();
  }

  fetch_path() async {
    final response = await http.get(Uri.parse('http://127.0.0.1:8000/api/history'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        pdfPaths = List<String>.from(data['files']).reversed.toList();
      });
    } else {
      throw Exception('Failed to load PDF paths');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "History",
            style: TextStyle(
              color: Colors.white,
              fontSize: 30,
            ),
          ),
          SizedBox(
            height: 30,
          ),
          Center(
            child: Container(
              width: 800,
              height: 600,
              decoration: BoxDecoration(color: Color.fromARGB(123, 73, 54, 244)),
              child: pdfPaths.isEmpty
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : Expanded(
                      child: ListView.builder(
                        itemCount: pdfPaths.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Container(
                              height: 50,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      pdfPaths[index].toString().split("_")[0],
                                      // style: TextStyle(),
                                    ),
                                    InkWell(
                                      onTap: () {
                                        _on_Press(pdfPaths[index]);
                                      },
                                      child: Container(
                                        width: 100,
                                        decoration: BoxDecoration(
                                          color: Color.fromARGB(255, 15, 153, 207),
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
                                                color: Colors.white,
                                              ),
                                              Text(
                                                "View Pdf",
                                                style: TextStyle(
                                                  color: Colors.white,
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
                          );
                        },
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
