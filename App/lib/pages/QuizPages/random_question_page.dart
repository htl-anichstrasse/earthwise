import 'package:flutter/material.dart';
import 'package:maestro/Models/country.dart';
import 'package:maestro/Server/quiz_data.dart';
import 'package:maestro/pages/QuizPages/guess_all.dart';
import 'package:maestro/pages/QuizPages/table_quiz.dart';
import 'package:maestro/pages/QuizPages/timer.dart';
import 'package:maestro/pages/QuizPages/world.dart';
import 'package:maestro/router/route_constants.dart';
import 'package:maestro/slider.dart';

class RandomQuestionPage extends StatefulWidget {
  const RandomQuestionPage({super.key, required this.continent});

  final Continent continent;

  @override
  State<RandomQuestionPage> createState() => _RandomQuestionPageState();
}

int numberOfQuestions = 0;
int scorePoints = 0;

class _RandomQuestionPageState extends State<RandomQuestionPage> {
  late PageController _controller;
  int _questionNumber = 1;

  late List<QuizData> question = getAllData();

  late SimpleTimer _timer;
  String _timerDisplay = '';
  Color _timerColor = Colors.white;
  bool onFirstChange = true;
  Continent continent = Continent.world;

  @override
  void dispose() {
    super.dispose();
    question.shuffle();
    _timer.stopTimer();
  }

  @override
  void initState() {
    super.initState();
    scorePoints = 0;
    _controller = PageController(initialPage: 0);
    _timer = SimpleTimer(
      onDisplayUpdate: (display, isNegative) {
        setState(() {
          _timerDisplay = display;
          // Ändere die Farbe zu Rot, wenn die Zeit negativ ist, sonst Weiß
          _timerColor = isNegative ? Colors.red : Colors.white;
        });
      },
      minutes: 0, // Startzeit für den Timer
      seconds: 10,
    );
  }

  @override
  Widget build(BuildContext context) {
    numberOfQuestions = getValueFromSlider();

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
            'Random',
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
              Text("Question $_questionNumber/$numberOfQuestions"),
              const Divider(
                thickness: 1,
                color: Colors.grey,
              ),
              Expanded(
                child: PageView.builder(
                  itemCount: numberOfQuestions,
                  controller: _controller,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    return buildRandomQuestion(question[index]);
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
        if (_questionNumber < numberOfQuestions) {
          _controller.nextPage(
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeInExpo,
          );
          setState(() {
            _questionNumber++;
          });
        } else {
          Navigator.pushNamed(context, resultRoute,
              arguments: [scorePoints, numberOfQuestions]);
        }
      },
      child: Text(_questionNumber < numberOfQuestions
          ? "Next Question"
          : "See the Result"),
    );
  }

  Widget buildRandomQuestion(QuizData question) {
    switch (question.type) {
      case QuizType.mapquiz:
        return BuildMapQuiz(continent: continent, timer: _timer);
      case QuizType.tablequiz:
        return TableQuizPage(continent: continent);
      case QuizType.flagquiz:
        return GuessAllPage(continent: continent);
      default:
        return const Column(children: [Text("Error")]);
    }
  }
}
