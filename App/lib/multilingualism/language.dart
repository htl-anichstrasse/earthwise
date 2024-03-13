import 'package:flag/flag_enum.dart';

class Language {
  final int id;
  final FlagsCode flag;
  final String name;
  final String languageCode;
  final String flagPath;

  Language(this.id, this.flag, this.name, this.languageCode, this.flagPath);

  static List<Language> languageList() {
    return <Language>[
      Language(1, FlagsCode.GB, "English", "en", "assets/images/gb.png"),
      Language(2, FlagsCode.DE, "Deutsch", "de", "assets/images/de.png"),
    ];
  }
}
