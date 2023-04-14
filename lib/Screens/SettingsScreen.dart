// ignore_for_file: prefer_const_constructors
import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);
  static const String id = 'SettingsScreen';
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
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
            child: Scaffold(body: Text("settings screen"))));
  }
}
