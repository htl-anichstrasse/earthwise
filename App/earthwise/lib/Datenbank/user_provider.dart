import 'package:flutter/material.dart';
import 'package:earthwise/Datenbank/user.dart';
import 'package:earthwise/Datenbank/db.dart';
import 'package:earthwise/Server/internet.dart';
import 'package:earthwise/Server/webapi.dart';

// Provides user data and notifies listeners of changes
class UserProvider with ChangeNotifier {
  User? _user;

  // Getter for user, throws if _user is null
  User get user => _user!;

  // Sets the user and notifies listeners
  void setUser(User user) {
    _user = user;
  }
}

// Updates the highscore for a user, either online or in the local database
Future<void> setHighscore(String mail, int id, int percent, int time) async {
  int level = calculateLevel(percent, time);
  if (await hasInternetConnection()) {
    setLevel(mail, level);
    setQuizHighscore(mail, id, percent, 100, time);
  } else {
    setHighscoreDB(id, percent, time);
  }
  DatabaseHelper.instance.updateUserLevel(mail, level);
}

// Calculates the level based on percent and time
int calculateLevel(int percent, int time) {
  int level = 0;
  if (percent == 100) {
    level += 500;
    level += 600 - time;
  } else {
    level += (500 * percent / 100).round();
  }

  return level;
}

// Updates the highscore in the local database
Future<void> setHighscoreDB(int id, int percent, int time) async {
  Map<String, dynamic>? data = await DatabaseHelper.instance.getQuizById(id);

  if (data == null) {
    await DatabaseHelper.instance.insertQuiz(id, percent, time);
  } else {
    int? savedScore = data["percent"];
    if (savedScore != null) {
      if (savedScore > percent) {
        await DatabaseHelper.instance.updateQuiz(id, percent, time);
      }
    }
  }
}

// Saves local highscores to the database
Future<void> saveDBHighscore(String mail) async {
  List<Map<String, dynamic>>? data =
      await DatabaseHelper.instance.getQuizHighscores();

  if (data != null) {
    for (Map<String, dynamic> d in data) {
      setHighscore(mail, d["quizid"], d["percent"], d["time"]);
    }
  }
}
