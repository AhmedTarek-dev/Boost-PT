// ignore_for_file: prefer_const_constructors
import 'dart:developer';
import 'package:boost_pt_new/Components/Components.dart';
import 'package:boost_pt_new/Screens/TraineeScreens/ViewTrainerScreen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';
import '../../FirebaseAuth/firestore_services.dart';

class ListOfTrainers extends StatefulWidget {
  const ListOfTrainers({Key? key}) : super(key: key);
  static const String id = 'ListOfTrainers';
  @override
  _ListOfTrainersState createState() => _ListOfTrainersState();
}

class _ListOfTrainersState extends State<ListOfTrainers> {
  List<Trainer> _trainerInfo = [];
  List<String> userInfo = [];

  int selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    getInfo();
  }

  getInfo() async {
    _trainerInfo = await FireStoreServices().getTrainers();
    log(_trainerInfo.length.toString());
    log(_trainerInfo[0].Name.toString());
    log(_trainerInfo[0].Rating.toString());
    log(_trainerInfo[0].ID.toString());
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return GestureDetector(
      onPanUpdate: (details) {
        if (details.delta.dx > 0) {
          ZoomDrawer.of(context)!.open();
        } else if (details.delta.dx < 0) {
          ZoomDrawer.of(context)!.close();
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0.0,
          backgroundColor: Color(0xFF060d55),
          leading: IconButton(
            onPressed: () => ZoomDrawer.of(context)!.toggle(),
            icon: Icon(
              Icons.menu,
              size: 40.0,
              color: Colors.white,
            ),
          ),
          title: Padding(
            padding: EdgeInsets.only(left: size.width * 0.06),
            child: Text(
              'List Of Trainers',
              style: GoogleFonts.play(
                fontSize: 35,
                //fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),
        body: SizedBox(
          height: size.height * 0.9,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  //height: size.height* 0.05,
                  height: 40,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      bottomRight: Radius.circular(50),
                    ),
                    color: Color(0xFF060d55),
                  ),
                ),
                SizedBox(
                  height: size.height * 0.02,
                ),
                SizedBox(
                  height: size.height * 0.725,
                  width: size.width * 0.999,
                  child: CustomScrollView(
                    slivers: <Widget>[
                      SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            final _trainer = _trainerInfo[index];

                            return SizedBox(
                              height: 230,
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
                                        child: ViewTrainerScreen(
                                            trainer:
                                                _trainerInfo[selectedIndex])),
                                  );
                                  // Navigator.pushNamed(
                                  //     context, ViewTrainerScreen.id);
                                },
                                child: Stack(
                                  children: [
                                    Positioned(
                                      //white container
                                      top: 35,
                                      left: 10,
                                      child: Material(
                                        child: Container(
                                          height: 180,
                                          width: size.width * 0.93,
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.grey
                                                    .withOpacity(0.3),
                                                offset: Offset(-10.0, 10.0),
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
                                      top: 60,
                                      left: 25,
                                      child: Container(
                                        height: size.height *
                                            0.15, //height and width of trainer's image
                                        width: size.width * 0.35,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                        ),
                                        child: _trainer.Image != null
                                            ? CachedNetworkImage(
                                                imageUrl:
                                                    _trainer.Image.toString(),
                                                //"https://images.unsplash.com/photo-1585533530535-2f4236949d08?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8M3x8ZHVja3xlbnwwfHwwfHw%3D&w=1000&q=80",
                                                //_ex.Image.toString(),
                                                imageBuilder:
                                                    (context, imageProvider) =>
                                                        Container(
                                                  width: 40.0,
                                                  height: 40.0,
                                                  decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    image: DecorationImage(
                                                        image: imageProvider,
                                                        fit: BoxFit.fill),
                                                  ),
                                                ),
                                                placeholder: (context, url) =>
                                                    Center(
                                                        child:
                                                            CircularProgressIndicator(
                                                  strokeWidth: 2,
                                                )),
                                                errorWidget:
                                                    (context, url, error) =>
                                                        Icon(Icons.error),
                                              )
                                            : CircularProgressIndicator(),
                                      ),
                                    ),
                                    Positioned(
                                      top: 80,
                                      left: 180,
                                      child: SizedBox(
                                        height: 150,
                                        width: 180,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              _trainer.Name.toString()
                                                  .toUpperCase(),
                                              style: TextStyle(
                                                fontSize: 20,
                                                color: Color(0xFF363f93),
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            RatingBarIndicator(
                                              rating: double.parse(
                                                  _trainer.Rating.toString()),
                                              itemBuilder: (context, index) =>
                                                  Icon(
                                                Icons.star,
                                                color: Colors.amber,
                                              ),
                                              itemCount: 5,
                                              itemSize: 25.0,
                                            ),
                                            Divider(
                                              indent: 2,
                                              endIndent: 25,
                                              color: Colors.black,
                                            ),
                                            Text(
                                              _trainer.Gender.toString(),
                                              style: TextStyle(
                                                fontSize: 16,
                                                color: Colors.grey,
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
                          childCount: _trainerInfo.length,
                        ),
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
