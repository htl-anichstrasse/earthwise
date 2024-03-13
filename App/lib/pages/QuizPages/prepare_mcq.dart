import 'package:flutter/material.dart';
import 'package:maestro/Models/country.dart';
import 'package:maestro/Models/user.dart';
import 'package:maestro/Server/quiz_data.dart';
import 'package:maestro/Server/user_provider.dart';
import 'package:maestro/pages/QuizPages/revers_questions.dart';
import 'package:maestro/pages/Login/authentication.dart';
import 'package:maestro/pages/QuizPages/guess_all.dart';
import 'package:maestro/pages/QuizPages/timer.dart';
import 'package:maestro/router/route_constants.dart';
import 'package:provider/provider.dart';

class PrepareMCQ extends StatefulWidget {
  const PrepareMCQ({super.key, required this.continent});

  final Continent continent;

  @override
  State<PrepareMCQ> createState() => _PrepareMCQState();
}

int scorePoints = 0;

class _PrepareMCQState extends State<PrepareMCQ> {
  late PageController _controller;
  int _questionNumber = 1;

  String result = "";

  String result2 = "";
  final flagQuestionController = TextEditingController();
  int tippCounter = 0;
  List<int> showTipps = [];

  bool newQuestion = true;

  late List<String> countries;

  late SimpleTimer _timer;
  String _timerDisplay = '';
  Color _timerColor = Colors.white;
  bool onFirstChange = true;

  bool signedIn = false;

  User? user;

  void isUserSignedIn() async {
    await AuthService.isUserLoggedIn().then((value) {
      setState(() {
        signedIn = value;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    _timer.stopTimer();
  }

  @override
  void initState() {
    super.initState();
    // isUserSignedIn();

    countries = getQuestions(widget.continent);
    countries.shuffle();
    scorePoints = 0;
    _controller = PageController(initialPage: 0);

    _timer = SimpleTimer(
      onDisplayUpdate: (display, isNegative) {
        _timerDisplay = display;
        _timerColor = isNegative ? Colors.red : Colors.white;
      },
      minutes: 10,
      seconds: 00,
    );
  }

  @override
  Widget build(BuildContext context) {
    if (signedIn) {
      final userProvider = Provider.of<UserProvider>(context);
      user = userProvider.user;
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
                  style: TextStyle(fontSize: 35, color: Colors.white),
                ),
                const SizedBox(width: 20)
              ],
            )),
          ],
          backgroundColor: Colors.transparent,
          leading: IconButton(
            iconSize: 30,
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: Text(
            'Flags',
            style: TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold, fontSize: 27),
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
                Color.fromARGB(255, 10, 199, 196), // Startfarbe
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
                  "Question $_questionNumber/${countries.length}",
                  style: TextStyle(color: Colors.white, fontSize: 25),
                ),
                const Divider(
                  thickness: 3,
                  color: Color.fromARGB(255, 255, 255, 255),
                ),
                Expanded(
                  child: PageView.builder(
                    itemCount: countries.length,
                    controller: _controller,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      return ReverseQuestion(
                        country: countries[index],
                        wrongs: getWrongs(countries[index]),
                        timer: _timer,
                        nextQ: nextQuestion,
                      );
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
    if (_questionNumber < countries.length) {
      _controller.nextPage(
        duration: const Duration(milliseconds: 550),
        curve: Curves.easeInOutCirc,
      );
      setState(() {
        _questionNumber++;
      });
    } else {
      checkResults(context);
    }
  }

  List<String> getWrongs(String country) {
    List<String> options = countries;
    options.shuffle();
    List<String> wrongs = [];

    for (int i = 0; i < 3; i++) {
      if (options[i] != country) {
        wrongs.add(options[i]);
      } else {
        i -= 1;
      }
    }
    return wrongs;
  }

  void checkResults(BuildContext context) async {
    int localScore = 0;

    _timer.stopTimer();
    if (signedIn) {
      getQuizId(QuizType.flagquiz, widget.continent).then((value) {
        if ((value != null) && (user != null)) {
          finishQuiz(user!.mail, value, localScore, getTime(_timerDisplay));
        }
      });
    }
    Navigator.pushNamed(context, resultRoute, arguments: [
      5,
      "GUESS ALL",
      getTime(_timerDisplay),
      guessAllRoute,
      widget.continent
    ]);
  }
}
