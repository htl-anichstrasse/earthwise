import 'package:flutter/material.dart';
import 'package:maestro/Models/user.dart';
import 'package:maestro/Server/db.dart';
import 'package:maestro/Server/internet.dart';
import 'package:maestro/Server/webapi.dart';

class UserProvider with ChangeNotifier {
  User? _user;

  User get user => _user!;

  void setUser(User user) {
    _user = user;
    notifyListeners();
  }
}

Future<void> setHighscore(String mail, int id, int percent, int time) async {
  if (await hasInternetConnection()) {
    setUserLevelInternet(mail, calculateLevel(percent, time));
    setQuizHighscore(mail, id, percent, 100, time);
  } else {
    setHighscoreDB(id, percent, time);
  }
  DatabaseHelper.instance.updateUserLevel(mail, calculateLevel(percent, time));
}

int calculateLevel(int percent, int time) {
  return 1000;
}

Future<void> setUserLevelInternet(String mail, int increase) async {
  try {
    Map<String, dynamic> user = await getUserData(mail);
    int? level = user["level"];
    if (level != null) {
      setLevel(mail, level + increase);
    }
  } catch (Exception) {
    print("Errors bei User Level");
  }
}

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

Future<void> saveDBHighscore(String mail) async {
  List<Map<String, dynamic>>? data =
      await DatabaseHelper.instance.getQuizHighscores();

  if (data != null) {
    for (Map<String, dynamic> d in data) {
      setHighscore(mail, d["quizid"], d["percent"], d["time"]);
    }
  }
}
