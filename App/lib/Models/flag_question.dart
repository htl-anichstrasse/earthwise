import 'package:maestro/Models/text_question.dart';

class FlagQuestion extends TextQuestion {
  final String picture;
  final List<String> tipps;
  final String continent;

  FlagQuestion(
      {required id,
      required title,
      text,
      required this.continent,
      required answers,
      required this.tipps,
      required this.picture,
      required quizType,
      required countryData})
      : super(
            id: id,
            title: title,
            description: text,
            answers: answers,
            quizType: quizType,
            countryData: countryData);
}
