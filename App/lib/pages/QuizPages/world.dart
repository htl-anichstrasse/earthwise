import 'package:countries_world_map/components/canvas/touchy_canvas.dart';
import 'package:countries_world_map/data/maps/world_map.dart';
import 'package:flutter/material.dart';
import 'package:maestro/Models/country.dart';
import 'package:maestro/Models/mapSettings.dart';
import 'package:maestro/Models/map_colour.dart';
import 'package:maestro/Models/user.dart';
import 'package:maestro/Server/quiz_data.dart';
import 'package:maestro/Server/user_provider.dart';
import 'package:maestro/map/map.dart';
import 'package:maestro/pages/Login/authentication.dart';
import 'package:maestro/pages/QuizPages/guess_all.dart';
import 'package:maestro/pages/QuizPages/timer.dart';
import 'package:maestro/router/route_constants.dart';
import 'package:provider/provider.dart';

class WorldMapQuizPage extends StatefulWidget {
  const WorldMapQuizPage({super.key, required this.continent});

  final Continent continent;

  @override
  State<WorldMapQuizPage> createState() => _WorldMapQuizPageState();
}

class _WorldMapQuizPageState extends State<WorldMapQuizPage> {
  late SimpleTimer _timer;
  String _timerDisplay = '';
  Color _timerColor = Colors.white;

  @override
  void initState() {
    // TODO: implement initState
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
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color.fromARGB(255, 210, 102, 229),
        onPressed: () {},
        child: const Icon(
          Icons.check,
          color: Color.fromARGB(255, 0, 0, 0),
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
  List<SimpleMap> countryMap = [];
  Color colour = Colors.black;
  Stack stack = const Stack();
  late MapSettings settings;
  GlobalKey repaintBoundaryKey = GlobalKey();

  MapColour mapColours = defaultColor;

  List<String> codes = countriesData.keys.toList();
  List<String> maps = countriesData.values.toList();

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
    widget.timer.stopTimer();
    deleteMap();
  }

  @override
  void initState() {
    isUserSignedIn();
    settings = setSetting(widget.continent);
    fillMap();
    countryMap.add(
      SimpleMap(
        countries: allCountries,
        colors: SMapWorldColors(aG: colour).toMap(),
        settings: settings,
        mapColours: mapColours,
      ),
    );

    super.initState();
  }

  Future<void> giveUp() async {
    finishMapQuiz(context);
  }

  void resumeGame() {
    Navigator.pop(context);

    widget.timer.startTimer();
  }

  int getResult() {
    return 75;
  }

  int getTime(String time) {
    print(time);
    return 5;
  }

  @override
  Widget build(BuildContext context) {
    if (signedIn) {
      final userProvider = Provider.of<UserProvider>(context);
      user = userProvider.user;
    }
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(height: MediaQuery.of(context).size.height * 0.14),
          Text(
            getNameofContinent(widget.continent),
            style: TextStyle(fontSize: 30, color: Colors.white),
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.05),
          Center(
            child: SizedBox(
              child: FittedBox(
                child: InteractiveViewer(
                  maxScale: 15.0,
                  child: RepaintBoundary(
                    key: repaintBoundaryKey,
                    child: Container(
                      child: Stack(
                        children: [
                          for (SimpleMap s in countryMap) ...{s}
                        ],
                      ),
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
              style:
                  const TextStyle(color: Colors.white), // Farbe der Eingabetext
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
                    color:
                        Colors.white.withOpacity(0.7)), // Farbe des Label-Texts
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
    );
  }

  void change(int i) {
    setState(() {
      index += i;
      colour = const Color.fromARGB(255, 6, 138, 26);
      fillMap();
    });
  }

  int? getIndexOfCountry(String value) {
    for (int i = 0; i < allCountries.length; i++) {
      if (allCountries[i].code.toLowerCase() == value.toLowerCase()) {
        return i;
      }
    }
    return null;
  }

  void finishMapQuiz(BuildContext context) async {
    int localScore = 0;
    widget.timer.stopTimer();
    if (signedIn) {
      getQuizId(QuizType.flagquiz, widget.continent).then((value) {
        if ((value != null) && (user != null)) {
          finishQuiz(
              user!.mail, value, localScore, getTime(widget.timer.toString()));
        }
      });
    }
    Navigator.pushNamed(context, resultRoute, arguments: [
      5,
      "GUESS ALL",
      getTime(widget.timer.toString()),
      guessAllRoute,
      widget.continent
    ]);
  }

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
              SimpleMap(
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

  String getAll(List<String> a) {
    String all = "";
    for (int i = 0; i < a.length; i++) {
      all += a[i];
    }
    return all;
  }

  void fillMap() {
    for (int i = 0; i < maps.length; i++) {
      if (settings.countries.contains(codes[i])) {
        addCountry(
            codes[i], null, maps[i], borderline[i], 0, mapColours.defaultColor);
      }
    }
    // addCountry(codes[indexes[index]], null, maps[indexes[index] + 1], 0);
  }

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
