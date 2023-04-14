// ignore_for_file: prefer_const_constructors
import 'package:boost_pt_new/Screens/TraineeScreens/ExercisesScreen.dart';
import 'package:boost_pt_new/Screens/TraineeScreens/ListOfTrainers.dart';
import 'package:boost_pt_new/Screens/TraineeScreens/NutritionScreen.dart';
import 'package:boost_pt_new/Screens/TraineeScreens/SupplementsScreen.dart';
import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter/services.dart';
import 'package:flutter/cupertino.dart';

class TraineeHomeScreen extends StatefulWidget {
  const TraineeHomeScreen({Key? key}) : super(key: key);
  static const String id = 'TraineeHomeScreen';
  @override
  _TraineeHomeScreenState createState() => _TraineeHomeScreenState();
}

class _TraineeHomeScreenState extends State<TraineeHomeScreen> {
  var currentIndex = 0;
  DateTime timeBackPressed = DateTime.now();
  int index = 0;
  final navigationKey = GlobalKey<CurvedNavigationBarState>();
  final screens = [
    ExercisesScreen(),
    NutritionScreen(),
    SupplementsScreen(),
    ListOfTrainers(),
  ];

  // final zoomController = ZoomDrawerController();

  @override
  Widget build(BuildContext context) {
    double displayWidth = MediaQuery.of(context).size.width;
    return WillPopScope(
      onWillPop: () async {
        final difference = DateTime.now().difference(timeBackPressed);
        final isExitWarning = difference >= Duration(seconds: 2);
        timeBackPressed = DateTime.now();
        if (isExitWarning) {
          const message = 'Press back again to exit';
          Fluttertoast.showToast(msg: message, fontSize: 10);
          return false;
        } else {
          Fluttertoast.cancel();
          SystemNavigator.pop();
          return true;
        }
      },
      child: Container(
        color: Colors.white,
        child: SafeArea(
          top: false,
          child: Scaffold(
            extendBody: true,
            // backgroundColor: Colors.white,
            body: screens[currentIndex],
            // body: ZoomDrawer(
            //   controller: zoomController,
            //   style: DrawerStyle.Style1,
            //   mainScreen: TraineeHomeScreen(),
            //   menuScreen: DrawerButtonsScreen(),
            // ),
            bottomNavigationBar: Opacity(
              opacity: 1,
              child: Container(
                margin: EdgeInsets.all(displayWidth * .05),
                height: displayWidth * .150,
                decoration: BoxDecoration(
                    color: Color(0xFF060d55),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(.1),
                        blurRadius: 30,
                        offset: Offset(0, 10),
                      ),
                    ],
                    borderRadius: BorderRadius.circular(30)),
                child: ListView.builder(
                  itemCount: 4,
                  scrollDirection: Axis.horizontal,
                  padding: EdgeInsets.symmetric(horizontal: displayWidth * .02),
                  itemBuilder: (context, index) => InkWell(
                    onTap: () {
                      setState(
                        () {
                          currentIndex = index;
                          HapticFeedback.lightImpact();
                        },
                      );
                    },
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    child: Stack(
                      children: [
                        AnimatedContainer(
                          duration: Duration(seconds: 1),
                          curve: Curves.fastLinearToSlowEaseIn,
                          width: index == currentIndex
                              ? displayWidth * .32
                              : displayWidth * .18,
                          alignment: Alignment.center,
                          child: AnimatedContainer(
                            duration: Duration(seconds: 1),
                            curve: Curves.fastLinearToSlowEaseIn,
                            height:
                                index == currentIndex ? displayWidth * .12 : 0,
                            width:
                                index == currentIndex ? displayWidth * .32 : 0,
                            decoration: BoxDecoration(
                                color: index == currentIndex
                                    ? Colors.white
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(20)),
                          ),
                        ),
                        AnimatedContainer(
                          duration: Duration(seconds: 1),
                          curve: Curves.fastLinearToSlowEaseIn,
                          width: index == currentIndex
                              ? displayWidth * .31
                              : displayWidth * .18,
                          alignment: Alignment.center,
                          child: Stack(
                            children: [
                              Row(
                                children: [
                                  AnimatedContainer(
                                    duration: Duration(seconds: 1),
                                    curve: Curves.fastLinearToSlowEaseIn,
                                    width: index == currentIndex
                                        ? displayWidth * .13
                                        : 0,
                                  ),
                                  AnimatedOpacity(
                                    opacity: index == currentIndex ? 1 : 0,
                                    duration: Duration(seconds: 1),
                                    curve: Curves.fastLinearToSlowEaseIn,
                                    child: Text(
                                      index == currentIndex
                                          ? '${listOfStrings[index]}'
                                          : '',
                                      style: TextStyle(
                                        color: Color(0xFF060d55),
                                        fontWeight: FontWeight.w600,
                                        fontSize: 15,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  AnimatedContainer(
                                    duration: Duration(seconds: 1),
                                    curve: Curves.fastLinearToSlowEaseIn,
                                    width: index == currentIndex
                                        ? displayWidth * .03
                                        : 20,
                                  ),
                                  Icon(
                                    listOfIcons[index],
                                    size: displayWidth * .076,
                                    color: index == currentIndex
                                        ? Color(0xFF060d55)
                                        : Colors.white,
                                  ),
                                ],
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
          ),
        ),
      ),
    );
  }
}

List<String> listOfStrings = [
  'Exercise',
  'Nutrition',
  'Supps',
  'Trainers',
];
List<IconData> listOfIcons = [
  FontAwesomeIcons.dumbbell,
  Icons.dinner_dining,
  FontAwesomeIcons.prescriptionBottle,
  Icons.people,
  //FontAwesomeIcons.bottleWater,
  //FontAwesomeIcons.peopleGroup,
];
