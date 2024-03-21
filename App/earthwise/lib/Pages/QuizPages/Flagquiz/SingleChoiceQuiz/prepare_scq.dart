import 'package:flutter/material.dart';
import 'package:earthwise/Pages/QuizPages/Mapquiz/map/country.dart';
import 'package:earthwise/Datenbank/user.dart';
import 'package:earthwise/Datenbank/quiz_data.dart';
import 'package:earthwise/Datenbank/user_provider.dart';
import 'package:earthwise/Pages/QuizPages/Flagquiz/SingleChoiceQuiz/single_choice_quiz.dart';
import 'package:earthwise/Pages/Login/authentication.dart';
import 'package:earthwise/Pages/QuizPages/Flagquiz/AllFlags/all_flags.dart';
import 'package:earthwise/Pages/QuizPages/Elements/timer.dart';
import 'package:earthwise/router/route_constants.dart';
import 'package:provider/provider.dart';

// Widget for preparing for Single Choice Quiz
class PrepareSCQPage extends StatefulWidget {
  const PrepareSCQPage({super.key, required this.continent});

  final Continent continent;

  @override
  State<PrepareSCQPage> createState() => _PrepareSCQPageState();
}

class _PrepareSCQPageState extends State<PrepareSCQPage> {
  late PageController _controller;
  int _questionNumber = 0;
  late List<String> wrongs = [];

  bool signedIn = false;
  late User? user;

  late SimpleTimer _timer;
  String _timerDisplay = '';
  Color _timerColor = Colors.white;

  @override
  void initState() {
    super.initState();
    _controller = PageController(initialPage: 0);
    _timer = SimpleTimer(
      onDisplayUpdate: (display, isNegative) {
        setState(() {
          _timerDisplay = display;
          _timerColor = isNegative ? Colors.red : Colors.white;
        });
      },
      minutes: 10,
      seconds: 0,
    );
    isUserSignedIn();
  }

  @override
  void dispose() {
    super.dispose();
    _timer.stopTimer();
  }

  void isUserSignedIn() async {
    final value = await AuthService.isUserLoggedIn();
    setState(() {
      signedIn = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    final countries = getQuestions(widget.continent);
    countries.shuffle();

    if (_questionNumber < countries.length) {
      wrongs = getWrongs(countries[_questionNumber]);
    }

    return Material(
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          actions: <Widget>[
            SizedBox(
              child: Row(
                children: <Widget>[
                  Text(
                    _timerDisplay,
                    style: const TextStyle(fontSize: 35, color: Colors.white),
                  ),
                  const SizedBox(width: 20)
                ],
              ),
            ),
          ],
          backgroundColor: Colors.transparent,
          leading: IconButton(
            iconSize: 30,
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: const Text(
            'Flags',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 27,
            ),
          ),
          elevation: 14.0,
        ),
        body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: [
                Color.fromARGB(255, 10, 199, 196),
                Color.fromARGB(255, 4, 2, 104),
              ],
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                SizedBox(height: MediaQuery.of(context).size.height * 0.13),
                Text(
                  "Question ${_questionNumber + 1}/10",
                  style: const TextStyle(color: Colors.white, fontSize: 23),
                ),
                const Divider(
                  thickness: 3,
                  color: Color.fromARGB(255, 255, 255, 255),
                ),
                Expanded(
                  child: PageView.builder(
                    itemCount: 10,
                    controller: _controller,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      if (index < countries.length) {
                        return SingleChoiceQuizPage(
                          country: countries[index],
                          timer: _timer,
                          wrongs: wrongs,
                          nextQ: nextQuestion,
                        );
                      } else {
                        return const SizedBox.shrink();
                      }
                    },
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void nextQuestion() {
    if (_questionNumber < 9) {
      Future.delayed(Duration.zero, () {
        setState(() {
          _questionNumber++;
        });
        _controller.nextPage(
          duration: const Duration(milliseconds: 550),
          curve: Curves.easeInOutCirc,
        );
      });
    } else {
      checkResults(context);
    }
  }

  List<String> getWrongs(String country) {
    final options = List<String>.from(getQuestions(widget.continent));
    options.remove(country);
    options.shuffle();
    return options.take(3).toList();
  }

  void checkResults(BuildContext context) async {
    final localScore = scqScore * 10;
    _timer.stopTimer();

    if (signedIn) {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      final user = userProvider.user;
      final quizId = await getQuizId(QuizType.flagquiz, widget.continent);
      if (quizId != null) {
        setHighscore(user.mail, quizId, localScore, getTime(_timerDisplay));
      }
    }

    Navigator.pushNamed(
      context,
      resultRoute,
      arguments: [
        localScore,
        "SCQ of ${getNameofContinent(widget.continent)}",
        getTime(_timerDisplay),
        prepareFlagRoute,
        widget.continent,
      ],
    );
  }
}

// Variable to keep track of single choice quiz score
int scqScore = 0;
