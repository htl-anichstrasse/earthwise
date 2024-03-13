import 'package:flutter/material.dart';
import 'package:maestro/Models/country.dart';
import 'package:maestro/Models/user.dart';
import 'package:maestro/Server/quiz_data.dart';
import 'package:maestro/Server/user_provider.dart';
import 'package:maestro/pages/Login/authentication.dart';
import 'package:maestro/pages/QuizPages/flaggen_page.dart';
import 'package:maestro/pages/QuizPages/guess_all.dart';
import 'package:maestro/pages/QuizPages/timer.dart';
import 'package:maestro/router/route_constants.dart';
import 'package:provider/provider.dart';

class PrepareFlagQuestion extends StatefulWidget {
  const PrepareFlagQuestion({super.key, required this.continent});

  final Continent continent;

  @override
  State<PrepareFlagQuestion> createState() => _PrepareFlagQuestionState();
}

int scorePoints = 0;

class _PrepareFlagQuestionState extends State<PrepareFlagQuestion> {
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
    isUserSignedIn();

    countries = getQuestions(widget.continent);
    countries.shuffle();
    scorePoints = 0;
    _controller = PageController(initialPage: 0);
    _timer = SimpleTimer(
      onDisplayUpdate: (display, isNegative) {
        setState(() {
          _timerDisplay = display;
          _timerColor = isNegative ? Colors.red : Colors.white;
        });
      },
      minutes: 0,
      seconds: 10,
    );
  }

  @override
  Widget build(BuildContext context) {
    if (signedIn) {
      final userProvider = Provider.of<UserProvider>(context);
      user = userProvider.user;
    }
    print("asdsadsadsadasdsad");
    return Material(
      child: Scaffold(
        appBar: AppBar(
          actions: <Widget>[
            SizedBox(
                child: Row(
              children: <Widget>[
                Text(
                  _timerDisplay,
                  style: TextStyle(fontSize: 30, color: _timerColor),
                ),
                SizedBox(width: 20)
              ],
            )),
          ],
          backgroundColor: Colors.deepPurple,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: const Text(
            'Länder der Weltkarte erraten',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          elevation: 4.0,
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const SizedBox(height: 32),
              Text("Question $_questionNumber/${countries.length}"),
              const Divider(
                thickness: 1,
                color: Colors.grey,
              ),
              Expanded(
                child: PageView.builder(
                  itemCount: countries.length,
                  controller: _controller,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    return BuildFlagQuestion(
                      country: countries[index],
                      timer: _timer,
                    );
                  },
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text("Abbrechen"),
                  ),
                  buildElevatedButton(),
                ],
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  ElevatedButton buildElevatedButton() {
    return ElevatedButton(
      onPressed: () {
        if (_questionNumber < countries.length) {
          _controller.nextPage(
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeInExpo,
          );
          setState(() {
            _questionNumber++;
          });
        } else {
          checkResults(context);
        }
      },
      child: Text(_questionNumber < countries.length
          ? "Next Question"
          : "See the Result"),
    );
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
