// ignore_for_file: prefer_const_constructors
import 'dart:developer';
import 'package:boost_pt_new/Components/Components.dart';
import 'package:boost_pt_new/Screens/ContactUsScreen.dart';
import 'package:boost_pt_new/Screens/FeedBackScreen.dart';
import 'package:boost_pt_new/Screens/PrivacyScreen.dart';
import 'package:boost_pt_new/Screens/TraineeScreens/NotificationTrainee.dart';
import 'package:boost_pt_new/Screens/TraineeScreens/profile_Screen.dart';
import 'package:boost_pt_new/Screens/TraineeScreens/TraineeHomeScreen.dart';
import 'package:boost_pt_new/Screens/chatScreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:intl/intl.dart';
import '../../FirebaseAuth/firestore_services.dart';
import '../../Components/DrawerButtons.dart';

class TraineeDrawerScreen extends StatefulWidget {
  const TraineeDrawerScreen({Key? key}) : super(key: key);
  static const String id = 'TraineeDrawerScreen';

  @override
  _TraineeDrawerScreenState createState() => _TraineeDrawerScreenState();
}

class _TraineeDrawerScreenState extends State<TraineeDrawerScreen>
    with WidgetsBindingObserver {
  DrawerButtons currentItem = MenuItems.home;
  Trainee? traineeInfo;
  Users? _currentUser;

  getUserInfo() async {
    traineeInfo = await FireStoreServices().getTraineeInformation();
    _currentUser = await FireStoreServices().getUserInformation();
    setStatus("Online");
    // log(traineeInfo!.PhoneNo.toString());
    // log(traineeInfo!.Name.toString());
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    getUserInfo();
    setState(() {});
  }

  void setStatus(String status) async {
    log(traineeInfo!.ID.toString());
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('EEE d MMM').format(now);
    await FirebaseFirestore.instance
        .collection("Trainee")
        .doc(traineeInfo!.ID)
        .update({"Status": status, "LastSeen": formattedDate}).then((value) {
      log("status updated");
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      setStatus("Online");
    } else {
      setStatus("Offline");
    }
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  Widget build(BuildContext context) {
    return ZoomDrawer(
      menuScreen: Builder(
        builder: (context) => DrawerButtonsScreen(
          currentItem: currentItem,
          onSelectedItem: (item) {
            setState(() {
              currentItem = item;
              ZoomDrawer.of(context)!.close();
            });
          },
        ),
      ),
      mainScreen: getScreen(),
      borderRadius: 40.0,
      style: DrawerStyle.Style1,
      showShadow: true,
      shadowLayer1Color: Color(0xFFA13939),
      angle: -12.0,
      backgroundColor: Color(0xFF9B0000),
      slideWidth: MediaQuery.of(context).size.width * 0.65,
    );
  }

  Widget getScreen() {
    switch (currentItem) {
      case MenuItems.home:
        return TraineeHomeScreen();
      case MenuItems.privacy:
        return PrivacyScreen();
      case MenuItems.notification:
        return NotificationTrainee(trainee: traineeInfo);
      case MenuItems.message:
        // Users user = Users(
        //     Name: traineeInfo!.Name,
        //     Email: traineeInfo!.Email,
        //     PhoneNo: traineeInfo!.PhoneNo,
        //     Gender: traineeInfo!.Gender,
        //     Age: traineeInfo!.Age,
        //     ID: traineeInfo!.ID,isTrainer: traineeInfo.i);
        return ChatScreen(
          trainee: traineeInfo,
          currentUser: _currentUser,
        );
      // case MenuItems.settings:
      //   return SettingsScreen();
      case MenuItems.feedBack:
        return FeedBackScreen();
      case MenuItems.profile:
        return ProfileScreen(trainee: traineeInfo);
      case MenuItems.contactUs:
        return ContactUsScreen();
      default:
        return TraineeHomeScreen();
    }
  }
}
