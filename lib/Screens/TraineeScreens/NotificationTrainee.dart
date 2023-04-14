// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import '../../Components/Components.dart';
import '../../FirebaseAuth/firestore_services.dart';

class NotificationTrainee extends StatefulWidget {
  final Trainee? trainee;
  const NotificationTrainee({this.trainee, Key? key}) : super(key: key);

  @override
  State<NotificationTrainee> createState() => _NotificationTraineeState();
}

class _NotificationTraineeState extends State<NotificationTrainee> {
  Trainee? _trainee;
  List<Notifications> _notifications = [];

  int selectedIndex = 0;
  getNotifications() async {
    log(_trainee!.ID.toString());
    _notifications = await FireStoreServices()
        .getNotificationsForTrainee(_trainee!.ID.toString());

    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _trainee = widget.trainee;

    getNotifications();
  }

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
                          height: size.height * 0.8,
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
                          // color: Colors.orange,
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
                                      final _notificationTrainee =
                                          _notifications[index];

                                      return SizedBox(
                                        // color: Colors.black,
                                        height: _notificationTrainee
                                                    .TypeOfNotification ==
                                                "delete"
                                            ? size.height * 0.22
                                            : size.height * 0.17,
                                        child: Stack(
                                          children: [
                                            Positioned(
                                              //white container
                                              top: 10,
                                              left: 15,
                                              child: Material(
                                                child: Container(
                                                  height: _notificationTrainee
                                                              .TypeOfNotification ==
                                                          "delete"
                                                      ? size.height * 0.19
                                                      : size.height * 0.13,
                                                  width: size.width * 0.93,
                                                  decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            25),
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
                                              top: 20,
                                              left: 45,
                                              child: SizedBox(
                                                // height: size.height * 0.1,
                                                width: size.width * 0.8,
                                                child: Column(
                                                  children: [
                                                    Text(
                                                      "Trainer: " +
                                                          _notificationTrainee
                                                              .Name.toString(),
                                                      style: TextStyle(
                                                        fontSize: 20,
                                                        color:
                                                            Color(0xFF363f93),
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                    Divider(
                                                      indent: 2,
                                                      endIndent: 25,
                                                      thickness: 2,
                                                      color: Colors.black,
                                                    ),
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceAround,
                                                      children: [
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .only(top: 5),
                                                          child: Text(
                                                            _notificationTrainee
                                                                        .TypeOfNotification ==
                                                                    "accept"
                                                                ? "You are accepted"
                                                                : "Trainer deleted you",
                                                            style: TextStyle(
                                                              fontSize: 18,
                                                              color:
                                                                  Colors.black,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                            ),
                                                          ),
                                                        ),
                                                        Icon(
                                                          _notificationTrainee
                                                                      .TypeOfNotification ==
                                                                  "accept"
                                                              ? Icons
                                                                  .check_circle_rounded
                                                              : Icons.close,
                                                          color: _notificationTrainee
                                                                      .TypeOfNotification ==
                                                                  "accept"
                                                              ? Colors.green
                                                              : Colors.red,
                                                          size: 30,
                                                        )
                                                      ],
                                                    ),
                                                    SizedBox(
                                                      height: 10,
                                                    ),
                                                    Visibility(
                                                      visible: _notificationTrainee
                                                                  .TypeOfNotification ==
                                                              "delete"
                                                          ? true
                                                          : false,
                                                      child: Row(
                                                        children: [
                                                          Text(
                                                            "Reason:",
                                                            style: TextStyle(
                                                                decoration:
                                                                    TextDecoration
                                                                        .underline,
                                                                fontSize: 15,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                          ),
                                                          Padding(
                                                            padding:
                                                                EdgeInsets.only(
                                                              left: size.width *
                                                                  0.04,
                                                            ),
                                                            child: SizedBox(
                                                              width:
                                                                  size.width *
                                                                      0.6,
                                                              child: Text(
                                                                _notificationTrainee
                                                                        .Reason
                                                                    .toString(),
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        16,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500),
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    )
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
