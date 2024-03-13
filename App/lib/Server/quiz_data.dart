import 'dart:convert';
import 'dart:io';
import 'package:maestro/Models/country.dart';
import 'package:maestro/Server/constants.dart';
import 'package:maestro/Server/webapi.dart';
import 'package:path_provider/path_provider.dart';

class QuizData {
  final int id;
  final String name;
  final String description;
  final QuizType type;
  final List data;

  QuizData({
    required this.id,
    required this.name,
    required this.description,
    required this.type,
    required this.data,
  });
}

class QuizManager {
  QuizManager._privateConstructor();

  static final QuizManager _instance = QuizManager._privateConstructor();

  static QuizManager get instance => _instance;

  bool setting = true;
  List<QuizData> _quizzes = [];
  Map<String, List<String>> _spellings = {};
  List<QuizData> _flagQuizzes = [];

  void loadQuizzes() async {
    _quizzes = await convertDataToQuiz();
  }

  void loadFlagQuiz() async {
    _flagQuizzes = await getAllQuizType(QuizType.flagquiz);
  }

  void loadAllSpellings() async {
    _spellings = await getAllSpellings(setting);
  }

  List<QuizData> get quizzes => _quizzes;
  List<QuizData> get flagQuizzes => _flagQuizzes;
  Map<String, List<String>> get spellings => _spellings;

  Future<List<QuizData>> getAllQuizType(QuizType type) async {
    List<QuizData> quizzes = [];

    List<QuizData> data = getAllData();

    if (data.isNotEmpty) {
      for (QuizData d in data) {
        if (d.type == type) {
          quizzes.add(d);
        }
      }
    }

    return quizzes;
  }

  Future<List?> getAllQuiz() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/${TextConstants.quizData}');
      if (await file.exists()) {
        String contents = await file.readAsString();
        return json.decode(contents);
      }
    } catch (e) {
      return null;
    }
    return null;
  }

  Future<Map<String, List<String>>> getAllSpellings(bool setting) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/${TextConstants.spellings}');
      if (await file.exists()) {
        String contents = await file.readAsString();
        final Map<String, dynamic> decodedMap = json.decode(contents);
        final Map<String, List<String>> spellingsMap =
            decodedMap.map((key, dynamic value) {
          return MapEntry(key, List<String>.from(value));
        });
        return spellingsMap;
      }
    } catch (e) {
      print(e);
      return {};
    }

    return {};
  }

  QuizType getQuizType(String type) {
    if (type == 'mapquiz') {
      return QuizType.mapquiz;
    } else if (type == 'flagquiz') {
      return QuizType.flagquiz;
    } else if (type == 'tablequiz') {
      return QuizType.tablequiz;
    } else if (type == 'neighboringcountries') {
      return QuizType.neighboringcountries;
    }
    return QuizType.quiz;
  }

  Future<List<QuizData>> convertDataToQuiz() async {
    var rawData = await getAllQuiz();

    List<QuizData> quizList = [];

    if (rawData != null) {
      for (var quiz in rawData) {
        QuizType type = getQuizType(quiz['quiz_type']);
        if (type != QuizType.neighboringcountries) {
          QuizData quizData = QuizData(
            id: quiz['quiz_id'],
            name: quiz['quiz_name'],
            description: quiz['description'],
            type: type,
            data: List.from(quiz['country_data']),
          );

          quizList.add(quizData);
        }
      }
    }

    return quizList;
  }
}

Future<bool> saveData(String address, String path) async {
  try {
    // Fetches data from the given address.
    String data = await getData(address);

    // Checks if the fetched data is not empty.
    if (data.isNotEmpty) {
      // Gets the application's documents directory.
      final directory = await getApplicationDocumentsDirectory();

      // Creates a file in the directory with the specified path.
      final file = File('${directory.path}/$path');

      // Writes the fetched data to the file.
      await file.writeAsString(data);

      // Returns true if data was successfully saved.
      return true;
    } else {
      // Returns false if the fetched data is empty.
      return false;
    }
  } catch (e) {
    // Returns false if any error occurs during the process.
    return false;
  }
}

enum QuizType {
  quiz,
  mapquiz,
  flagquiz,
  tablequiz,
  neighboringcountries,
}

List<QuizData> getAllData() {
  List<QuizData> data = QuizManager.instance.quizzes;
  if (data.isEmpty) {
    QuizManager.instance.loadQuizzes();
    data = QuizManager.instance.quizzes;
    if (data.isEmpty) {
      QuizManager.instance.setting = false;
    }
  }
  return data;
}

Map<String, List<String>> getAllSpellings() {
  Map<String, List<String>> data = QuizManager.instance.spellings;
  if (data.isEmpty) {
    QuizManager.instance.loadAllSpellings();
    data = QuizManager.instance.spellings;
    if (data.isEmpty) {
      QuizManager.instance.setting = false;
    }
  }
  return data;
}

List<QuizData> getAllFlagQuizzes() {
  List<QuizData> data = QuizManager.instance.flagQuizzes;
  if (data.isEmpty) {
    QuizManager.instance.loadFlagQuiz();
    data = QuizManager.instance.flagQuizzes;
    if (data.isEmpty) {
      QuizManager.instance.setting = false;
    }
  }
  return data;
}

QuizData? getFlagQuizWorld() {
  List<QuizData> data = getAllFlagQuizzes();
  for (QuizData quiz in data) {
    if (quiz.id == 8) {
      return quiz;
    }
  }
  return null;
}

List<String> getAllQuizTitles() {
  List<QuizData> data = getAllData();
  print(data.length);
  return data.map((quiz) => quiz.name).toList();
}

String? checkAnswer(String answer, List questionData) {
  // Retrieves all possible spellings for comparison.
  Map<String, List<String>> spellings = getAllSpellings();

  // Iterates over each question data key.
  for (String key in questionData) {
    // Finds the list of valid spellings for the current key.
    List<String>? spellingList = spellings[key.toUpperCase()];

    // If valid spellings exist, checks the answer against each.
    if (spellingList != null) {
      for (String s in spellingList) {
        // If a matching spelling is found, returns the key.
        if (answer.toLowerCase() == s.toLowerCase()) {
          return key;
        }
      }
    }
  }
  // Returns null if no matching spelling is found.
  return null;
}

Future<int?> getQuizId(QuizType type, Continent continent) async {
  List<QuizData> quizzes = await QuizManager.instance.getAllQuizType(type);
  List<String> data = getQuestions(continent);
  data.sort();

  for (QuizData d in quizzes) {
    int index = 0;

    for (String s in d.data) {
      if (data.contains(s)) {
        index++;
      }
    }

    if ((index > 9) && (d.data.length - data.length < 50)) {
      return d.id;
    }
  }
  return null;
}

Future<String> getQuizName(QuizType type, Continent continent) async {
  List<QuizData> quizzes = await QuizManager.instance.getAllQuizType(type);
  List<String> data = getQuestions(continent);
  data.sort();

  for (QuizData d in quizzes) {
    int index = 0;

    for (String s in d.data) {
      if (data.contains(s)) {
        index++;
      }
      if (index > 9) {
        return d.name;
      }
    }
  }
  return "";
}

int getQuizTableId(Continent continent) {
  switch (continent) {
    case Continent.world:
      return 21;
    case Continent.oceania:
      return 21;
    case Continent.asia:
      return 17;
    case Continent.africa:
      return 20;
    case Continent.europe:
      return 16;
    case Continent.northAmerica:
      return 18;
    case Continent.southAmerica:
      return 19;
  }
}

Future<QuizData> getQuizTable(int id) async {
  List<QuizData> quizzes =
      await QuizManager.instance.getAllQuizType(QuizType.tablequiz);
  for (QuizData quiz in quizzes) {
    if (id == quiz.id) {
      return quiz;
    }
  }
  return quizzes[1];
}
