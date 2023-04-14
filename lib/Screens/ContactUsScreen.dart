// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables
import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';

class ContactUsScreen extends StatefulWidget {
  const ContactUsScreen({Key? key}) : super(key: key);
  static const String id = 'ContactUsScreen';
  @override
  _ContactUsScreenState createState() => _ContactUsScreenState();
}

class _ContactUsScreenState extends State<ContactUsScreen> {
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
          ),
          body: Container(
            alignment: Alignment.center,
            child: Column(
              children: [
                SizedBox(
                  height: 50.0,
                ),
                Text(
                  'Contact us',
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
                  alignment: Alignment.center,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            backgroundColor: Colors.white,
                            child: Icon(
                              Icons.mail,
                              color: Colors.grey,
                            ),
                          ),
                          Text(
                            'Contact@boostpt.com.eg',
                            style: TextStyle(
                              color: Color.fromRGBO(0, 0, 70, 9000),
                              fontSize: 25.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      Row(
                        children: [
                          CircleAvatar(
                            backgroundColor: Colors.white,
                            child: Icon(
                              Icons.camera_enhance_outlined,
                              color: Colors.grey,
                            ),
                          ),
                          Text(
                            'boost-pt',
                            style: TextStyle(
                              color: Color.fromRGBO(0, 0, 70, 9000),
                              fontSize: 25.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      Row(
                        children: [
                          CircleAvatar(
                            backgroundColor: Colors.white,
                            child: Icon(
                              Icons.facebook,
                              color: Colors.grey,
                            ),
                          ),
                          Text(
                            'boost personal trainer',
                            style: TextStyle(
                              color: Color.fromRGBO(0, 0, 70, 9000),
                              fontSize: 25.0,
                              fontWeight: FontWeight.bold,
                            ),
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
    );
  }
}
