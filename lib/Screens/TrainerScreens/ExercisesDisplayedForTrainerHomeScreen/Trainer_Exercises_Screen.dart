// ignore_for_file: prefer_const_constructors
import 'package:boost_pt_new/Screens/TrainerScreens/ExercisesDisplayedForTrainerHomeScreen/Add_Exercise_Screen.dart';
import 'package:boost_pt_new/Screens/TrainerScreens/ExercisesDisplayedForTrainerHomeScreen/Back.dart';
import 'package:boost_pt_new/Screens/TrainerScreens/ExercisesDisplayedForTrainerHomeScreen/Legs.dart';
import 'package:boost_pt_new/Screens/TrainerScreens/TrainerDrawerScreen.dart';
import 'package:flutter/material.dart';
import 'Abs.dart';
import 'Arms.dart';
import 'Chest.dart';

class TrainerExercises extends StatelessWidget {
  const TrainerExercises({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.0,
        title: Padding(
          padding: const EdgeInsets.only(top: 20),
          child: GestureDetector(
            onTap: () {
              Navigator.pushNamedAndRemoveUntil(
                  context, TrainerDrawerScreen.id, (r) => false);
            },
            child: Container(
              alignment: Alignment.topRight,
              child: CircleAvatar(
                backgroundColor: Colors.white,
                radius: 50.0,
                backgroundImage: AssetImage(
                  'assets/LgoFinal.png',
                ),
              ),
            ),
          ),
        ),
        leading: Padding(
          padding: const EdgeInsets.only(top: 15, left: 15),
          child: IconButton(
            icon: Icon(
              Icons.arrow_back_rounded,
              color: Colors.black,
              size: 35,
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            SizedBox(
              height: 70.0,
            ),
            Text(
              'Exercises',
              style: TextStyle(
                fontSize: 40.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              height: 70.0,
            ),
            Container(
              alignment: Alignment.center,
              child: Column(
                children: [
                  SizedBox(
                    width: 280.0,
                    height: 50.0,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamed(
                            context, BackExercisesTrainerHomeScreen.id);
                      },
                      style: ElevatedButton.styleFrom(
                        elevation: 10,
                        primary: Color.fromRGBO(0, 0, 70, 9000),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                      ),
                      child: Text(
                        'Back',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20.0,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 40.0,
                  ),
                  SizedBox(
                    width: 280.0,
                    height: 50.0,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamed(
                            context, ChestExercisesTrainerHomeScreen.id);
                      },
                      style: ElevatedButton.styleFrom(
                        elevation: 10,
                        primary: Color.fromRGBO(0, 0, 70, 9000),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                      ),
                      child: Text(
                        'Chest',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20.0,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 40.0,
                  ),
                  SizedBox(
                    width: 280.0,
                    height: 50.0,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamed(
                            context, ArmsExercisesTrainerHomeScreen.id);
                      },
                      style: ElevatedButton.styleFrom(
                        elevation: 10,
                        primary: Color.fromRGBO(0, 0, 70, 9000),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                      ),
                      child: Text(
                        'Arms',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20.0,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 40.0,
                  ),
                  SizedBox(
                    width: 280.0,
                    height: 50.0,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamed(
                            context, LegsExercisesTrainerHomeScreen.id);
                      },
                      style: ElevatedButton.styleFrom(
                        elevation: 15,
                        primary: Color.fromRGBO(0, 0, 70, 9000),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                      ),
                      child: Text(
                        'Legs',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20.0,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 40.0,
                  ),
                  SizedBox(
                    width: 280.0,
                    height: 50.0,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamed(
                            context, AbsExercisesTrainerHomeScreen.id);
                      },
                      style: ElevatedButton.styleFrom(
                        elevation: 15,
                        primary: Color.fromRGBO(0, 0, 70, 9000),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                      ),
                      child: Text(
                        'Abs',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20.0,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 30.0,
                  ),
                  Container(
                    padding: EdgeInsetsDirectional.only(start: 220.0),
                    width: 280.0,
                    height: 50.0,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AddExercise(),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        elevation: 15,
                        primary: Color.fromRGBO(0, 0, 70, 9000),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                      ),
                      child: Text(
                        '+',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 30.0,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
