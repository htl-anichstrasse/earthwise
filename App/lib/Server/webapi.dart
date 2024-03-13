import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:maestro/Models/user.dart';
import 'package:maestro/Server/constants.dart';
import 'package:maestro/Server/db.dart';

final String address = ApiConstants.url;

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
    return 'Anfrage fehlgeschlagen mit Statuscode: ${response.statusCode}';
  } on Exception {
    return "Server ist nicht erreichbar. Bitte versuchen Sie es später erneut.";
  }
}

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
  } on Exception {
    print("Error");
  }
  return {'Error': "Fehler"};
}

Future<void> setLevel(String mail, int level) async {
  try {
    final response = await http
        .get(Uri.parse('$address/increaselevel/$mail/$level'))
        .timeout(const Duration(seconds: 5), onTimeout: () {
      throw Exception();
    });

    final responseData = json.decode(response.body);
  } on Exception {
    print("SETLEVEL");
  }
}

Future<String?> setQuizHighscore(
    String mail, int id, int score, int achivablescore, int time) async {
  try {
    final response = await http
        .get(Uri.parse(
            '$address/setscore/$mail/$id/$score/$achivablescore/$time'))
        .timeout(const Duration(seconds: 5), onTimeout: () {
      throw Exception();
    });

    print(response.body);

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);

      if (responseData['message_type'] == 'Success') {
        print("PASSS");
        return null;
      } else if (responseData['message_type'] == 'Error') {
        return '${responseData['message']}';
      }
    }
  } on Exception {
    print("Error setQuizHighscore");
  }
  return null;
}

Future<void> setUserLevel() async {
  List<User> u = await DatabaseHelper.instance.getUsers();
  if (u.isNotEmpty) {
    setLevel(u[1].mail, u[1].score);
  }
}

// Defines an asynchronous function to fetch data from an API.
Future<String> getData(String path) async {
  // Stores the base URL from API constants.
  String address = ApiConstants.url;

  try {
    // Attempts to send a GET request to the constructed URL and sets a timeout of 5 seconds.
    final response = await http
        .get(Uri.parse('$address$path'))
        .timeout(const Duration(seconds: 5), onTimeout: () {
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
