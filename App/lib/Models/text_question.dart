import 'package:maestro/Models/question.dart';

class TextQuestion extends Question {
  final List answers;

  TextQuestion(
      {required id,
      required title,
      required description,
      required this.answers,
      required quizType,
      required countryData})
      : super(
            quizId: id,
            quizName: title,
            description: "SSSS",
            quizType: quizType,
            countryData: countryData);
}
