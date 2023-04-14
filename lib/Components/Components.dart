// ignore_for_file: non_constant_identifier_names

import 'package:flutter/cupertino.dart';

class Exercises {
  String? Name;
  String? Type;
  String? Image;
  String? Description;
  String? sets;
  String? reps;
  String? day;

  Exercises(
      {this.Name,
      this.Type,
      this.Image,
      this.Description,
      this.sets,
      this.reps,
      this.day});
}

class Nutrition {
  String? Name;
  String? Type;
  String? Image;
  String? Description;
  String? Calories;
  String? Measure;
  String? Category;
  String? day;

  Nutrition({
    this.Name,
    this.Type,
    this.Image,
    this.Description,
    this.Calories,
    this.Measure,
    this.Category,
    this.day,
  });
}

class Supplements {
  String? Name;
  String? Type;
  String? Image;
  String? Description;
  String? Dose;
  String? day;

  Supplements(
      {this.Name,
      this.Type,
      this.Image,
      this.Description,
      this.Dose,
      this.day});
}

class Users {
  String? Name;
  String? Email;
  String? Date_Of_Birth;
  String? PhoneNo;
  String? Gender;
  String? Age;
  String? isTrainer;
  String? ID;

  Users(
      {this.Name,
      this.Email,
      this.Date_Of_Birth,
      this.PhoneNo,
      this.Gender,
      this.Age,
      this.isTrainer,
      this.ID});
}

class Trainer {
  String? Name;
  String? Email;
  String? Image;
  String? PhoneNo;
  bool? isPhoneVerified;
  String? Gender;
  String? Rating;
  String? NoOfRatings;
  String? Bio;
  String? Age;
  String? ID;

  Trainer(
      {this.Name,
      this.Email,
      this.Image,
      this.PhoneNo,
      this.isPhoneVerified,
      this.Gender,
      this.Rating,
      this.NoOfRatings,
      this.Bio,
      this.Age,
      this.ID});
}

class Trainee {
  String? Name;
  String? Email;
  String? Image;
  String? PhoneNo;
  String? AssignedTrainer;
  bool? isPhoneVerified;
  String? Gender;
  String? Status;
  String? LastSeen;
  String? Age;
  String? ID;

  Trainee(
      {this.Name,
      this.Email,
      this.Image,
      this.PhoneNo,
      this.AssignedTrainer,
      this.isPhoneVerified,
      this.Gender,
      this.Status,
      this.LastSeen,
      this.Age,
      this.ID});
}

class DrawerButtons {
  final String? title;
  final IconData? icon;

  const DrawerButtons(this.title, this.icon);
}

class Notifications {
  String? Name;
  String? Email;
  String? Age;
  String? ID;
  String? Reason;
  String? TypeOfNotification;

  Notifications(
      {this.Name,
      this.Email,
      this.Age,
      this.ID,
      this.Reason,
      this.TypeOfNotification});
}
