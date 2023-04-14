import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../Components/Components.dart';

class FireStoreServices extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future addUsers(String? name, String? phone, String? email,
      DateTime dateOfBirth, int age, int gender, bool isTrainer) async {
    await _firestore.collection('Users').add({
      'Name': name,
      'Email': email,
      'PhoneNumber': phone,
      'Date Of Birth':
          "${dateOfBirth.year}/${dateOfBirth.month}/${dateOfBirth.day}",
      "Age": age,
      'Gender': gender == 1 ? "Male" : "Female",
      'isTrainer': isTrainer,
      'isAdmin': false
    });
    log('User added');
  }

  Future addTrainer(String? name, String? phone, String? email,
      DateTime dateOfBirth, int age, int gender, String bio) async {
    await _firestore.collection('Trainer').add({
      'Name': name,
      'Email': email,
      'PhoneNumber': phone,
      'Date Of Birth':
          "${dateOfBirth.year}/${dateOfBirth.month}/${dateOfBirth.day}",
      "Age": age.toString(),
      'Gender': gender == 1 ? "Male" : "Female",
      'Rating': 0,
      'NumberOfRatings': 0,
      'Image': "image",
      'isPhoneVerified': false,
      "Bio": bio,
      'isTrainer': true,
      'isAdmin': false
    });

    log('User added');
  }

  // Future addSubcollection(String id)async{
  //   try {
  //     await _firestore.collection("Trainee").doc(id).collection("Abs")
  //         .doc()
  //         .set(
  //         {
  //           "Name": "name",
  //           "Type": "abs",
  //           "Image": "image",
  //           "description": "decs."
  //         });
  //   }catch(e){
  //     log('$e');
  //   }
  // }
  Future addTrainee(String? name, String? phone, String? email,
      DateTime dateOfBirth, int age, int gender) async {
    String? id;
    try {
      DateTime now = DateTime.now();
      String formattedDate = DateFormat('EEE d MMM').format(now);
      await _firestore.collection('Trainee').add({
        'Name': name,
        'Email': email,
        'Image': "image",
        'PhoneNumber': phone,
        'Date Of Birth':
            "${dateOfBirth.year}/${dateOfBirth.month}/${dateOfBirth.day}",
        "Age": age.toString(),
        'Gender': gender == 1 ? "Male" : "Female",
        'Status': "Online",
        'LastSeen': formattedDate,
        'Assigned Trainer': "NoTrainer",
        'isPhoneVerified': false,
        'hasTrainer': false,
        'isTrainer': false,
        'isAdmin': false
      });
      await _firestore
          .collection("Trainee")
          .where("Email", isEqualTo: email)
          .get()
          .then((value) {
        id = value.docs.first.id;
      });

      // await _firestore
      //     .collection("Trainee")
      //     .doc(id)
      //     .collection("Exercises")
      //     .add({
      //   "Name": "name",
      //   "Type": "type",
      //   "Image": "image",
      //   "Description": "desc."
      // });
      // await _firestore
      //     .collection("Trainee")
      //     .doc(id)
      //     .collection("Nutrition")
      //     .add({
      //   "Name": "name",
      //   "Type": "type",
      //   "Image": "image",
      //   "Calories": "calories",
      //   "Category": "category",
      //   "Description": "desc."
      // });
      // await _firestore
      //     .collection("Trainee")
      //     .doc(id)
      //     .collection("Supplements")
      //     .add({
      //   "Name": "name",
      //   "Type": "type",
      //   "Image": "image",
      //   "Dose": "dose",
      //   "Description": "desc."
      // });
    } catch (e) {
      log('$e');
    }
    log('User added');
  }

  Future<void> addFeedBack(String rating, String feedback) async {
    Users? data;
    User? loggedInUser;
    try {
      final _user = _auth.currentUser;
      if (_user != null) {
        loggedInUser = _user;
      }
      await _firestore.collection("FeedBack").add({
        'Rating': rating,
        'FeedBack': feedback,
        'submitter': loggedInUser!.email
      });
    } catch (e) {
      log(e.toString());
    }
  }

  Future<Users?> getUserInformation() async {
    //get Information about the current user from user collection
    Users? data;
    User? loggedInUser;
    try {
      final _user = _auth.currentUser;
      if (_user != null) {
        loggedInUser = _user;
        log("dsadsadsadsadsadsadsa");
        log(loggedInUser.email.toString());
      }
      await _firestore
          .collection("Users")
          .where("Email", isEqualTo: loggedInUser!.email)
          .get()
          .then((value) {
        data = Users(
            Name: value.docs.first.get("Name"),
            Email: value.docs.first.get("Email"),
            PhoneNo: value.docs.first.get("PhoneNumber"),
            Gender: value.docs.first.get("Gender"),
            Age: value.docs.first.get("Age").toString(),
            isTrainer: value.docs.first.get("isTrainer").toString(),
            Date_Of_Birth: value.docs.first.get("Date Of Birth"),
            ID: value.docs.first.id);
        // log(data!.Email.toString());
        log("data collected");
      });
    } catch (e) {
      log("error in get getUserInformation ");
      log('$e');
    }

    return data;
  }

  Future<String?> getTraineeID() async {
    //RETURNS ONLY THE ID OF THE TRAINEE FROM TRAINEE COLLECTION
    String? id;
    User? loggedInUser;
    try {
      final _user = _auth.currentUser;
      if (_user != null) {
        loggedInUser = _user;
      }
      await _firestore
          .collection("Trainee")
          .where("Email", isEqualTo: loggedInUser!.email)
          .get()
          .then((QuerySnapshot snapshot) {
        if (snapshot.docs.isNotEmpty) {
          id = snapshot.docs[0].reference.id;
          // isDone = true;
        }
      });
    } catch (e) {
      log('$e');
    }
    return id;
  }

  Future<String?> getTraineeIDForTrainer(String name) async {
    //RETURNS ONLY THE ID OF THE TRAINEE FROM TRAINEE COLLECTION this function is used to only in the trainer interface
    String? id;

    try {
      await _firestore
          .collection("Trainee")
          .where("Name", isEqualTo: name)
          .get()
          .then((value) {
        id = value.docs.first.id;
        log("data collected");
      });
    } catch (e) {
      log('$e');
    }
    return id;
  }

  Future<Trainee?> getTraineeInformation() async {
    //returns all of the information about a specific trainee
    Trainee? data;
    // String? id;
    User? loggedInUser;
    try {
      final _user = _auth.currentUser;
      if (_user != null) {
        loggedInUser = _user;
      }
      await _firestore
          .collection("Trainee")
          .where("Email", isEqualTo: loggedInUser!.email)
          .get()
          .then((value) {
        data = Trainee(
            Name: value.docs.first.get("Name"),
            Email: value.docs.first.get("Email"),
            Image: value.docs.first.get("Image"),
            PhoneNo: value.docs.first.get("PhoneNumber"),
            AssignedTrainer: value.docs.first.get("Assigned Trainer"),
            isPhoneVerified: value.docs.first.get("isPhoneVerified"),
            Gender: value.docs.first.get("Gender"),
            Status: value.docs.first.get("Status"),
            LastSeen: value.docs.first.get("LastSeen"),
            Age: value.docs.first.get("Age"),
            ID: value.docs.first.id);

        log("data collected");
      });
    } catch (e) {
      log("error in get traineeInformation function  ");
      log('$e');
    }
    return data;
  }

  Future<List<Trainee>> getTrainees(String nameOfTheTrainer) async {
    //filter trainees by trainer name
    //returns all of the trainees to be viewed in trainees list view
    List<Trainee> data = [];
    try {
      await _firestore
          .collection("Trainee")
          .where("Assigned Trainer", isEqualTo: nameOfTheTrainer)
          .orderBy('LastSeen', descending: true)
          .get()
          .then((QuerySnapshot snapshot) {
        if (snapshot.docs.isNotEmpty) {
          for (var element in snapshot.docs) {
            Trainee trainee = Trainee(
                Name: element.get("Name"),
                Email: element.get("Email"),
                Image: element.get("Image"),
                PhoneNo: element.get("PhoneNumber"),
                AssignedTrainer: element.get("Assigned Trainer"),
                Gender: element.get("Gender"),
                Status: element.get("Status"),
                LastSeen: element.get("LastSeen"),
                Age: element.get("Age"),
                ID: element.id);
            data.add(trainee);
            // log(data[0].Name.toString());
          }
        }
      });
    } catch (e) {
      log('$e' "here in get trainees function");
    }
    return data;
  }

  Future<Trainer?> getTrainerInformation() async {
    //returns all of the information about a specific trainer
    Trainer? data;
    // String? id;
    User? loggedInUser;
    try {
      final _user = _auth.currentUser;
      if (_user != null) {
        loggedInUser = _user;
      }
      await _firestore
          .collection("Trainer")
          .where("Email", isEqualTo: loggedInUser!.email)
          .get()
          .then((value) {
        data = Trainer(
            Name: value.docs.first.get("Name"),
            Email: value.docs.first.get("Email"),
            Image: value.docs.first.get("Image"),
            PhoneNo: value.docs.first.get("PhoneNumber"),
            isPhoneVerified: value.docs.first.get("isPhoneVerified"),
            Rating: value.docs.first.get("Rating").toString(),
            NoOfRatings: value.docs.first.get("NumberOfRatings").toString(),
            Gender: value.docs.first.get("Gender"),
            Age: value.docs.first.get("Age"),
            Bio: value.docs.first.get("Bio"),
            ID: value.docs.first.id);
        log("data collected");
      });
    } catch (e) {
      log('$e');
    }
    return data;
  }

  Future<List<Trainer>> getTrainers() async {
    //returns all of the trainers to be viewed in list view
    List<Trainer> data = [];
    try {
      await _firestore
          .collection("Trainer")
          // .where("isTrainer", isEqualTo: true)
          .get()
          .then((QuerySnapshot snapshot) {
        if (snapshot.docs.isNotEmpty) {
          for (var element in snapshot.docs) {
            Trainer trainer = Trainer(
                Name: element.get("Name"),
                Email: element.get("Email"),
                Image: element.get("Image"),
                PhoneNo: element.get("PhoneNumber"),
                Gender: element.get("Gender"),
                Rating: element.get("Rating").toString(),
                NoOfRatings: element.get("NumberOfRatings").toString(),
                Bio: element.get("Bio"),
                ID: element.id);
            data.add(trainer);
            // log(data[0].Name.toString());

          }
        }
      });
    } catch (e) {
      log('$e' "here in get trainers function");
    }
    return data;
  }

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  Future<List<Exercises>> getExercises(String id) async {
    //getting exercises for a specific trainee
    log(id);
    List<Exercises> data = [];

    try {
      await _firestore
          .collection("Trainee/$id/Exercises")
          // .where("Type", isEqualTo: type)
          // .where("day", isEqualTo: day)
          .get()
          .then((QuerySnapshot snapshot) {
        if (snapshot.docs.isNotEmpty) {
          for (var element in snapshot.docs) {
            Exercises ex = Exercises(
                Name: element.get("Name"),
                Image: element.get("Image"),
                Type: element.get("Type"),
                Description: element.get("Description"),
                reps: element.get("Reps"),
                sets: element.get("Sets"),
                day: element.get("day"));
            data.add(ex);
            // log(data[0].Type.toString());
          }
        }
      });
    } catch (e) {
      log("can weeeeeee?");
      log('$e');
    }
    return data;
  }

  Future<List<Nutrition>> getNutrition(String id) async {
    //getting nutrition for a specific trainee
    log(id);
    List<Nutrition> data = [];

    try {
      await _firestore
          .collection("Trainee/$id/Nutrition")
          // .where("Category", isEqualTo: category)
          .get()
          .then((QuerySnapshot snapshot) {
        if (snapshot.docs.isNotEmpty) {
          for (var element in snapshot.docs) {
            Nutrition nutri = Nutrition(
              Name: element.get("Name"),
              Image: element.get("Image"),
              Type: element.get("Type"),
              Description: element.get("Description"),
              Calories: element.get("Calories"),
              Measure: element.get("Measure"),
              Category: element.get("Category"),
              day: element.get("Day"),
            );
            data.add(nutri);
          }
        }
      });
    } catch (e) {
      log("can we?");
      log('$e');
    }
    return data;
  }

  Future<List<Supplements>> getSupplements(String id) async {
    //getting supplements for a specific trainee
    log(id);
    List<Supplements> data = [];

    try {
      await _firestore
          .collection("Trainee/$id/Supplements")
          // .where("Type", isEqualTo: type)
          .get()
          .then((QuerySnapshot snapshot) {
        if (snapshot.docs.isNotEmpty) {
          for (var element in snapshot.docs) {
            Supplements nutri = Supplements(
              Name: element.get("Name"),
              Image: element.get("Image"),
              Type: element.get("Type"),
              Description: element.get("Description"),
              Dose: element.get("Dose"),
              day: element.get("Day"),
            );
            data.add(nutri);
          }
        }
      });
    } catch (e) {
      log('$e');
    }
    return data;
  }

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  Future<void> addPathToDatabase(List list, bool isTrainer) async {
    //USED WHEN UPLOADING images to firebase and take its url and put it in fire-store
    try {
      User? loggedInUser;
      final _user = _auth.currentUser;
      if (_user != null) {
        loggedInUser = _user;
      }
      if (isTrainer) {
        await _firestore
            .collection("Trainer")
            .where("Email", isEqualTo: loggedInUser!.email)
            .get()
            .then((value) {
          for (var element in value.docs) {
            _firestore
                .collection("Trainer")
                .doc(element.id)
                .update({"Image": list[0]});
          }
        });
      } else {
        await _firestore
            .collection("Trainee")
            .where("Email", isEqualTo: loggedInUser!.email)
            .get()
            .then((value) {
          for (var element in value.docs) {
            _firestore
                .collection("Trainee")
                .doc(element.id)
                .update({"Image": list[0]});
          }
        });
      }
      // await _firestore
      //     .collection("Trainee/lbPp1YmIjjj39KE5hggm/Supplements")
      //     .where("Type", isEqualTo: "mass gainer")
      //     .where("Name", isEqualTo: "Super Mass Gainer")
      //     .get()
      //     .then((value) {
      //   value.docs.forEach((element) {
      //     _firestore
      //         .collection("Trainee/lbPp1YmIjjj39KE5hggm/Supplements")
      //         .doc(element.id)
      //         .update({"Image": list[0]});
      //   });
      // });
    } catch (e) {
      log('$e');
    }
  }

  Future<void> changeName(String newName, bool isTrainer) async {
    try {
      User? loggedInUser;
      final _user = _auth.currentUser;
      if (_user != null) {
        loggedInUser = _user;
      }
      if (isTrainer == true) {
        await _firestore
            .collection("Trainer")
            .where("Email", isEqualTo: loggedInUser!.email)
            .get()
            .then((value) {
          for (var element in value.docs) {
            _firestore
                .collection("Trainer")
                .doc(element.id)
                .update({"Name": newName});
          }
        });
      } else {
        await _firestore
            .collection("Trainee")
            .where("Email", isEqualTo: loggedInUser!.email)
            .get()
            .then((value) {
          for (var element in value.docs) {
            _firestore
                .collection("Trainee")
                .doc(element.id)
                .update({"Name": newName});
          }
        });
      }
    } catch (e) {
      log('$e');
    }
  }

  Future<void> changeProfileImage() async {}

  Future<bool> changeEmail(
      String newEmail, String password, bool isTrainer) async {
    try {
      User? loggedInUser;
      final _user = _auth.currentUser;
      if (_user != null) {
        loggedInUser = _user;

        //because firebase requires re-authentication after long time of sign in
        // Create a credential
        AuthCredential credential = EmailAuthProvider.credential(
            email: loggedInUser.email.toString(), password: password);

        // Reauthenticate
        await FirebaseAuth.instance.currentUser!
            .reauthenticateWithCredential(credential);
      }
      if (isTrainer == true) {
        await _firestore
            .collection("Trainer")
            .where("Email", isEqualTo: loggedInUser!.email)
            .get()
            .then((value) async {
          await loggedInUser?.updateEmail(newEmail);
          for (var element in value.docs) {
            _firestore
                .collection("Trainer")
                .doc(element.id)
                .update({"Email": newEmail});
          }
        });
      } else {
        await _firestore
            .collection("Trainee")
            .where("Email", isEqualTo: loggedInUser!.email)
            .get()
            .then((value) async {
          await loggedInUser?.updateEmail(newEmail);
          for (var element in value.docs) {
            _firestore
                .collection("Trainee")
                .doc(element.id)
                .update({"Email": newEmail});
          }
        });
      }
      await _firestore
          .collection("Users")
          .where("Email", isEqualTo: loggedInUser.email)
          .get()
          .then((value) async {
        for (var element in value.docs) {
          _firestore
              .collection("Users")
              .doc(element.id)
              .update({"Email": newEmail});
        }
      });
    } catch (e) {
      log('$e');
      return false;
    }
    return true;
  }

  Future<bool> changePhoneNumber(String newPhoneNumber, bool isTrainer) async {
    try {
      User? loggedInUser;
      final _user = _auth.currentUser;
      if (_user != null) {
        loggedInUser = _user;
      }
      if (isTrainer == true) {
        await _firestore
            .collection("Trainer")
            .where("Email", isEqualTo: loggedInUser!.email)
            .get()
            .then((value) {
          for (var element in value.docs) {
            _firestore.collection("Trainer").doc(element.id).update(
                {"PhoneNumber": newPhoneNumber, "isPhoneVerified": true});
          }
        });
      } else {
        await _firestore
            .collection("Trainee")
            .where("Email", isEqualTo: loggedInUser!.email)
            .get()
            .then((value) {
          for (var element in value.docs) {
            _firestore.collection("Trainee").doc(element.id).update(
                {"PhoneNumber": newPhoneNumber, "isPhoneVerified": true});
          }
        });
      }
      await _firestore
          .collection("Users")
          .where("Email", isEqualTo: loggedInUser.email)
          .get()
          .then((value) {
        for (var element in value.docs) {
          _firestore
              .collection("Users")
              .doc(element.id)
              .update({"PhoneNumber": newPhoneNumber});
        }
      });
    } catch (e) {
      log('$e');
      return false;
    }
    return true;
  }

  Future<bool> changePassword(String email) async {
    //changing password by sending email to change their password
    bool isDone = false;
    try {
      User? loggedInUser;
      final _user = _auth.currentUser;
      if (_user != null) {
        loggedInUser = _user;
      } else {
        log('User is currently signed out!');
        return false;
      }
      log(email.toString());
      await _auth.sendPasswordResetEmail(email: email.trim()).then((value) {
        isDone = true;
      }).catchError((onError) {
        isDone = false;
      });
      // await loggedInUser.updatePassword(newPass).then((value) {
      //   isDone = true;
      // }).catchError((onError) {
      //   log(onError.toString());
      //   isDone = false;
      // });
    } catch (e) {
      log('$e');
    }
    log("change password: " + isDone.toString());
    return isDone;
  }

  Future<List<Exercises>> getExercisesForTrainerHomeScreen(String type) async {
    List<Exercises> data = [];
    try {
      await _firestore
          .collection(type)
          // .where("Type", isEqualTo: type)
          .get()
          .then((QuerySnapshot snapshot) {
        if (snapshot.docs.isNotEmpty) {
          for (var element in snapshot.docs) {
            Exercises ex = Exercises(
              Name: element.get("Name"),
              Image: element.get("Image"),
              Type: element.get("Type"),
              Description: element.get("Description"),
              // reps: element.get("Reps"),
              // sets: element.get("Sets"),
            );
            data.add(ex);
            // log(data[0].Type.toString());
          }
        }
      });
    } catch (e) {
      log('$e');
    }
    return data;
  }

  Future<List<Nutrition>> getNutritionForTrainerHomeScreen(String type) async {
    List<Nutrition> data = [];
    try {
      await _firestore
          .collection(type)
          // .where("Type", isEqualTo: type)
          .get()
          .then((QuerySnapshot snapshot) {
        if (snapshot.docs.isNotEmpty) {
          for (var element in snapshot.docs) {
            Nutrition nutrition = Nutrition(
              Name: element.get("Name"),
              Image: element.get("Image"),
              Description: element.get("Description"),
              Calories: element.get("Calories"),
              Measure: element.get("Measure"),
              Type: element.get("Type"),
            );
            data.add(nutrition);
            // log(data[0].Type.toString());
          }
        }
      });
    } catch (e) {
      log('$e');
    }
    log(data.length.toString());
    return data;
  }

  Future<List<Supplements>> getSupplementsForTrainerHomeScreen(
      String type) async {
    List<Supplements> data = [];
    try {
      await _firestore
          .collection("Supplements")
          .where("Type", isEqualTo: type)
          .get()
          .then((QuerySnapshot snapshot) {
        if (snapshot.docs.isNotEmpty) {
          for (var element in snapshot.docs) {
            Supplements supp = Supplements(
              Name: element.get("Name"),
              Image: element.get("Image"),
              Type: element.get("Type"),
              Description: element.get("Description"),
              Dose: element.get("Dose"),
            );
            data.add(supp);
            // log(data[0].Type.toString());
          }
        }
      });
    } catch (e) {
      log('$e');
    }
    return data;
  }

  //the next three functions are used by the trainer to add exercises, nutrition
  // and supplements for the home screen of the trainer
  Future<void> addExercises(
      String type, String name, String image, String description) async {
    try {
      await _firestore.collection(type).add({
        'Name': name,
        'Image': image,
        'Description': description,
        'Type': type,
      });
      log("Exercise added to : " + type + " collection");
    } catch (e) {
      log(e.toString());
    }
  }

  Future<void> addNutrition(String type, String name, String image,
      String description, String calories, String measure) async {
    try {
      await _firestore.collection(type).add({
        "Type": type,
        "Name": name,
        "Image": image,
        "Calories": calories,
        "Measure": measure,
        "Description": description
      });
      log("Nutrition added to : " + type + " collection");
    } catch (e) {
      log(e.toString());
    }
  }

  Future<void> addSupplements(String type, String name, String image,
      String description, String dose) async {
    try {
      await _firestore.collection("Supplements").add({
        "Name": name,
        "Type": type,
        "Image": image,
        "Dose": dose,
        "Description": description
      });
      log("Supplements added by type : " + type);
    } catch (e) {
      log(e.toString());
    }
  }

  //the next three functions are for adding exercises, nutrition and supplements plans
  // for a trainee listed in the trainer's trainees list
  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  Future<bool> addExerciseToTrainee(
      String id, Exercises ex, String sets, String reps, String day) async {
    //receiving object of added single exercise
    bool isDone = false;
    try {
      log(id.toString());
      await _firestore.collection("Trainee/$id/Exercises").add({
        'Name': ex.Name,
        'Type': ex.Type,
        'Image': ex.Image,
        'Description': ex.Description,
        'Sets': sets,
        'Reps': reps,
        'day': day
      }).then((value) {
        log("exercise added  to Trainee");
        isDone = true;
      });
    } catch (e) {
      log(e.toString());
      isDone = false;
      log("exercise not added");
    }
    return isDone;
  }

  Future<bool> addNutritionToTrainee(
      String id, Nutrition nut, String category, String day) async {
    //receiving object of added single Nutrition
    bool isDone = false;
    try {
      await _firestore.collection("Trainee/$id/Nutrition").add({
        'Name': nut.Name,
        'Type': nut.Type,
        'Image': nut.Image,
        'Description': nut.Description,
        'Calories': nut.Calories,
        'Measure': nut.Measure,
        'Category': category,
        'Day': day.toString()
      }).then((value) {
        isDone = true;
        log("nutrition added to trainee");
      });
    } catch (e) {
      isDone = false;
      log(e.toString());
      log("nutrition not added");
    }
    return isDone;
  }

  Future<bool> addSupplementsToTrainee(
      String id, Supplements supp, String day) async {
    //receiving object of added single supplement
    bool isDone = false;
    try {
      await _firestore.collection("Trainee/$id/Supplements").add({
        'Name': supp.Name,
        'Type': supp.Type,
        'Image': supp.Image,
        'Description': supp.Description,
        'Dose': supp.Dose,
        'Day': day
      }).then((value) {
        isDone = true;
        log("supplements added to trainee");
      });
    } catch (e) {
      isDone = false;
      log(e.toString());
      log("supplements not added");
    }
    return isDone;
  }

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  //the next three functions are used to delete exercises, nutrition and
  // supplements from the trainee by the trainer
  Future<bool> deleteExerciseFromTrainee(
      String id, String type, String name) async {
    bool isDone = false;
    try {
      await _firestore
          .collection("Trainee/$id/Exercises")
          .where("Type", isEqualTo: type)
          .where("Name", isEqualTo: name)
          .get()
          .then((QuerySnapshot snapshot) {
        if (snapshot.docs.isNotEmpty) {
          // log(snapshot.docs[0].id);
          snapshot.docs[0].reference.delete();
          isDone = true;
        }
      });
    } catch (e) {
      log(e.toString());
      isDone = false;
      log("nutrition not added");
    }
    return isDone;
  }

  Future<bool> deleteNutritionFromTrainee(
      String id, String type, String name) async {
    bool isDone = false;
    try {
      await _firestore
          .collection("Trainee/$id/Nutrition")
          .where("Type", isEqualTo: type)
          .where("Name", isEqualTo: name)
          .get()
          .then((QuerySnapshot snapshot) {
        if (snapshot.docs.isNotEmpty) {
          // log(snapshot.docs[0].id);
          snapshot.docs[0].reference.delete();
          isDone = true;
        }
      });
    } catch (e) {
      log(e.toString());
      isDone = false;
      log("nutrition not added");
    }
    return isDone;
  }

  Future<bool> deleteSupplementFromTrainee(
      String id, String type, String name) async {
    bool isDone = false;
    try {
      await _firestore
          .collection("Trainee/$id/Supplements")
          .where("Type", isEqualTo: type)
          .where("Name", isEqualTo: name)
          .get()
          .then((QuerySnapshot snapshot) {
        if (snapshot.docs.isNotEmpty) {
          // log(snapshot.docs[0].id);
          snapshot.docs[0].reference.delete();
          isDone = true;
        }
      });
    } catch (e) {
      log(e.toString());
      isDone = false;
      log("nutrition not added");
    }
    return isDone;
  }

  Future<bool> addNotificationToTrainer(String id, Trainee trainee) async {
    bool isDone = false;
    try {
      await _firestore.collection("Trainer/$id/Notification").add({
        'Name': trainee.Name,
        'Age': trainee.Age,
        'Email': trainee.Email
      }).then((value) {
        log("notification added  to Trainer");
        isDone = true;
      });
    } catch (e) {
      log(e.toString());
      isDone = false;
      log("notification not added");
    }
    return isDone;
  }

  Future<List<Notifications>> getNotificationsForTrainee(String id) async {
    List<Notifications> data = [];
    try {
      await _firestore
          .collection("Trainee/$id/Notification")
          .get()
          .then((QuerySnapshot snapshot) {
        if (snapshot.docs.isNotEmpty) {
          for (var element in snapshot.docs) {
            Notifications trainee = Notifications(
              Name: element.get("NameOfTrainer"),
              Reason: element.get("Reason"),
              TypeOfNotification: element.get("typeOfNotification"),
            );
            data.add(trainee);
            // log(data[0].Name.toString());

          }
        }
        log("got notifications of trainee");
      });
    } catch (e) {
      log(e.toString());
      log("notification not added");
    }
    return data;
  }

  Future<List<Notifications>> getNotificationsForTrainer(String id) async {
    List<Notifications> data = [];

    try {
      await _firestore
          .collection("Trainer/$id/Notification")
          .get()
          .then((QuerySnapshot snapshot) {
        if (snapshot.docs.isNotEmpty) {
          for (var element in snapshot.docs) {
            Notifications trainer = Notifications(
                Name: element.get("Name"),
                Email: element.get("Email"),
                Age: element.get("Age"),
                ID: element.id);
            data.add(trainer);
            // log(data[0].Name.toString());

          }
        }
        log("got notifications of trainer");
      });
    } catch (e) {
      log(e.toString());
      log("notification not added");
    }
    return data;
  }

  Future<bool> acceptNotification(
      String id, String trainerName, Notifications noti) async {
    bool isDone = false;
    try {
      await _firestore
          .collection("Trainee")
          .where("Email", isEqualTo: noti.Email)
          .get()
          .then((value) async {
        for (var element in value.docs) {
          await _firestore.collection("Trainee").doc(element.id).update({
            //set new variables
            "Assigned Trainer": trainerName,
            "hasTrainer": true
          }).then((value) async {
            //adds notification collection with the name of the trainer
            log("assigned trainer name update to trainee");
            await _firestore
                .collection("Trainee")
                .doc(element.id)
                .collection("Notification")
                .add({
              "NameOfTrainer": trainerName,
              "typeOfNotification": "accept",
              "Reason": null
            }).then((value) async {
              log("notification collection added to trainee");
              //deletes the notification at the trainer screen
              isDone = await deleteNotification(id, noti);
              log("deleted " + isDone.toString());
            });
          });
        }
      });
    } catch (e) {
      log('$e');
      isDone = false;
    }
    log("at end" + isDone.toString());
    return isDone;
  }

  //called if the trainer declines trainee request from the notifications
  Future<bool> deleteNotification(String id, Notifications noti) async {
    bool isDone = false;
    try {
      log(noti.Age.toString());
      log(noti.Email.toString());
      log(noti.Name.toString());
      await _firestore
          .collection("Trainer/$id/Notification")
          .where("Email", isEqualTo: noti.Email)
          .where("Name", isEqualTo: noti.Name)
          .where("Age", isEqualTo: noti.Age)
          .get()
          .then((QuerySnapshot snapshot) {
        if (snapshot.docs.isNotEmpty) {
          // log(snapshot.docs[0].id);
          snapshot.docs[0].reference.delete();
          isDone = true;
        }
      });
    } catch (e) {
      log(e.toString());
      isDone = false;
      log("Notification not deleted");
    }
    return isDone;
  }

  //called when the trainer is deleting the trainee from the list of trainees
  Future<bool> addDeleteNotificationToTrainee(
      String trainerName, String traineeEmail, String reason) async {
    bool isDone = false;
    try {
      await _firestore
          .collection("Trainee")
          .where("Email", isEqualTo: traineeEmail)
          .get()
          .then((value) async {
        for (var element in value.docs) {
          await _firestore.collection("Trainee").doc(element.id).update({
            //set new variables
            "Assigned Trainer": "NoTrainer",
            "hasTrainer": false
          }).then((value) async {
            //adds notification collection with the name of the trainer
            log("assigned trainer name update to trainee");
            await _firestore
                .collection("Trainee")
                .doc(element.id)
                .collection("Notification")
                .add({
              "NameOfTrainer": trainerName,
              "typeOfNotification": "delete",
              "Reason": reason
            }).then((value) async {
              log("notification collection added to trainee");
            });
          });
        }
      });
    } catch (e) {
      log(e.toString());
    }
    return isDone;
  }

  Future<bool> addMessageToTrainee(
      String msg, String senderEmail, String traineeId, FieldValue time) async {
    bool isDone = false;
    try {
      await _firestore
          .collection("Trainee")
          .doc(traineeId)
          .collection("Messages")
          .add({"text": msg, "sender": senderEmail, "time": time}).then(
              (value) {
        isDone = true;
      });
    } catch (e) {
      log('$e');
    }
    return isDone;
  }

  Future<bool> deleteTraineePlan(String ID) async {
    bool isDone = false;
    bool isDone1 = false;
    bool isDone2 = false;
    bool isDone3 = false;
    bool isDone4 = false;
    int number = 0;
    int number1 = 0;
    int number2 = 0;
    int number3 = 0;
    int number4 = 0;

    try {
      await _firestore.collection('Trainee/$ID/Exercises').get().then((value) {
        number = value.docs.length;
      });
      await _firestore.collection('Trainee/$ID/Nutrition').get().then((value) {
        number1 = value.docs.length;
      });
      await _firestore
          .collection('Trainee/$ID/Supplements')
          .get()
          .then((value) {
        number2 = value.docs.length;
      });
      await _firestore.collection('Trainee/$ID/Messages').get().then((value) {
        number3 = value.docs.length;
      });
      await _firestore
          .collection('Trainee/$ID/Notification')
          .get()
          .then((value) {
        number4 = value.docs.length;
      });
      if (number > 0) {
        await _firestore
            .collection("Trainee/$ID/Exercises")
            .get()
            .then((snapshot) {
          List<DocumentSnapshot> allDocs = snapshot.docs;
          for (DocumentSnapshot ds in allDocs) {
            ds.reference.delete();
          }
        }).then((value) async {
          log("came here");
          isDone = true;
        });
      } else {
        isDone = true;
      }

      if (number1 > 0) {
        await _firestore
            .collection("Trainee/$ID/Nutrition")
            .get()
            .then((snapshot) {
          List<DocumentSnapshot> allDocs = snapshot.docs;
          for (DocumentSnapshot ds in allDocs) {
            ds.reference.delete();
          }
        }).then((value) async {
          log("came here 1");
          isDone1 = true;
        });
      } else {
        isDone1 = true;
      }

      if (number2 > 0) {
        await _firestore
            .collection("Trainee/$ID/Supplements")
            .get()
            .then((snapshot) {
          List<DocumentSnapshot> allDocs = snapshot.docs;
          for (DocumentSnapshot ds in allDocs) {
            ds.reference.delete();
          }
        }).then((value) async {
          log("came here 2");
          isDone2 = true;
        });
      } else {
        isDone2 = true;
      }

      if (number3 > 0) {
        await _firestore
            .collection("Trainee/$ID/Messages")
            .get()
            .then((snapshot) {
          List<DocumentSnapshot> allDocs = snapshot.docs;
          for (DocumentSnapshot ds in allDocs) {
            ds.reference.delete();
          }
        }).then((value) async {
          log("came here 3");
          isDone3 = true;
        });
      } else {
        isDone3 = true;
      }

      if (number4 > 0) {
        await _firestore
            .collection("Trainee/$ID/Notification")
            .get()
            .then((snapshot) {
          List<DocumentSnapshot> allDocs = snapshot.docs;
          for (DocumentSnapshot ds in allDocs) {
            ds.reference.delete();
          }
        }).then((value) async {
          log("came here 4");
          isDone4 = true;
        });
      } else {
        isDone4 = true;
      }

      if (isDone == true &&
          isDone1 == true &&
          isDone2 == true &&
          isDone3 == true &&
          isDone4 == true) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      log('$e' 'in delete Trainee Plan function');
      return false;
    }
  }

  Future<bool> deleteTraineeExercisesNutritionSupplements(String ID) async {
    bool isDone = false;
    bool isDone1 = false;
    bool isDone2 = false;

    int number = 0;
    int number1 = 0;
    int number2 = 0;

    try {
      await _firestore.collection('Trainee/$ID/Exercises').get().then((value) {
        number = value.docs.length;
      });
      await _firestore.collection('Trainee/$ID/Nutrition').get().then((value) {
        number1 = value.docs.length;
      });
      await _firestore
          .collection('Trainee/$ID/Supplements')
          .get()
          .then((value) {
        number2 = value.docs.length;
      });
      if (number > 0) {
        await _firestore
            .collection("Trainee/$ID/Exercises")
            .get()
            .then((snapshot) {
          List<DocumentSnapshot> allDocs = snapshot.docs;
          for (DocumentSnapshot ds in allDocs) {
            ds.reference.delete();
          }
        }).then((value) async {
          log("came here");
          isDone = true;
        });
      } else {
        isDone = true;
      }
      if (number1 > 0) {
        await _firestore
            .collection("Trainee/$ID/Nutrition")
            .get()
            .then((snapshot) {
          List<DocumentSnapshot> allDocs = snapshot.docs;
          for (DocumentSnapshot ds in allDocs) {
            ds.reference.delete();
          }
        }).then((value) async {
          log("came here 1");
          isDone1 = true;
        });
      } else {
        isDone1 = true;
      }

      if (number2 > 0) {
        await _firestore
            .collection("Trainee/$ID/Supplements")
            .get()
            .then((snapshot) {
          List<DocumentSnapshot> allDocs = snapshot.docs;
          for (DocumentSnapshot ds in allDocs) {
            ds.reference.delete();
          }
        }).then((value) async {
          log("came here 2");
          isDone2 = true;
        });
      } else {
        isDone2 = true;
      }

      if (isDone == true && isDone1 == true && isDone2 == true) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      log('e' 'in deleteTraineeExercisesNutritionSupplements function');
      return false;
    }
  }
}
