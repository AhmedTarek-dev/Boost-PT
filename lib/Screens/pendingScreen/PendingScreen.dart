// ignore_for_file: prefer_const_constructors
import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PendingScreen extends StatefulWidget {
  const PendingScreen({Key? key}) : super(key: key);
  static const String id = "PendingScreen";
  @override
  _PendingScreenState createState() => _PendingScreenState();
}

class _PendingScreenState extends State<PendingScreen>
    with SingleTickerProviderStateMixin {
  AnimationController? _animationController;
  Animation? _animation;
  late final SharedPreferences pref;
  String? EndDate;
  int formattedHours = 0;
  int formattedMinutes = 0;
  String formattedHoursString = "0";
  String formattedMinutesString = "0";

  @override
  void initState() {
    super.initState();

    getSharedPref();

    _animationController = AnimationController(
        vsync: this, duration: Duration(milliseconds: 2000));
    _animationController!.repeat(reverse: true);
    _animation = Tween(begin: 0.0, end: 1.0).animate(_animationController!
      ..addListener(() {
        setState(() {});
      }));
  }

  Future<void> getSharedPref() async {
    pref = await SharedPreferences.getInstance();
    // EndDate = pref.getString("EndTime");

    formattedHours = pref.getInt("formattedEndTimeHours")!;
    if (formattedHours > 12) {
      formattedHours = formattedHours - 12;
    }
    formattedMinutes = pref.getInt("formattedEndTimeMinutes")!;

    if (formattedHours < 9) {
      setState(() {
        formattedHoursString = '0' + formattedHours.toString();
      });
    } else {
      setState(() {
        formattedHoursString = formattedHours.toString();
      });
    }
    if (formattedMinutes < 9) {
      setState(() {
        formattedMinutesString = '0' + formattedMinutes.toString();
      });
    } else {
      setState(() {
        formattedMinutesString = formattedMinutes.toString();
      });
    }
    // int.parse(DateFormat('kk').format(DateTime.parse(EndDate!)));
    // formattedHours = formattedHours - 12;
    // formattedMinutes =
    //     int.parse(DateFormat('mm').format(DateTime.parse(EndDate!)));
    // formattedMinutes = formattedMinutes + 5;
    // formattedDay = DateFormat('EEE').format(DateTime.parse(EndDate!)); //name of day
    // formattedNumberOfDay = DateFormat('d').format(DateTime.parse(EndDate!)); //number of day in the month
    // formattedMonth = DateFormat('MMM').format(DateTime.parse(EndDate!)); //name of the month

    log(formattedHours.toString() + " : " + formattedMinutes.toString());

    // showEndTime = DateTime(DateTime.now().year,formattedMonth,formattedDay+1,formattedHours,formattedMinutes,0,0,0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            SizedBox(
              height: 100,
            ),
            SizedBox(
              width: 300,
              child: ShaderMask(
                child: Text(
                  "Unfortunately, You did not pass the Quiz. You can redo it after 72Hrs.",
                  textAlign: TextAlign.center,
                  softWrap: true,
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                shaderCallback: (rect) {
                  return LinearGradient(
                    stops: [
                      _animation!.value - 0.5,
                      _animation!.value,
                      _animation!.value + 0.5
                    ],
                    colors: const [
                      Color(0xFF060d55),
                      Color(0xFF9B0000),
                      Color(0xFF060d55),
                    ],
                  ).createShader(rect);
                },
              ),
            ),
            SizedBox(
              height: 50,
            ),
            SizedBox(
              height: 290,
              width: 380,
              child: Stack(
                children: [
                  Positioned(
                    top: 0,
                    left: 10,
                    right: 10,
                    child: Lottie.asset(
                      "animations/pending.json",
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 50,
            ),
            Text(
              "Retake the quiz at  " +
                  formattedHoursString +
                  " : " +
                  formattedMinutesString
                      .toString(), //add minutes to change the pending time
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.italic),
            ),
          ],
        ),
      ),
    );
  }
}
