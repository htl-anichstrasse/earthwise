import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

const String lCode = 'languageCode';

// Language codes
const String english = 'en';
const String deutsch = 'de';

// Sets and saves the locale based on the language code
Future<Locale> setLocale(String languageCode) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString(
      lCode, languageCode); // Save language code to SharedPreferences
  return _locale(languageCode); // Return the Locale object
}

// Retrieves the locale from SharedPreferences, defaults to English
Future<Locale> getLocale() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String languageCode = prefs.getString(lCode) ??
      english; // Get saved language code, default to 'en'
  return _locale(languageCode); // Return the Locale object
}

// Returns a Locale object based on the language code
Locale _locale(String languageCode) {
  switch (languageCode) {
    case english:
      return const Locale(english, ''); // Locale for English
    case deutsch:
      return const Locale(deutsch, ""); // Locale for German
    default:
      return const Locale(
          english, ''); // Default to English if language code is unrecognized
  }
}

// Utility function to access localized strings
AppLocalizations translation(BuildContext context) {
  return AppLocalizations.of(
      context)!; // Access localized strings using AppLocalizations
}
