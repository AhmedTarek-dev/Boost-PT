// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';

class PrivacyScreen extends StatefulWidget {
  const PrivacyScreen({Key? key}) : super(key: key);
  static const String id = 'PrivacyScreen';
  @override
  _PrivacyScreenState createState() => _PrivacyScreenState();
}

class _PrivacyScreenState extends State<PrivacyScreen> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onPanUpdate: (details) {
          if (details.delta.dx > 0) {
            ZoomDrawer.of(context)!.open();
          } else if (details.delta.dx < 0) {
            ZoomDrawer.of(context)!.close();
          }
        },
        child: WillPopScope(
          onWillPop: () async {
            ZoomDrawer.of(context)!.toggle();
            return false;
          },
          child: Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0.0,
              leading: GestureDetector(
                onTap: () {
                  ZoomDrawer.of(context)!.toggle();
                },
                child: Padding(
                  padding: const EdgeInsets.only(left: 15, top: 15),
                  child: Icon(
                    Icons.menu,
                    color: Colors.black,
                    size: 50,
                  ),
                ),
              ),
              // title: CircleAvatar(
              //   backgroundColor: Colors.white,
              //   radius: 50.0,
              //   backgroundImage: AssetImage('assets/LgoFinal.png'),
              // ),
            ),
            body: Container(
              alignment: Alignment.center,
              child: Column(
                children: [
                  SizedBox(
                    height: 50.0,
                  ),
                  Text(
                    'Privacy',
                    style: TextStyle(
                      color: Color.fromRGBO(0, 0, 70, 9000),
                      fontSize: 30.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: 30.0,
                  ),
                  Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 50.0, vertical: 50.0),
                    child: Text(
                      'Here will be listed the privacy of our application',
                      style: TextStyle(
                        color: Color.fromRGBO(0, 0, 70, 9000),
                        fontSize: 25.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
