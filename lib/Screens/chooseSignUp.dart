// ignore_for_file: prefer_const_constructors
import 'package:boost_pt_new/Screens/Quiz/screen/quizz_screen.dart';
import 'package:boost_pt_new/Screens/Register.dart';
import 'package:boost_pt_new/Screens/pendingScreen/PendingScreen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChooseSignUp extends StatefulWidget {
  const ChooseSignUp({Key? key}) : super(key: key);

  static const String id = "ChooseSignUp";
  @override
  _ChooseSignUpState createState() => _ChooseSignUpState();
}

class _ChooseSignUpState extends State<ChooseSignUp> {
  bool? _isFailed;

  DateTime timeBackPressed = DateTime.now();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image(
                image: AssetImage("assets/LgoFinal.png"),
                width: 450.0,
                height: 450.0,
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    elevation: 20,
                    backgroundColor: Color(0XFF9B0000),
                    minimumSize: Size(size.width * 0.75, size.height * 0.07),
                    shadowColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(55),
                    ),
                  ),
                  onPressed: () async {
                    final SharedPreferences pref =
                        await SharedPreferences.getInstance();
                    _isFailed = pref.getBool("_isFailed");
                    if (_isFailed != null && _isFailed == true) {
                      Navigator.pushNamed(context, PendingScreen.id);
                    } else {
                      Navigator.pushNamed(context, QuizScreen.id);
                    }
                  },
                  child: Text(
                    'Trainer',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 25,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: size.height * 0.03,
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 50),
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    elevation: 20,
                    backgroundColor: Color(0xFF9B0000),
                    minimumSize: Size(size.width * 0.75, size.height * 0.07),
                    shadowColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(55),
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => RegisterScreen(2)),
                    );
                  },
                  child: Text(
                    'Trainee',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 25,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
