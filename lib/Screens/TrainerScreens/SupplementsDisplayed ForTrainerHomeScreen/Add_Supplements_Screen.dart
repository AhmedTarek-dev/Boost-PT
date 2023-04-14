// ignore_for_file: prefer_const_constructors

import 'dart:developer';
import 'dart:io';

import 'package:boost_pt_new/Screens/TrainerScreens/TrainerDrawerScreen.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';

import '../../../FirebaseAuth/firestore_services.dart';

class AddSupplement extends StatefulWidget {
  const AddSupplement({Key? key}) : super(key: key);

  @override
  State<AddSupplement> createState() => _AddSupplementState();
}

class _AddSupplementState extends State<AddSupplement> {
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
  final items = ["Protein", "MassGainer"];

  //controllers
  final TextEditingController _supplementNameController =
      TextEditingController();
  final TextEditingController _instructionsController = TextEditingController();
  final TextEditingController _doseController = TextEditingController();

  @override
  void initState() {
    super.initState();
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
                      'Add Supplement',
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
                          'Upload Image',
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
                      'Supplement description.',
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
                        controller: _supplementNameController,
                        decoration: InputDecoration(
                          hintText: 'Supplement name',
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
                          hint: Text("Type Of Supplement"),
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
                    SizedBox(
                      height: 15,
                    ),
                    SizedBox(
                      width: size.width * 0.83,
                      child: TextFormField(
                        controller: _doseController,
                        keyboardType: TextInputType.number,
                        maxLines: 1,
                        decoration: InputDecoration(
                          hintText: 'Dose/s per day',
                          border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(15.0)),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 15.0,
                    ),
                    SizedBox(
                      width: size.width * 0.83,
                      child: TextFormField(
                        controller: _instructionsController,
                        maxLines: 2,
                        decoration: InputDecoration(
                          hintText: 'instructions',
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
                    SizedBox(
                      width: 200.0,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () async {
                          if (_supplementNameController.text.isNotEmpty &&
                              _instructionsController.text.isNotEmpty &&
                              _doseController.text.isNotEmpty &&
                              _doseController.text.toString().trim() != '0' &&
                              _instructionsController.text.isNotEmpty &&
                              image != null &&
                              typeOfExercise != null) {
                            await uploadFunction(_selectedImage!);
                            await FireStoreServices().addSupplements(
                                typeOfExercise!,
                                _supplementNameController.text.toString(),
                                imageURL.toString(),
                                _instructionsController.text.toString(),
                                _doseController.text.toString());
                            Fluttertoast.showToast(
                                msg: "Done adding the Exercise", fontSize: 15);
                            _supplementNameController.clear();
                            _instructionsController.clear();
                            _doseController.clear();
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
                          'Add Supplement',
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
        _storageRef.ref().child("Supplements").child(_image.name);
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
