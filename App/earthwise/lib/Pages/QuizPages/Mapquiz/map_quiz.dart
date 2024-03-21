import 'package:countries_world_map/components/canvas/touchy_canvas.dart';
import 'package:countries_world_map/data/maps/world_map.dart';
import 'package:flutter/material.dart';
import 'package:earthwise/Datenbank/user.dart';
import 'package:earthwise/Pages/QuizPages/Elements/timer.dart';
import 'package:earthwise/Pages/QuizPages/Flagquiz/AllFlags/all_flags.dart';
import 'package:earthwise/Pages/QuizPages/Mapquiz/map/map_settings.dart';
import 'package:earthwise/Pages/QuizPages/Mapquiz/map/map_colour.dart';
import 'package:earthwise/Pages/QuizPages/Mapquiz/map/prepare_painter.dart';
import 'package:earthwise/Datenbank/quiz_data.dart';
import 'package:earthwise/Datenbank/user_provider.dart';
import 'package:earthwise/Pages/QuizPages/Mapquiz/map/country.dart';
import 'package:earthwise/Pages/Login/authentication.dart';
import 'package:earthwise/router/route_constants.dart';
import 'package:provider/provider.dart';

class MapQuizPage extends StatefulWidget {
  const MapQuizPage({super.key, required this.continent});

  final Continent continent;

  @override
  State<MapQuizPage> createState() => _MapQuizPageState();
}

String _timerDisplay = '';

class _MapQuizPageState extends State<MapQuizPage> {
  late SimpleTimer _timer;
  Color _timerColor = Colors.white;

  @override
  void initState() {
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
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
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
        leading: IconButton(
          iconSize: 30,
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Countries',
          style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 25),
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
        child: BuildMapQuiz(
          continent: widget.continent,
          timer: _timer,
        ),
      ),
    );
  }
}

class BuildMapQuiz extends StatefulWidget {
  const BuildMapQuiz({Key? key, required this.continent, required this.timer})
      : super(key: key);
  final Continent continent;
  final SimpleTimer timer;

  @override
  _BuildMapQuizState createState() => _BuildMapQuizState();
}

class _BuildMapQuizState extends State<BuildMapQuiz> {
  TextEditingController controller = TextEditingController();

  int index = 0;
  Color c = Colors.black;
  List<Country> countries = [];
  late TouchyCanvas canvas;
  List<String> guessed = [];
  bool onFirstChange = true;

  List<String> borderline = borders.values.toList();
  List<String> souveran = countryCodes;
  List<DrawMap> countryMap = [];
  Color colour = Colors.black;
  Stack stack = const Stack();
  late MapSettings settings;
  GlobalKey repaintBoundaryKey = GlobalKey();

  MapColour mapColours = defaultColor;

  List<String> codes = countriesData.keys.toList();
  List<String> maps = countriesData.values.toList();

  bool signedIn = false;

  User? user;

  // Method to check if user is signed in
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
    widget.timer.stopTimer();
    deleteMap();
  }

  @override
  void initState() {
    isUserSignedIn();
    settings = setSetting(widget.continent);
    fillMap();
    countryMap.add(
      DrawMap(
        countries: allCountries,
        colors: SMapWorldColors(aG: colour).toMap(),
        settings: settings,
        mapColours: mapColours,
      ),
    );

    super.initState();
  }

  // Method to give up the quiz
  Future<void> giveUp() async {
    finishMapQuiz(context);
  }

  // Method to resume the game
  void resumeGame() {
    Navigator.pop(context);

    widget.timer.startTimer();
  }

  @override
  Widget build(BuildContext context) {
    if (signedIn) {
      final userProvider = Provider.of<UserProvider>(context);
      user = userProvider.user;
    }
    return Scaffold(
      backgroundColor: Colors.transparent,
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color.fromARGB(255, 210, 102, 229),
        onPressed: () {
          finishMapQuiz(context);
        },
        child: const Icon(
          Icons.check,
          color: Color.fromARGB(255, 0, 0, 0),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: MediaQuery.of(context).size.height * 0.14),
            Text(
              getNameofContinent(widget.continent),
              style: const TextStyle(fontSize: 30, color: Colors.white),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.05),
            Center(
              child: SizedBox(
                child: FittedBox(
                  child: InteractiveViewer(
                    maxScale: 15.0,
                    child: RepaintBoundary(
                      key: repaintBoundaryKey,
                      child: Stack(
                        children: [
                          for (DrawMap s in countryMap) ...{s}
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.04),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              child: TextField(
                controller: controller,
                cursorColor: Colors.white, // Farbe des Cursors
                style: const TextStyle(
                    color: Colors.white), // Farbe der Eingabetext
                decoration: InputDecoration(
                  border: const OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.white,
                    ),
                  ),
                  enabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.white,
                      width: 2,
                    ), // Umrandung in Weiß, wenn das TextField aktiv ist
                  ),
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.white,
                      width: 2,
                    ), // Umrandung in Weiß, wenn das TextField fokussiert ist
                  ),
                  labelText: 'Type the name of a country here',
                  labelStyle: TextStyle(
                      color: Colors.white
                          .withOpacity(0.7)), // Farbe des Label-Texts
                ),
                onChanged: (value) {
                  if (onFirstChange) {
                    onFirstChange = false;
                    widget.timer.startTimer();
                  }
                  checkResult(value);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Method to change the index and update the map color
  void change(int i) {
    setState(() {
      index += i;
      colour = const Color.fromARGB(255, 6, 138, 26);
      fillMap();
    });
  }

  // Method to get the index of a country by its code
  int? getIndexOfCountry(String value) {
    for (int i = 0; i < allCountries.length; i++) {
      if (allCountries[i].code.toLowerCase() == value.toLowerCase()) {
        return i;
      }
    }
    return null;
  }

  // Method to finish the map quiz and navigate to the result page
  void finishMapQuiz(BuildContext context) async {
    int localScore = (guessed.length * 100 / allCountries.length).round();
    widget.timer.stopTimer();
    if (signedIn) {
      getQuizId(QuizType.flagquiz, widget.continent).then((value) {
        if ((value != null) && (user != null)) {
          setHighscore(user!.mail, value, localScore, getTime(_timerDisplay));
        }
      });
    }
    Navigator.pushNamed(context, resultRoute, arguments: [
      localScore,
      "Map of ${getNameofContinent(widget.continent)}",
      getTime(_timerDisplay),
      worldMapRoute,
      widget.continent
    ]);
  }

  // Method to check the result entered by the user
  void checkResult(String value) {
    String? check = checkAnswer(value.toLowerCase(), codes);
    if (check != null) {
      if ((!guessed.contains(check.toLowerCase())) &&
          !combindedCountry.containsValue(value)) {
        int? index = getIndexOfCountry(check);
        if (index != null) {
          controller.clear();
          setState(() {
            guessed.add(allCountries[index].code.toLowerCase());
            allCountries[index].colour = mapColours.rightColor;
            countryMap.add(
              DrawMap(
                countries: [
                  allCountries[index],
                ],
                settings: settings,
                mapColours: mapColours,
              ),
            );
            if (combindedCountry.containsKey(value.toLowerCase())) {
              String c = combindedCountry[value]!;
              combindedCountry.remove(value);

              checkResult(c);
            }
          });
        }
      }
    }
  }

  // Method to concatenate all elements of a list into a single string
  String getAll(List<String> a) {
    String all = "";
    for (int i = 0; i < a.length; i++) {
      all += a[i];
    }
    return all;
  }

  // Method to fill the map with countries based on settings
  void fillMap() {
    for (int i = 0; i < maps.length; i++) {
      if (settings.countries.contains(codes[i])) {
        addCountry(
            codes[i], null, maps[i], borderline[i], 0, mapColours.defaultColor);
      }
    }
    // addCountry(codes[indexes[index]], null, maps[indexes[index] + 1], 0);
  }

  // Method to set map settings based on continent
  MapSettings setSetting(Continent continent) {
    switch (continent) {
      case Continent.world:
        return souveranSettings;
      case Continent.northAmerica:
        return northAmericaSettings;
      case Continent.southAmerica:
        return southAmericaSettings;
      case Continent.europe:
        return europeSetting;
      case Continent.africa:
        return africaSettings;
      case Continent.asia:
        return asiaSettings;
      case Continent.oceania:
        return oceaniaSettings;
    }
  }
}
