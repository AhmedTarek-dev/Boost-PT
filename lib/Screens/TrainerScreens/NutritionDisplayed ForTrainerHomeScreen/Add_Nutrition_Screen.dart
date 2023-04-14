// ignore_for_file: prefer_const_constructors
import 'dart:developer';
import 'dart:io';
import 'package:boost_pt_new/Screens/TrainerScreens/TrainerDrawerScreen.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import '../../../FirebaseAuth/firestore_services.dart';

class AddNutrition extends StatefulWidget {
  const AddNutrition({Key? key}) : super(key: key);

  @override
  State<AddNutrition> createState() => _AddNutritionState();
}

class _AddNutritionState extends State<AddNutrition> {
  //for uploading image
  final ImagePicker _picker = ImagePicker();
  File? image;
  XFile? _selectedImage;
  final FirebaseStorage _storageRef = FirebaseStorage.instance;
  int uploadItem = 0;
  bool _isUploading = false;

  //displayed image URL in the screen
  String? imageURL;

  //type of nutrition to be added to in firebase
  String? typeOfNutrition;
  final items = ["Protein", "Carbohydrates", "Fats"];
  String? measureOfCalories;
  final measures = ["Table spoon", "Slice", "100 grams", "500 grams", "1"];

  //controllers
  final TextEditingController _nutritionNameController =
      TextEditingController();
  final TextEditingController _instructionsController = TextEditingController();
  final TextEditingController _caloriesController = TextEditingController();

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
                      'Add Nutrition',
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
                      width: size.width * 0.5,
                      child: ElevatedButton(
                        onPressed: () {
                          selectImage();
                          log("upload Image button clicked");
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
                      'Nutrition description.',
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
                        controller: _nutritionNameController,
                        decoration: InputDecoration(
                          hintText: 'Nutrition name',
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
                          hint: Text("Type Of Nutrition"),
                          dropdownColor: Colors.white,
                          value: typeOfNutrition,
                          isExpanded: true,
                          icon: Icon(Icons.arrow_drop_down),
                          elevation: 16,
                          iconSize: 36,
                          // style: TextStyle(color: Colors.black),
                          onChanged: (String? newValue) {
                            setState(() {
                              typeOfNutrition = newValue!;
                              log(typeOfNutrition.toString());
                            });
                          },
                          items: items
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(
                                value,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 17),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 15.0,
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: size.width * 0.08),
                      child: Row(
                        children: [
                          SizedBox(
                            width: size.width * 0.38,
                            child: TextFormField(
                              controller: _caloriesController,
                              keyboardType: TextInputType.number,
                              maxLines: 1,
                              decoration: InputDecoration(
                                hintText: 'Calories(Approx.)',
                                border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(15.0)),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: size.width * 0.02,
                          ),
                          Text(
                            "Per",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 15),
                          ),
                          SizedBox(
                            width: size.width * 0.02,
                          ),
                          Container(
                            width: size.width * 0.35,
                            padding: EdgeInsets.only(left: 15, right: 5),
                            decoration: BoxDecoration(
                                border:
                                    Border.all(color: Colors.grey, width: 1),
                                borderRadius: BorderRadius.circular(15)),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                hint: Text("Measure"),
                                dropdownColor: Colors.white,
                                value: measureOfCalories,
                                isExpanded: true,
                                icon: Icon(Icons.arrow_drop_down),
                                elevation: 16,
                                iconSize: 36,
                                // style: TextStyle(color: Colors.black),
                                onChanged: (String? newValue) {
                                  setState(() {
                                    measureOfCalories = newValue!;
                                    log(measureOfCalories.toString());
                                  });
                                },
                                items: measures.map<DropdownMenuItem<String>>(
                                    (String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(
                                      value,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16),
                                    ),
                                  );
                                }).toList(),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 15,
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
                          if (_nutritionNameController.text.isNotEmpty &&
                              _instructionsController.text.isNotEmpty &&
                              image != null &&
                              typeOfNutrition != null &&
                              measureOfCalories != null) {
                            await uploadFunction(_selectedImage!);
                            await FireStoreServices().addNutrition(
                                typeOfNutrition!,
                                _nutritionNameController.text.toString(),
                                imageURL.toString(),
                                _instructionsController.text.toString(),
                                _caloriesController.text.toString(),
                                measureOfCalories!);
                            Fluttertoast.showToast(
                              msg: "Done adding the Nutrition",
                              fontSize: 15,
                            );
                            _nutritionNameController.clear();
                            _instructionsController.clear();
                            typeOfNutrition = " ";
                            measureOfCalories = " ";
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
                          'Add Nutrition',
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
        _storageRef.ref().child(typeOfNutrition.toString()).child(_image.name);
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
          final imageTemp = File(image.path);
          this.image = imageTemp;
        });
      } else {
        Fluttertoast.showToast(
          msg: "Please select an Image",
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
          content: Text("Please Select an Image."),
        ),
      );
    }
  }
}
