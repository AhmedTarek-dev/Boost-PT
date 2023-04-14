// ignore_for_file: prefer_const_constructors

import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../Components/Components.dart';
import '../../FirebaseAuth/firestore_services.dart';

class NotificationTrainer extends StatefulWidget {
  final Trainer? trainer;
  const NotificationTrainer({this.trainer, Key? key}) : super(key: key);
  @override
  State<NotificationTrainer> createState() => _NotificationTrainerState();
}

class _NotificationTrainerState extends State<NotificationTrainer> {
  Trainer? _trainer;
  List<Notifications> _notifications = [];

  int selectedIndex = 0;
  getNotifications() async {
    log(_trainer!.ID.toString());
    _notifications = await FireStoreServices()
        .getNotificationsForTrainer(_trainer!.ID.toString());

    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _trainer = widget.trainer;

    getNotifications();
  }

  // onPanUpdate: (details) {
  // if (details.delta.dx > 0) {
  // ZoomDrawer.of(context)!.open();
  // } else if (details.delta.dx < 0) {
  // ZoomDrawer.of(context)!.close();
  // }
  // },

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: () async {
        ZoomDrawer.of(context)!.toggle();
        return false;
      },
      child: Scaffold(
        body: SizedBox(
          height: size.height * 0.99,
          child: RefreshIndicator(
            color: Colors.blue,
            backgroundColor: Colors.white,
            onRefresh: () async {
              await getNotifications();
              setState(() {});
            },
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(
                parent: AlwaysScrollableScrollPhysics(),
              ),
              child: Column(
                children: [
                  Container(
                    height: 190,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        bottomRight: Radius.circular(70),
                      ),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.grey.withOpacity(0.3),
                            offset: Offset(-10.0, 10.0),
                            blurRadius: 20.0,
                            spreadRadius: 10.0),
                      ],
                      color: Color(0xFF060d55),
                    ),
                    child: Stack(
                      children: [
                        Positioned(
                          top: 40,
                          left: 10,
                          child: GestureDetector(
                            onTap: () => ZoomDrawer.of(context)!.toggle(),
                            child: Icon(
                              Icons.menu,
                              color: Colors.white,
                              size: 45,
                            ),
                          ),
                        ),
                        Positioned(
                          top: 100,
                          left: 0,
                          child: Container(
                            height: 70,
                            width: 280,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(
                                bottomRight: Radius.circular(50),
                                topRight: Radius.circular(50),
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          top: 110,
                          left: 20,
                          child: SizedBox(
                            width: 250,
                            child: Text(
                              "Notifications",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 35,
                                color: Color(0xFF060d55),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  _notifications.isEmpty
                      ? SizedBox(
                          height: size.height * 0.7,
                          width: size.width * 0.99,
                          child: Padding(
                            padding: EdgeInsets.only(
                                top: size.height * 0.1, left: size.width * 0.1),
                            child: Text(
                              "No Notifications available",
                              style: TextStyle(
                                fontSize: 27,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        )
                      : SizedBox(
                          height: size.height * 0.8,
                          width: size.width * 0.999,
                          child: RefreshIndicator(
                            color: Colors.blue,
                            backgroundColor: Colors.white,
                            onRefresh: () async {
                              await getNotifications();
                              setState(() {});
                            },
                            child: CustomScrollView(
                              slivers: <Widget>[
                                SliverList(
                                  delegate: SliverChildBuilderDelegate(
                                    (context, index) {
                                      final _notificationTrainer =
                                          _notifications[index];
                                      return SizedBox(
                                        // color: Colors.black,
                                        height: size.height * 0.8,
                                        child: Stack(
                                          children: [
                                            Positioned(
                                              //white container
                                              top: 30,
                                              left: 10,
                                              child: Material(
                                                child: Container(
                                                  height: size.height * 0.17,
                                                  width: size.width * 0.93,
                                                  decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20),
                                                    boxShadow: [
                                                      BoxShadow(
                                                        color: Colors.grey
                                                            .withOpacity(0.4),
                                                        offset:
                                                            Offset(-10.0, 10.0),
                                                        blurRadius: 20.0,
                                                        spreadRadius: 4.0,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Positioned(
                                              top: 45,
                                              left: 50,
                                              child: SizedBox(
                                                width: size.width * 0.8,
                                                child: Column(
                                                  children: [
                                                    Row(
                                                      children: [
                                                        Text(
                                                          "Trainee: " +
                                                              _notificationTrainer
                                                                      .Name
                                                                  .toString(),
                                                          style: TextStyle(
                                                            fontSize: 20,
                                                            color: Color(
                                                                0xFF363f93),
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ),
                                                        Text(
                                                          "        Age: " +
                                                              _notificationTrainer
                                                                      .Age
                                                                  .toString(),
                                                          style: TextStyle(
                                                            fontSize: 20,
                                                            color: Color(
                                                                0xFF363f93),
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    Divider(
                                                      indent: 2,
                                                      endIndent: 25,
                                                      color: Colors.black,
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              right: 30,
                                                              top: 5),
                                                      child: Text(
                                                        "Requested to train with you",
                                                        style: TextStyle(
                                                          fontSize: 16,
                                                          color: Colors.black,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      height: 10,
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                        right: 30,
                                                      ),
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceEvenly,
                                                        children: [
                                                          ElevatedButton(
                                                            onPressed:
                                                                () async {
                                                              setState(() {
                                                                selectedIndex =
                                                                    index;
                                                              });
                                                              bool isDone = await FireStoreServices().acceptNotification(
                                                                  _trainer!.ID
                                                                      .toString(),
                                                                  _trainer!.Name
                                                                      .toString(),
                                                                  _notifications[
                                                                      selectedIndex]);
                                                              log("here when back " +
                                                                  isDone
                                                                      .toString());
                                                              if (isDone) {
                                                                Fluttertoast.showToast(
                                                                    msg:
                                                                        "Trainee accepted",
                                                                    fontSize:
                                                                        17,
                                                                    toastLength:
                                                                        Toast
                                                                            .LENGTH_LONG);
                                                              }
                                                              await getNotifications();
                                                              setState(() {});
                                                            },
                                                            child:
                                                                Text("Accept"),
                                                            style:
                                                                ElevatedButton
                                                                    .styleFrom(
                                                              primary:
                                                                  Colors.green,
                                                            ),
                                                          ),
                                                          ElevatedButton(
                                                            onPressed:
                                                                () async {
                                                              setState(() {
                                                                selectedIndex =
                                                                    index;
                                                              });
                                                              bool isDone = await FireStoreServices()
                                                                  .deleteNotification(
                                                                      _trainer!
                                                                          .ID
                                                                          .toString(),
                                                                      _notifications[
                                                                          selectedIndex]);
                                                              if (isDone) {
                                                                Fluttertoast
                                                                    .showToast(
                                                                        msg:
                                                                            "Notification deleted");
                                                              }
                                                              await getNotifications();
                                                              setState(() {});
                                                            },
                                                            child:
                                                                Text("Decline"),
                                                            style: ElevatedButton
                                                                .styleFrom(
                                                                    primary:
                                                                        Colors
                                                                            .red),
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                    childCount: _notifications.length,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
