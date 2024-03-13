import 'package:maestro/Models/question.dart';

class MultipleChoiceQuestion extends Question {
  final List<Option> options;
  Option? selectedOption;
  bool isLocked;

  MultipleChoiceQuestion({
    required id,
    required title,
    required describtion,
    required quizType,
    required countryData,
    required this.options,
    this.selectedOption,
    required this.isLocked,
  }) : super(
          quizId: id,
          quizName: title,
          description: describtion,
          quizType: quizType,
          countryData: countryData,
        );
}

class Option {
  final String text;
  final bool isCorrect;

  const Option({
    required this.text,
    required this.isCorrect,
  });
}
