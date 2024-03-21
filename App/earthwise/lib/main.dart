import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:earthwise/Server/constants.dart';
import 'package:earthwise/Datenbank/db.dart';
import 'package:earthwise/Datenbank/quiz_data.dart';
import 'package:earthwise/Datenbank/user_provider.dart';
import 'package:earthwise/multilingualism/language_constants.dart';
import 'package:earthwise/router/custom_router.dart';
import 'package:earthwise/router/route_constants.dart';
import 'package:provider/provider.dart';
import 'package:sqflite/sqflite.dart';

// Entry point of the application
void main() async {
  // Ensure Flutter bindings are initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize database
  final Database db = await DatabaseHelper.instance.database;

  // Save quiz data and load quizzes
  saveData(ApiConstants.getAllQuizData, TextConstants.quizData).then((_) {
    QuizManager.instance.loadQuizzes();
  });

  // Save spellings data and load all spellings
  saveData(ApiConstants.getSpellings, TextConstants.spellings).then((_) {
    QuizManager.instance.loadAllSpellings();
  });

  // Run the application
  runApp(
    ChangeNotifierProvider(
      create: (context) => UserProvider(),
      child: Provider<Database>.value(
        value: db,
        child: const MyApp(),
      ),
    ),
  );
}

// Root widget of the application
class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();

  // Method to set the locale of the application
  static void setLocale(BuildContext context, Locale newLocale) {
    _MyAppState? state = context.findAncestorStateOfType<_MyAppState>();
    state?.setLocale(newLocale);
  }
}

// State class for MyApp
class _MyAppState extends State<MyApp> {
  Locale? _locale;
  String initialRoute = loginRoute;

  // Method to set the locale
  setLocale(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

  // Method called when dependencies change
  @override
  void didChangeDependencies() {
    // Get the current locale and set it
    getLocale().then((locale) => {setLocale(locale)});
    super.didChangeDependencies();
  }

  // Build method to construct the UI
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Localization',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      // Localizations configurations
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      // Router configurations
      onGenerateRoute: CustomRouter.generatedRoute,
      initialRoute: initialRoute,
      locale: _locale,
    );
  }
}
