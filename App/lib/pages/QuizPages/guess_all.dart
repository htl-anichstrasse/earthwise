import 'package:flag/flag.dart';
import 'package:flutter/material.dart';
import 'package:maestro/Models/country.dart';
import 'package:maestro/Models/user.dart';
import 'package:maestro/Server/quiz_data.dart';
import 'package:maestro/Server/user_provider.dart';
import 'package:maestro/pages/Login/authentication.dart';
import 'package:maestro/pages/QuizPages/timer.dart';
import 'package:maestro/router/route_constants.dart';
import 'package:provider/provider.dart';

class GuessAllPage extends StatefulWidget {
  final Continent continent;
  const GuessAllPage({super.key, required this.continent});

  @override
  State<GuessAllPage> createState() => _GuessAllPageState();
}

class _GuessAllPageState extends State<GuessAllPage> {
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
  final List<bool> _selectedFruits = <bool>[false, true, false];
  final List<bool> _selectedSort = <bool>[true, false];

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
    data.shuffle();
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
        title: Text(
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
              SizedBox(height: 15),
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

  void checkResults(BuildContext context) async {
    int localScore = 0;
    for (int i = 0; i < data.length; i++) {
      if (data[i].toLowerCase() == textControllers[i].text.toLowerCase()) {
        localScore++;
      }
    }
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

  Widget buildItemToGuess(String picture, TextEditingController tController) {
    return Padding(
      padding: const EdgeInsets.only(right: 8, left: 8),
      child: Column(
        children: [
          SizedBox(
            height: 100,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(5),
              child: Image.asset("assets/images/${picture.toLowerCase()}.png"),
            ),
          ),
          const SizedBox(height: 10),
          TextField(
            textAlignVertical:
                TextAlignVertical.center, // Zentriert den Text vertikal
            cursorColor: Colors.white, // Farbe des Cursors
            style:
                const TextStyle(color: Colors.white), // Farbe der Eingabetext
            decoration: InputDecoration(
              border: const OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.white,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: BorderSide(
                  color: Colors.white,
                  width: 2,
                ), // Umrandung in Weiß, wenn das TextField aktiv ist
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),

                borderSide: BorderSide(
                  color: Colors.white,
                  width: 2,
                ), // Umrandung in Weiß, wenn das TextField fokussiert ist
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

  Widget buildFlagsForDrawer(int countFlags, double height, double width) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        for (int i = 0; i < countFlags; i++) ...{
          Container(
            decoration: BoxDecoration(border: Border.all()),
            child: SizedBox(
                child: Flag.fromString("gb", height: height, width: width)),
          )
        }
      ],
    );
  }

  Drawer buildDrawer() {
    List<Widget> flags = <Widget>[
      buildFlagsForDrawer(1, 19, 25),
      buildFlagsForDrawer(2, 16, 22),
      buildFlagsForDrawer(3, 15, 20),
    ];
    List<Widget> sort = <Widget>[
      const Text("Kontinental"),
      const Text("Alphapetisch"),
    ];

    return Drawer(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text("How many Flags per Row?"),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ToggleButtons(
                onPressed: (int index) {
                  setState(() {
                    for (int i = 0; i < _selectedFruits.length; i++) {
                      _selectedFruits[i] = i == index;
                    }
                    crossAxisCount = index + 1;
                  });
                },
                borderRadius: const BorderRadius.all(Radius.circular(8)),
                selectedBorderColor: Colors.red[700],
                selectedColor: Colors.white,
                fillColor: Colors.red[200],
                color: Colors.red[400],
                constraints: const BoxConstraints(
                  minHeight: 40.0,
                  minWidth: 80.0,
                ),
                isSelected: _selectedFruits,
                children: flags,
              ),
            ],
          ),
          const SizedBox(height: 50),
          const Text("How do you want to sort the Flags?"),
          const SizedBox(height: 8),
          ToggleButtons(
            direction: Axis.vertical,
            onPressed: (int index) {
              setState(() {
                for (int i = 0; i < _selectedSort.length; i++) {
                  _selectedSort[i] = i == index;
                }
                howToSort = index;
              });
            },
            borderRadius: const BorderRadius.all(Radius.circular(8)),
            selectedBorderColor: Colors.red[700],
            selectedColor: Colors.white,
            fillColor: Colors.red[200],
            color: Colors.red[400],
            constraints: const BoxConstraints(
              minHeight: 40.0,
              minWidth: 150.0,
            ),
            isSelected: _selectedSort,
            children: sort,
          ),
        ],
      ),
    );
  }
}

int getTime(String time) {
  List<String> parts = time.split(':');
  int minutes = int.parse(parts[0]);
  int seconds = int.parse(parts[1]);

  int totalSeconds = (minutes * 60) + seconds;

  return totalSeconds;
}

void finishQuiz(String mail, int id, int percent, int time) {
  setHighscore(mail, id, percent, time);
}
