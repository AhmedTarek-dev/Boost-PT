// ignore_for_file: prefer_const_constructors

import 'package:boost_pt_new/Screens/TrainerScreens/NutritionDisplayed%20ForTrainerHomeScreen/Add_Nutrition_Screen.dart';
import 'package:boost_pt_new/Screens/TrainerScreens/NutritionDisplayed%20ForTrainerHomeScreen/Carbohydrates.dart';
import 'package:boost_pt_new/Screens/TrainerScreens/NutritionDisplayed%20ForTrainerHomeScreen/Fats.dart';
import 'package:boost_pt_new/Screens/TrainerScreens/NutritionDisplayed%20ForTrainerHomeScreen/Protein.dart';
import 'package:boost_pt_new/Screens/TrainerScreens/TrainerDrawerScreen.dart';
import 'package:flutter/material.dart';

class TrainerNutrition extends StatelessWidget {
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
              Navigator.pushReplacementNamed(context, TrainerDrawerScreen.id);
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
        leading: IconButton(
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
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            SizedBox(
              height: 70.0,
            ),
            Text(
              'Nutrition',
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
                    height: 60.0,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamed(context, ProteinScreen.id);
                      },
                      style: ElevatedButton.styleFrom(
                        elevation: 10,
                        primary: Color.fromRGBO(0, 0, 70, 9000),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                      ),
                      child: Text(
                        'Protein',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 25.0,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 80.0,
                  ),
                  SizedBox(
                    width: 280.0,
                    height: 60.0,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamed(context, CarbohydratesScreen.id);
                      },
                      style: ElevatedButton.styleFrom(
                        elevation: 10,
                        primary: Color.fromRGBO(0, 0, 70, 9000),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                      ),
                      child: Text(
                        'Carbs',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 25.0,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 80.0,
                  ),
                  SizedBox(
                    width: 280.0,
                    height: 60.0,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamed(context, FatsScreen.id);
                      },
                      style: ElevatedButton.styleFrom(
                        elevation: 10,
                        primary: Color.fromRGBO(0, 0, 70, 9000),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                      ),
                      child: Text(
                        'Fats',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 25.0,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 80.0,
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
                            builder: (context) => AddNutrition(),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        elevation: 10,
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
