import 'package:flutter/material.dart';
import 'package:earthwise/Pages/QuizPages/Elements/timer.dart';
import 'package:earthwise/Pages/QuizPages/Flagquiz/AllFlags/all_flags.dart';
import 'package:earthwise/Pages/QuizPages/Flagquiz/SingleFlag/single_flag.dart';
import 'package:earthwise/Pages/QuizPages/Mapquiz/map/country.dart';
import 'package:earthwise/Datenbank/user.dart';
import 'package:earthwise/Datenbank/quiz_data.dart';
import 'package:earthwise/Datenbank/user_provider.dart';
import 'package:earthwise/Pages/Login/authentication.dart';
import 'package:earthwise/router/route_constants.dart';
import 'package:provider/provider.dart';

// Stateful widget for preparing single flag quiz page
class PrepareSingleFlagPage extends StatefulWidget {
  // Constructor with continent parameter
  const PrepareSingleFlagPage({super.key, required this.continent});

  final Continent continent;

  @override
  State<PrepareSingleFlagPage> createState() => _PrepareSingleFlagPageState();
}

int scorePoints = 0;

// State class for the PrepareSingleFlagPage widget
class _PrepareSingleFlagPageState extends State<PrepareSingleFlagPage> {
  late PageController
      _controller; // Page controller for managing page navigation
  int _questionNumber = 1; // Variable to track current question number

  String result = ""; // String variable for result
  String result2 = ""; // Additional string variable for result
  final flagQuestionController =
      TextEditingController(); // Text controller for flag question input
  int tippCounter = 0; // Counter for tips
  List<int> showTipps = []; // List to store tip information

  bool newQuestion = true; // Boolean variable to track new question status

  late List<String> countries; // List to store countries
  late SimpleTimer _timer; // Timer object for countdown timer
  String _timerDisplay = ''; // String variable to display timer
  Color _timerColor = Colors.white; // Timer color variable
  bool onFirstChange = true; // Boolean variable for initial change status

  bool signedIn = false; // Boolean variable to track sign-in status
  User? user; // User object

  // Method to check if user is signed in
  void isUserSignedIn() async {
    await AuthService.isUserLoggedIn().then((value) {
      setState(() {
        signedIn = value;
      });
    });
  }

  // Dispose method to clean up resources
  @override
  void dispose() {
    super.dispose();
    _timer.stopTimer();
  }

  // Initialize method to set up initial state
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

  // Build method to construct the widget's UI
  @override
  Widget build(BuildContext context) {
    // Check if user is signed in
    if (signedIn) {
      final userProvider = Provider.of<UserProvider>(context);
      user = userProvider.user;
    }
    // Return material scaffold for the page
    return Material(
      child: Scaffold(
        // App bar widget
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
            'Guess Countries on World Map',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          elevation: 4.0,
        ),
        // Body of the scaffold
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
                // Page view to display questions
                child: PageView.builder(
                  itemCount: countries.length,
                  controller: _controller,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    return SingleFlagPage(
                      country: countries[index],
                      timer: _timer,
                    );
                  },
                ),
              ),
              // Row containing action buttons
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

  // Method to build elevated button widget
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

  // Method to check quiz results
  void checkResults(BuildContext context) async {
    int localScore = 0;

    _timer.stopTimer();
    if (signedIn) {
      getQuizId(QuizType.flagquiz, widget.continent).then((value) {
        if ((value != null) && (user != null)) {
          setHighscore(user!.mail, value, localScore, getTime(_timerDisplay));
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
