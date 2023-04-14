// ignore_for_file: prefer_const_constructors
import 'package:boost_pt_new/FirebaseAuth/firestore_services.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../Components/Components.dart';

class ViewTrainerScreen extends StatefulWidget {
  final Trainer? trainer;
  const ViewTrainerScreen({this.trainer, Key? key}) : super(key: key);
  static const String id = 'ViewTrainerScreen';
  @override
  _ViewTrainerScreenState createState() => _ViewTrainerScreenState();
}

class _ViewTrainerScreenState extends State<ViewTrainerScreen> {
  Trainer? _trainer;
  Trainee? _trainee;

  Future<void> getTraineeInfo() async {
    _trainee = await FireStoreServices().getTraineeInformation();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _trainer = widget.trainer;
    getTraineeInfo();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        shadowColor: Colors.transparent,
        leading: BackButton(
          color: Colors.black,
        ),
        backgroundColor: Colors.transparent,
        elevation: 5,
      ),
      body: ListView(
        physics: BouncingScrollPhysics(),
        children: [
          Center(
            child: Stack(
              children: [
                buildImage(),
                // Positioned(
                //   bottom: 0,
                //   right: 4,
                //   child: ClipOval(
                //     child: Container(
                //       padding: EdgeInsets.all(8.0),
                //       color: Colors.blue[500],
                //       child: Icon(
                //         Icons.edit,
                //         color: Colors.white,
                //         size: 20,
                //       ),
                //     ),
                //   ),
                // ),
              ],
            ),
          ),
          SizedBox(
            height: 24,
          ),
          Column(
            children: [
              Text(
                _trainer!.Name.toString().toUpperCase(),
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                ),
              ),
              SizedBox(
                height: 5,
              ),
              Text(
                _trainer!.Email.toString(),
                style: TextStyle(
                  color: Colors.grey,
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                ),
              ),
              SizedBox(
                height: 24,
              ),
            ],
          ),
          Center(
            child: ElevatedButton(
              onPressed: () async {
                if (_trainee!.AssignedTrainer == "NoTrainer") {
                  // log(_trainer!.ID.toString());
                  bool isDone = await FireStoreServices()
                      .addNotificationToTrainer(
                          _trainer!.ID.toString(), _trainee!);
                  if (isDone) {
                    Fluttertoast.showToast(
                      msg: "Request Sent to trainer",
                      fontSize: 15,
                    );
                  } else {
                    Fluttertoast.showToast(
                      msg: "Something wrong happened",
                      fontSize: 15,
                    );
                  }
                } else {
                  Fluttertoast.showToast(
                    msg: "You are assigned to a trainer",
                    fontSize: 15,
                  );
                }
              },
              child: Text(
                "Apply To Trainer",
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
              style: ElevatedButton.styleFrom(
                elevation: 5,
                shadowColor: Colors.grey,
                shape: StadiumBorder(),
                onPrimary: Colors.white,
                padding: EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 12,
                ),
              ),
            ),
          ),
          SizedBox(
            height: size.height * 0.05,
          ),
          IntrinsicHeight(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        _trainer!.NoOfRatings
                            .toString(), //call number of ratings from firebase
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 30,
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        "No. of Ratings", //call number of ratings from firebase
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 50,
                  child: VerticalDivider(),
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      _trainer!.Rating
                          .toString(), //call number of ratings from firebase
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 30,
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    RatingBarIndicator(
                      rating: double.parse(_trainer!.Rating.toString()),
                      itemBuilder: (context, index) => Icon(
                        Icons.star,
                        color: Colors.amber,
                      ),
                      itemCount: 5,
                      itemSize: 25.0,
                    ),
                  ],
                )
              ],
            ),
          ),
          SizedBox(
            height: 48,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 38),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "About: ",
                  style: TextStyle(
                    fontSize: 27,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: 16,
                ),
                Text(
                  _trainer!.Bio.toString(),
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    height: 1.7,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildImage() {
    final image = NetworkImage(_trainer!.Image.toString());

    return ClipOval(
      child: Material(
        color: Colors.transparent,
        child: ClipRRect(
            borderRadius: BorderRadius.circular(35),
            child: CachedNetworkImage(
              width: 150,
              height: 150,
              imageUrl: _trainer!.Image.toString(),
              fit: BoxFit.fill,
              placeholder: (context, url) => Center(
                  child: CircularProgressIndicator(
                strokeWidth: 2,
              )),
              errorWidget: (context, url, error) => Icon(Icons.error),
            )),
      ),
    );
  }
}
