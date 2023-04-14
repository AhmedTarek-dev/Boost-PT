// ignore_for_file: prefer_const_constructors
import 'dart:developer';
import 'package:boost_pt_new/Screens/WelcomeScreen.dart';
import 'package:boost_pt_new/Screens/pendingScreen/PendingScreen.dart';
import 'package:flutter/material.dart';
import 'package:boost_pt_new/Screens/Register.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ResultScreen extends StatefulWidget {
  final int score;
  const ResultScreen(this.score, {Key? key}) : super(key: key);
  @override
  _ResultScreenState createState() => _ResultScreenState(score);
}

class _ResultScreenState extends State<ResultScreen> {
  int _score = 0;

  //for controlling of pendingScreen time to exit the screen
  DateTime? nowTime;
  DateTime? pendingTime;

  _ResultScreenState(this._score);
  DateTime timeBackPressed = DateTime.now();

  @override
  void initState() {
    super.initState();
    // setBoolean();
  }

  // setBoolean() async{
  //   final SharedPreferences pref = await SharedPreferences.getInstance();
  //   _score >=3 ?
  //   pref.setBool("_isFailed", false)  :
  //   pref.setBool("_isFailed", true);
  // }
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        final SharedPreferences pref = await SharedPreferences.getInstance();
        _score >= 3
            ? pref.setBool("_isFailed", false)
            : pref.setBool("_isFailed", true);
        Navigator.pushReplacementNamed(context, WelcomeScreen.id);
        return Future.value(true);
      },
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          backgroundColor: const Color(0xFF252c4a),
          body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: double.infinity,
                child: Text(
                  _score >= 3
                      ? "Congratulations, You have passed the Quiz"
                      : "Unfortunately, You have Failed in the quiz",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 30.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(
                height: 45.0,
              ),
              const Text(
                "You Score is",
                style: TextStyle(color: Colors.white, fontSize: 34.0),
              ),
              const SizedBox(
                height: 20.0,
              ),
              Text(
                "${widget.score} / 5",
                style: const TextStyle(
                  color: Colors.orange,
                  fontSize: 85.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                height: 100.0,
              ),
              OutlinedButton(
                onPressed: () async {
                  final SharedPreferences pref =
                      await SharedPreferences.getInstance();
                  widget.score >= 3
                      ? () async {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => RegisterScreen(1)),
                          );
                          pref.setBool("_isFailed", false);
                        }()
                      : () async {
                          pref.setBool("_isFailed", true);
                          nowTime = DateTime.now();
                          pref.setString(
                              "EndTime",
                              nowTime
                                  .toString()); //for pending screen to show the end time

                          String formattedDateMinutes =
                              DateFormat('mm').format(nowTime!);
                          String formattedDateHours =
                              DateFormat('kk').format(nowTime!);
                          log("Minutes: " + formattedDateMinutes.toString());
                          log("Hours: " + formattedDateHours.toString());
                          if (int.parse(formattedDateMinutes) <= 54) {
                            pref.setInt("formattedEndTimeHours",
                                int.parse(formattedDateHours));
                            pref.setInt(
                                "formattedEndTimeMinutes",
                                int.parse(formattedDateMinutes) +
                                    5); //for loading Screen to detect if the time has reached to end time + 5 minutes
                            log("if case");
                          } else {
                            pref.setInt("formattedEndTimeHours",
                                int.parse(formattedDateHours) + 1);
                            pref.setInt(
                                "formattedEndTimeMinutes",
                                int.parse(formattedDateMinutes) -
                                    60 +
                                    5); //for loading Screen to detect if the time has reached to end time + 5 minutes
                            log("else case");
                          }

                          log("formattedEndTime " +
                              pref.getInt("formattedEndTimeHours").toString() +
                              pref
                                  .getInt("formattedEndTimeMinutes")
                                  .toString());
                          Navigator.pushNamed(context, PendingScreen.id);
                        }();
                },
                style: OutlinedButton.styleFrom(
                    primary: Colors.white,
                    backgroundColor: Colors.teal,
                    shadowColor: Colors.greenAccent,
                    elevation: 10,
                    shape: const StadiumBorder(),
                    minimumSize: Size(100, 40)),
                child: const Text(
                  "Done",
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
