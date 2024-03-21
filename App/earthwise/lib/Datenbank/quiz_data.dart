import 'dart:convert';
import 'dart:io';
import 'package:earthwise/Pages/QuizPages/Mapquiz/map/country.dart';
import 'package:earthwise/Server/constants.dart';
import 'package:earthwise/Server/webapi.dart';
import 'package:path_provider/path_provider.dart';

// Defines the structure for quiz data
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

// Manages quizzes, including loading and organizing them
class QuizManager {
  QuizManager._privateConstructor();

  static final QuizManager _instance = QuizManager._privateConstructor();

  static QuizManager get instance => _instance;

  bool setting = true;
  List<QuizData> _quizzes = [];
  Map<String, List<String>> _spellings = {};
  List<QuizData> _flagQuizzes = [];

  // Loads quiz data
  void loadQuizzes() async {
    _quizzes = await convertDataToQuiz();
  }

  // Loads flag quizzes specifically
  void loadFlagQuiz() async {
    _flagQuizzes = await getAllQuizType(QuizType.flagquiz);
  }

  // Loads all spelling variations for quizzes
  void loadAllSpellings() async {
    _spellings = await getAllSpellings(setting);
  }

  // Getter for quizzes
  List<QuizData> get quizzes => _quizzes;

  // Getter for flag quizzes
  List<QuizData> get flagQuizzes => _flagQuizzes;

  // Getter for spellings
  Map<String, List<String>> get spellings => _spellings;

  // Fetches all quizzes of a specific type
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

  // Retrieves all quiz data from storage
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

  // Fetches all spelling variations from storage
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
      return {};
    }

    return {};
  }

  // Converts a string type to QuizType enum
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

  // Converts raw data into a list of QuizData objects
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

// Saves the data in a local file
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

// Enum defining different quiz types
enum QuizType {
  quiz,
  mapquiz,
  flagquiz,
  tablequiz,
  neighboringcountries,
  scq,
}

// Returns a list of all available quizzes
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

// Returns a map of all spellings for comparison in quizzes
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

// Returns a list of all flag quizzes
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

// Finds and returns a specific flag quiz about the world
QuizData? getFlagQuizWorld() {
  List<QuizData> data = getAllFlagQuizzes();
  for (QuizData quiz in data) {
    if (quiz.id == 8) {
      return quiz;
    }
  }
  return null;
}

// Returns a list of titles from all quizzes
List<String> getAllQuizTitles() {
  List<QuizData> data = getAllData();
  return data.map((quiz) => quiz.name).toList();
}

// Checks if a given answer is correct based on question data and spellings
String? checkAnswer(String answer, List questionData) {
  Map<String, List<String>> spellings = getAllSpellings();
  for (String key in questionData) {
    List<String>? spellingList = spellings[key.toUpperCase()];
    if (spellingList != null) {
      for (String s in spellingList) {
        if (answer.toLowerCase() == s.toLowerCase()) {
          return key;
        }
      }
    }
  }
  return null;
}

// Retrieves the ID of a quiz based on its type and the continent it covers
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

// Finds and returns the name of a quiz by its ID
Future<String> getQuizNameById(int id) async {
  List<QuizData> quizzes = await QuizManager.instance.convertDataToQuiz();
  if (quizzes.isNotEmpty) {
    for (QuizData q in quizzes) {
      if (q.id == id) {
        return q.name;
      }
    }
  }
  return "";
}

// Checks if a quiz is relevant to a specific continent
bool checkQuizContinent(Continent continent, QuizData quiz) {
  List<String> data = getQuestions(continent);
  data.sort();
  int index = 0;

  for (String s in quiz.data) {
    if (data.contains(s)) {
      index++;
    }
    if (index > 9) {
      return true;
    }
  }
  return false;
}

// Returns the name of a quiz based on its type and continent
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

// Determines the ID of a quiz table based on the continent
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

// Fetches a specific quiz table based on its ID
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
