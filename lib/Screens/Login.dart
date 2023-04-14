// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables
import 'dart:developer';
import 'package:boost_pt_new/Screens/TraineeScreens/TraineeDrawerScreen.dart';
import 'package:boost_pt_new/Screens/chooseSignUp.dart';
import 'package:boost_pt_new/Screens/verifyEmailOTP.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../FirebaseAuth/Validation.dart';
import '../FirebaseAuth/auth.dart';
import 'TrainerScreens/TrainerDrawerScreen.dart';
import 'WelcomeScreen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);
  static const String id = 'LoginScreen';

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();

  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  bool _isShow = false;

  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: WillPopScope(
        onWillPop: () async {
          Navigator.pushReplacementNamed(context, WelcomeScreen.id);
          return true;
        },
        child: Scaffold(
          backgroundColor: Colors.white,
          body: SafeArea(
            child: SingleChildScrollView(
              child: Center(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 30),
                      child: Image(
                        alignment: Alignment.topCenter,
                        image: AssetImage("assets/LgoForground.png"),
                        width: size.width * 0.5,
                        height: size.height * 0.2,
                      ),
                    ),
                    SizedBox(
                      height: 40,
                    ),
                    Text(
                      "Welcome back",
                      style: TextStyle(
                        fontSize: 45,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "Login to your account",
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      height: 60,
                    ),

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.grey[200],
                            border: Border.all(
                              color: Colors.white,
                            ),
                            borderRadius: BorderRadius.circular(15)),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 15.0),
                          child: TextFormField(
                            controller: _email,
                            decoration: InputDecoration(
                              prefixIcon: Icon(Icons.email_outlined),
                              labelText: "Email",
                              hintStyle: TextStyle(
                                color: Colors.black,
                              ),
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.grey[200],
                            border: Border.all(
                              color: Colors.white,
                            ),
                            borderRadius: BorderRadius.circular(15)),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 15.0),
                          child: TextFormField(
                            controller: _password,
                            obscureText: !_isShow,
                            decoration: InputDecoration(
                              prefixIcon: Icon(Icons.lock),
                              labelText: "Password",
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _isShow
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                  size: 25,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _isShow = !_isShow;
                                  });
                                },
                              ),
                              hintStyle: TextStyle(
                                color: Colors.black,
                              ),
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                      ),
                    ),
                    // GestureDetector(
                    //   onTap: () async {
                    //     if (_email.text.isNotEmpty &&
                    //         _password.text.isNotEmpty) {
                    //       try {
                    //         final _user = await FireStoreDatabase()
                    //             .Login(_email.text.trim(), _password.text);
                    //
                    //         if (_user != null) {
                    //           final FirebaseAuth _auth =
                    //               FirebaseAuth.instance;
                    //           log("login success");
                    //           if (await FireStoreDatabase()
                    //               .checkUser(_auth.currentUser!.email)) {
                    //             Navigator.pushReplacementNamed(
                    //                 context, TrainerDrawerScreen.id);
                    //           } else {
                    //             Navigator.pushReplacementNamed(
                    //                 context, TraineeDrawerScreen.id);
                    //           }
                    //         } else {
                    //           _ackAlert(context, "Wrong Email or Password");
                    //         }
                    //       } catch (e) {
                    //         log('$e');
                    //       }
                    //     } else {
                    //       log("please enter fields correctly");
                    //     }
                    //   },
                    //   child: Container(
                    //     height: size.height * 0.07,
                    //     width: double.infinity,
                    //     decoration: BoxDecoration(
                    //         borderRadius: BorderRadius.circular(10),
                    //         color: Color(0xFF9B0000)),
                    //     alignment: Alignment.center,
                    //     child: Text(
                    //       'Login',
                    //       style: TextStyle(
                    //         color: Colors.white,
                    //         fontSize: 18,
                    //         fontWeight: FontWeight.bold,
                    //       ),
                    //     ),
                    //   ),
                    // ),
                    SizedBox(
                      height: 20,
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          primary: Color(0xFF9B0000),
                          minimumSize:
                              Size(size.width * 0.9, size.height * 0.05),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.0)),
                          elevation: 10),
                      child: _isLoading
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CircularProgressIndicator(
                                  strokeWidth: 3,
                                  color: Colors.white,
                                ),
                                SizedBox(
                                  width: 40,
                                ),
                                Text("Please wait ...")
                              ],
                            )
                          : Text(
                              "Login",
                              style: TextStyle(fontSize: 22),
                            ),
                      onPressed: () async {
                        if (_isLoading) {
                          return;
                        }
                        setState(() {
                          _isLoading = true;
                        });
                        if (_email.text.isNotEmpty &&
                            _password.text.isNotEmpty) {
                          try {
                            final _user = await FireStoreDatabase()
                                .login(_email.text.trim(), _password.text);

                            if (_user != null) {
                              final FirebaseAuth _auth = FirebaseAuth.instance;
                              bool isEmailVerified =
                                  _auth.currentUser!.emailVerified;
                              if (isEmailVerified) {
                                log("login success and verified");
                                if (await FireStoreDatabase()
                                    .checkUser(_auth.currentUser!.email)) {
                                  Navigator.pushReplacementNamed(
                                      context, TrainerDrawerScreen.id);
                                } else {
                                  Navigator.pushReplacementNamed(
                                      context, TraineeDrawerScreen.id);
                                }
                              } else {
                                log("not verified");
                                Navigator.pushNamed(context, VerifyEmailOTP.id);
                              }
                            } else {
                              _ackAlert(context, "Wrong Email or Password");
                            }
                          } catch (e) {
                            log('$e');
                          }
                        } else {
                          log("please enter fields correctly");
                        }
                        setState(() {
                          _isLoading = false;
                        });
                      },
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    GestureDetector(
                      onTap: () =>
                          Navigator.pushNamed(context, ChooseSignUp.id),
                      child: Text(
                        'Don\'t have an account?',
                        style: TextStyle(
                            color: Colors.black87,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    GestureDetector(
                      onTap: () async {
                        await changePasswordDialog();
                      },
                      child: Text(
                        "Forgot Password?",
                        style: TextStyle(
                            color: Colors.black87,
                            fontSize: 16,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future _ackAlert(BuildContext context, String isError) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Failed to login'),
          content: Text(isError),
          actions: [
            ElevatedButton(
              child: Text('Ok'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<String?> changePasswordDialog() {
    //for changing the email address of the user by otp code
    // final size = MediaQuery.of(context).size;
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
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    validator: (email) =>
                        (!Validator().validateEmail(email.toString()))
                            ? 'Enter correct Email address'
                            : null,
                    decoration: InputDecoration(
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
                  SizedBox(
                    height: 15,
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () async {
                  bool done = false;
                  log(_emailController.text);
                  try {
                    await FirebaseAuth.instance
                        .sendPasswordResetEmail(
                            email: _emailController.text.toString().trim())
                        .then((value) {
                      setState(() {
                        done = true;
                      });
                    }).catchError((onError) {
                      setState(() {
                        done = false;
                      });
                    });
                  } on FirebaseAuthException catch (e) {
                    Fluttertoast.showToast(
                      msg: e.message.toString(),
                      fontSize: 15,
                    );
                  }
                  if (done) {
                    _emailController.clear();
                    Fluttertoast.showToast(
                      msg: "Password reset link sent!!",
                      fontSize: 15,
                    );
                    Navigator.of(context).pop();
                  } else {
                    Fluttertoast.showToast(
                      msg: "Something happened while changing password",
                      fontSize: 15,
                    );
                    Navigator.of(context).pop();
                  }
                },
                child: Text("Send Link"),
              )
            ],
          );
        },
      ),
    );
  }
}
