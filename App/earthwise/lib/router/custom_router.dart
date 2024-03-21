import 'package:flutter/material.dart';
import 'package:earthwise/Pages/MainPages/Profilpage/change_user.dart';
import 'package:earthwise/Pages/MainPages/Profilpage/highscores.dart';
import 'package:earthwise/Pages/QuizPages/Mapquiz/map/country.dart';
import 'package:earthwise/Pages/Login/login.dart';
import 'package:earthwise/Pages/Login/registration.dart';
import 'package:earthwise/Pages/MainPages/Homepage/main_page.dart';
import 'package:earthwise/Pages/MainPages/Homepage/home_page.dart';
import 'package:earthwise/Pages/MainPages/Profilpage/profil_page.dart';
import 'package:earthwise/Pages/MainPages/Quizpage/quiz_page.dart';
import 'package:earthwise/Pages/QuizPages/Random/random_filter_page.dart';
import 'package:earthwise/Pages/QuizPages/Random/random_question_page.dart';
import 'package:earthwise/Pages/MainPages/Resultpage/result_page.dart';
import 'package:earthwise/Pages/MainPages/Profilpage/settings_page.dart';
import 'package:earthwise/Pages/MainPages/Searchpage/build_searched_question.dart';
import 'package:earthwise/Pages/QuizPages/Flagquiz/AllFlags/all_flags.dart';
import 'package:earthwise/Pages/QuizPages/Flagquiz/SingleFlag/prepare_single_flag.dart';
import 'package:earthwise/Pages/QuizPages/Flagquiz/SingleChoiceQuiz/prepare_scq.dart';
import 'package:earthwise/Pages/MainPages/Quizpage/selection_page.dart';
import 'package:earthwise/Pages/QuizPages/Cityquiz/city_quiz.dart';
import 'package:earthwise/Pages/QuizPages/Mapquiz/map_quiz.dart';
import 'package:earthwise/router/route_constants.dart';

// The CustomRouter takes care about the navigation between sides
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
        return MaterialPageRoute(builder: (_) => const Homepage());
      case quizRoute:
        return MaterialPageRoute(builder: (_) => const QuizPage());

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
        var data = settings.arguments as List;
        return MaterialPageRoute(
            builder: (_) => RandomQuestionPage(
                categories: data[0], count: data[1], continent: data[2]));
      case randomFilterRoute:
        return MaterialPageRoute(builder: (_) => const RandomFilterPage());
      case guessAllRoute:
        var data = settings.arguments as Continent;
        return MaterialPageRoute(builder: (_) => AllFlagsPage(continent: data));

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
        return MaterialPageRoute(builder: (_) => MapQuizPage(continent: data));

      case prepareFlagRoute:
        var data = settings.arguments as Continent;
        return MaterialPageRoute(
            builder: (_) => PrepareSingleFlagPage(continent: data));
      case tableQuizRoute:
        var data = settings.arguments as Continent;
        return MaterialPageRoute(builder: (_) => CityQuizPage(continent: data));

      case prepareMCQRoute:
        var data = settings.arguments as Continent;
        return MaterialPageRoute(
            builder: (_) => PrepareSCQPage(continent: data));

      case buildMapRoute:
        var data = settings.arguments as List;
        return MaterialPageRoute(
            builder: (_) => BuildMapQuiz(continent: data[0], timer: data[1]));
      case changeUserRoute:
        var data = settings.arguments as int;
        return MaterialPageRoute(builder: (_) => ChangeUserPage(index: data));
      case allHighscoresRoute:
        return MaterialPageRoute(builder: (_) => const DisplayAllHighscores());

      default:
        return MaterialPageRoute(builder: (_) => const Mainpage(page: 0));
    }
  }
}
