import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:maestro/Server/constants.dart';
import 'package:maestro/Server/db.dart';
import 'package:maestro/Server/quiz_data.dart';
import 'package:maestro/Server/user_provider.dart';
import 'package:maestro/Server/webapi.dart';
import 'package:maestro/multilingualism/language_constants.dart';
import 'package:maestro/router/custom_router.dart';
import 'package:maestro/router/route_constants.dart';
import 'package:maestro/pages/Login/authentication.dart';
import 'package:provider/provider.dart';
import 'package:sqflite/sqflite.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final Database db = await DatabaseHelper.instance.database;
  saveData(ApiConstants.getAllQuizData, TextConstants.quizData).then((_) {
    QuizManager.instance.loadQuizzes();
  });
  saveData(ApiConstants.getSpellings, TextConstants.spellings).then((_) {
    QuizManager.instance.loadAllSpellings();
  });

  setUserLevel();

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

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();

  static void setLocale(BuildContext context, Locale newLocale) {
    _MyAppState? state = context.findAncestorStateOfType<_MyAppState>();
    state?.setLocale(newLocale);
  }
}

class _MyAppState extends State<MyApp> {
  Locale? _locale;
  String initialRoute = loginRoute;

  setLocale(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

  @override
  void didChangeDependencies() {
    getLocale().then((locale) => {setLocale(locale)});
    super.didChangeDependencies();
  }

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    bool loggedId = await AuthService.isUserLoggedIn();
    setState(() {
      initialRoute = loggedId ? mainRoute : loginRoute;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Localization',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      onGenerateRoute: CustomRouter.generatedRoute,
      initialRoute: initialRoute,
      locale: _locale,
    );
  }
}
