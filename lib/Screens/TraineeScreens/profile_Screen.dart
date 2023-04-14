// ignore_for_file: prefer_const_constructors
import 'dart:developer';
import 'dart:io';
import 'package:boost_pt_new/Components/Components.dart';
import 'package:boost_pt_new/FirebaseAuth/firestore_services.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:image_picker/image_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../FirebaseAuth/Validation.dart';
import '../../FirebaseAuth/auth.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:email_auth/email_auth.dart';

class ProfileScreen extends StatefulWidget {
  final Trainee? trainee;
  const ProfileScreen({this.trainee, Key? key}) : super(key: key);
  static const String id = 'TraineeProfileScreen';
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  //this screen is for trainee to view his/her personal data

  //this part for uploading images
  final ImagePicker _picker = ImagePicker();
  final List<XFile> _selectedFiles = [];
  final FirebaseStorage _storageRef = FirebaseStorage.instance;
  final List<String> _arrImageUrls = [];
  int uploadItem = 0;
  bool _isUploading = false;

  final TextEditingController _changeNameController = TextEditingController();

  //this part for changing the current user's email
  final TextEditingController _oldPasswordForEmailController =
      TextEditingController();

  final TextEditingController _email = TextEditingController();
  final TextEditingController _oTP = TextEditingController();
  bool _isOTPVerified = false;

  //this part for changing and authenticating user's phone number
  final TextEditingController _phoneNumber = TextEditingController();
  final TextEditingController _phoneNumberOTP = TextEditingController();
  String? _countryCode = "+20";
  bool _isPhoneNumberOTPVerified = false;
  String? _verificationID;

  //this part for changing current user's password
  final TextEditingController _oldPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmNewPasswordController =
      TextEditingController();

  //this is the object data of the trainee
  Trainee? traineeInfo;

  void setData(verificationID) {
    //takes the verificationID from the verifyPhoneNumber method in auth file
    setState(() {
      _verificationID = verificationID;
    });
  }

  void setDoneBoolean(bool isDone) {
    setState(() {
      _isPhoneNumberOTPVerified = isDone;
    });
  }

  EmailAuth emailAuth = EmailAuth(sessionName: "BoostPt.");
  void sendOTP() async {
    bool _isEmailTaken = await FireStoreDatabase().checkEmail(_email.text);

    if (!_isEmailTaken) {
      var response = await emailAuth.sendOtp(recipientMail: _email.text);

      if (response) {
        log("OTP sent");
      } else {
        log("we couldn't send the OTP");
      }
    } else {
      Fluttertoast.showToast(
        msg: "Email is already taken, try another one",
        fontSize: 18,
      );
    }
  }

  void verifyOTP() async {
    var response = false;
    if (_email.text.isNotEmpty) {
      setState(() {
        response = emailAuth.validateOtp(
            recipientMail: _email.text, userOtp: _oTP.text);
      });
      log(response.toString());
    }
    if (response) {
      log("OTP verified");
    } else {
      log("Invalid OTP");
    }
    setState(() {
      _isOTPVerified = response;
    });
  }

  getUserInfo() async {
    traineeInfo = await FireStoreServices().getTraineeInformation();
    setState(() {});
  }

  bool? switchValue = false;
  SharedPreferences? pref;
  initializeTheSharedPreferenceInstance() async {
    pref = await SharedPreferences.getInstance();
    setState(() {
      switchValue = pref?.getBool("switchValue");
    });

    log("value of the switch button: " '${pref?.getBool("switchValue")}');
    // log(switchValue.toString());
  }

  @override
  void initState() {
    super.initState();
    log("is verified : " +
        FirebaseAuth.instance.currentUser!.emailVerified.toString());
    traineeInfo = widget.trainee;
    getUserInfo();
    initializeTheSharedPreferenceInstance();
    setState(() {});
  }

  @override
  void dispose() {
    _changeNameController.dispose();
    _oldPasswordForEmailController.dispose();
    super.dispose();
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
      child: WillPopScope(
        onWillPop: () async {
          ZoomDrawer.of(context)!.toggle();
          return false;
        },
        child: Scaffold(
          body: RefreshIndicator(
            color: Colors.blue,
            backgroundColor: Colors.white,
            onRefresh: () async {
              await getUserInfo();
              setState(() {});
            },
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(
                parent: AlwaysScrollableScrollPhysics(),
              ),
              child: _isUploading
                  ? showLoading()
                  : Column(
                      children: [
                        Stack(
                          clipBehavior: Clip.none,
                          children: [
                            Container(
                              height: size.height * 0.3,
                              width: size.width * 0.999,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                  bottomRight: Radius.circular(50),
                                  bottomLeft: Radius.circular(50),
                                ),
                                boxShadow: [
                                  BoxShadow(
                                      color: Colors.grey.withOpacity(0.3),
                                      offset: Offset(-10.0, 10.0),
                                      blurRadius: 20.0,
                                      spreadRadius: 10.0),
                                ],
                                color: Color(0xFF060d55),
                              ),
                              child: Stack(
                                children: [
                                  Positioned(
                                    top: 40,
                                    left: 10,
                                    child: GestureDetector(
                                      onTap: () =>
                                          ZoomDrawer.of(context)!.toggle(),
                                      child: Icon(
                                        Icons.menu,
                                        color: Colors.white,
                                        size: 45,
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    top: 100,
                                    left: 0,
                                    right: 0,
                                    child: Center(
                                      child: Text(
                                        "Name:  " +
                                            traineeInfo!.Name
                                                .toString()
                                                .toUpperCase(),
                                        style: TextStyle(
                                          fontWeight: FontWeight.w300,
                                          fontSize: 25,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    top: 150,
                                    left: 0,
                                    right: 0,
                                    child: Center(
                                      child: Text(
                                        "Trainer:  " +
                                            traineeInfo!.AssignedTrainer
                                                .toString()
                                                .toUpperCase(),
                                        style: TextStyle(
                                          fontWeight: FontWeight.w400,
                                          fontSize: 25,
                                          color: Colors.white,
                                          fontStyle: FontStyle.italic,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Positioned(
                              top: 190,
                              left: 0,
                              right: 0,
                              child: Center(
                                child: Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(66),
                                      boxShadow: const [
                                        BoxShadow(
                                            color: Colors.transparent,
                                            spreadRadius: 3)
                                      ]),
                                  child: ClipOval(
                                    child: Material(
                                      color: Colors.black,
                                      child: Container(
                                        height: size.height *
                                            0.15, //height and width of trainer's image
                                        width: size.width * 0.32,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(60.0),
                                        ),
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(35),
                                          child: traineeInfo!.Image != null
                                              ? GestureDetector(
                                                  child: CachedNetworkImage(
                                                    width: size.width * 0.82,
                                                    height: size.height * 0.25,
                                                    imageUrl: traineeInfo!.Image
                                                        .toString(),
                                                    // "https://images.unsplash.com/photo-1585533530535-2f4236949d08?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8M3x8ZHVja3xlbnwwfHwwfHw%3D&w=1000&q=80",
                                                    //_ex.Image.toString(),
                                                    fit: BoxFit.fill,
                                                    placeholder: (context,
                                                            url) =>
                                                        CircularProgressIndicator(),
                                                    errorWidget:
                                                        (context, url, error) =>
                                                            Icon(
                                                      Icons.warning_outlined,
                                                      color: Colors.red,
                                                      size: 35,
                                                    ),
                                                  ),
                                                  onTap: () {
                                                    log("image pressed");
                                                  },
                                                )
                                              : CircularProgressIndicator(),
                                        ),
                                      ),
                                      // Ink.image(
                                      //   image: NetworkImage(traineeInfo!.Image
                                      //               .toString() ==
                                      //           null
                                      //       ? traineeInfo!.Image.toString()
                                      //       : "https://www.google.com/url?sa=i&url=https%3A%2F%2Fwww.redbubble.com%2Fi%2Fart-board-print%2FQuack-I-m-A-Duck-Funny-Water-Ducklings-by-Bendthetrend%2F40278131.NVL2T&psig=AOvVaw0KxS6r6f5UMYPgqlUpSGNM&ust=1647366445456000&source=images&cd=vfe&ved=0CAsQjRxqFwoTCIjiiLKUxvYCFQAAAAAdAAAAABAD"),
                                      //   fit: BoxFit.fill,
                                      //   width: 128,
                                      //   height: 125,
                                      //   child: InkWell(
                                      //     //to provide animation when pressed on the image
                                      //     onTap: () {
                                      //       log("image clicked");
                                      //     },
                                      //   ),
                                      // ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding:
                              const EdgeInsets.only(top: 30, right: 5, left: 5),
                          child: SizedBox(
                            width: size.width * 0.99,
                            height: size.height * 0.48,
                            // color: Colors.indigo,
                            child: Padding(
                              padding: const EdgeInsets.only(top: 0),
                              child: Stack(
                                children: [
                                  Positioned(
                                    bottom: 350,
                                    right: 135,
                                    child: ClipOval(
                                      child: Container(
                                        padding: EdgeInsets.all(7.0),
                                        color: Colors.blue[500],
                                        child: GestureDetector(
                                          onTap: () {
                                            selectImage();
                                            log("edit image button clicked");
                                          }, //we'll use to change personal profile image
                                          child: Icon(
                                            Icons.edit,
                                            color: Colors.white,
                                            size: 20,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    top: 60,
                                    left: 10,
                                    child: SizedBox(
                                      width: size.width * 0.9,
                                      height: size.height * 0.08,
                                      child: Text(
                                        "Personal Info:",
                                        style: TextStyle(
                                          fontSize: 30,
                                          color: Color(0xFF060d55),
                                          fontWeight: FontWeight.bold,

                                        ),
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    top: 100,
                                    left: 10,
                                    child: Container(
                                      width: size.width * 0.9,
                                      height: size.height * 0.08,
                                      color: Colors.transparent,
                                      child: ListTile(
                                        trailing: GestureDetector(
                                            onTap: () async {
                                              final name =
                                                  await changeNameDialog();
                                              _changeNameController.clear();
                                              if (name == null ||
                                                  name.isEmpty) {
                                                return;
                                              }

                                              setState(() {
                                                traineeInfo!.Name = name;
                                                Fluttertoast.showToast(
                                                  msg:
                                                      "Name Changed Successfully",
                                                  fontSize: 20,
                                                );
                                              });
                                            },
                                            child: SizedBox(
                                              width: 40,
                                              height: 40,
                                              child: Icon(
                                                Icons.edit,
                                                size: 28,
                                                color: Colors.black45,
                                              ),
                                            )),
                                        title: Text(
                                          "Name ",
                                          style: TextStyle(
                                              fontSize: 15,
                                              color: Color(0xFF060d55)),
                                        ),
                                        subtitle: Text(
                                          traineeInfo!.Name.toString(),
                                          style: TextStyle(
                                              fontSize: 20,
                                              color: Color(0xFF060d55)),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    top: 180,
                                    left: 10,
                                    child: Container(
                                      width: size.width * 0.9,
                                      height: size.height * 0.08,
                                      color: Colors.transparent,
                                      child: ListTile(
                                        // trailing: GestureDetector(
                                        //   onTap: () async {
                                        //     final password =
                                        //         await provideOldPasswordDialog();
                                        //     _oldPasswordForEmailController
                                        //         .clear();
                                        //     if (password != null &&
                                        //         password.isNotEmpty) {
                                        //       setState(() {
                                        //         _isOTPVerified = false;
                                        //       });
                                        //       final email =
                                        //           await changeEmailDialog(
                                        //               password);
                                        //       if (email == null ||
                                        //           email.isEmpty) {
                                        //         return;
                                        //       }
                                        //       setState(() {
                                        //         traineeInfo!.Email = email;
                                        //         Fluttertoast.showToast(
                                        //             msg:
                                        //                 "Email Changed Successfully!",
                                        //             fontSize: 15);
                                        //       });
                                        //     } else {
                                        //       Fluttertoast.showToast(
                                        //           msg:
                                        //               "Please Enter Your Password!",
                                        //           fontSize: 15);
                                        //     }
                                        //   },
                                        //   child: SizedBox(
                                        //     height: 40,
                                        //     width: 40,
                                        //     child: Icon(
                                        //       Icons.edit,
                                        //       size: 28,
                                        //       color: Colors.black45,
                                        //     ),
                                        //   ),
                                        // ),
                                        title: Text(
                                          "Email ",
                                          style: TextStyle(
                                              fontSize: 15,
                                              color: Color(0xFF060d55)),
                                        ),
                                        subtitle: Text(
                                          traineeInfo!.Email.toString(),
                                          style: TextStyle(
                                              fontSize: 20,
                                              color: Color(0xFF060d55)),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    top: 265,
                                    left: 26,
                                    child: SizedBox(
                                      child: Text(
                                        "Enable Biometric Auth.",
                                        style: TextStyle(
                                            fontSize: 20, color: Color(0xFF060d55)),
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    top: 260,
                                    left: 275,
                                    child: FlutterSwitch(
                                      width: 70.0,
                                      height: 30.0,
                                      valueFontSize: 13.0,
                                      toggleSize: 24.0,
                                      value:
                                          switchValue == false ? false : true,
                                      borderRadius: 30.0,
                                      padding: 8.0,
                                      showOnOff: true,
                                      onToggle: (val) async {
                                        setState(() {
                                          switchValue = val;
                                          pref?.setBool("switchValue", val);
                                        });
                                        if (val == true) {
                                          Fluttertoast.showToast(
                                            msg: "BioMetric is enabled",
                                            fontSize: 15,
                                          );
                                        } else {
                                          Fluttertoast.showToast(
                                            msg: "BioMetric is disabled",
                                            fontSize: 15,
                                          );
                                        }
                                      },
                                    ),
                                  ),
                                  Positioned(
                                    top: 300,
                                    left: 30,
                                    child: IntrinsicHeight(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 5, horizontal: 15),
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: <Widget>[
                                                Text(
                                                  "Age", //call number of ratings from firebase
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: Color(0xFF060d55),
                                                    fontSize: 20,
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 5,
                                                ),
                                                Text(
                                                  traineeInfo!.Age
                                                      .toString(), //call number of ratings from firebase
                                                  style: TextStyle(
                                                    color: Color(0xFF060d55),
                                                    fontWeight:
                                                        FontWeight.normal,
                                                    fontSize: 30,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          SizedBox(
                                            width: 30,
                                            height: 50,
                                            child: VerticalDivider(
                                              color: Color(0xFF060d55),
                                              thickness: 1.5,
                                            ),
                                          ),
                                          Column(
                                            mainAxisSize: MainAxisSize.min,
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: <Widget>[
                                              Text(
                                                "Phone No.", //call number of ratings from firebase
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Color(0xFF060d55),
                                                  fontSize: 20,
                                                ),
                                              ),
                                              SizedBox(
                                                height: 5,
                                              ),
                                              Text(
                                                traineeInfo!.PhoneNo
                                                    .toString(), //call number of ratings from firebase
                                                style: TextStyle(
                                                  color: Color(0xFF060d55),
                                                  fontWeight: FontWeight.normal,
                                                  fontSize: 30,
                                                ),
                                              ),
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    top: 310,
                                    left: 125,
                                    child: Divider(
                                      height: 25,
                                      thickness: 5,
                                      color: Colors.red,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Divider(
                          height: 20,
                          thickness: 2,
                          indent: 45,
                          endIndent: 35,
                          color: Colors.black45,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                            top: 10,
                            right: 15,
                          ),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              primary: Color(0xFF060d55),
                              elevation: 10,
                              padding: EdgeInsets.all(6),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25.0),
                              ),
                            ),
                            onPressed: () async {
                              String? _newPhoneNumber =
                                  await changePhoneNumberDialog();
                              if (_newPhoneNumber != null &&
                                  _newPhoneNumber.isNotEmpty) {
                                traineeInfo!.PhoneNo = _newPhoneNumber;

                                Fluttertoast.showToast(
                                  msg: "Phone Number changed successfully!!",
                                  fontSize: 15,
                                );
                              }
                              _phoneNumber.clear();
                              _phoneNumberOTP.clear();
                            },
                            child: Text(
                              "Phone Verification",
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                            top: 10,
                            right: 15,
                          ),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              primary: Color(0xFF060d55),
                              elevation: 10,
                              padding: EdgeInsets.all(6),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25.0),
                              ),
                            ),
                            onPressed: () async {
                              await changePasswordDialog();

                              _oldPasswordController.clear();
                              _newPasswordController.clear();
                              _confirmNewPasswordController.clear();
                            },
                            child: Text(
                              "Change Your Password",
                              style: TextStyle(
                                  fontSize: 20, fontStyle: FontStyle.italic),
                            ),
                          ),
                        ),
                      ],
                    ),
            ),
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
            Text("Uploading : " +
                uploadItem.toString() +
                " / " +
                _selectedFiles.length.toString()),
            SizedBox(
              height: 30,
            ),
            CircularProgressIndicator(),
          ],
        ),
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
    setState(() {
      traineeInfo!.Image = _arrImageUrls[0];
    });
    _selectedFiles.clear();
    await FireStoreServices().addPathToDatabase(_arrImageUrls, false);
    _arrImageUrls.clear();
  }

  Future<String?> uploadFile(XFile _image) async {
    String? imageTest;
    Reference reference =
        _storageRef.ref().child("TraineesProfilePics").child(_image.name);
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
      _selectedFiles.clear();
      final List<XFile>? imgs = await _picker.pickMultiImage();
      if (imgs!.isNotEmpty) {
        _selectedFiles.addAll(imgs);

        if (_selectedFiles.isNotEmpty) {
          uploadFunction(_selectedFiles);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Please Select Images."),
            ),
          );
        }
      }
      setState(() {});
      log("List of selected images: " + imgs.length.toString());
    } catch (e) {
      log('$e');
    }
  }

  Future<String?> changeNameDialog() => showDialog<String>(
        //changing name of the current user
        context: context,
        builder: (context) => AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(32.0))),
          title: Text("Change Your Name"),
          content: TextField(
            autofocus: true,
            decoration: InputDecoration(hintText: "New Name"),
            controller: _changeNameController,
          ),
          actions: [
            TextButton(
              onPressed: () async {
                if (_changeNameController.text.isNotEmpty) {
                  await FireStoreServices()
                      .changeName(_changeNameController.text, false);
                  Navigator.of(context).pop(_changeNameController.text);
                  _changeNameController.clear();
                } else {
                  Navigator.of(context).pop();
                }
              },
              child: Text("Submit"),
            )
          ],
        ),
      );

  Future<String?> provideOldPasswordDialog() {
    //we should take the old password to change the current email address
    final size = MediaQuery.of(context).size;
    bool _isShow = false;
    return showDialog<String>(
      context: context,
      builder: (context) => StatefulBuilder(builder: (context, setState) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(32.0))),
          title: Text("Provide Your Old Password"),
          content: SizedBox(
            width: size.width * 0.9,
            height: size.height * 0.1,
            child: TextFormField(
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (password) =>
                  (!Validator().validatePassword(password.toString()))
                      ? 'Enter correct password'
                      : null,
              obscureText: !_isShow,
              showCursor: true,
              controller: _oldPasswordForEmailController,
              decoration: InputDecoration(
                suffixIcon: IconButton(
                  icon: Icon(
                    _isShow ? Icons.visibility_off : Icons.visibility,
                    size: 25,
                  ),
                  onPressed: () {
                    setState(() {
                      _isShow = !_isShow;
                    });
                  },
                ),
                hintText: "Old password",
                prefixIcon: Icon(
                  Icons.lock_rounded,
                ),
                hintStyle: TextStyle(
                  color: Colors.black,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(21),
                ),
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () async {
                if (_oldPasswordForEmailController.text.isNotEmpty) {
                  Navigator.of(context)
                      .pop(_oldPasswordForEmailController.text);
                  _oldPasswordForEmailController.clear();
                } else {
                  Navigator.of(context).pop();
                }
              },
              child: Text("Submit"),
            )
          ],
        );
      }),
    );
  }

  Future<String?> changeEmailDialog(String? password) {
    //for changing the email address of the user by otp code
    final size = MediaQuery.of(context).size;
    return showDialog<String>(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(32.0))),
            title: Text("Change Your Email"),
            content: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    width: size.width * 0.88,
                    child: TextFormField(
                      maxLines: 1,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      controller: _email,
                      keyboardType: TextInputType.emailAddress,
                      validator: (email) =>
                          (!Validator().validateEmail(email.toString()))
                              ? 'Enter correct Email address'
                              : null,
                      decoration: InputDecoration(
                        suffixIcon: TextButton(
                          onPressed: () {
                            if (Validator()
                                .validateEmail(_email.text.toString())) {
                              sendOTP();
                            } else {
                              Fluttertoast.showToast(
                                msg: "Enter correct Email address",
                                fontSize: 15,
                              );
                            }
                          },
                          child: Text("Send OTP"),
                        ),
                        prefixIcon: Icon(Icons.account_box),
                        hintText: "Enter Your Email",
                        hintStyle: TextStyle(
                          color: Colors.black,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(21),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  SizedBox(
                    width: size.width * 0.6,
                    child: TextFormField(
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      controller: _oTP,
                      validator: (otpCode) {
                        if (_oTP.text.isEmpty) {
                          return "Missing OTP Code";
                        } else if (otpCode!.length != 6) {
                          return "Wrong OTP Code";
                        } else {
                          return null;
                        }
                      },
                      onChanged: (value) {
                        verifyOTP();
                        setState(() {});
                      },
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: "OTP",
                        prefixIcon: _isOTPVerified
                            ? Icon(
                                Icons.verified_user_rounded,
                                color: Colors.green,
                              )
                            : Icon(Icons.mark_email_unread_rounded),
                        hintText: "Enter code sent to your email",
                        focusColor: Colors.green,
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(40),
                          borderSide: BorderSide(
                              color:
                                  _isOTPVerified ? Colors.green : Colors.blue),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(40),
                          borderSide: BorderSide(
                              color:
                                  _isOTPVerified ? Colors.green : Colors.grey,
                              width: 2.0),
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
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () async {
                  if (_email.text.isNotEmpty &&
                      _oTP.text.isNotEmpty &&
                      _isOTPVerified) {
                    bool done = await FireStoreServices()
                        .changeEmail(_email.text, password!, false);
                    if (done) {
                      Navigator.of(context).pop(_email.text);
                    } else {
                      Fluttertoast.showToast(
                        msg: "Wrong Password Entered!!",
                        fontSize: 20,
                      );
                      Navigator.of(context).pop();
                    }

                    _email.clear();
                    _oTP.clear();
                  }
                },
                child: Text("Submit"),
              )
            ],
          );
        },
      ),
    );
  }

  Future<String?> changePhoneNumberDialog() {
    //changing the phone number of the current user
    final size = MediaQuery.of(context).size;
    return showDialog<String>(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(45.0))),
            title: Text("Change Your PhoneNumber"),
            content: SingleChildScrollView(
              child: SizedBox(
                height: size.height * 0.22,
                child: Column(
                  children: [
                    SizedBox(
                      width: size.width * 0.99,
                      height: size.height * 0.1,
                      child: IntlPhoneField(
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        keyboardType: TextInputType.phone,
                        controller: _phoneNumber,
                        onCountryChanged: (value) {
                          setState(() {
                            _countryCode = value.code;
                          });
                        },
                        validator: (phone) {
                          if (Validator().validatePhone(phone.toString())) {
                            return null;
                          } else {
                            return "Enter right phone number";
                          }
                        },
                        decoration: InputDecoration(
                          suffixIcon: SizedBox(
                            width:
                                42, //size of the sendOTP button inside the text field
                            child: TextButton(
                              onPressed: () async {
                                if (Validator().validatePhone(
                                    _phoneNumber.text.toString())) {
                                  bool _isFound = await FireStoreDatabase()
                                      .checkPhoneNumberToVerifyPhoneNumberForTrainee(
                                          _countryCode.toString() +
                                              _phoneNumber.text,
                                          traineeInfo!.Email.toString());
                                  if (_isFound) {
                                    log("phone number " +
                                        _countryCode.toString() +
                                        _phoneNumber.text.toString());
                                    await FireStoreDatabase().verifyPhoneNumber(
                                        _countryCode.toString() +
                                            _phoneNumber.text,
                                        setData);
                                    Fluttertoast.showToast(
                                      msg: "OTP sent",
                                      fontSize: 15,
                                    );
                                  } else {
                                    Fluttertoast.showToast(
                                      msg: "Phone Number already registered",
                                      fontSize: 15,
                                    );
                                  }
                                } else {
                                  Fluttertoast.showToast(
                                    msg: "Enter correct Phone Number",
                                    fontSize: 15,
                                  );
                                }
                              },
                              child: Text(
                                "Send OTP",
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          labelText: "Phone Number",
                          focusColor: Colors.grey,
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(40),
                            borderSide: BorderSide(
                              color: Colors.blue,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(40),
                            borderSide: BorderSide(
                                color:
                                    // _isPhoneNumberOTPVerified
                                    //     ? Colors.green
                                    //     :
                                    Colors.grey,
                                width: 2.0),
                          ),
                          hintText: '(123) 123-1234',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                        ),
                        initialCountryCode: 'EG',
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    SizedBox(
                      width: size.width * 0.5,
                      height: size.height * 0.1,
                      child: TextFormField(
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        controller: _phoneNumberOTP,
                        validator: (otpCode) {
                          if (_phoneNumberOTP.text.isEmpty) {
                            return "Missing OTP Code";
                          } else if (otpCode!.length != 6) {
                            return "Wrong OTP Code";
                          } else {
                            return null;
                          }
                        },
                        onChanged: (value) async {
                          if (value.length == 6) {
                            log(value);
                            log("Verification ID: " +
                                _verificationID.toString());
                            bool isDone = await FireStoreDatabase()
                                .sentCodeToFirebase(
                                    code: value,
                                    verificationID: _verificationID,
                                    setDoneBoolean: setDoneBoolean);
                            log("isOTPDone " + isDone.toString());
                            setDoneBoolean(isDone);
                          }
                          setState(() {});
                        },
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: "OTP",
                          prefixIcon: _isPhoneNumberOTPVerified
                              ? Icon(
                                  Icons.verified_user_rounded,
                                  color: Colors.green,
                                )
                              : Icon(
                                  Icons.mark_email_unread_rounded,
                                ),
                          hintText: "Enter code sent to your Phone",
                          focusColor: Colors.green,
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(40),
                            borderSide: BorderSide(
                              color: _isPhoneNumberOTPVerified
                                  ? Colors.green
                                  : Colors.blue,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(40),
                            borderSide: BorderSide(
                                color: _isPhoneNumberOTPVerified
                                    ? Colors.green
                                    : Colors.grey,
                                width: 2.0),
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
                  ],
                ),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () async {
                  if (_phoneNumber.text.isNotEmpty &&
                      _phoneNumberOTP.text.isNotEmpty &&
                      _isPhoneNumberOTPVerified) {
                    bool done = await FireStoreServices().changePhoneNumber(
                        _countryCode.toString() + _phoneNumber.text, false);
                    if (done) {
                      Navigator.of(context)
                          .pop(_countryCode.toString() + _phoneNumber.text);
                    } else {
                      Fluttertoast.showToast(
                        msg: "Something wrong happened!!",
                        fontSize: 20,
                      );
                      Navigator.of(context).pop();
                    }
                    setState(() {
                      _isPhoneNumberOTPVerified = false;
                    });

                    _phoneNumber.clear();
                    _phoneNumberOTP.clear();
                  } else {
                    log(_isPhoneNumberOTPVerified.toString());
                    Fluttertoast.showToast(
                      msg: "Something wrong happened!!",
                      fontSize: 20,
                    );
                  }
                },
                child: Text("Submit"),
              )
            ],
          );
        },
      ),
    );
  }

  Future<String?> changePasswordDialog() {
    //for changing the email address of the user by otp code
    // final size = MediaQuery.of(context).size;
    bool _isShow = false;
    return showDialog<String>(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(32.0),
              ),
            ),
            title: Text("Change Your Password"),
            content: SingleChildScrollView(
              child: Column(
                children: [
                  TextFormField(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (password) =>
                        (!Validator().validatePassword(password.toString()))
                            ? 'Enter correct password'
                            : null,
                    obscureText: !_isShow,
                    showCursor: true,
                    controller: _oldPasswordController,
                    decoration: InputDecoration(
                      suffixIcon: IconButton(
                        icon: Icon(
                          _isShow ? Icons.visibility_off : Icons.visibility,
                          size: 25,
                        ),
                        onPressed: () {
                          setState(() {
                            _isShow = !_isShow;
                          });
                        },
                      ),
                      hintText: "Enter Old Password",
                      prefixIcon: Icon(
                        Icons.lock_rounded,
                      ),
                      hintStyle: TextStyle(
                        color: Colors.black,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(21),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () async {
                  bool passwordMatchesEmail = false;
                  if (_oldPasswordController.text.isNotEmpty) {
                    await FirebaseAuth.instance
                        .signInWithEmailAndPassword(
                            email: traineeInfo!.Email.toString(),
                            password: _oldPasswordController.text)
                        .then((value) {
                      setState(() {
                        passwordMatchesEmail = true;
                      });
                    }).catchError((error) {
                      if (error == "wrong-password") {
                        setState(() {
                          passwordMatchesEmail = false;
                        });
                      }
                    });
                    if (passwordMatchesEmail) {
                      Navigator.of(context).pop();

                      bool done = await FireStoreServices()
                          .changePassword(traineeInfo!.Email.toString());
                      if (done) {
                        Fluttertoast.showToast(
                          msg: "Password reset link sent!!",
                          fontSize: 15,
                        );
                      } else {
                        Navigator.of(context)
                            .pop(); //for popping the circularProgress indicator
                        Fluttertoast.showToast(
                          msg: "Something happened while changing password",
                          fontSize: 15,
                        );
                        Navigator.of(context).pop();
                      }
                    } else {
                      Fluttertoast.showToast(
                        msg: "Wrong Password Entered!!",
                        fontSize: 15,
                      );
                    }
                  }
                },
                child: Text("Submit"),
              )
            ],
          );
        },
      ),
    );
  }
}
