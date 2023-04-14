import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
// import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
// import 'package:flutter_facebook_login/flutter_facebook_login.dart';
// import 'package:google_sign_in/google_sign_in.dart';

class FireStoreDatabase extends ChangeNotifier {
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;
  final CollectionReference _users =
      FirebaseFirestore.instance.collection('Users');
  // final CollectionReference _trainer =
  //     FirebaseFirestore.instance.collection('Trainer');
  // final CollectionReference _trainee =
  //     FirebaseFirestore.instance.collection('Trainee');
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // User? _user;

  //google sign in variables
  // final googleSignIn = GoogleSignIn();

  Future<dynamic> login(String email, String password) async {
    try {
      final _user = await _auth.signInWithEmailAndPassword(
          email: email, password: password);

      notifyListeners();
      return _user;
    } catch (e) {
      log('$e' 'in login function');
    }
  }

  Future<dynamic> signUp(String email, String password) async {
    try {
      return _auth.createUserWithEmailAndPassword(
          email: email, password: password);
    } catch (e) {
      log('$e' 'in sign up function');
    }
  }

  // Future googleLogin(BuildContext context) async {
  //   try {
  //     final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
  //
  //     if (googleUser == null) return;
  //
  //     // Obtain the auth details from the request
  //     final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
  //
  //     final credential = GoogleAuthProvider.credential(
  //       accessToken: googleAuth.accessToken,
  //       idToken: googleAuth.idToken,
  //     );
  //
  //     final UserCredential authResult =
  //     await FirebaseAuth.instance.signInWithCredential(credential);
  //
  //     final User? _googleUser = authResult.user;
  //
  //     if (authResult.additionalUserInfo!.isNewUser) {
  //       //User logging in for the first time
  //       // Redirect user to tutorial
  //       if (_googleUser != null) {
  //         //You can her set data user in Fire store
  //         //Ex: Go to RegisterPage()
  //         await addUsers(
  //             _googleUser.displayName, _googleUser.phoneNumber, _googleUser.email);
  //         log('added');
  //
  //         log('first time');
  //         Register.signUpMethod = 1;
  //         Navigator.pushReplacementNamed(context, Tutorial.id);
  //       }
  //     } else {
  //       log('logged in before');
  //       Navigator.pushReplacementNamed(context, Home.id);
  //       //User has already logged in before.
  //       //Show user profile
  //     }
  //   } catch (e) {
  //     print(e.toString());
  //   }
  //   notifyListeners();
  // }

  // Future facebookLogin(BuildContext context) async {
  //   try {
  //     final FacebookLogin facebookSignIn = new FacebookLogin();
  //
  //     Map? userData;
  //
  //     var loginResult = await FacebookAuth.i.login(
  //       permissions: ["email", "public_profile"],
  //       loginBehavior: LoginBehavior.webViewOnly,
  //     );
  //
  //     if (loginResult.status == LoginStatus.success) {
  //       // case FacebookLoginStatus.loggedIn:
  //       final requestedData = await FacebookAuth.i.getUserData(
  //         fields: "email, name, picture",
  //       );
  //       userData = requestedData;
  //       notifyListeners();
  //     }
  //
  //     // Create a credential from the access token
  //     final OAuthCredential facebookAuthCredential =
  //     FacebookAuthProvider.credential(loginResult.accessToken!.token);
  //
  //     // Once signed in, return the UserCredential
  //     final UserCredential result =
  //     await FirebaseAuth.instance.signInWithCredential(facebookAuthCredential);
  //
  //     final User? _facebookUser = result.user;
  //
  //     if (result.additionalUserInfo!.isNewUser) {
  //       //You can her set data user in Fire store
  //       //Ex: Go to RegisterPage()
  //       if (_facebookUser != null) {
  //         await addUsers(
  //             userData!['name'],
  //             "123", // _facebookUser.phoneNumber,
  //             userData['email']);
  //         log('added');
  //         // }
  //         log('first time');
  //         Register.signUpMethod = 2;
  //         Navigator.pushReplacementNamed(context, Tutorial.id);
  //       }
  //     } else {
  //       Register.signUpMethod = 2;
  //       log('logged in before');
  //       Navigator.pushReplacementNamed(context, Home.id);
  //       //User has already logged in before.
  //       //Show user profile
  //     }
  //   } on FirebaseAuthException catch (e) {
  //     log(e.toString());
  //   }
  //   notifyListeners();
  // }

  Future<bool> checkName(String name) async {
    bool _isTaken = false;
    await _users.where('Name', isEqualTo: name).get().then((value) {
      if (value.docs.isNotEmpty) {
        log('NameFound');
        _isTaken = true;
      } else {
        log('name not Found');
        _isTaken = false;
      }
    });

    return _isTaken;
  }

  Future<bool> checkPhoneNumber(String number) async {
    bool _isTaken = false;
    await _users.where('PhoneNumber', isEqualTo: number).get().then((value) {
      if (value.docs.isNotEmpty) {
        log('phone found');
        _isTaken = true;
      } else {
        log('phone not Found');
        _isTaken = false;
      }
    });

    return _isTaken;
  }

  Future<bool> checkPhoneNumberToVerifyPhoneNumberForTrainee(
      String number, String email) async {
    bool _isTaken = false;
    await _fireStore
        .collection("Trainee")
        .where('PhoneNumber', isEqualTo: number)
        .where('Email', isEqualTo: email)
        .get()
        .then((value) {
      if (value.docs.isNotEmpty) {
        log('phone found with that email');
        _isTaken = true;
      } else {
        log('phone not Found with that email');
        _isTaken = false;
      }
    });

    return _isTaken;
  }

  Future<bool> checkPhoneNumberToVerifyPhoneNumberForTrainer(
      String number, String email) async {
    bool _isTaken = false;
    await _fireStore
        .collection("Trainer")
        .where('PhoneNumber', isEqualTo: number)
        .where('Email', isEqualTo: email)
        .get()
        .then((value) {
      if (value.docs.isNotEmpty) {
        log('phone found with that email');
        _isTaken = true;
      } else {
        log('phone not Found with that email');
        _isTaken = false;
      }
    });

    return _isTaken;
  }

  Future<bool> checkEmail(String email) async {
    bool _isTaken = false;
    await _users.where('Email', isEqualTo: email).get().then((value) {
      if (value.docs.isNotEmpty) {
        _isTaken = true;
        log("this email is taken");
      } else {
        _isTaken = false;
        log("this email is not taken");
      }
    });
    return _isTaken;
  }

  Future<bool> checkUser(String? email) async {
    //determines if the current user is trainer or trainee
    bool isTrainer = false;
    await _fireStore
        .collection("Users")
        .where("Email", isEqualTo: email)
        .get()
        .then((value) {
      if (value.docs.isNotEmpty) {
        isTrainer = value.docs.first.get("isTrainer");
      }
    });
    return isTrainer;
  }

  //lets use this function after signing up because it needs a user to set its (emailVerified) property
  Future verifyEmailAddress(String email) async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null && !user.emailVerified) {
      await user.sendEmailVerification();
    }
    // User? _user = FirebaseAuth.instance.currentUser;
    //
    // if (_user != null && !_user.emailVerified) {
    //   var actionCodeSettings = ActionCodeSettings(
    //     url: 'https://www.example.com/?email=${_user.email}',
    //     // dynamicLinkDomain: "example.page.link",
    //     androidMinimumVersion: "12",
    //     androidInstallApp: false,
    //     androidPackageName: "com.example.boost_pt",
    //     // iOS: {"bundleId": "com.example.ios"},
    //     handleCodeInApp: true,
    //   );
    //
    //   User? user = FirebaseAuth.instance.currentUser;
    //
    //   if (!user!.emailVerified) {
    //     var actionCodeSettings = ActionCodeSettings(
    //         url: 'https://www.google.com/?email=${user.email}',
    //         // dynamicLinkDomain: "example.page.link",
    //         androidPackageName: "com.example.android",
    //         androidInstallApp: true,
    //         androidMinimumVersion: "12",
    //         iOSBundleId: "com.example.ios",
    //         handleCodeInApp: true);
    //
    //     await user.sendEmailVerification(actionCodeSettings);
    //   }
    // }
  }

  Future<void> verifyPhoneNumber(String number, Function setData) async {
    // String? _verificationCode;
    try {
      log(number);
      await _auth.verifyPhoneNumber(
        phoneNumber: number,
        verificationCompleted: (PhoneAuthCredential credential) async {},
        verificationFailed: (FirebaseAuthException e) {
          log(e.toString());
        },
        codeSent: (String verificationId, int? resendToken) async {
          log("came here");
          setData(verificationId);
        },
        codeAutoRetrievalTimeout: (String verificationId) {},
        timeout: const Duration(seconds: 60),
      );
    } catch (e) {
      log(e.toString());
    }
  }

  Future<bool> sentCodeToFirebase(
      {String? code,
      String? verificationID,
      required Function setDoneBoolean}) async {
    bool isDone = false;
    try {
      User? loggedInUser;

      final _user = _auth.currentUser;
      if (_user != null) {
        loggedInUser = _user;
      }
      if (verificationID != null) {
        PhoneAuthCredential credential = PhoneAuthProvider.credential(
            verificationId: verificationID, smsCode: code.toString());

        await loggedInUser?.linkWithCredential(credential).then((value) {
          isDone = true;
        }).catchError((onError) {
          log(onError.toString());
          isDone = false;
        });
      }
    } catch (e) {
      log(e.toString());
    }
    log(isDone.toString());
    return isDone;
  }

  // Future googleSignOut() async {
  //   await googleSignIn.disconnect();
  //   await FirebaseAuth.instance.signOut();
  // }

  // Future facebookSignOut() async {
  //   await FacebookAuth.i.logOut();
  //   await FirebaseAuth.instance.signOut();
  //   notifyListeners();
  // }

  // ignore: non_constant_identifier_names
  Future<dynamic> Logout() async {
    FirebaseAuth _auth = FirebaseAuth.instance;
    try {
      return _auth.signOut();
    } catch (e) {
      log('$e');
    }
  }

  Future<bool> removeTraineeFromTrainerList(String id) async {
    bool isDone = false;
    try {
      await _fireStore.collection("Trainee").doc(id).update(
          {"Assigned Trainer": "NoTrainer", "hasTrainer": false}).then((value) {
        isDone = true;
      });
    } catch (e) {
      log(e.toString());
      isDone = false;
    }
    return isDone;
  }

  final _bioAuth = LocalAuthentication();
  Future<bool> hasBiometrics() async {
    try {
      bool hasBio = await _bioAuth.canCheckBiometrics;
      return hasBio;
    } catch (e) {
      return false;
    }
  }

  Future<bool> authenticate() async {
    bool isAvailable = await hasBiometrics();
    if (!isAvailable) return false;
    try {
      return await _bioAuth.authenticate(
        localizedReason: 'BioMetric Authentication to access the application',
        options: const AuthenticationOptions(
          biometricOnly: true,
          useErrorDialogs: false,
          sensitiveTransaction: true,
          stickyAuth: false,
        ),
      );
    } catch (e) {
      return false;
    }
  }
}
