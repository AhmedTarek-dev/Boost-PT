// ignore_for_file: prefer_const_constructors
import 'dart:developer';
import 'package:boost_pt_new/Components/Components.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:boost_pt_new/FirebaseAuth/firestore_services.dart';
import 'package:google_fonts/google_fonts.dart';

class SupplementsScreen extends StatefulWidget {
  const SupplementsScreen({Key? key}) : super(key: key);
  static const String id = 'SupplementsScreen';
  @override
  _SupplementsScreenState createState() => _SupplementsScreenState();
}

class _SupplementsScreenState extends State<SupplementsScreen> {
  List<Supplements> _supplementList = [];
  List<Supplements> _finalList = [];
  final List<Supplements> _supplementListProtein = [];
  final List<Supplements> _supplementListMassGainer = [];
  String? _id;
  int activeIndex = 0;
  int activeCard = 0;
  List labels = ["Protein", "MassGainer"];
  List activeCards = [];

  //for zooming on supplements images
  final transController = TransformationController();
  TapDownDetails? doubleTapDetails;

  handleDoubleTapDown(TapDownDetails details) {
    doubleTapDetails = details;
  }

  handleDoubleTap() {
    if (transController.value != Matrix4.identity()) {
      transController.value = Matrix4.identity();
    } else {
      final position = doubleTapDetails!.localPosition;
      transController.value = Matrix4.identity()
        ..translate(-position.dx, -position.dy)
        ..scale(1.5);
    }
  }

  getInfo() async {
    _id = await FireStoreServices().getTraineeID();
    log(_id.toString());
    setNewSupplementList();
  }

  Future<void> setNewSupplementList() async {
    _supplementList = await FireStoreServices().getSupplements(_id!);
    log("all supplements = " + _supplementList.length.toString());
    fillArrays(0);
    setState(() {});
  }

  fillArrays(int activeIndex) async {
    for (int i = 0; i < _supplementList.length; i++) {
      if (_supplementList[i].day == getSwiperHeader(activeIndex)) {
        if (_supplementList[i].Type == "Protein") {
          log("check1");
          _supplementListProtein.add(_supplementList[i]);
        } else if (_supplementList[i].Type == "MassGainer") {
          log("check2");
          _supplementListMassGainer.add(_supplementList[i]);
        }
      }
    }
    if (_supplementListProtein.isNotEmpty) {
      log("number of protein supplements in that day:  " +
          _supplementListProtein.length.toString());
      activeCards.add(labels.elementAt(0));
    }
    if (_supplementListMassGainer.isNotEmpty) {
      log("number of Massgainer supplements in that day: " +
          _supplementListMassGainer.length.toString());
      activeCards.add(labels.elementAt(1));
    }

    if (activeCards.isNotEmpty) {
      assignFinalList(activeCards.elementAt(0));
    }
  }

  assignFinalList(String supplement) {
    setState(() {
      if (supplement == "Protein") {
        _finalList = _supplementListProtein;
      } else if (supplement == "MassGainer") {
        _finalList = _supplementListMassGainer;
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
            padding: EdgeInsets.only(left: size.width * 0.03),
            child: Text(
              'Supplement Plan',
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
                            _supplementListProtein.clear();
                            _supplementListMassGainer.clear();
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
                            elevation: 8,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20)),
                            child: Center(
                              child: Text(
                                getSwiperHeader(index),
                                style: TextStyle(
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ), //Image(image: AssetImage("assets/Picture2.png")),
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
                            "Supplement",
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
                    _supplementList.isEmpty
                        ? Padding(
                            padding: const EdgeInsets.only(top: 150),
                            child: Center(
                              child: Text(
                                "No Assigned Supplements",
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
                            child: getExapandable(size),
                          )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget getExapandable(Size size) {
    return CustomScrollView(
      slivers: <Widget>[
        SliverList(
          delegate: SliverChildBuilderDelegate((context, index) {
            final _supple = _finalList[index];

            return ExpandableNotifier(
              child: Padding(
                padding: EdgeInsets.all(10),
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
                        child: _supple.Image != null
                            ? GestureDetector(
                                child: InteractiveViewer(
                                  transformationController: transController,
                                  child: AspectRatio(
                                    aspectRatio: 1.5,
                                    child: CachedNetworkImage(
                                      width: size.width * 0.95,
                                      height: size.height * 0.25,
                                      imageUrl: _supple.Image.toString(),
                                      fit: BoxFit.fitHeight,
                                      placeholder: (context, url) => Center(
                                          child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                      )),
                                      errorWidget: (context, url, error) =>
                                          Icon(Icons.error),
                                    ),
                                  ),
                                ),
                                onDoubleTapDown: handleDoubleTapDown,
                                onDoubleTap: handleDoubleTap,
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
                            "Dose: " + _supple.Dose.toString(),
                            style: TextStyle(
                              fontSize: 18,
                              color: Color(0xFF060d55),
                            ),
                            softWrap: true,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          header: Padding(
                            padding: const EdgeInsets.only(left: 10.0),
                            child: Text(
                              _supple.Name.toString().toUpperCase(),
                              style: TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF060d55),
                              ),
                            ),
                          ),
                          expanded: Text(
                            _supple.Description.toString(),
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
