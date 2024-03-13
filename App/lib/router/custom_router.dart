import 'package:flutter/material.dart';
import 'package:maestro/Models/country.dart';
import 'package:maestro/pages/Login/login.dart';
import 'package:maestro/pages/Login/registration.dart';
import 'package:maestro/pages/MainPages/main_page.dart';
import 'package:maestro/pages/MainPages/home_page.dart';
import 'package:maestro/pages/MainPages/profil_page.dart';
import 'package:maestro/pages/MainPages/quiz_page.dart';
import 'package:maestro/pages/MainPages/result_page.dart';
import 'package:maestro/pages/MainPages/settings_page.dart';
import 'package:maestro/pages/QuizPages/TEST.dart';
import 'package:maestro/pages/QuizPages/build_searched_question.dart';
import 'package:maestro/pages/QuizPages/guess_all.dart';
import 'package:maestro/pages/QuizPages/prepare_flag_question.dart';
import 'package:maestro/pages/QuizPages/prepare_mcq.dart';
import 'package:maestro/pages/QuizPages/random_filter.dart';
import 'package:maestro/pages/QuizPages/random_question_page.dart';
import 'package:maestro/pages/QuizPages/selection_page.dart';
import 'package:maestro/pages/QuizPages/table_quiz.dart';
import 'package:maestro/pages/QuizPages/world.dart';
import 'package:maestro/router/route_constants.dart';

class CustomRouter {
  static Route<dynamic> generatedRoute(RouteSettings settings) {
    switch (settings.name) {
      case mainRoute:
        int data;
        if (settings.arguments == null) {
          data = 0;
        } else {
          data = settings.arguments as int;
        }
        return MaterialPageRoute(builder: (_) => Mainpage(page: data));
      case homeRoute:
        return MaterialPageRoute(builder: (_) => Homepage());
      case quizRoute:
        return MaterialPageRoute(builder: (_) => QuizPage());

      case profilRoute:
        return MaterialPageRoute(builder: (_) => const ProfilPage());
      case buildSearchedQRoute:
        var data = settings.arguments as String;
        return MaterialPageRoute(builder: (_) => BuildSearchedQ(title: data));
      case selectionPageRoute:
        var data = settings.arguments as Continent;
        return MaterialPageRoute(
            builder: (_) => SelectionPage(continent: data));
      case resultRoute:
        var data = settings.arguments as List;
        return MaterialPageRoute(
          builder: (_) => ResultPage(
              percentage: data[0],
              quizname: data[1],
              time: data[2],
              route: data[3],
              continent: data[4]),
        );
      case randomRoute:
        var data = settings.arguments as Continent;
        return MaterialPageRoute(
            builder: (_) => RandomQuestionPage(continent: data));
      case randomFilterRoute:
        return MaterialPageRoute(builder: (_) => RandomFilter());
      case guessAllRoute:
        var data = settings.arguments as Continent;
        return MaterialPageRoute(builder: (_) => GuessAllPage(continent: data));

      case settingsRoute:
        return MaterialPageRoute(builder: (_) => const SettingsPage());
      case loginRoute:
        return MaterialPageRoute(builder: (_) => const LoginPage());
      case registrationRoute:
        return MaterialPageRoute(builder: (_) => const RegistrationPage());
      case worldMapRoute:
        // Extracts Continent data from navigation arguments.
        var data = settings.arguments as Continent;

        // Creates a route to WorldMapQuizPage with the provided Continent data.
        return MaterialPageRoute(
            builder: (_) => WorldMapQuizPage(continent: data));
      case testRoute:
        return MaterialPageRoute(builder: (_) => TestPage());

      case prepareFlagRoute:
        var data = settings.arguments as Continent;
        return MaterialPageRoute(
            builder: (_) => PrepareFlagQuestion(continent: data));
      case tableQuizRoute:
        var data = settings.arguments as Continent;
        return MaterialPageRoute(
            builder: (_) => TableQuizPage(continent: data));

      case prepareMCQRoute:
        var data = settings.arguments as Continent;
        return MaterialPageRoute(builder: (_) => PrepareMCQ(continent: data));

      case buildMapRoute:
        var data = settings.arguments as List;
        return MaterialPageRoute(
            builder: (_) => BuildMapQuiz(continent: data[0], timer: data[1]));

      default:
        return MaterialPageRoute(builder: (_) => Mainpage(page: 0));
    }
  }
}
