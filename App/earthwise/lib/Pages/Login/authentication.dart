import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static const String _loggedInKey = 'loggedIn';

  // Sign in user and update the loggedIn status to true
  static Future<void> signIn() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_loggedInKey, true);
  }

  // Sign out user and update the loggedIn status to false
  static Future<void> signOut() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_loggedInKey, false);
  }

  // Check if the user is currently logged in
  static Future<bool> isUserLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_loggedInKey) ?? false;
  }
}
