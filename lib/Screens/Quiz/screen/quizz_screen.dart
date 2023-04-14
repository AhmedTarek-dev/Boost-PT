// ignore_for_file: prefer_const_constructors

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:boost_pt_new/Screens/Quiz/data/questions_example.dart';
import 'package:boost_pt_new/Screens/Quiz/screen/result_screen.dart';

class QuizScreen extends StatefulWidget {
  const QuizScreen({Key? key}) : super(key: key);
  static const String id = "QuizScreen";
  @override
  _QuizScreenState createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  bool right = false;
  bool reachedFirstPage = false;
  int questionPos = 0;
  int score = 0;
  bool btnPressed = false;
  PageController? _controller;
  String btnText = "Next Question";
  bool answered = false;
  @override
  void initState() {
    super.initState();
    _controller = PageController(initialPage: 0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF252c4a),
      body: Padding(
          padding: const EdgeInsets.all(18.0),
          child: PageView.builder(
            controller: _controller!,
            onPageChanged: (page) {
              if (page == questions.length - 1) {
                setState(() {
                  btnText = "See Results";
                });
              }
              setState(() {
                answered = false;
              });
            },
            physics: NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: Text(
                      "Question ${index + 1}/5",
                      textAlign: TextAlign.start,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 28.0,
                      ),
                    ),
                  ),
                  const Divider(
                    color: Colors.white,
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                  SizedBox(
                    width: double.infinity,
                    height: 200.0,
                    child: Text(
                      "${questions[index].question}",
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 22.0,
                      ),
                    ),
                  ),
                  for (int i = 0; i < questions[index].answers!.length; i++)
                    Container(
                      width: double.infinity,
                      height: 50.0,
                      margin: const EdgeInsets.only(
                          bottom: 20.0, left: 12.0, right: 12.0),
                      child: RawMaterialButton(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        fillColor: btnPressed
                            ? questions[index].answers!.values.toList()[i] ==
                                        true &&
                                    right == true
                                ? Colors.green
                                : Colors.red
                            : const Color(0xFF117eeb),
                        onPressed: !answered
                            ? () {
                                if (questions[index]
                                    .answers!
                                    .values
                                    .toList()[i]) {
                                  score++;
                                  setState(() {
                                    right = true;
                                  });
                                  log("yes");
                                } else {
                                  setState(() {
                                    right = false;
                                  });
                                  log("no");
                                }
                                setState(() {
                                  btnPressed = true;
                                  answered = true;
                                });
                              }
                            : null,
                        child: Text(questions[index].answers!.keys.toList()[i],
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18.0,
                            )),
                      ),
                    ),
                  const SizedBox(
                    height: 40.0,
                  ),
                  // Row(
                  // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  // children: [
                  // RawMaterialButton(
                  //   onPressed: () {
                  //     if (_controller!.page?.toInt() == 0) {
                  //       setState(() {
                  //         reachedFirstPage =true;
                  //       });
                  //
                  //     } else {
                  //       _controller!.previousPage(
                  //           duration: const Duration(milliseconds: 250),
                  //           curve: Curves.easeInExpo);
                  //
                  //       setState(() {
                  //         btnPressed = false;
                  //       });
                  //     }
                  //   },
                  //   shape: const StadiumBorder(),
                  //   fillColor: Colors.blue,
                  //   padding: const EdgeInsets.all(18.0),
                  //   elevation: 0.0,
                  //   child: const Text(
                  //     "Previous Question",
                  //     style: TextStyle(color: Colors.white),
                  //   ),
                  // ),
                  RawMaterialButton(
                    onPressed: () async {
                      if (_controller!.page?.toInt() == questions.length - 1) {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ResultScreen(score)));
                      } else {
                        _controller!.nextPage(
                            duration: const Duration(milliseconds: 250),
                            curve: Curves.easeInExpo);

                        setState(() {
                          reachedFirstPage = false;
                          btnPressed = false;
                        });
                      }
                    },
                    shape: const StadiumBorder(),
                    fillColor: Colors.blue,
                    padding: const EdgeInsets.all(18.0),
                    elevation: 0.0,
                    child: const Text(
                      "Next Question",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  // ],
                  // )
                ],
              );
            },
            itemCount: questions.length,
          )),
    );
  }
}
