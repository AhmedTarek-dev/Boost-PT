// ignore_for_file: prefer_const_constructors
import 'dart:developer';
import 'package:boost_pt_new/Components/Components.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'dart:async';
import 'package:boost_pt_new/FirebaseAuth/firestore_services.dart';
import 'package:google_fonts/google_fonts.dart';

class ExercisesScreen extends StatefulWidget {
  const ExercisesScreen({Key? key}) : super(key: key);
  static const String id = 'ExercisesScreen';
  @override
  _ExercisesScreenState createState() => _ExercisesScreenState();
}

class _ExercisesScreenState extends State<ExercisesScreen> {
  List<Exercises> _exerciseList = [];
  List<Exercises> _finalList = [];
  final List<Exercises> _exerciseListAbs = [];
  final List<Exercises> _exerciseListArms = [];
  final List<Exercises> _exerciseListChest = [];
  final List<Exercises> _exerciseListBack = [];
  final List<Exercises> _exerciseListLegs = [];

  String? _id;
  int activeIndex = 0;
  int activeCard = 0;
  List labels = ["Abs", "Arms", "Back", "Chest", "Legs"];
  List activeCards = [];

  getInfo() async {
    _id = await FireStoreServices().getTraineeID();
    log(_id.toString());
    setNewExerciseList();
  }

  Future<void> setNewExerciseList() async {
    _exerciseList = await FireStoreServices().getExercises(_id!);
    log("all exercises = " + _exerciseList.length.toString());

    fillArrays(0);
    setState(() {});
  }

  fillArrays(int activeIndex) async {
    for (int i = 0; i < _exerciseList.length; i++) {
      if (_exerciseList[i].day == getSwiperHeader(activeIndex)) {
        if (_exerciseList[i].Type == "Abs") {
          log("check1");
          _exerciseListAbs.add(_exerciseList[i]);
        } else if (_exerciseList[i].Type == "Arms") {
          log("check2");
          _exerciseListArms.add(_exerciseList[i]);
        } else if (_exerciseList[i].Type == "Back") {
          log("check3");
          _exerciseListBack.add(_exerciseList[i]);
        } else if (_exerciseList[i].Type == "Chest") {
          log("check4");
          _exerciseListChest.add(_exerciseList[i]);
        } else if (_exerciseList[i].Type == "Legs") {
          log("check5");
          _exerciseListLegs.add(_exerciseList[i]);
        }
      }
    }
    if (_exerciseListAbs.isNotEmpty) {
      log("number of Abs in that day:  " + _exerciseListAbs.length.toString());
      activeCards.add(labels.elementAt(0));
    }
    if (_exerciseListArms.isNotEmpty) {
      log("number of Arms in that day: " + _exerciseListArms.length.toString());
      activeCards.add(labels.elementAt(1));
    }
    if (_exerciseListBack.isNotEmpty) {
      log("number of Back in that day: " + _exerciseListBack.length.toString());
      activeCards.add(labels.elementAt(2));
    }
    if (_exerciseListChest.isNotEmpty) {
      log("number of chest in that day: " +
          _exerciseListChest.length.toString());
      activeCards.add(labels.elementAt(3));
    }
    if (_exerciseListLegs.isNotEmpty) {
      log("number of legs in that day: " + _exerciseListLegs.length.toString());
      activeCards.add(labels.elementAt(4));
    }

    if (activeCards.isNotEmpty) {
      assignFinalList(activeCards.elementAt(0));
    }
  }

  assignFinalList(String exercise) {
    setState(() {
      if (exercise == "Abs") {
        _finalList = _exerciseListAbs;
      } else if (exercise == "Arms") {
        _finalList = _exerciseListArms;
      } else if (exercise == "Chest") {
        _finalList = _exerciseListChest;
      } else if (exercise == "Back") {
        _finalList = _exerciseListBack;
      } else if (exercise == "Legs") {
        _finalList = _exerciseListLegs;
      }
    });
  }

  String getSwiperHeader(int index) {
    if (index == 0) {
      return "Saturday";
    } else if (index == 1) {
      return "Sunday";
    } else if (index == 2) {
      return "Monday";
    } else if (index == 3) {
      return "Tuesday";
    } else if (index == 4) {
      return "Wednesday";
    } else if (index == 5) {
      return "Thursday";
    } else {
      return "Friday";
    }
  }

  bool isActive(int index) {
    if (index == activeCard) {
      return true;
    } else {
      return false;
    }
  }

  @override
  void initState() {
    super.initState();
    getInfo();
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
              'Exercises Plan',
              style: GoogleFonts.play(
                fontSize: 35,
                //fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),
        body: SizedBox(
          height: size.height * 0.90,
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
                Column(
                  children: [
                    SizedBox(
                      height: 100,
                      child: Swiper(
                        curve: Curves.easeIn,
                        viewportFraction: 0.5,
                        scale: 0.6,
                        autoplay: false,
                        itemWidth: size.width - 2 * 64,
                        pagination: SwiperPagination(
                          builder: DotSwiperPaginationBuilder(
                            size: 10,
                            activeSize: 10,
                            space: 5,
                            activeColor: Color(0xFF9B0000),
                            color: Colors.white,
                          ),
                        ),
                        indicatorLayout: PageIndicatorLayout.SCALE,
                        itemCount: 7,
                        layout: SwiperLayout.DEFAULT,
                        onIndexChanged: (index) {
                          setState(() {
                            activeIndex = index;
                            activeCard = 0;
                            activeCards.clear();
                            _finalList.clear();
                            _exerciseListArms.clear();
                            _exerciseListBack.clear();
                            _exerciseListChest.clear();
                            _exerciseListAbs.clear();
                            _exerciseListLegs.clear();
                            fillArrays(activeIndex);
                            if (activeCards.isNotEmpty) {
                              assignFinalList(activeCards.elementAt(0));
                            }
                          });
                          log(activeIndex.toString());
                        },
                        itemBuilder: (context, index) {
                          return Card(
                            color: Color(0xFF060d55),
                            // color: Colors.blue.shade700,
                            elevation: 8,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30)),

                            child: Center(
                              child: Text(
                                getSwiperHeader(index),
                                style: TextStyle(
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ), //Image(image: AssetImage("assets/Picture2.png")),
                            ),
                          );
                        },
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    SizedBox(
                      height: size.height * 0.15,
                      width: size.width * 0.99,
                      child: Column(
                        children: [
                          Text(
                            "Exercises",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(
                            height: size.height * 0.09,
                            child: ListView.builder(
                              itemCount: activeCards.length,
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (context, index) {
                                final label = activeCards[index];
                                return SizedBox(
                                  width: size.width * 0.3,
                                  child: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        activeCard = index;
                                      });

                                      assignFinalList(label);
                                    },
                                    child: Card(
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                      ),
                                      elevation: 5,
                                      color: isActive(index) == true
                                          ? Colors.red.shade500
                                          : Colors.red.shade900,
                                      child: Center(
                                        child: Text(
                                          label,
                                          style: TextStyle(
                                            fontSize: 18,
                                            color: Color(0xFFFFFFFF),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    _exerciseList.isEmpty
                        ? Padding(
                            padding: const EdgeInsets.only(top: 150),
                            child: Center(
                              child: Text(
                                "No Assigned Exercises",
                                style: TextStyle(
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          )
                        : SizedBox(
                            height: size.height * 0.442,
                            width: size.width * 0.99,
                            child: getExpandable(size),
                          ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget getExpandable(Size size) {
    return CustomScrollView(
      slivers: <Widget>[
        SliverList(
          delegate: SliverChildBuilderDelegate((context, index) {
            final _ex = _finalList[index];

            return ExpandableNotifier(
              child: Padding(
                padding: EdgeInsets.all(15),
                child: Card(
                  clipBehavior: Clip.antiAlias,
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(30),
                          topRight: Radius.circular(30))),
                  //shadowColor: Colors.black,
                  elevation: 25.0,
                  child: Column(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(30),
                            topRight: Radius.circular(30)),
                        child: _ex.Image != null
                            ? CachedNetworkImage(
                                width: size.width * 0.92,
                                height: size.height * 0.25,
                                imageUrl: _ex.Image.toString(),
                                fit: BoxFit.fitWidth,
                                placeholder: (context, url) => Center(
                                    child: CircularProgressIndicator(
                                  strokeWidth: 3,
                                )),
                                errorWidget: (context, url, error) =>
                                    Icon(Icons.error),
                              )
                            : CircularProgressIndicator(),
                      ),
                      ScrollOnExpand(
                        child: ExpandablePanel(
                          theme: ExpandableThemeData(
                            tapBodyToCollapse: true,
                            tapBodyToExpand: true,
                          ),
                          collapsed: Text(
                            "Sets: " +
                                _ex.sets.toString() +
                                "       Reps: " +
                                _ex.reps.toString(),
                            style: TextStyle(
                                fontSize: 18,
                                color: Color(0xFF060d55),
                                fontWeight: FontWeight.bold),
                            softWrap: true,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          header: Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: Text(
                              _ex.Name.toString().toUpperCase(),
                              style: TextStyle(
                                fontSize: 25,
                                color: Color(0xFF060d55),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          expanded: Text(
                            _ex.Description.toString(),
                            style: TextStyle(
                              fontSize: 18,
                              color: Color(0xFF060d55),
                            ),
                          ),
                          builder: (_, collapsed, expanded) {
                            return Padding(
                              padding: EdgeInsets.all(10).copyWith(top: 0),
                              child: Expandable(
                                collapsed: collapsed,
                                expanded: expanded,
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }, childCount: _finalList.length),
        )
      ],
    );
  }
}

// StreamBuilder(
// stream: FirebaseFirestore.instance.collection("Trainee").snapshots(),
// builder: (context , AsyncSnapshot<QuerySnapshot> snapshot){
// return GridView.builder(
// shrinkWrap: true,
// physics: ScrollPhysics(),
// primary: true,
// gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
// crossAxisCount: 2,crossAxisSpacing: 6,mainAxisSpacing: 3,
// ),
// itemCount: snapshot.data!.docs.length,
// itemBuilder: (context,i){
// QueryDocumentSnapshot x = snapshot.data!.docs[i];
// if(snapshot.hasData){
// return Card(
// child: Image.network(x['Abs']),
// );
// }
// return Center(child: CircularProgressIndicator(),);
// },
// );
// }
// ),

// ClipRRect(
// borderRadius: BorderRadius.circular(10),
// child: _abs.Image != null?
// CachedNetworkImage(
// width: size.width*0.5,
// height: size.height*0.25,
// imageUrl: _abs.Image.toString(),
// fit: BoxFit.cover,
// placeholder: (context, url)=> CircularProgressIndicator(),
// errorWidget: (context, url, error) => Icon(Icons.error),
// ):
// Container(width: 25,height: 25,)
// ),
