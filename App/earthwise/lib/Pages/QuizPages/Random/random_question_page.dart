import 'package:flutter/material.dart';
import 'package:earthwise/Pages/QuizPages/Cityquiz/city_quiz.dart';
import 'package:earthwise/Pages/QuizPages/Elements/timer.dart';
import 'package:earthwise/Pages/QuizPages/Flagquiz/AllFlags/all_flags.dart';
import 'package:earthwise/Pages/QuizPages/Mapquiz/map_quiz.dart';
import 'package:earthwise/Pages/QuizPages/Mapquiz/map/country.dart';
import 'package:earthwise/Datenbank/quiz_data.dart';
import 'package:earthwise/router/route_constants.dart';

// Page for displaying random questions based on selected categories and continent
class RandomQuestionPage extends StatefulWidget {
  const RandomQuestionPage(
      {super.key,
      required this.categories,
      required this.count,
      required this.continent});

  final List<QuizType> categories;
  final int count;
  final Continent continent;

  @override
  State<RandomQuestionPage> createState() => _RandomQuestionPageState();
}

// State class for RandomQuestionPage
class _RandomQuestionPageState extends State<RandomQuestionPage> {
  late PageController _controller;
  int _questionNumber = 1;
  late int numberOfQuestions = widget.count;
  int scorePoints = 0;
  late List categories = widget.categories;
  late List<QuizData> question = getRandomQuestions();
  late SimpleTimer _timer;
  String _timerDisplay = '';
  Color _timerColor = Colors.white;
  bool onFirstChange = true;
  late Continent continent = widget.continent;

  // Method to get random questions based on selected categories and continent
  List<QuizData> getRandomQuestions() {
    List<QuizData> allquestions = getAllData();
    List<QuizData> randomQuestions = [];

    for (QuizData question in allquestions) {
      if (categories.contains(question.type)) {
        if ((continent == Continent.world) ||
            (checkQuizContinent(continent, question))) {
          randomQuestions.add(question);
        }
      }
    }
    return randomQuestions;
  }

  // Initialize state
  @override
  void initState() {
    super.initState();
    scorePoints = 0;
    _controller = PageController(initialPage: 0);
    _timer = SimpleTimer(
      onDisplayUpdate: (display, isNegative) {
        setState(() {
          _timerDisplay = display;
          // Change color to red if time is negative, otherwise white
          _timerColor = isNegative ? Colors.red : Colors.white;
        });
      },
      minutes: 0, // Start time for timer
      seconds: 10,
    );
  }

  // Dispose method
  @override
  void dispose() {
    super.dispose();
    question.shuffle();
    _timer.stopTimer();
  }

  // Build method
  @override
  Widget build(BuildContext context) {
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
                const SizedBox(width: 20)
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
                    child: const Text("Cancel"),
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

  // Build method for elevated button
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

  // Method to build random question based on its type
  Widget buildRandomQuestion(QuizData question) {
    switch (question.type) {
      case QuizType.mapquiz:
        return BuildMapQuiz(continent: continent, timer: _timer);
      case QuizType.tablequiz:
        return CityQuizPage(continent: continent);
      case QuizType.flagquiz:
        return AllFlagsPage(continent: continent);
      default:
        return const Column(children: [Text("Error")]);
    }
  }
}
