import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:earthwise/Datenbank/user.dart';
import 'package:earthwise/Server/constants.dart';
import 'package:earthwise/Datenbank/db.dart';

final String address = ApiConstants.url;

// Method for the Login
Future<String?> loginUser(String email, String password) async {
  try {
    final response = await http
        .get(Uri.parse('$address/login/$email/$password'))
        .timeout(const Duration(seconds: 7), onTimeout: () {
      throw Exception();
    });

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);

      if (responseData['message_type'] == 'Success') {
        return null;
      } else if (responseData['message_type'] == 'Error') {
        return '${responseData['message']}';
      }
    }
    return "Server ist nicht erreichbar. Bitte versuchen Sie es später erneut.";
  } on Exception {
    return "Server ist nicht erreichbar. Bitte versuchen Sie es später erneut.";
  }
}

// Method to delete the User
Future<String?> deleteUser(String email, String password) async {
  try {
    final response = await http
        .get(Uri.parse('$address/deleteuser/$email/$password'))
        .timeout(const Duration(seconds: 7), onTimeout: () {
      throw Exception();
    });

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);

      if (responseData['message_type'] == 'Success') {
        return null;
      } else if (responseData['message_type'] == 'Error') {
        return '${responseData['message']}';
      }
    }
    return "Server ist nicht erreichbar. Bitte versuchen Sie es später erneut.";
  } on Exception {
    return "Server ist nicht erreichbar. Bitte versuchen Sie es später erneut.";
  }
}

// Method to create a new User
Future<String?> createUser(
    String email, String username, String password) async {
  try {
    final response = await http
        .get(Uri.parse('$address/createnewuser/$email/$username/$password'))
        .timeout(const Duration(seconds: 5), onTimeout: () {
      throw Exception();
    });

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);

      if (responseData['message_type'] == 'Success') {
        return null;
      } else if (responseData['message_type'] == 'Error') {
        return '${responseData['message']}';
      }
    }
    return 'Anfrage fehlgeschlagen mit Statuscode: ${response.statusCode}';
  } on Exception {
    return "Server ist nicht erreichbar. Bitte versuchen Sie es später erneut.";
  }
}

// Method to fetch the username and level
Future<Map<String, dynamic>> getUserData(String email) async {
  try {
    final response = await http
        .get(Uri.parse('$address/getusernameandlevel/$email'))
        .timeout(const Duration(seconds: 5), onTimeout: () {
      throw Exception();
    });
    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);

      return responseData;
    }
  } on Exception {}
  return {'Error': "Fehler"};
}

// Method to fetch the highscores
Future<List<dynamic>?> getHighscores(String email) async {
  try {
    final response = await http
        .get(Uri.parse('$address/getallscores/$email'))
        .timeout(const Duration(seconds: 5), onTimeout: () {
      throw Exception();
    });
    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      return responseData;
    }
  } on Exception {
    return null;
  }
  return null;
}

// Method to increase the level of the user
Future<bool> setLevel(String mail, int level) async {
  try {
    final response = await http
        .get(Uri.parse('$address/increaselevel/$mail/$level'))
        .timeout(const Duration(seconds: 5), onTimeout: () {
      throw Exception();
    });
    if (response.statusCode == 200) {
      return true;
    }
  } on Exception {
    return false;
  }
  return false;
}

// Method to change the password
Future<bool> setPWD(String mail, String oldPWD, String newPWD) async {
  try {
    final response = await http
        .get(Uri.parse('$address/changepassword/$mail/$oldPWD/$newPWD'))
        .timeout(const Duration(seconds: 5), onTimeout: () {
      throw Exception();
    });

    if (response.statusCode == 200) {
      return true;
    }
  } on Exception {
    return false;
  }
  return false;
}

// Method to change the Username
Future<bool> setUsername(String mail, String username, String pwd) async {
  try {
    final response = await http
        .get(Uri.parse('$address/changeusername/$mail/$pwd/$username'))
        .timeout(const Duration(seconds: 5), onTimeout: () {
      throw Exception();
    });
    if (response.statusCode == 200) {
      return true;
    }
  } on Exception {
    return false;
  }
  return false;
}

// Method to set a quiz highscore
Future<String?> setQuizHighscore(
    String mail, int id, int score, int achivablescore, int time) async {
  try {
    final response = await http
        .get(Uri.parse(
            '$address/setscore/$mail/$id/$score/$achivablescore/$time'))
        .timeout(const Duration(seconds: 5), onTimeout: () {
      throw Exception();
    });

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);

      if (responseData['message_type'] == 'Success') {
        return null;
      } else if (responseData['message_type'] == 'Error') {
        return '${responseData['message']}';
      }
    }
  } on Exception {}
  return null;
}

// Method to set the level of the User
Future<void> setUserLevel() async {
  List<User> u = await DatabaseHelper.instance.getUsers();
  if (u.isNotEmpty) {
    setLevel(u[1].mail, u[1].score);
  }
}

// Defines an asynchronous function to fetch data from an API.
Future<String> getData(String path) async {
  // Stores the base URL from API constants.
  try {
    // Attempts to send a GET request to the constructed URL and sets a timeout of 5 seconds.
    final response = await http
        .get(Uri.parse('$address$path'))
        .timeout(const Duration(seconds: 30), onTimeout: () {
      // Throws an exception if the request times out.
      throw Exception();
    });

    // Checks if the HTTP status code is 200 (OK), indicating a successful response.
    if (response.statusCode == 200) {
      // Returns the response body if the status code is 200.
      return response.body;
    }
  } on Exception {
    // Catches any exceptions and returns an empty string as a fallback.

    return "";
  }
  // Returns an empty string if the condition for statusCode == 200 is not met.
  return "";
}
