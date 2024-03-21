import 'package:flutter/material.dart';
import 'package:earthwise/Pages/QuizPages/Mapquiz/map/country.dart';
import 'package:earthwise/Datenbank/user.dart';
import 'package:earthwise/Datenbank/quiz_data.dart';
import 'package:earthwise/Datenbank/user_provider.dart';
import 'package:earthwise/Pages/Login/authentication.dart';
import 'package:earthwise/Pages/QuizPages/Elements/timer.dart';
import 'package:earthwise/router/route_constants.dart';
import 'package:provider/provider.dart';

// Widget for displaying all flags in a continent
class AllFlagsPage extends StatefulWidget {
  final Continent continent;
  const AllFlagsPage({super.key, required this.continent});

  @override
  State<AllFlagsPage> createState() => _AllFlagsPageState();
}

// State class for AllFlagsPage
class _AllFlagsPageState extends State<AllFlagsPage> {
  late List<String> data;
  int crossAxisCount = 2;
  int score = 0;
  List<TextEditingController> textControllers = [];
  SimpleTimer _timer = SimpleTimer(onDisplayUpdate: (_, __) {});
  String _timerDisplay = '';
  Color _timerColor = Colors.white;
  bool onFirstChange = true;

  bool signedIn = false;

  User? user;

  int howToSort = 0;

  void isUserSignedIn() async {
    await AuthService.isUserLoggedIn().then((value) {
      setState(() {
        signedIn = value;
      });
    });
  }

  @override
  void initState() {
    isUserSignedIn();
    data = getQuestions(widget.continent);
    textControllers =
        List.generate(data.length, (i) => TextEditingController());
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
    super.initState();
  }

  @override
  void dispose() {
    for (var controller in textControllers) {
      controller.dispose();
    }
    _timer.stopTimer();
    super.dispose();
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
            color: Colors.white,
          ),
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
        backgroundColor: Colors.transparent,
        title: const Text(
          "Flags",
          style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 27),
        ),
        elevation: 14.0,
      ),
      resizeToAvoidBottomInset: false,
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
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 20),
          child: Column(
            children: [
              const SizedBox(height: 15),
              Flexible(
                child: GridView.builder(
                  itemCount: data.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxisCount,
                    mainAxisSpacing: 10,
                  ),
                  itemBuilder: (context, index) =>
                      buildItemToGuess(data[index], textControllers[index]),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color.fromARGB(255, 210, 102, 229),
        onPressed: () {
          checkResults(context);
        },
        child: const Icon(
          Icons.check,
          color: Color.fromARGB(255, 0, 0, 0),
        ),
      ),
    );
  }

  // Method to check results after guessing flags
  void checkResults(BuildContext context) {
    int localScore = 0;
    for (int i = 0; i < data.length; i++) {
      if (checkAnswer(textControllers[i].text.toLowerCase(), data) != null) {
        localScore++;
      }
    }
    _timer.stopTimer();
    if (signedIn) {
      getQuizId(QuizType.flagquiz, widget.continent).then((value) {
        if ((value != null) && (user != null)) {
          setHighscore(user!.mail, value, localScore, getTime(_timerDisplay));
        }
      });
    }
    Navigator.pushNamed(context, resultRoute, arguments: [
      localScore,
      "All Flags of ${getNameofContinent(widget.continent)}",
      getTime(_timerDisplay),
      guessAllRoute,
      widget.continent
    ]);
  }

  // Widget to build items for guessing flags
  Widget buildItemToGuess(String picture, TextEditingController tController) {
    return Padding(
      padding: const EdgeInsets.only(right: 8, left: 8),
      child: Column(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.1,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(5),
              child: Image.asset("assets/images/${picture.toLowerCase()}.png"),
            ),
          ),
          const SizedBox(height: 10),
          TextField(
            textAlignVertical:
                TextAlignVertical.center, // Center the text vertically
            cursorColor: Colors.white, // Cursor color
            style: const TextStyle(color: Colors.white), // Input text color
            decoration: InputDecoration(
              border: const OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.white,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: const BorderSide(
                  color: Colors.white,
                  width: 2,
                ), // Border in white when TextField is active
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),

                borderSide: const BorderSide(
                  color: Colors.white,
                  width: 2,
                ), // Border in white when TextField is focused
              ),
            ),
            controller: tController,
            onChanged: (_) {
              if (onFirstChange) {
                onFirstChange = false;
                _timer.startTimer();
              }
            },
            textInputAction: TextInputAction.next,
          ),
        ],
      ),
    );
  }
}

// Function to parse time string into

int getTime(String time) {
  List<String> parts = time.split(':');
  int minutes = int.parse(parts[0]);
  int seconds = int.parse(parts[1]);

  int totalSeconds = (minutes * 60) + seconds;

  return totalSeconds;
}
