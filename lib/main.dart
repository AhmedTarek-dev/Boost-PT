// ignore_for_file: prefer_const_constructors
import 'package:boost_pt_new/Screens/ContactUsScreen.dart';
import 'package:boost_pt_new/Screens/LoadingScreen.dart';
import 'package:boost_pt_new/Screens/Login.dart';
import 'package:boost_pt_new/Screens/PrivacyScreen.dart';
import 'package:boost_pt_new/Screens/TraineeScreens/profile_Screen.dart';
import 'package:boost_pt_new/Screens/SettingsScreen.dart';
import 'package:boost_pt_new/Screens/TraineeScreens/ListOfTrainers.dart';
import 'package:boost_pt_new/Screens/TraineeScreens/NutritionScreen.dart';
import 'package:boost_pt_new/Screens/TraineeScreens/SupplementsScreen.dart';
import 'package:boost_pt_new/Screens/TraineeScreens/TraineeDrawerScreen.dart';
import 'package:boost_pt_new/Screens/TraineeScreens/ViewTrainerScreen.dart';
import 'package:boost_pt_new/Screens/TrainerScreens/ExercisesDisplayedForTrainerHomeScreen/Back.dart';
import 'package:boost_pt_new/Screens/TrainerScreens/ExercisesDisplayedForTrainerHomeScreen/Legs.dart';
import 'package:boost_pt_new/Screens/TrainerScreens/ListOfTrainees.dart';
import 'package:boost_pt_new/Screens/TrainerScreens/NutritionDisplayed%20ForTrainerHomeScreen/Carbohydrates.dart';
import 'package:boost_pt_new/Screens/TrainerScreens/NutritionDisplayed%20ForTrainerHomeScreen/Fats.dart';
import 'package:boost_pt_new/Screens/TrainerScreens/NutritionDisplayed%20ForTrainerHomeScreen/Protein.dart';
import 'package:boost_pt_new/Screens/TrainerScreens/SupplementsDisplayed%20ForTrainerHomeScreen/MassGainerSupplement.dart';
import 'package:boost_pt_new/Screens/TrainerScreens/SupplementsDisplayed%20ForTrainerHomeScreen/ProteinSupplement.dart';
import 'package:boost_pt_new/Screens/TrainerScreens/TraineeInterface/TraineeExercises.dart';
import 'package:boost_pt_new/Screens/TrainerScreens/TraineeInterface/TraineeHomePage.dart';
import 'package:boost_pt_new/Screens/TrainerScreens/TraineeInterface/TraineeNutrition.dart';
import 'package:boost_pt_new/Screens/TrainerScreens/TraineeInterface/TraineeSupplements.dart';
import 'package:boost_pt_new/Screens/chatScreen.dart';
import 'package:boost_pt_new/Screens/TrainerScreens/trainerProfileScreen.dart';
import 'package:boost_pt_new/Screens/WelcomeScreen.dart';
import 'package:boost_pt_new/Screens/pendingScreen/PendingScreen.dart';
import 'package:boost_pt_new/Screens/verifyEmailOTP.dart';
import 'package:boost_pt_new/firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:boost_pt_new/FirebaseAuth/auth.dart';
import 'package:boost_pt_new/Screens/chooseSignUp.dart';
import 'package:boost_pt_new/Screens/Quiz/screen/quizz_screen.dart';
import 'package:boost_pt_new/Screens/Register.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:boost_pt_new/Screens/TrainerScreens/TrainerDrawerScreen.dart';
import 'package:boost_pt_new/Screens/TraineeScreens/TraineeHomeScreen.dart';
import 'Screens/FeedBackScreen.dart';
import 'Screens/TraineeScreens/ExercisesScreen.dart';
import 'Screens/TrainerScreens/ExercisesDisplayedForTrainerHomeScreen/Abs.dart';
import 'Screens/TrainerScreens/ExercisesDisplayedForTrainerHomeScreen/Arms.dart';
import 'Screens/TrainerScreens/ExercisesDisplayedForTrainerHomeScreen/Chest.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  // log('Initialized default app $app');
  runApp(MyApp());
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => FireStoreDatabase(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          dividerColor: Colors.black,
        ),
        home: const LoadingScreen(),
        routes: {
          TrainerDrawerScreen.id: (context) => TrainerDrawerScreen(),
          TrainerProfileScreen.id: (context) => TrainerProfileScreen(),
          TraineeHomeScreen.id: (context) => TraineeHomeScreen(),
          TraineeHomePageScreen.id: (context) => TraineeHomePageScreen(),
          TraineeExercises.id: (context) => TraineeExercises(),
          TraineeNutrition.id: (context) => TraineeNutrition(),
          TraineeSupplements.id: (context) => TraineeSupplements(),
          ListOfTrainees.id: (context) => ListOfTrainees(),
          LoginScreen.id: (context) => LoginScreen(),
          RegisterScreen.id: (context) =>
              RegisterScreen(0), //sent 0 as initial value
          VerifyEmailOTP.id: (context) => VerifyEmailOTP(),
          WelcomeScreen.id: (context) => WelcomeScreen(),

          ChatScreen.id: (context) => ChatScreen(),

          //screen of exercises of trainer home screen
          BackExercisesTrainerHomeScreen.id: (context) =>
              BackExercisesTrainerHomeScreen(),
          ChestExercisesTrainerHomeScreen.id: (context) =>
              ChestExercisesTrainerHomeScreen(),
          ArmsExercisesTrainerHomeScreen.id: (context) =>
              ArmsExercisesTrainerHomeScreen(),
          AbsExercisesTrainerHomeScreen.id: (context) =>
              AbsExercisesTrainerHomeScreen(),
          LegsExercisesTrainerHomeScreen.id: (context) =>
              LegsExercisesTrainerHomeScreen(),
          //screen of nutrition of trainer home screen
          ProteinScreen.id: (context) => ProteinScreen(),
          CarbohydratesScreen.id: (context) => CarbohydratesScreen(),
          FatsScreen.id: (context) => FatsScreen(),
          //screen of Supplements of trainer home screen
          ProteinSupplementScreen.id: (context) => ProteinSupplementScreen(),
          MassGainerSupplementScreen.id: (context) =>
              MassGainerSupplementScreen(),

          // LoadingScreen.id: (context) => LoadingScreen(),
          // Tutorial.id: (context) => Tutorial(),
          // OTPphone.id: (context) => OTPphone(),
          ProfileScreen.id: (context) => ProfileScreen(),
          ContactUsScreen.id: (context) => ContactUsScreen(),
          SettingsScreen.id: (context) => SettingsScreen(),
          PrivacyScreen.id: (context) => PrivacyScreen(),
          FeedBackScreen.id: (context) => FeedBackScreen(),
          TraineeDrawerScreen.id: (context) => TraineeDrawerScreen(),
          NutritionScreen.id: (context) => NutritionScreen(),
          ViewTrainerScreen.id: (context) => ViewTrainerScreen(),
          SupplementsScreen.id: (context) => SupplementsScreen(),
          ExercisesScreen.id: (context) => ExercisesScreen(),
          ListOfTrainers.id: (context) => ListOfTrainers(),
          PendingScreen.id: (context) => PendingScreen(),
          ChooseSignUp.id: (context) => ChooseSignUp(),
          QuizScreen.id: (context) => const QuizScreen(),
        },
      ),
    );
  }
}
