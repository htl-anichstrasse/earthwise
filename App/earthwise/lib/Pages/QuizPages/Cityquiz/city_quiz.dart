import 'package:flutter/material.dart';
import 'package:earthwise/Datenbank/user.dart';
import 'package:earthwise/Pages/QuizPages/Mapquiz/map/country.dart';
import 'package:earthwise/Datenbank/quiz_data.dart';
import 'package:earthwise/Datenbank/user_provider.dart';
import 'package:earthwise/Pages/Login/authentication.dart';
import 'package:earthwise/Pages/QuizPages/Flagquiz/AllFlags/all_flags.dart';
import 'package:earthwise/Pages/QuizPages/Elements/timer.dart';
import 'package:earthwise/router/route_constants.dart';
import 'package:provider/provider.dart';

// Represents the page for the City Quiz.
class CityQuizPage extends StatefulWidget {
  const CityQuizPage({super.key, required this.continent});

  final Continent continent;

  @override
  State<CityQuizPage> createState() => _CityQuizPageState();
}

// Represents the state of the City Quiz page.
class _CityQuizPageState extends State<CityQuizPage> {
  SimpleTimer _timer = SimpleTimer(onDisplayUpdate: (_, __) {});
  String _timerDisplay = '';
  Color _timerColor = Colors.white;
  bool onFirstChange = true;

  QuizData? question;

  bool signedIn = false;

  User? user;

  // Checks if the user is signed in.
  void isUserSignedIn() async {
    await AuthService.isUserLoggedIn().then((value) {
      setState(() {
        signedIn = value;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    isUserSignedIn();
    // Schedule the async operation to run after initState
    Future.delayed(Duration.zero, () async {
      await _loadQuizData();
      _initializeTimer();
    });
    formatQuiz();
  }

  // Loads quiz data asynchronously.
  Future<void> _loadQuizData() async {
    int id = getQuizTableId(widget.continent);
    question = await getQuizTable(id);
    if (mounted) {
      setState(() {
        formatQuiz();
      }); // Call setState if the widget is still in the tree
    }
  }

  // Initializes the timer.
  void _initializeTimer() {
    _timer = SimpleTimer(
      onDisplayUpdate: (display, isNegative) {
        if (mounted) {
          setState(() {
            _timerDisplay = display;
            _timerColor = isNegative ? Colors.red : Colors.white;
          });
        }
      },
      minutes: 10,
      seconds: 00,
    );
  }

  @override
  void dispose() {
    _timer.stopTimer();
    super.dispose();
  }

  // Formats the quiz data.
  void formatQuiz() {
    Map<String, List<String>> spellings = getAllSpellings();

    if ((question != null) && (spellings.isNotEmpty)) {
      for (List l in question!.data) {
        String? country = spellings[l[0]]![0];

        data.addEntries([MapEntry(country, extractListFromString(l[1])[0])]);
      }
    }
  }

  // Extracts list from string.
  List<String> extractListFromString(String inputString) {
    RegExp regExp = RegExp(r"'(.*?)'");
    var matches = regExp.allMatches(inputString);

    List<String> resultList = [];
    for (var match in matches) {
      resultList.add(match.group(1)!);
    }

    return resultList;
  }

  Map<String, String> data = {};
  Map<String, String> answers = {};

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // Submits the user's answers.
  void submitAnswers(BuildContext context) {
    _formKey.currentState!.save();
    int score = calculateScore();
    checkResults(context, score);
  }

  // Calculates the user's score.
  int calculateScore() {
    int score = 0;

    for (String key in data.keys) {
      if (data[key]!.toLowerCase() == answers[key]!.toLowerCase()) {
        score++;
      }
    }
    int percentage = (score * 100 / question!.data.length).round();
    return percentage;
  }

  @override
  Widget build(BuildContext context) {
    if (signedIn) {
      final userProvider = Provider.of<UserProvider>(context);
      user = userProvider.user;
    }
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 14,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back,
            size: 30,
          ),
        ),
        foregroundColor: Colors.white,
        backgroundColor: Colors.transparent,
        title: const Text(
          "Capitals",
          style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
        ),
        actions: <Widget>[
          SizedBox(
              child: Row(
            children: <Widget>[
              Text(
                _timerDisplay,
                style: TextStyle(fontSize: 35, color: _timerColor),
              ),
              const SizedBox(width: 20)
            ],
          )),
        ],
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
        child: Column(
          children: [
            SizedBox(height: MediaQuery.of(context).size.height * 0.12),
            Expanded(
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: data.keys.map((country) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 16.0),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.2),
                                spreadRadius: 1,
                                blurRadius: 5,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(17.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(country,
                                    style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold)),
                                TextFormField(
                                  onChanged: (value) {
                                    if (onFirstChange) {
                                      onFirstChange = false;
                                      _timer.startTimer();
                                    }
                                  },
                                  decoration: const InputDecoration(
                                    hintText: "Capital",
                                  ),
                                  onSaved: (value) {
                                    answers[country] = value!;
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 15),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color.fromARGB(255, 210, 102, 229),
        onPressed: () {
          submitAnswers(context);
        },
        child: const Icon(
          Icons.check,
          color: Color.fromARGB(255, 0, 0, 0),
        ),
      ),
    );
  }

// Checks the user's results and navigates to the result page.
  void checkResults(BuildContext context, int score) async {
    _timer.stopTimer();
    if (signedIn) {
      getQuizId(QuizType.flagquiz, widget.continent).then((value) {
        if ((value != null) && (user != null)) {
          setHighscore(user!.mail, value, score, getTime(_timerDisplay));
        }
      });
    }
    Navigator.pushNamed(context, resultRoute, arguments: [
      score,
      "Cities of ${getNameofContinent(widget.continent)}",
      getTime(_timerDisplay),
      tableQuizRoute,
      widget.continent
    ]);
  }
}
