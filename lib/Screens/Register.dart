// ignore_for_file: prefer_const_constructors, non_constant_identifier_names
import 'dart:developer';
import 'package:boost_pt_new/FirebaseAuth/Validation.dart';
import 'package:boost_pt_new/FirebaseAuth/auth.dart';
import 'package:boost_pt_new/FirebaseAuth/firestore_services.dart';
import 'package:boost_pt_new/Screens/verifyEmailOTP.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
// import 'package:email_auth/email_auth.dart';
import 'package:boost_pt_new/Screens/Login.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import '../FirebaseAuth/Validation.dart';
import '../FirebaseAuth/auth.dart';

enum ButtonState { init, loading, done }

class RegisterScreen extends StatefulWidget {
  static const String id = 'RegisterScreen';
  final int? signUpMethod;
  const RegisterScreen(this.signUpMethod, {Key? key}) : super(key: key);
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _email = TextEditingController();
  final TextEditingController _OTP = TextEditingController();

  final TextEditingController _password = TextEditingController();
  final TextEditingController _confirmPassword = TextEditingController();
  final TextEditingController _name = TextEditingController();

  final TextEditingController _BioController = TextEditingController();
  var maxLength = 150;
  var textLength = 0;

  final TextEditingController _phoneNumber = TextEditingController();
  String? _countryCode = "+20";
  final bool _isDoneInOTP = false;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  // EmailAuth emailAuth = EmailAuth(sessionName: "BoostPt.");
  // bool _isOTPVerified = false;

  DateTime date = DateTime.now(); //for date of birth
  int _age = 0;

  int _valueOfRadioButtons = 0;

  bool _dateChosen = false;

  int? _signUpMethod;

  //for animation of register button
  ButtonState state = ButtonState.init;
  bool isAnimating = true;

  // bool _isOTPPHoneNumberVerified = false;

  int calculateAge(DateTime birthDate) {
    DateTime currentDate = DateTime.now();
    int age = currentDate.year - birthDate.year;
    int month1 = currentDate.month;
    int month2 = birthDate.month;
    if (month2 > month1) {
      age--;
    } else if (month1 == month2) {
      int day1 = currentDate.day;
      int day2 = birthDate.day;
      if (day2 > day1) {
        age--;
      }
    }
    return age;
  }

  //password fields
  bool _isShow = false;

  // void sendOTP() async {
  //   bool _isEmailTaken = await FireStoreDatabase().checkEmail(_email.text);
  //
  //   if (!_isEmailTaken) {
  //     // var response = await emailAuth.sendOtp(recipientMail: _email.text);
  //
  //     if (response) {
  //       log("OTP sent");
  //     } else {
  //       log("we couldn't send the OTP");
  //     }
  //   } else {
  //     alertFlutter("Email is already taken, try another one");
  //   }
  // }

  // void verifyOTP() async {
  //   var response = false;
  //   if (_email.text.isNotEmpty) {
  //     setState(() {
  //       // response = emailAuth.validateOtp(
  //       //     recipientMail: _email.text, userOtp: _OTP.text);
  //     });
  //     log(response.toString());
  //   }
  //   if (response) {
  //     log("OTP verified");
  //   } else {
  //     log("Invalid OTP");
  //   }
  //   setState(() {
  //     _isOTPVerified = response;
  //   });
  // }

  @override
  void initState() {
    super.initState();
    _signUpMethod = widget.signUpMethod;
    _isShow = false;
  }

  @override
  void dispose() {
    _email.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDone = state == ButtonState.done;
    final isStretched = state == ButtonState.init;
    final size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () async {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        key: _scaffoldKey,
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Image(
                image: AssetImage("assets/LgoFinal.png"),
                width: size.width * 0.9,
                height: size.height * 0.35,
              ),
              // Padding(
              //   padding: const EdgeInsets.only(left: 70, top: 10),
              //   child: SizedBox(
              //     height: 120,
              //     width: double.infinity,
              //     child: Text(
              //       "Register",
              //       style: TextStyle(
              //         fontSize: 70,
              //         fontWeight: FontWeight.bold,
              //       ),
              //     ),
              //   ),
              // ),
              // SizedBox(
              //   height: 20,
              // ),
              Container(
                height: size.height,
                margin: const EdgeInsets.symmetric(horizontal: 10),
                width: double.infinity,
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      TextFormField(
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        controller: _name,
                        validator: (name) {
                          if (Validator().validateName(name.toString())) {
                            return null;
                          } else {
                            List<String> list = [
                              'No special characters',
                              'No numbers',
                              'At least 4 char.'
                            ];

                            String result =
                                list.map((val) => val.trim()).join(',  ');
                            log(result);
                            return result;
                          }
                        },
                        decoration: InputDecoration(
                          floatingLabelBehavior: FloatingLabelBehavior.auto,
                          prefixIcon: const Icon(Icons.account_box),
                          labelText: "Enter Your Name",
                          hintStyle: TextStyle(
                            color: Colors.black,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      IntlPhoneField(
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        keyboardType: TextInputType.phone,
                        controller: _phoneNumber,
                        onCountryChanged: (value) {
                          setState(() {
                            _countryCode = value.code;
                          });
                        },
                        validator: (phone) {
                          if (!Validator().validatePhone(phone.toString())) {
                            return null;
                          }
                        },
                        decoration: InputDecoration(
                          labelText: "Phone Number",
                          focusColor: Colors.green,
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: BorderSide(
                                color:
                                    _isDoneInOTP ? Colors.green : Colors.grey),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: BorderSide(
                                color:
                                    _isDoneInOTP ? Colors.green : Colors.grey,
                                width: 1.0),
                          ),
                          hintText: '(123) 123-1234',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        initialCountryCode: 'EG',
                      ),
                      TextFormField(
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        controller: _email,
                        keyboardType: TextInputType.emailAddress,
                        validator: (email) =>
                            (!Validator().validateEmail(email.toString()))
                                ? 'Enter correct Email address'
                                : null,
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.mail_outline),
                          labelText: "Enter Your Email",
                          hintStyle: TextStyle(
                            color: Colors.black,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: size.height * 0.01,
                      ),

                      Column(
                        children: [
                          Text(
                            "Choose Date Of Birth:",
                            style: TextStyle(
                              color: Colors.black87,
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () async {
                              DateTime? newDate = await showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime(1900),
                                lastDate: DateTime(2100),
                              );
                              if (newDate == null) return;

                              setState(() {
                                _dateChosen = true;
                                date = newDate;
                              });
                            },
                            style: ElevatedButton.styleFrom(
                              primary: Color(0xFF9B0000),
                            ),
                            child: Text(
                              _dateChosen
                                  ? "${date.year}/${date.month}/${date.day}"
                                  : "Year/Month/Day",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 25),
                        child: Column(
                          children: [
                            Container(
                              alignment: Alignment.topLeft,
                              child: Text(
                                "Choose Gender :",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            Column(
                              children: [
                                Row(
                                  children: [
                                    Radio(
                                      value: 1,
                                      groupValue: _valueOfRadioButtons,
                                      onChanged: (value) {
                                        setState(() {
                                          _valueOfRadioButtons = value as int;
                                          log(_valueOfRadioButtons.toString());
                                        });
                                      },
                                    ),
                                    Text("Male"),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Radio(
                                      value: 2,
                                      groupValue: _valueOfRadioButtons,
                                      onChanged: (value) {
                                        setState(() {
                                          _valueOfRadioButtons = value as int;
                                          log(_valueOfRadioButtons.toString());
                                        });
                                      },
                                    ),
                                    Text("Female"),
                                  ],
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                      Visibility(
                        visible: _signUpMethod == 1 ? true : false,
                        child: Column(
                          children: [
                            TextFormField(
                              onChanged: (value) {
                                setState(() {
                                  textLength = value.length;
                                });
                              },
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              showCursor: true,
                              controller: _BioController,
                              maxLines: 4,
                              maxLength: maxLength,
                              keyboardType: TextInputType.text,
                              decoration: InputDecoration(
                                suffixText:
                                    '${textLength.toString()}/${maxLength.toString()}',
                                counterText: "",
                                labelText: "Bio",
                                hintText: "Provide us with your Bio",
                                focusColor: Colors.green,
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                  borderSide: BorderSide(
                                    color: Colors.blue,
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                  borderSide: BorderSide(
                                    color: Colors.grey,
                                  ),
                                ),
                                hintStyle: TextStyle(
                                  color: Colors.black,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                          ],
                        ),
                      ),
                      TextFormField(
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        // validator: (password) =>
                        //     (!Validator().validatePassword(password.toString()))
                        //         ? 'Enter correct password'
                        //         : null,
                        validator: (password) {
                          if (Validator()
                              .validatePassword(password.toString())) {
                            return null;
                          } else {
                            List<String> list = [
                              '8 chars ',
                              'Uppercase ',
                              'special ',
                              'numbers'
                            ];

                            String result =
                                list.map((val) => val.trim()).join(',  ');
                            log(result);
                            return result;
                          }
                        },
                        obscureText: !_isShow,
                        showCursor: true,
                        controller: _password,
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
                          hintText: "Enter password",
                          prefixIcon: Icon(
                            Icons.lock_rounded,
                          ),
                          hintStyle: TextStyle(
                            color: Colors.black,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                      ),
                      TextFormField(
                        autovalidateMode: AutovalidateMode.always,
                        validator: (confirm) {
                          if (confirm != _password.text) {
                            return "Password doesn't match";
                          } else {
                            return null;
                          }
                        },
                        obscureText: !_isShow,
                        controller: _confirmPassword,
                        showCursor: true,
                        decoration: InputDecoration(
                          prefixIcon: Icon(
                            Icons.lock_rounded,
                          ),
                          labelText: "Confirm password",
                          hintStyle: TextStyle(
                            color: Colors.black,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                      ),
                      Divider(
                        thickness: 0.2,
                      ),
                      Container(
                        width: state == ButtonState.init ? size.width : 100,
                        alignment: Alignment.center,
                        child: isStretched
                            ? AnimatedContainer(
                                duration: Duration(milliseconds: 300),
                                curve: Curves.easeIn,
                                onEnd: () =>
                                    setState(() => isAnimating = !isAnimating),
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    shape: const StadiumBorder(),
                                    primary: Color(0xFF9B0000),
                                    minimumSize: Size(
                                        size.width * 0.57, size.height * 0.06),
                                    // maximumSize: Size(100, 40),
                                    //     height: size.height * 0.05,
                                    //     width: size.width * 0.5,
                                    //     decoration: BoxDecoration(
                                    //       borderRadius: BorderRadius.circular(25),
                                    //       color: Color(0xFF9B0000),
                                    //     ),
                                    //     alignment: Alignment.center,
                                  ),
                                  onPressed: () async {
                                    setState(() {
                                      state = ButtonState.loading;

                                      // state = ButtonState.done;
                                    });
                                    await Future.delayed(
                                        Duration(milliseconds: 400));
                                    if (formKey.currentState!.validate() &&
                                        // _isOTPVerified &&
                                        _email.text.isNotEmpty &&
                                        _password.text.isNotEmpty &&
                                        _confirmPassword.text.isNotEmpty &&
                                        _name.text.isNotEmpty &&
                                        _valueOfRadioButtons != 0 &&
                                        (_signUpMethod == 1
                                            ? _BioController.text.isNotEmpty
                                            : true) &&
                                        date != DateTime.now()) {
                                      _age = calculateAge(date);

                                      bool _isNameTaken =
                                          await FireStoreDatabase()
                                              .checkName(_name.text);

                                      bool _isPhoneTaken = await FireStoreDatabase()
                                          .checkPhoneNumber(
                                              '$_countryCode${_phoneNumber.text}');

                                      if (!_isNameTaken &&
                                          !_isPhoneTaken &&
                                          _age >= 20) {
                                        final _user = await FireStoreDatabase()
                                            .signUp(
                                                _email.text, _password.text);
                                        StreamBuilder<User?>(
                                          stream: FirebaseAuth.instance
                                              .authStateChanges(),
                                          builder: (context, snapshot) {
                                            if (snapshot.hasData) {
                                              return VerifyEmailOTP();
                                            } else {
                                              return LoginScreen();
                                            }
                                          },
                                        );
                                        if (_signUpMethod == 1) {
                                          if (_BioController.text.isNotEmpty) {
                                            await FireStoreServices().addTrainer(
                                                _name.text,
                                                '$_countryCode${_phoneNumber.text}',
                                                _email.text.toLowerCase(),
                                                date,
                                                _age,
                                                _valueOfRadioButtons,
                                                _BioController.text);
                                            await FireStoreServices().addUsers(
                                                _name.text,
                                                '$_countryCode${_phoneNumber.text}',
                                                _email.text.toLowerCase(),
                                                date,
                                                _age,
                                                _valueOfRadioButtons,
                                                true);
                                          } else {
                                            alertFlutter(
                                                "Please Enter Your Bio Info");
                                          }
                                        } else if (_signUpMethod == 2) {
                                          await FireStoreServices().addTrainee(
                                              _name.text,
                                              '$_countryCode${_phoneNumber.text}',
                                              _email.text.toLowerCase(),
                                              date,
                                              _age,
                                              _valueOfRadioButtons);
                                          await FireStoreServices().addUsers(
                                              _name.text,
                                              '$_countryCode${_phoneNumber.text}',
                                              _email.text.toLowerCase(),
                                              date,
                                              _age,
                                              _valueOfRadioButtons,
                                              false);
                                        }

                                        if (_user != null) {
                                          log("Registration success");
                                          await Future.delayed(
                                              Duration(seconds: 1));
                                          setState(() {
                                            state = ButtonState.done;
                                          });
                                          await Future.delayed(
                                              Duration(milliseconds: 200));
                                          // await FireStoreDatabase().Logout();
                                          // Navigator.pushReplacementNamed(
                                          //     context, LoginScreen.id);
                                          Navigator.pushReplacementNamed(
                                              context, VerifyEmailOTP.id);
                                        } else {
                                          log("Registration failed");
                                        }
                                      } else if (_isNameTaken) {
                                        alertFlutter(
                                            "Name is already taken, try another one");
                                      } else if (_isPhoneTaken) {
                                        alertFlutter(
                                            "Phone number is already taken, try another one");
                                      } else if (_age < 20) {
                                        alertFlutter(
                                            "You're too young to be a coach");
                                      }
                                    } else {
                                      setState(() {
                                        state = ButtonState.init;
                                      });
                                      alertFlutter(
                                          "Please enter all fields correctly");
                                    }
                                  },
                                  child: Text(
                                    "Submit",
                                    style: TextStyle(
                                        fontSize: 27,
                                        color: Colors.white,
                                        letterSpacing: 1.5,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ),
                              )
                            : Container(
                                width: 40,
                                height: 40,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Color(0xFF9B0000),
                                ),
                                child: Center(
                                  child: isDone
                                      ? Icon(
                                          Icons.done,
                                          size: 24,
                                          color: Colors.white,
                                        )
                                      : CircularProgressIndicator(
                                          color: Color(0xFF4C638A),
                                        ),
                                ),
                              ),
                      ),
                      // GestureDetector(
                      //   child: Container(
                      //     height: size.height * 0.05,
                      //     width: size.width * 0.5,
                      //     decoration: BoxDecoration(
                      //       borderRadius: BorderRadius.circular(25),
                      //       color: Color(0xFF9B0000),
                      //     ),
                      //     alignment: Alignment.center,
                      //     child: Text(
                      //       'Sign Up',
                      //       style: TextStyle(
                      //         color: Colors.white,
                      //         fontSize: 20,
                      //         fontWeight: FontWeight.bold,
                      //       ),
                      //     ),
                      //   ),
                      //   onTap: () async {
                      //     //check if the OTP code has been sent and confirmed by the user
                      //
                      //     if (formKey.currentState!.validate() &&
                      //         _isOTPVerified &&
                      //         _email.text.isNotEmpty &&
                      //         _password.text.isNotEmpty &&
                      //         _confirmPassword.text.isNotEmpty &&
                      //         _name.text.isNotEmpty &&
                      //         _valueOfRadioButtons != 0 &&
                      //         (_signUpMethod == 1
                      //             ? _BioController.text.isNotEmpty
                      //             : true) &&
                      //         date != DateTime.now()) {
                      //       _age = calculateAge(date);
                      //
                      //       bool _isNameTaken =
                      //           await FireStoreDatabase().checkName(_name.text);
                      //
                      //       bool _isPhoneTaken = await FireStoreDatabase()
                      //           .checkPhoneNumber(
                      //               '$_countryCode${_phoneNumber.text}');
                      //
                      //       if (!_isNameTaken && !_isPhoneTaken && _age >= 20) {
                      //         final _user = await FireStoreDatabase()
                      //             .SignUp(_email.text, _password.text);
                      //
                      //         if (_signUpMethod == 1) {
                      //           if (_BioController.text.isNotEmpty) {
                      //             await FireStoreServices().addTrainer(
                      //                 _name.text,
                      //                 '$_countryCode${_phoneNumber.text}',
                      //                 _email.text,
                      //                 date,
                      //                 _age,
                      //                 _valueOfRadioButtons,
                      //                 _BioController.text);
                      //             await FireStoreServices().addUsers(
                      //                 _name.text,
                      //                 '$_countryCode${_phoneNumber.text}',
                      //                 _email.text,
                      //                 date,
                      //                 _age,
                      //                 _valueOfRadioButtons,
                      //                 true);
                      //           } else {
                      //             alertFlutter("Please Enter Your Bio Info");
                      //           }
                      //         } else if (_signUpMethod == 2) {
                      //           await FireStoreServices().addTrainee(
                      //               _name.text,
                      //               '$_countryCode${_phoneNumber.text}',
                      //               _email.text,
                      //               date,
                      //               _age,
                      //               _valueOfRadioButtons);
                      //           await FireStoreServices().addUsers(
                      //               _name.text,
                      //               '$_countryCode${_phoneNumber.text}',
                      //               _email.text,
                      //               date,
                      //               _age,
                      //               _valueOfRadioButtons,
                      //               false);
                      //         }
                      //
                      //         if (_user != null) {
                      //           log("Registration success");
                      //
                      //           await FireStoreDatabase().Logout();
                      //           Navigator.pushReplacementNamed(
                      //               context, LoginScreen.id);
                      //         } else {
                      //           log("Registration failed");
                      //         }
                      //       } else if (_isNameTaken) {
                      //         alertFlutter(
                      //             "Name is already taken, try another one");
                      //       } else if (_isPhoneTaken) {
                      //         alertFlutter(
                      //             "Phone number is already taken, try another one");
                      //       } else if (_age < 20) {
                      //         alertFlutter("You're too young to be a coach");
                      //       }
                      //     } else {
                      //       alertFlutter("Please enter all fields correctly");
                      //     }
                      //   },
                      // ),
                      SizedBox(
                        height: size.height * 0.01,
                      ),
                      GestureDetector(
                        onTap: () =>
                            Navigator.pushNamed(context, LoginScreen.id),
                        child: Text(
                          'Already have an account',
                          style: TextStyle(
                            color: Colors.black87,
                            fontSize: 16,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: size.height * 0.02,
                      ),
                    ],
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
      animationType: AnimationType.grow,
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
        color: Colors.redAccent,
      ),
    );
    Alert(
      context: context,
      style: style,
      type: AlertType.error,
      title: title,
      buttons: [
        DialogButton(
          child: Text(
            "Okay!",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          onPressed: () => Navigator.pop(context),
          color: Color.fromRGBO(0, 179, 134, 1.0),
          radius: BorderRadius.circular(10.0),
        ),
      ],
    ).show();
  }
}
