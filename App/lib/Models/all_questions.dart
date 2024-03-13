import 'package:maestro/Models/flag_question.dart';
import 'package:maestro/Models/multiple_choice.dart';
import 'package:maestro/Models/question.dart';
import 'package:maestro/Models/text_question.dart';
import 'package:maestro/Models/user.dart';

final multipleChoice = [
  MultipleChoiceQuestion(
    quizType: "Text",
    countryData: [
      [""]
    ],
    id: 1,
    title: "How many people live in Austria?",
    isLocked: false,
    describtion: "",
    options: [
      const Option(text: "8 Million", isCorrect: true),
      const Option(text: "9 Million", isCorrect: false),
      const Option(text: "10 Million", isCorrect: false),
      const Option(text: "7 Million", isCorrect: false),
    ],
  ),
  MultipleChoiceQuestion(
    quizType: "Text",
    countryData: [
      [""]
    ],
    id: 2,
    title: "Which of the following island is located in Amerika?",
    isLocked: false,
    describtion: "",
    options: [
      const Option(text: "St. Vincent", isCorrect: true),
      const Option(text: "Kap Verde", isCorrect: false),
      const Option(text: "Palau", isCorrect: false),
      const Option(text: "Malta", isCorrect: false),
    ],
  ),
];

final textQuestions = [
  TextQuestion(
    quizType: "Text",
    description: "dd",
    countryData: [
      [""]
    ],
    id: 3,
    title: "What is the biggest country in the world?",
    answers: ["Russland", "Russia"],
  ),
  TextQuestion(
    quizType: "Text",
    description: "dd",
    countryData: [
      [""]
    ],
    id: 4,
    title: "What is the smallest country in the world?",
    answers: ["Vatikan"],
  ),
  TextQuestion(
    quizType: "Text",
    description: "dd",
    countryData: [
      [""]
    ],
    id: 13,
    title: "Name all the countries?",
    answers: ["Austria", "Germany", "Uk", "Italy", "Spain", "France"],
  ),
];

final flagQuestions = [
  FlagQuestion(
    quizType: "Text",
    countryData: [
      [""]
    ],
    id: 101,
    continent: "Europe",
    title: "Flagge von Österreich",
    answers: ["Austria", "Österreich", "Oesterreich", "Osterreich"],
    picture: "assets/images/at.svg",
    tipps: [
      "Land der Berge",
      "Das gesuchte Land liegt im Herzen von Europa",
      "Spitzname: Klein-Deutschland"
    ],
  ),
  FlagQuestion(
    quizType: "Text",
    countryData: [
      [""]
    ],
    id: 102,
    continent: "Asia",
    title: "Flagge von Großbritannien",
    answers: ["Vereinigtes Königreich", "uk", "vk", "Großbritannien"],
    picture: "assets/images/gb.png",
    tipps: ["Haupstadt: London"],
  ),
  FlagQuestion(
    quizType: "Text",
    countryData: [
      [""]
    ],
    id: 103,
    continent: "Africa",
    title: "Flagge von Deutschland",
    answers: ["Deutschland", "Germany"],
    picture: "assets/images/de.png",
    tipps: [""],
  ),
  FlagQuestion(
    quizType: "Text",
    countryData: [
      [""]
    ],
    id: 104,
    continent: "Europe",
    title: "Flagge von Liechtenstein",
    answers: ["Liechtenstein"],
    picture: "assets/images/li.png",
    tipps: [],
  ),
  FlagQuestion(
    quizType: "Text",
    countryData: [
      [""]
    ],
    id: 105,
    continent: "Asia",
    title: "Flagge von Nepal",
    answers: ["Nepal"],
    picture: "assets/images/np.png",
    tipps: ["Haupstadt: Khatmandu"],
  ),
];

List<Question> getAllQuestion() {
  List<Question> allQuestions = [];

  for (TextQuestion t in textQuestions) {
    allQuestions.add(t);
  }

  for (MultipleChoiceQuestion m in multipleChoice) {
    allQuestions.add(m);
  }
  for (FlagQuestion t in flagQuestions) {
    allQuestions.add(t);
  }
  allQuestions.shuffle();
  return allQuestions;
}

List<String> getAllQuestionsTitle() {
  List<Question> allQuestions = getAllQuestion();
  List<String> allTitles = [];

  for (Question q in allQuestions) {
    allTitles.add(q.quizName);
  }
  return allTitles;
}

class LearnProgress {
  final int id;
  final int userId;
  final Map<Question, bool> questions;

  LearnProgress(
      {required this.id, required this.userId, required this.questions});
}

User userX = User(
    username: "Luca", password: "12345678", mail: "luca@gmail.com", score: 0);
/*
LearnProgress learnAllCountries = LearnProgress(
  id: 1,
  userId: 2,
  questions: getAllFlagsAndProgress(),
);
*/

Map<Question, bool> _allFlags = {for (var v in flagQuestions) v: false};

Map<Question, bool> getAllFlagsLearn() {
  return _allFlags;
}

Iterable<Question> getList() {
  return _allFlags.keys;
}

void setAllFlagsLearn(Question key, bool value) {
  _allFlags[key] = value;
}

Question getQuestionFromTitle(String title) {
  for (Question q in getAllQuestion()) {
    if (q.quizName.toLowerCase() == title.toLowerCase()) {
      return q;
    }
  }
  return textQuestions[0];
}

List<String> getAllContinents() {
  return [
    "Africa",
    "No",
    "Asia",
    "Australia",
    "Europe",
  ];
}
