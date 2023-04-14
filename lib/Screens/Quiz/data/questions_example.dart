import 'package:boost_pt_new/Screens/Quiz/model/question_model.dart';

List<QuestionModel> questions = [
  QuestionModel(
    "Which assessment cannot determine actual body fat composition?",
    {
      "Skinfold Measurements": false,
      "Hydrostatic Weighing": false,
      "BMI": true,
      "Bioelectrical Impedance Analysis": false,
    },
  ),
  QuestionModel("Dynamic stretches should be held for at least 30 seconds.", {
    "true": false,
    "false": true,
  }),
  QuestionModel("Which of the following is not a complex carbohydrate?", {
    "Brown Rice": false,
    "Millet": false,
    "Maltose": true,
    "Buckwheat": false,
  }),
  QuestionModel("Which of the following isn't necessary for a healthy diet?", {
    "Milk": false,
    "Grains": false,
    "Multivitamins": true,
    "Vegetables": false,

  }),
  QuestionModel("What does a goniometer measure?", {
    "Range of movement": true,
    "Strength": false,
    "Load": false,
    "BMI": false,

  }),

];
