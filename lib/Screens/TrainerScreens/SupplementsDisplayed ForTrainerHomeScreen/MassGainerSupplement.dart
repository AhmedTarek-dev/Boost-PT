// ignore_for_file: prefer_const_constructors

import 'dart:developer';

import 'package:boost_pt_new/Screens/TrainerScreens/TrainerDrawerScreen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';

import '../../../Components/Components.dart';
import '../../../FirebaseAuth/firestore_services.dart';

class MassGainerSupplementScreen extends StatefulWidget {
  const MassGainerSupplementScreen({Key? key}) : super(key: key);
  static const String id = "MassGainerSupplementScreen";
  @override
  State<MassGainerSupplementScreen> createState() =>
      _MassGainerSupplementScreenState();
}

class _MassGainerSupplementScreenState
    extends State<MassGainerSupplementScreen> {
  List<Supplements> _supplementList = [];

  Future getInfo() async {
    _supplementList = await FireStoreServices()
        .getSupplementsForTrainerHomeScreen("MassGainer");
    log(_supplementList.length.toString());
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    getInfo();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
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
          leading: Padding(
            padding: const EdgeInsets.only(left: 10, top: 10),
            child: IconButton(
              icon: Icon(
                Icons.arrow_back,
                color: Colors.black,
                size: 35,
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ),
        ),
        body: SizedBox(
          width: size.width * 0.99,
          height: size.height * 0.87,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Text(
                  "Mass Gainer",
                  style: TextStyle(
                    fontSize: 45,
                    color: Color(0xFF050B48),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                _supplementList.isEmpty
                    ? Padding(
                        padding: EdgeInsets.only(top: size.height * 0.3),
                        child: Center(
                          child: Text(
                            "No added Supplements",
                            style: TextStyle(
                                fontSize: 25, fontWeight: FontWeight.bold),
                          ),
                        ),
                      )
                    : SizedBox(
                        height: size.height * 0.99,
                        child: CustomScrollView(
                          slivers: <Widget>[
                            SliverList(
                              delegate:
                                  SliverChildBuilderDelegate((context, index) {
                                final _supp = _supplementList[index];

                                return ExpandableNotifier(
                                  child: Padding(
                                    padding: EdgeInsets.all(10),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.transparent,
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.grey.withOpacity(0.5),
                                            spreadRadius: 6,
                                            blurRadius: 10,
                                            offset: Offset(0, 3), // changes position of shadow
                                          ),
                                        ],
                                      ),
                                      child: Card(
                                        clipBehavior: Clip.antiAlias,
                                        color: Colors.white,
                                        shadowColor: Colors.black,
                                        shape:  RoundedRectangleBorder(
                                            borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(30),
                                                topRight: Radius.circular(30))),
                                        elevation: 25.0,
                                        child: Column(
                                          children: [
                                            ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                              child: _supp.Image != null
                                                  ? CachedNetworkImage(
                                                      width: size.width * 0.92,
                                                      height: size.height * 0.25,
                                                      filterQuality:
                                                          FilterQuality.high,
                                                      imageUrl:
                                                          _supp.Image.toString(),
                                                      fit: BoxFit.fitHeight,
                                                      placeholder:
                                                          (context, url) =>
                                                              Center(
                                                        child:
                                                            CircularProgressIndicator(
                                                          strokeWidth: 3,
                                                        ),
                                                      ),
                                                      errorWidget:
                                                          (context, url, error) =>
                                                              Icon(
                                                        Icons.error,
                                                        size: 35,
                                                      ),
                                                    )
                                                  : CircularProgressIndicator(),
                                            ),
                                            ScrollOnExpand(
                                              child: ExpandablePanel(
                                                theme: ExpandableThemeData(
                                                  tapBodyToCollapse: true,
                                                  tapBodyToExpand: true,
                                                  tapHeaderToExpand: true,
                                                ),
                                                collapsed: Text(
                                                  "Dose: " +
                                                      _supp.Dose.toString(),
                                                  style: TextStyle(
                                                      color: Color(0xFF050B48),
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                  softWrap: true,
                                                  maxLines: 1,
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                                header: Padding(
                                                  padding: const EdgeInsets.only(
                                                      left: 5),
                                                  child: Text(
                                                    _supp.Name.toString()
                                                        .toUpperCase(),
                                                    style: TextStyle(
                                                      color: Color(0xFF050B48),
                                                      fontSize: 25,
                                                      fontWeight: FontWeight.bold,
                                                    ),
                                                  ),
                                                ),
                                                expanded: Text(
                                                  _supp.Description.toString(),
                                                  style: TextStyle(fontSize: 18,
                                                    color: Color(0xFF050B48),),
                                                ),
                                                builder:
                                                    (_, collapsed, expanded) {
                                                  return Padding(
                                                    padding: EdgeInsets.all(10)
                                                        .copyWith(top: 0),
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
                                  ),
                                );
                              }, childCount: _supplementList.length),
                            )
                          ],
                        ),
                      )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
