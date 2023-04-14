// ignore_for_file: prefer_const_constructors
import 'dart:developer';
import 'package:boost_pt_new/FirebaseAuth/auth.dart';
import 'package:boost_pt_new/Screens/TraineeScreens/TraineeDrawerScreen.dart';
import 'package:boost_pt_new/Screens/WelcomeScreen.dart';
import 'package:boost_pt_new/Screens/TrainerScreens/TrainerDrawerScreen.dart';
import 'package:boost_pt_new/Screens/pendingScreen/PendingScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({Key? key}) : super(key: key);
  static const String id = 'LoadingScreen';
  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  bool? _isFailed;
  int? endTimeMinutes;
  int? endTimeHours;
  DateTime? currentTime;

  @override
  void initState() {
    super.initState();
    checkConnection1();
  }

  checkConnection1() async {
    await checkConnection();
  }

  Future checkConnection() async {
    try {
      var _result = await (Connectivity().checkConnectivity());
      final FirebaseAuth _auth = FirebaseAuth.instance;

      if (_result == ConnectivityResult.wifi ||
          _result == ConnectivityResult.mobile) {
        log('connected');

        SharedPreferences pref = await SharedPreferences.getInstance();

        if (_auth.currentUser != null) {
          if (pref.getBool("switchValue") == true) {
            log("check first authentication");
            final isAuthenticated = await FireStoreDatabase().authenticate();
            if (isAuthenticated) {
              if (await FireStoreDatabase()
                  .checkUser(_auth.currentUser!.email)) {
                Navigator.pushReplacementNamed(context, TrainerDrawerScreen.id);
              } else {
                Navigator.pushReplacementNamed(context, TraineeDrawerScreen.id);
              }
            } else {
              //when user presses cancel button when biometric authentication is required
              SystemNavigator.pop();
            }
          } else {
            if (await FireStoreDatabase().checkUser(_auth.currentUser!.email)) {
              Navigator.pushReplacementNamed(context, TrainerDrawerScreen.id);
            } else {
              Navigator.pushReplacementNamed(context, TraineeDrawerScreen.id);
            }
          }
        } else {
          pref.setBool("switchValue", false);

          if (pref.getInt("formattedEndTimeMinutes") == null ||
              pref.getInt("formattedEndTimeHours") == null) {
            pref.setInt("formattedEndTimeMinutes", 0);
            pref.setInt("formattedEndTimeHours", 0);
          }
          endTimeMinutes = pref.getInt("formattedEndTimeMinutes");
          endTimeHours = pref.getInt("formattedEndTimeHours");
          currentTime = DateTime.now();
          String formattedDateMinutes = DateFormat('mm').format(currentTime!);
          String formattedDateHours = DateFormat('kk').format(currentTime!);

          log("here minutes: " + int.parse(formattedDateMinutes).toString());
          log("here hours: " + int.parse(formattedDateHours).toString());
          // log(endTimeMinutes.toString());

          if (int.parse(formattedDateMinutes) >= endTimeMinutes! &&
              int.parse(formattedDateHours) >= endTimeHours!) {
            pref.setBool("_isFailed", false);
            log("isFailed = false");
          }

          _isFailed = pref.getBool("_isFailed");
          if (_isFailed!) {
            Navigator.pushReplacementNamed(context, PendingScreen.id);
            log("isFailed = true");
          } else {
            Navigator.pushReplacementNamed(context, WelcomeScreen.id);
          }
        }
      } else {
        log('no connection');
      }
    } catch (e) {
      log('$e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Container(),
    );
  }
}
