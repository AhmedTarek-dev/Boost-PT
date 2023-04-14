// ignore_for_file: prefer_const_constructors
import 'dart:developer';
import 'dart:io';
import 'package:boost_pt_new/Screens/TrainerScreens/TrainerDrawerScreen.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import '../../../FirebaseAuth/firestore_services.dart';

class AddExercise extends StatefulWidget {
  const AddExercise({Key? key}) : super(key: key);
  @override
  State<AddExercise> createState() => _AddExerciseState();
}

class _AddExerciseState extends State<AddExercise> {
  //for uploading image
  final ImagePicker _picker = ImagePicker();
  File? image;
  XFile? _selectedImage;
  final FirebaseStorage _storageRef = FirebaseStorage.instance;
  int uploadItem = 0;
  bool _isUploading = false;

  //displayed image URL in the screen
  String? imageURL;

  //type of exercises to be added to in firebase
  String? typeOfExercise;
  final items = ["Back", "Arms", "Legs", "Chest", "Abs"];

  //controllers
  final TextEditingController _exerciseNameController = TextEditingController();
  final TextEditingController _instructionsController = TextEditingController();
  // final TextEditingController _repsController = TextEditingController();
  // final TextEditingController _setsController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (_selectedImage != null) log(_selectedImage!.name.toString());
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
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
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: SingleChildScrollView(
        child: _isUploading
            ? showLoading()
            : Container(
                alignment: Alignment.center,
                child: Column(
                  children: [
                    SizedBox(
                      height: 50.0,
                    ),
                    Text(
                      'Add Exercises',
                      style: TextStyle(
                        fontSize: 30.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      height: size.height * 0.03,
                    ),
                    ClipOval(
                      child: SizedBox(
                        height: size.height *
                            0.16, //height and width of trainer's image
                        width: size.width * 0.35,
                        child: image != null
                            ? Image.file(
                                image!,
                                fit: BoxFit.fill,
                                errorBuilder: (context, url, error) => Icon(
                                  Icons.warning_outlined,
                                  color: Colors.red,
                                  size: 35,
                                ),
                              )
                            : GestureDetector(
                                onTap: () {
                                  selectImage();
                                },
                                child: Container(
                                  child: Icon(
                                    Icons.upload_rounded,
                                    size: 35,
                                  ),
                                  color: Colors.grey.shade300,
                                ),
                              ),
                      ),
                    ),
                    SizedBox(
                      height: size.height * 0.02,
                    ),
                    SizedBox(
                      width: 210.0,
                      child: ElevatedButton(
                        onPressed: () {
                          selectImage();
                          log("upload GIF button clicked");
                        },
                        style: ElevatedButton.styleFrom(
                          elevation: 10,
                          primary: Color.fromRGBO(0, 0, 70, 9000),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                        ),
                        child: Text(
                          'Upload GIF',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20.0,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    Text(
                      'Exercise description.',
                      style: TextStyle(
                        color: Color.fromRGBO(0, 0, 70, 9000),
                        fontSize: 25.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    SizedBox(
                      width: size.width * 0.83,
                      child: TextFormField(
                        controller: _exerciseNameController,
                        decoration: InputDecoration(
                          hintText: 'Exercise name',
                          border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(15.0)),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    Container(
                      width: size.width * 0.83,
                      padding: EdgeInsets.only(left: 10, right: 5),
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey, width: 1),
                          borderRadius: BorderRadius.circular(15)),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          hint: Text("Type Of Exercise"),
                          dropdownColor: Colors.white,
                          value: typeOfExercise,
                          isExpanded: true,
                          icon: Icon(Icons.arrow_drop_down),
                          elevation: 16,
                          iconSize: 36,
                          // style: TextStyle(color: Colors.black),
                          onChanged: (String? newValue) {
                            setState(() {
                              typeOfExercise = newValue!;
                              log(typeOfExercise.toString());
                            });
                          },
                          items: items
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(
                                value,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 20),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                    // Padding(
                    //   padding: EdgeInsets.only(
                    //       left: size.width * 0.1, top: size.height * 0.02),
                    //   child: Row(
                    //     children: [
                    //       SizedBox(
                    //         width: size.width * 0.36,
                    //         child: TextFormField(
                    //           controller: _repsController,
                    //           keyboardType: TextInputType.number,
                    //           maxLines: 1,
                    //           decoration: InputDecoration(
                    //             hintText: 'Number of Reps',
                    //             border: OutlineInputBorder(
                    //               borderRadius:
                    //                   BorderRadius.all(Radius.circular(15.0)),
                    //             ),
                    //           ),
                    //         ),
                    //       ),
                    //       SizedBox(
                    //         width: 15,
                    //       ),
                    //       SizedBox(
                    //         width: size.width * 0.36,
                    //         child: TextFormField(
                    //           controller: _setsController,
                    //           keyboardType: TextInputType.number,
                    //           maxLines: 1,
                    //           decoration: InputDecoration(
                    //             hintText: 'Number of Sets',
                    //             border: OutlineInputBorder(
                    //               borderRadius:
                    //                   BorderRadius.all(Radius.circular(15.0)),
                    //             ),
                    //           ),
                    //         ),
                    //       ),
                    //     ],
                    //   ),
                    // ),
                    SizedBox(
                      height: 20.0,
                    ),
                    SizedBox(
                      width: size.width * 0.83,
                      child: TextFormField(
                        controller: _instructionsController,
                        maxLines: 2,
                        decoration: InputDecoration(
                          hintText: 'instructions',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(15.0),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    SizedBox(
                      width: 200.0,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () async {
                          if (_exerciseNameController.text.isNotEmpty &&
                              _instructionsController.text.isNotEmpty &&
                              // _repsController.text.isNotEmpty &&
                              // _repsController.text.toString().trim() != '0' &&
                              // _setsController.text.isNotEmpty &&
                              // _setsController.text.toString().trim() != "0" &&
                              image != null &&
                              typeOfExercise != null) {
                            await uploadFunction(_selectedImage!);
                            await FireStoreServices().addExercises(
                              typeOfExercise!,
                              _exerciseNameController.text.toString(),
                              imageURL.toString(),
                              _instructionsController.text.toString(),
                              // _repsController.text.toString(),
                              // _setsController.text.toString()
                            );
                            Fluttertoast.showToast(
                                msg: "Done adding the Exercise", fontSize: 15);
                            _exerciseNameController.clear();
                            _instructionsController.clear();
                            typeOfExercise = " ";
                            Navigator.of(context).pop();
                          } else {
                            Fluttertoast.showToast(
                                msg: "Please fill all the fields",
                                fontSize: 15);
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          elevation: 10,
                          primary: Color.fromRGBO(0, 0, 70, 9000),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                        ),
                        child: Text(
                          'Add exercise',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20.0,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    )
                  ],
                ),
              ),
      ),
    );
  }

  Widget showLoading() {
    return SafeArea(
      child: Center(
        child: Column(
          children: [
            Text("Uploading : " + uploadItem.toString() + " / 1"),
            SizedBox(
              height: 30,
            ),
            CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }

  Future<void> uploadFunction(XFile _image) async {
    //this function is for sending images to be uploaded one by one
    setState(() {
      _isUploading = true;
    });

    String? imageurl = await uploadFile(_image);

    setState(() {
      imageURL = imageurl;
    });
  }

  Future<String?> uploadFile(XFile _image) async {
    String? imageTest;
    Reference reference =
        _storageRef.ref().child(typeOfExercise.toString()).child(_image.name);
    UploadTask uploadTask = reference.putFile(File(_image.path));
    await uploadTask.whenComplete(() {
      setState(() {
        uploadItem++;
        if (uploadItem == 1) {
          _isUploading = false;
          uploadItem = 0;
        }
      });
    });
    imageTest = await reference.getDownloadURL(); //returns the URL OF THE IMAGE

    log(imageTest.toString());
    return imageTest;
  }

  Future<void> selectImage() async {
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        setState(() {
          _selectedImage = image;
          log(_selectedImage!.length().toString());
          final imageTemp = File(image.path);
          this.image = imageTemp;
        });
      } else {
        Fluttertoast.showToast(
          msg: "Please select a GIF Image",
          fontSize: 15,
        );
        return;
      }
      setState(() {});
      log("Image has been selected");
    } catch (e) {
      log('$e' " here in add exercises file");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Please Select a GIF Image."),
        ),
      );
    }
  }
}
