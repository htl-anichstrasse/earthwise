import 'package:flag/flag_enum.dart';

class Language {
  final int id;
  final FlagsCode flag; // Enum for flag code from 'flag' package
  final String name; // Name of the language
  final String languageCode; // Language code (e.g., 'en', 'de')
  final String flagPath; // Path to the flag image in assets

  // Constructor to create a Language instance with all required fields
  Language(this.id, this.flag, this.name, this.languageCode, this.flagPath);

  // Static method to return a list of Language objects
  static List<Language> languageList() {
    return <Language>[
      Language(1, FlagsCode.GB, "English", "en",
          "assets/images/gb.png"), // English language entry
      Language(2, FlagsCode.DE, "Deutsch", "de",
          "assets/images/de.png"), // German language entry
    ];
  }
}
