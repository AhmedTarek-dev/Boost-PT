// ignore_for_file: prefer_const_constructors

import 'dart:developer';

import 'package:boost_pt_new/Screens/TrainerScreens/TrainerDrawerScreen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:page_transition/page_transition.dart';
import 'package:boost_pt_new/Screens/TrainerScreens/TraineeInterface/TraineeHomePage.dart';
import '../../Components/Components.dart';
import '../../FirebaseAuth/firestore_services.dart';

class ListOfTrainees extends StatefulWidget {
  final String? trainerName;
  const ListOfTrainees({this.trainerName, Key? key}) : super(key: key);
  static const String id = "ListOfTrainees";
  @override
  State<ListOfTrainees> createState() => _ListOfTraineesState();
}

class _ListOfTraineesState extends State<ListOfTrainees> {
  List<Trainee> _traineeInfo = [];
  List<String> userInfo = [];
  String? trainerName;
  int selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    trainerName = widget.trainerName;
    getInfo();
  }

  getInfo() async {
    _traineeInfo = await FireStoreServices().getTrainees(trainerName!);
    log("number of trainees under this trainer: " +
        _traineeInfo.length.toString());
    log(_traineeInfo[0].LastSeen.toString());
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
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
      body: SizedBox(
        height: size.height * 0.88,
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 40.0,
              ),
              Text(
                'Trainees List',
                style: TextStyle(
                    fontSize: 35.0,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF050b48)),
              ),
              SizedBox(
                height: size.height * 0.04,
              ),
              SizedBox(
                height: size.height * 0.86,
                width: size.width * 0.97,
                child: CustomScrollView(
                  slivers: <Widget>[
                    SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          final _trainee = _traineeInfo[index];

                          return SizedBox(
                            height: 180,
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  selectedIndex = index;
                                });
                                Navigator.of(context).push(
                                  PageTransition(
                                      type: PageTransitionType.size,
                                      alignment: Alignment.bottomCenter,
                                      childCurrent: widget,
                                      duration: Duration(milliseconds: 500),
                                      reverseDuration:
                                          Duration(milliseconds: 500),
                                      child: TraineeHomePageScreen(
                                          trainee: _traineeInfo[selectedIndex],
                                          trainerName: trainerName)),
                                );
                                // Navigator.pushNamed(
                                //     context, ViewTrainerScreen.id);
                              },
                              child: Stack(
                                children: [
                                  Positioned(
                                    //white container
                                    top: 15,
                                    left: 10,
                                    child: Material(
                                      child: Container(
                                        height: 140,
                                        width: size.width * 0.93,
                                        decoration: BoxDecoration(
                                          color: Colors.grey.shade300,
                                          borderRadius:
                                              BorderRadius.circular(15),
                                          boxShadow: [
                                            BoxShadow(
                                              color:
                                                  Colors.grey.withOpacity(0.2),
                                              offset: Offset(-10.0, 5.0),
                                              blurRadius: 20.0,
                                              spreadRadius: 4.0,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    //image position on the container
                                    bottom: -10,
                                    left: 40,
                                    child: Container(
                                      height: size.height *
                                          0.25, //height and width of trainer's image
                                      width: size.width * 0.25,
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                      ),
                                      child: _trainee.Image != null
                                          ? CachedNetworkImage(
                                              imageUrl:
                                                  _trainee.Image.toString(),
                                              //"https://images.unsplash.com/photo-1585533530535-2f4236949d08?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8M3x8ZHVja3xlbnwwfHwwfHw%3D&w=1000&q=80",
                                              //_ex.Image.toString(),
                                              imageBuilder:
                                                  (context, imageProvider) =>
                                                      Container(
                                                decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  image: DecorationImage(
                                                    image: imageProvider,
                                                  ),
                                                ),
                                              ),

                                              placeholder: (context, url) =>
                                                  Center(
                                                      child:
                                                          CircularProgressIndicator(
                                                strokeWidth: 3,
                                              )),
                                              errorWidget: (context, url,
                                                      error) =>
                                                  Icon(Icons
                                                      .error_outline_outlined),
                                            )
                                          : CircularProgressIndicator(),
                                    ),
                                  ),
                                  Positioned(
                                    top: 35,
                                    left: 170,
                                    child: SizedBox(
                                      height: size.height * 0.15,
                                      width: size.width * 0.54,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            _trainee.Name.toString(),
                                            style: TextStyle(
                                              fontSize: 20,
                                              color: Color(0xFF363f93),
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Text(_trainee.Email.toString()),
                                          Divider(
                                            indent: 2,
                                            endIndent: 20,
                                            thickness: 0.5,
                                            color: Colors.black,
                                          ),
                                          Text(
                                            _trainee.Gender.toString(),
                                            style: TextStyle(
                                              fontSize: 16,
                                              color: Colors.grey.shade700,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          SizedBox(
                                            height: size.height * 0.004,
                                          ),
                                          Text(
                                            "Last Seen:   " +
                                                _trainee.LastSeen.toString(),
                                            style: TextStyle(
                                              fontSize: 16,
                                              color: Colors.grey.shade900,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                        childCount: _traineeInfo.length,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
