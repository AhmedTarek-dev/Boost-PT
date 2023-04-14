// ignore_for_file: prefer_const_constructors
import 'dart:developer';
import 'dart:io';
import 'package:boost_pt_new/FirebaseAuth/firestore_services.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UploadTestScreen extends StatefulWidget {
  const UploadTestScreen({Key? key}) : super(key: key);
  static const String id = 'NutritionScreen';
  @override
  _UploadTestScreenState createState() => _UploadTestScreenState();
}

class _UploadTestScreenState extends State<UploadTestScreen> {
  final ImagePicker _picker = ImagePicker();
  final List<XFile> _selectedFiles = [];
  final FirebaseStorage _storageRef = FirebaseStorage.instance;
  final List<String> _arrImageUrls = [];
  int uploadItem = 0;
  bool _isUploading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: _isUploading
            ? showLoading()
            : Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    OutlinedButton(
                        onPressed: () {
                          selectImage();
                        },
                        child: Text("Select files")),
                    ElevatedButton.icon(
                      onPressed: () {
                        if (_selectedFiles.isNotEmpty) {
                          uploadFunction(_selectedFiles);
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text("Please Select Images."),
                            ),
                          );
                        }
                      },
                      icon: Icon(Icons.file_upload),
                      label: Text("upload"),
                    ),
                    _selectedFiles.isEmpty
                        ? Text("no images selected ")
                        : Expanded(
                            child: GridView.builder(
                                itemCount: _selectedFiles.length,
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 3,
                                ),
                                itemBuilder: (context, index) {
                                  return Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Image.file(
                                      File(_selectedFiles[index].path),
                                      fit: BoxFit.cover,
                                    ),
                                  );
                                }),
                          )
                  ],
                ),
              ),
      ),
    );
  }

  Widget showLoading() {
    return Center(
      child: Column(
        children: [
          Text("Uploading : " +
              uploadItem.toString() +
              "/" +
              _selectedFiles.length.toString()),
          SizedBox(
            height: 30,
          ),
          CircularProgressIndicator(),
        ],
      ),
    );
  }

  Future<void> uploadFunction(List<XFile> _images) async {
    //this function is for sending images to be uploaded one by one
    setState(() {
      _isUploading = true;
    });
    for (int i = 0; i < _images.length; i++) {
      String? imageUrl = await uploadFile(_images[i]);
      _arrImageUrls.add(imageUrl.toString());
    }
    _selectedFiles.clear();
    // await FireStoreServices().addPathToDatabase(_arrImageUrls);
    _arrImageUrls.clear();
  }

  Future<String?> uploadFile(XFile _image) async {
    String? imageTest;
    Reference reference =
        _storageRef.ref().child("Supplements").child(_image.name);
    UploadTask uploadTask = reference.putFile(File(_image.path));
    await uploadTask.whenComplete(() {
      setState(() {
        uploadItem++;
        if (uploadItem == _selectedFiles.length) {
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
      if (_selectedFiles != null) {
        _selectedFiles.clear();
      }
      final List<XFile>? imgs = await _picker.pickMultiImage();
      if (imgs!.isNotEmpty) {
        _selectedFiles.addAll(imgs);
      }
      setState(() {});
      log("List of selected images: " + imgs.length.toString());
    } catch (e) {
      log('$e');
    }
  }
}
