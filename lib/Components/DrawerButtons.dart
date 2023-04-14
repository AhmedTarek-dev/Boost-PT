//ignore_for_file:prefer_const_constructors
import 'dart:developer';
import 'package:boost_pt_new/Components/Components.dart';
import 'package:boost_pt_new/FirebaseAuth/auth.dart';
import 'package:boost_pt_new/FirebaseAuth/firestore_services.dart';
import 'package:boost_pt_new/Screens/WelcomeScreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class DrawerButtonsScreen extends StatefulWidget {
  final DrawerButtons currentItem;
  final ValueChanged<DrawerButtons> onSelectedItem;
  const DrawerButtonsScreen({
    Key? key,
    required this.currentItem,
    required this.onSelectedItem,
  }) : super(key: key);

  @override
  _DrawerButtonsScreenState createState() => _DrawerButtonsScreenState();
}

class _DrawerButtonsScreenState extends State<DrawerButtonsScreen> {
  String? _id;
  bool isTrainer = false;
  getInfo() async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    if (!await FireStoreDatabase().checkUser(_auth.currentUser!.email)) {
      _id = await FireStoreServices().getTraineeID();

      setState(() {
        isTrainer = false;
      });
    } else {
      setState(() {
        isTrainer = true;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    setState(() {});
    getInfo();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Theme(
      data: ThemeData.dark(),
      child: Scaffold(
          backgroundColor: Color(0xFF060d55),
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 0),
              child: SingleChildScrollView(
                child: SizedBox(
                  width: size.width * 0.5,
                  height: size.height * 0.95,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Spacer(),
                      if (isTrainer)
                        ...MenuItems.allTrainer.map(buildMenuItem).toList()
                      else
                        ...MenuItems.allTrainee.map(buildMenuItem).toList(),
                      Spacer(
                        flex: 1,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 20, bottom: 50),
                        child: OutlinedButton.icon(
                          style: OutlinedButton.styleFrom(
                            // maximumSize: Size.zero,
                            side: BorderSide(width: 1.0, color: Colors.white),
                            elevation: 20,
                            backgroundColor: Colors.indigo,
                            minimumSize:
                                Size(size.width * 0.35, size.height * 0.05),
                            shadowColor: Colors.black,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(55),
                            ),
                          ),
                          onPressed: () async {
                            await FireStoreDatabase().Logout();

                            //this part is for changing the status of the trainee
                            // from online to offline and vice versa
                            // we are not updating the trainer status, because
                            // we do not need to do this
                            if (!isTrainer) {
                              await FirebaseFirestore.instance
                                  .collection("Trainee")
                                  .doc(_id)
                                  .update({"Status": "Offline"}).then((value) {
                                log("status updated");
                              });
                              log("check here");
                            }

                            Navigator.pushReplacementNamed(
                                context, WelcomeScreen.id);
                          },
                          label: Text(
                            "Logout",
                            style: TextStyle(color: Colors.white),
                          ),
                          icon: Icon(
                            Icons.lock_outline,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          )),
    );
  }

  Widget buildMenuItem(DrawerButtons item) {
    final DrawerButtons currentItem = widget.currentItem;
    final ValueChanged<DrawerButtons> onSelectedItem = widget.onSelectedItem;

    return ListTileTheme(
      selectedColor: Colors.white,
      child: ListTile(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        selected: currentItem == item,
        minLeadingWidth: 20,
        selectedTileColor: Colors.black26,
        leading: Icon(item.icon),
        title: Text(item.title.toString()),
        onTap: () => onSelectedItem(item),
      ),
    );
  }
}

class MenuItems {
  static const home = DrawerButtons("Home", Icons.home);
  static const profile = DrawerButtons("Profile", Icons.person);
  static const notification =
      DrawerButtons("Notification", Icons.notifications_active_outlined);

  static const message = DrawerButtons("Message", Icons.message_outlined);
  // static const settings = DrawerButtons("Settings", Icons.settings);
  static const privacy = DrawerButtons("Privacy", Icons.privacy_tip_outlined);
  static const feedBack = DrawerButtons("FeedBack", Icons.feedback_outlined);
  static const contactUs =
      DrawerButtons("Contact us", Icons.contact_mail_outlined);

  static List<DrawerButtons> allTrainee = <DrawerButtons>[
    home,
    profile,
    notification,
    message,
    privacy,
    feedBack,
    contactUs,
  ];
  static List<DrawerButtons> allTrainer = <DrawerButtons>[
    home,
    profile,
    notification,
    privacy,
    feedBack,
    contactUs,
  ];
}
