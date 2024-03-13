import 'package:flutter/material.dart';
import 'package:maestro/Models/country.dart';
import 'package:maestro/Models/user.dart';
import 'package:maestro/Server/quiz_data.dart';
import 'package:maestro/Server/user_provider.dart';
import 'package:maestro/pages/Login/authentication.dart';
import 'package:maestro/pages/QuizPages/guess_all.dart';
import 'package:maestro/pages/QuizPages/timer.dart';
import 'package:maestro/router/route_constants.dart';
import 'package:provider/provider.dart';

class TableQuizPage extends StatefulWidget {
  const TableQuizPage({super.key, required this.continent});

  final Continent continent;

  @override
  State<TableQuizPage> createState() => _TableQuizPageState();
}

class _TableQuizPageState extends State<TableQuizPage> {
  SimpleTimer _timer = SimpleTimer(onDisplayUpdate: (_, __) {});
  String _timerDisplay = '';
  Color _timerColor = Colors.white;
  bool onFirstChange = true;

  QuizData? question;

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

  Future<void> _loadQuizData() async {
    int id = getQuizTableId(widget.continent);
    question = await getQuizTable(id);
    if (mounted) {
      setState(() {
        formatQuiz();
      }); // Call setState if the widget is still in the tree
    }
  }

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

  void formatQuiz() {
    Map<String, List<String>> spellings = getAllSpellings();

    if ((question != null) && (spellings.isNotEmpty)) {
      for (List l in question!.data) {
        String? country = spellings[l[0]]![0];

        data.addEntries([MapEntry(country, extractListFromString(l[1])[0])]);
      }
    }
  }

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

  void submitAnswers(BuildContext context) {
    _formKey.currentState!.save();
    int score = calculateScore();
    checkResults(context, score);
  }

  int calculateScore() {
    int score = 0;

    for (String key in data.keys) {
      if (data[key]!.toLowerCase() == answers[key]!.toLowerCase()) {
        score++;
      }
    }
    return score;
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
            SizedBox(
                height: MediaQuery.of(context).size.height *
                    0.12), // Diese SizedBox bleibt immer oben sichtbar.
            Expanded(
              // Das Expanded-Widget nimmt den restlichen verfügbaren Platz ein.
              child: SingleChildScrollView(
                // Erlaubt das Scrollen der Inhalte im Expanded-Widget.
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

  void checkResults(BuildContext context, int score) async {
    _timer.stopTimer();
    if (signedIn) {
      getQuizId(QuizType.flagquiz, widget.continent).then((value) {
        if ((value != null) && (user != null)) {
          finishQuiz(user!.mail, value, score, getTime(_timerDisplay));
        }
      });
    }
    Navigator.pushNamed(context, resultRoute, arguments: [
      score,
      "GUESS ALL",
      getTime(_timerDisplay),
      tableQuizRoute,
      widget.continent
    ]);
  }
}
