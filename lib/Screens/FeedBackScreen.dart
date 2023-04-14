//ignore_for_file: prefer_const_constructors
import 'package:boost_pt_new/FirebaseAuth/firestore_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class FeedBackScreen extends StatefulWidget {
  const FeedBackScreen({Key? key}) : super(key: key);
  static const String id = 'FeedBackScreen';
  @override
  _FeedBackScreenState createState() => _FeedBackScreenState();
}

class _FeedBackScreenState extends State<FeedBackScreen> {
  double activeRating = 0;

  final TextEditingController _feedBackController = TextEditingController();
  var maxLength = 150;
  var textLength = 0;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
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
          appBar: AppBar(
            backgroundColor: Color(0xFF050B48),
            leading: GestureDetector(
              onTap: () {
                ZoomDrawer.of(context)!.toggle();
              },
              child: Icon(
                Icons.menu,
                size: 45,
              ),
            ),
            title: Center(
              child: Text(
                "FeedBack",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 25,
                ),
              ),
            ),
          ),
          body: Stack(
            children: [
              Positioned(
                top: 45,
                left: 15,
                child: Text(
                  "Rating:",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 35,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
              Positioned(
                top: size.height * 0.15,
                left: 55,
                child: RatingBar.builder(
                  glowRadius: 1,
                  initialRating: activeRating,
                  minRating: 0,
                  direction: Axis.horizontal,
                  itemBuilder: (context, index) => Icon(
                    Icons.star,
                    color: Colors.amber,
                  ),
                  unratedColor: Color(0xFF9B0000),
                  itemCount: 5,
                  itemSize: 45.0,
                  allowHalfRating: true,
                  itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                  onRatingUpdate: (newRating) {
                    setState(() {
                      activeRating = newRating;
                    });
                  },
                ),
              ),
              Positioned(
                top: size.height * 0.32,
                left: 15,
                child: Text(
                  "Your FeedBack:",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 35,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
              Positioned(
                top: size.height * 0.4,
                left: 20,
                child: SizedBox(
                  height: size.height * 0.2,
                  width: size.width * 0.9,
                  child: TextFormField(
                    onChanged: (value) {
                      setState(() {
                        textLength = value.length;
                      });
                    },
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    showCursor: true,
                    controller: _feedBackController,
                    maxLines: 8,
                    maxLength: maxLength,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      suffixText:
                          '${textLength.toString()}/${maxLength.toString()}',
                      counterText: "",
                      labelText: "Enter Your FeedBack",
                      hintText: "Provide us with your FeedBack",
                      focusColor: Colors.green,
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide(
                          color: Colors.blue,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide(
                          color: Colors.grey,
                        ),
                      ),
                      hintStyle: TextStyle(
                        color: Colors.black,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(40),
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                top: size.height * 0.75,
                left: 50,
                child: SizedBox(
                  height: 50,
                  width: 300,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      // maximumSize: Size.zero,
                      // side: BorderSide(width: 1.0, color: Colors.white),
                      elevation: 10,
                      primary: Color(0xFF050B48),
                      minimumSize: Size(size.width * 0.35, size.height * 0.05),
                      shadowColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    onPressed: () async {
                      await FireStoreServices().addFeedBack(
                          activeRating.toString(), _feedBackController.text);

                      _feedBackController.clear();
                      setState(() {
                        textLength = 0;
                        activeRating = 0;
                      });
                      alertFlutter("Thank you for your FeedBack");
                    },
                    child: Text(
                      "Submit FeedBack",
                      style: TextStyle(color: Colors.white, fontSize: 30),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void alertFlutter(String title) {
    var style = AlertStyle(
      animationType: AnimationType.fromBottom,
      isCloseButton: false,
      isOverlayTapDismiss: false,
      descStyle: TextStyle(fontWeight: FontWeight.bold),
      animationDuration: Duration(milliseconds: 400),
      alertBorder: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(25.0),
        side: BorderSide(
          color: Colors.grey,
        ),
      ),
      titleStyle: TextStyle(
        color: Colors.green,
      ),
    );
    Alert(
      context: context,
      style: style,
      type: AlertType.success,
      title: title,
      buttons: [
        DialogButton(
          child: Text(
            "Confirm",
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
            ),
          ),
          onPressed: () => Navigator.pop(context),
          color: Color.fromRGBO(0, 179, 134, 1.0),
          radius: BorderRadius.circular(20.0),
        ),
      ],
    ).show();
  }
}
